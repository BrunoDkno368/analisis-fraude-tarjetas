Análisis de fraude con tarjetas de crédito: ¿cuándo y con qué montos?

Análisis de datos de fraude con Python, SQL (MySQL) y Power BI · Dataset ULB / Kaggle · 284.807 transacciones

Dashboard de fraude con tarjetas

English summary: Credit card fraud analytics project. I analyzed 284,807 transactions to find when and at what amounts fraud concentrates, and built a simple review-priority rule. Tools: Python (pandas), MySQL, Power BI (DAX).

Pregunta de negocio

Un equipo de prevención de fraude no puede revisar todas las transacciones. ¿En qué horarios y rangos de monto se concentra el fraude con tarjetas, y qué conviene revisar primero?

Resultado en 30 segundos
El fraude es muy raro: 492 casos sobre 284.807 transacciones (0,17 %). Por eso revisar todo es inviable.
La madrugada concentra el riesgo. Las horas 2 a 4 tienen una tasa de fraude de 1,07 % contra 0,14 % del resto del día, y reúnen el 19,7 % del fraude en solo el 3,2 % de las transacciones. El pico está en la hora 2, con 1,71 %.
Los montos altos también. El tramo de más de 200 tiene la tasa más alta (0,29 %) y el tramo de 10 a 50 la más baja (0,06 %).
Regla de prioridad propuesta: revisar primero la madrugada (horas 2 a 4) y, como segunda capa, los montos de 200 o más. Esta regla revisa el 13,1 % de las transacciones y cubre el 35,6 % del fraude, con una tasa de fraude de 0,47 % en lo revisado (contra 0,13 % en lo no revisado).
Datos
Fuente: Credit Card Fraud Detection, del Machine Learning Group de la ULB (Kaggle).
Contenido: transacciones con tarjeta de titulares europeos durante dos días de 2013. 284.807 transacciones, de las cuales 492 son fraudes.
Columnas usadas: Time (segundos desde la primera transacción), Amount (monto) y Class (1 = fraude, 0 = legítima).
Columnas descartadas: V1 a V28, porque están anonimizadas y no se pueden interpretar para contar una historia de negocio.
Proceso
Etapa	Herramienta	Qué se hizo
Preparación	Python (pandas)	Verificación del dataset, conversión de Time a hora del día, creación de tramos de monto y carga a MySQL
Análisis	MySQL	Tasas de fraude por hora, por tramo de monto y evaluación de una regla de revisión con GROUP BY, CASE WHEN y subconsultas
Visualización	Power BI (DAX)	Dashboard de una página con medidas DAX y resaltado de los hallazgos
Decisiones de análisis
Se usa la tasa y no la cantidad. Una hora con más transacciones tiene más fraudes aunque no sea más riesgosa. La tasa (fraudes / transacciones) compara de forma justa.
Se valida en dos herramientas. Los resultados calculados en Python coinciden con los de SQL y con las medidas de Power BI.
Se descartó el tramo de 0 a 10 como regla. Concentra la mitad de los fraudes (50,6 %), pero revisarlo implica el 35 % de las transacciones y su tasa (0,25 %) está apenas por encima de la global (0,17 %). Cubre mucho, pero no prioriza.
El orden de los tramos se resolvió en el modelo. Se creó una columna de orden en DAX para que el tramo de más de 200 no se ordene alfabéticamente al principio.
Limitaciones

Prefiero decirlas yo antes de que las encuentre otro:

Son solo dos días de datos de 2013. No se puede afirmar que el patrón se repita en otro período.
La hora es relativa. Time se mide desde la primera transacción, así que las franjas no coinciden necesariamente con la hora local. Además, los dos días se juntan en un solo reloj de 24 horas: no se puede saber si el pico de la hora 2 es un patrón diario o un ataque puntual en una sola noche.
Los umbrales se eligieron mirando los mismos datos con los que se mide la cobertura. El 35,6 % es, por lo tanto, optimista. Con datos nuevos, probablemente sea menor.
Pocos casos por segmento. Con 492 fraudes en total, las diferencias grandes entre franjas son confiables como tendencia, pero las pequeñas no.
Una regla simple prioriza, no resuelve. El 64 % del fraude queda fuera de la regla, y casi todo lo que se revisa es legítimo (falsos positivos). Un sistema real combinaría varias reglas o un modelo de machine learning.
Estructura del repositorio
analisis-fraude-tarjetas/
├── README.md
├── datos/            # fuente del dataset y tabla preparada
├── python/           # preparación de los datos y carga a MySQL
├── sql/              # consultas comentadas
├── power_bi/         # dashboard (.pbix)
└── imagenes/         # captura del dashboard
Cómo reproducirlo
Descargar creditcard.csv desde Kaggle (enlace de arriba) y guardarlo en la carpeta datos/. No está incluido en el repositorio porque pesa más de 100 MB.
Crear la base en MySQL: CREATE DATABASE fraude_tarjetas;
Instalar las dependencias: pip install pandas sqlalchemy pymysql
Completar usuario y contraseña en python/preparacion_datos.py y ejecutarlo. Crea la tabla transacciones.
Agregar la clave primaria: ALTER TABLE transacciones ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;
Ejecutar las consultas de sql/consultas.sql.
Abrir power_bi/fraude_tarjetas_dashboard.pbix en Power BI Desktop.
Tecnologías y conceptos

Python · pandas · MySQL · SQL · Power BI · DAX · análisis de datos · fraud detection · credit card fraud · fraud analytics · risk analytics · data visualization · business intelligence · prevención de fraude · tasa de fraude · falsos positivos

Autor

Bruno Argañaraz · Analista de datos junior, con 14 años de experiencia en atención al cliente y foco en fraude y riesgos.

LinkedIn · GitHub
