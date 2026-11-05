
use fraude_tarjetas;

SELECT COUNT(*) AS total, SUM(Class) AS fraudes
FROM transacciones;

-- Consulta 1: tasa de fraude por tramo de monto
select 
	tramo_monto,
    count(*) as transacciones,
    sum(Class) as fraudes,
    round(100* sum(Class)/ count(*),2) as tasa_fraude_pct
from transacciones
group by tramo_monto
order by min(Amount);


-- Tasa de fraude por hora del día (hora relativa al inicio de los datos)
select
	Hora,
    count(*) as transacciones,
    sum(Class) as fraudes,
    round(100* sum(Class)/count(*),2) as tasa_fraude_pct
from transacciones
group by Hora
order by tasa_fraude_pct desc;

-- -- Cobertura de fraude: franja de madrugada vs. resto del día
select
	case
		when Hora between 2 and 4 then 'Madrugada (2-4)'
			else 'Resto del dia' 
		end as franja,
	count(*) as transacciones,
    sum(Class) as fraudes,
    round(100 * sum(Class)/count(*) ,2) as tasa_fraude_pct,
    round(100 * sum(Class)/(select sum(Class) from transacciones),1) as pct_del_fraude_total
from transacciones
group by franja;

-- Paso 7: la última consulta, una regla de prioridad
select
	case 
		when Hora between 2 and 4 or tramo_monto = '+200' then 'Madrugada (2-4) o +200'
        else 'No revisar'
	end as revisar,
    count(*) as transacciones,
    sum(Class) as fraudes,
    round(100* sum(Class)/count(*),2) as tasa_fraude_pct,
    round(100* sum(Class)/(select sum(Class) from transacciones),1) as pct_del_fraude_total
from transacciones
group by revisar;