# Preparación de datos: fraude con tarjetas (dataset ULB)
import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

# 1. Leer y verificar
df = pd.read_csv("creditcard.csv")
print(df.shape)                  # 284807 filas, 31 columnas
print(df["Class"].value_counts())  # 284315 legítimas, 492 fraudes

# 2. Hora del día (relativa al inicio de los datos)
df["hora"] = (df["Time"] // 3600) % 24

# 3. Tramos de monto
df["tramo_monto"] = pd.cut(
    df["Amount"],
    bins=[0, 10, 50, 200, float("inf")],
    labels=["0-10", "10-50", "50-200", "+200"],
    include_lowest=True
)

# 4. Carga a MySQL (solo las columnas que usa el análisis)
usuario = "root"
clave = quote_plus("TU_CLAVE")   # reemplazar por la contraseña propia
engine = create_engine(f"mysql+pymysql://{usuario}:{clave}@localhost:3306/fraude_tarjetas")

tabla = df[["Time", "Amount", "Class", "hora", "tramo_monto"]].copy()
tabla["hora"] = tabla["hora"].astype(int)
tabla["tramo_monto"] = tabla["tramo_monto"].astype(str)

tabla.to_sql("transacciones", engine, if_exists="replace",
             index=False, method="multi", chunksize=5000)