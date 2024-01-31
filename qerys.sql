-----------------------------------------------------------     --1-----------------------------------------------------------------------------------------
SELECT
    SUM(TO_NUMBER(EXTRACTVALUE(B.inf_boleto, '//precio_boleto'))) AS TotalGanancias
FROM CompraBoleto CB
INNER JOIN Boleto B ON CB.boleto_id = B.ID_BOLETO
WHERE EXTRACTVALUE(CB.inf_compra,'//estado_pago') = 'Pagado';
----------------------------------------------2-----------------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS TotalComprasReemblzadas
FROM CompraBoleto CB
WHERE EXTRACTVALUE(CB.inf_compra,'//estado_pago') = 'Reembolsado';
-------------3---------------------------------------------------------------------------------------------------------------------------------------------
----mensual---
SELECT
    CASE 
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 1 THEN 'Enero'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 2 THEN 'Febrero'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 3 THEN 'Marzo'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 4 THEN 'Abril'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 5 THEN 'Mayo'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 6 THEN 'Junio'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 7 THEN 'Julio'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 8 THEN 'Agosto'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 9 THEN 'Septiembre'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 10 THEN 'Octubre'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 11 THEN 'Noviembre'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 12 THEN 'Diciembre'
    END AS Mes,
    EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Cancelado'
GROUP BY EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')),
        EXTRACTVALUE(inf_evento, '/Evento/nombre_evento');
-----mes especifico------------
SELECT
    'Marzo' AS Mes,
    EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Cancelado'
AND EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = 3;


-----trimestral-----
SELECT
    CASE 
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 1 AND 3 THEN 'Primer Trimestre'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 4 AND 6 THEN 'Segundo Trimestre'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 7 AND 9 THEN 'Tercer Trimestre'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 10 AND 12 THEN 'Cuarto Trimestre'
    END AS Trimestre,
    EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Cancelado'
GROUP BY CASE 
            WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 1 AND 3 THEN 'Primer Trimestre'
            WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 4 AND 6 THEN 'Segundo Trimestre'
            WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 7 AND 9 THEN 'Tercer Trimestre'
            WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 10 AND 12 THEN 'Cuarto Trimestre'
        END,
        EXTRACTVALUE(inf_evento, '/Evento/nombre_evento');

---------------trimestre especifico------------------
SELECT
    'Primer Trimestre' AS Trimestre,
    EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Cancelado'
AND EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 1 AND 3;

-----semestral-----
SELECT
    CASE 
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 1 AND 6 THEN 'Primer Semestre'
        WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 7 AND 12 THEN 'Segundo Semestre'
    END AS Semestre,
    EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Cancelado'
GROUP BY CASE 
            WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 1 AND 6 THEN 'Primer Semestre'
            WHEN EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 7 AND 12 THEN 'Segundo Semestre'
        END,
        EXTRACTVALUE(inf_evento, '/Evento/nombre_evento');
---------------semestre especifico---------------------
SELECT
    'Primer Semestre' AS Semestre,
    EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento 
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Cancelado'
AND EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 1 AND 6;

------------------------------4-----------------------------------------------------------------------------------------------------------
------------mes------------
SELECT
    COUNT(*) AS EventosProximoMes
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Programado'
AND EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = EXTRACT(MONTH FROM ADD_MONTHS(CURRENT_DATE, 1))
AND EXTRACT(YEAR FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = EXTRACT(YEAR FROM ADD_MONTHS(CURRENT_DATE, 1));

------------ trimestre------------
SELECT
    COUNT(*) AS EventosProximoTrimestre 
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Programado'
AND EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN EXTRACT(MONTH FROM ADD_MONTHS(CURRENT_DATE, 1)) AND EXTRACT(MONTH FROM ADD_MONTHS(CURRENT_DATE, 3))
AND EXTRACT(YEAR FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = EXTRACT(YEAR FROM ADD_MONTHS(CURRENT_DATE, 1));

------------semestre------------
SELECT
    COUNT(*) AS EventosProximoSemestre
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Programado'
AND EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN EXTRACT(MONTH FROM ADD_MONTHS(CURRENT_DATE, 1)) AND EXTRACT(MONTH FROM ADD_MONTHS(CURRENT_DATE, 6))
AND EXTRACT(YEAR FROM TO_DATE(EXTRACTVALUE(inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = EXTRACT(YEAR FROM ADD_MONTHS(CURRENT_DATE, 1));
--------------------5----------------------------------------------------------------------------------------------------------------------
SELECT
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento') AS CategoriaEvento,
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_maxima') AS CapacidadMaxima,
    (EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_maxima') - COALESCE(SUM(CASE WHEN EXTRACTVALUE(CB.inf_compra, '//estado_pago') IN ('Pagado', 'Pendiente') THEN 1 ELSE 0 END), 0)) AS BoletosDisponibles
FROM
    Evento E
    INNER JOIN Lugar L ON E.lugar_id = L.id_lugar
    LEFT JOIN Boleto B ON E.id_evento = B.evento_id
    LEFT JOIN CompraBoleto CB ON B.id_boleto = CB.boleto_id
WHERE EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento') = 'Concierto'
GROUP BY
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento'),
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_maxima'),
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento');


----------6---------------------------------------------------------------------------------------------------------------------------------
SELECT id_evento, EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Realizado';
-------------------------7--------------------------------------------------------------------------------------------------------------
SELECT
    EXTRACTVALUE(U.inf_usuario, '//estado_cuenta') AS EstadoCuenta,
    EXTRACTVALUE(B.inf_boleto,'//tipo_boleto') AS tipo_boleto,
    COUNT(*) AS TotalBoletosVendidos
FROM CompraBoleto CB
INNER JOIN Boleto B ON CB.boleto_id = B.id_boleto
INNER JOIN Usuario U ON CB.usuario_id = U.id_usuario
WHERE EXTRACTVALUE(CB.inf_compra, '//estado_pago') = 'Pagado'
GROUP BY EXTRACTVALUE(B.inf_boleto, '//tipo_boleto'),
        EXTRACTVALUE(U.inf_usuario, '//estado_cuenta')
ORDER BY EXTRACTVALUE(U.inf_usuario, '//estado_cuenta') ASC;


-----------------------8----------------------------------------------------------------------------------------------------------------------------------------------
SELECT id_evento, EXTRACTVALUE(inf_evento, '/Evento/nombre_evento') AS NombreEvento
FROM Evento
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Cancelado';

----------------------9---------------------------------------------------------------------------------------------------------------------------
SELECT
    count(*) AS TotalDeBoletos,
    EXTRACTVALUE(B.inf_boleto, '//tipo_boleto') AS TipoBoleto,
    SUM(TO_NUMBER(EXTRACTVALUE(B.inf_boleto, '//precio_boleto'))) AS TotalGanancias
FROM CompraBoleto CB
INNER JOIN Boleto B ON CB.boleto_id = B.ID_BOLETO
INNER JOIN Evento E ON B.evento_id = E.id_evento
WHERE EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') = 'Evento 1'
AND EXTRACTVALUE(CB.inf_compra,'//estado_pago') = 'Pagado'
GROUP BY EXTRACTVALUE(B.inf_boleto, '//tipo_boleto');
---------------------10---------------------------------------------------------------------------------------------------------------
SELECT 
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(E.inf_evento, '/Evento/fecha') AS Fecha,
    EXTRACTVALUE(E.inf_evento, '/Evento/hora') AS Hora,
    EXTRACTVALUE(L.inf_lugar, '/Lugar/nombre_lugar') AS NombreLugar
FROM Evento E
INNER JOIN Lugar L ON E.lugar_id = L.id_lugar
WHERE EXTRACTVALUE(E.inf_evento, '/Evento/estatus_evento') = 'Programado'
AND EXTRACT(MONTH FROM TO_DATE(EXTRACTVALUE(E.inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) BETWEEN 1 AND 3
AND EXTRACT(YEAR FROM TO_DATE(EXTRACTVALUE(E.inf_evento, '/Evento/fecha'), 'YYYY-MM-DD')) = EXTRACT(YEAR FROM CURRENT_DATE);

-----------------11--------------------------------------------------------------------------------------------------------------------------------------
-------vip--------------------------------------------------------
SELECT
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento') AS CategoriaEvento,
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_vip') AS CapacidadMaximaVIP,
    (EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_vip') - COALESCE(SUM(CASE WHEN EXTRACTVALUE(CB.inf_compra, '//estado_pago') IN ('Pagado', 'Pendiente') THEN 1 ELSE 0 END), 0)) AS BoletosDisponiblesVIP
FROM
    Evento E
    INNER JOIN Lugar L ON E.lugar_id = L.id_lugar
    LEFT JOIN Boleto B ON E.id_evento = B.evento_id
    LEFT JOIN CompraBoleto CB ON B.id_boleto = CB.boleto_id
WHERE EXTRACTVALUE(B.inf_boleto,'//tipo_boleto') = 'VIP'
GROUP BY
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento'),
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_vip'),
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento');

--------------------preferencial--------------------------------------

SELECT
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento') AS CategoriaEvento,
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_preferencial') AS CapacidadMaximaPreferencial,
    (EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_preferencial') - COALESCE(SUM(CASE WHEN EXTRACTVALUE(CB.inf_compra, '//estado_pago') IN ('Pagado', 'Pendiente') THEN 1 ELSE 0 END), 0)) AS BoletosDisponiblesPreferencial
FROM
    Evento E
    INNER JOIN Lugar L ON E.lugar_id = L.id_lugar
    LEFT JOIN Boleto B ON E.id_evento = B.evento_id
    LEFT JOIN CompraBoleto CB ON B.id_boleto = CB.boleto_id
WHERE EXTRACTVALUE(B.inf_boleto,'//tipo_boleto') = 'Preferencial'
GROUP BY
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento'),
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_preferencial'),
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento');

-----------------general-------------------------------------------
SELECT
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento') AS CategoriaEvento,
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_general') AS CapacidadMaximaGeneral,
    (EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_general') - COALESCE(SUM(CASE WHEN EXTRACTVALUE(CB.inf_compra, '//estado_pago') IN ('Pagado', 'Pendiente') THEN 1 ELSE 0 END), 0)) AS BoletosDisponiblesGeneral
FROM
    Evento E
    INNER JOIN Lugar L ON E.lugar_id = L.id_lugar
    LEFT JOIN Boleto B ON E.id_evento = B.evento_id
    LEFT JOIN CompraBoleto CB ON B.id_boleto = CB.boleto_id
WHERE EXTRACTVALUE(B.inf_boleto,'//tipo_boleto') = 'General'
GROUP BY
    E.id_evento,
    EXTRACTVALUE(E.inf_evento, '/Evento/categoria_evento'),
    EXTRACTVALUE(L.inf_lugar, '/Lugar/capacidad_general'),
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento');
--------------------------12-------------------------------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS BoletosPagados
FROM CompraBoleto CB
INNER JOIN Boleto B ON CB.boleto_id = B.id_boleto
WHERE B.evento_id = 1
AND EXTRACTVALUE(CB.inf_compra, '//estado_pago') = 'Pagado';


------------------------13-----------------------------------------------------------------------------------------------------

SELECT
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(B.inf_boleto,'//tipo_boleto') AS TipoBoleto,
    EXTRACTVALUE(B.inf_boleto, '//precio_boleto') AS PrecioBoleto,
    EXTRACTVALUE(CB.inf_compra, '//estado_pago') AS Estado,
    EXTRACTVALUE(CB.inf_compra, '//metodo_pago') AS MetodoPago
FROM CompraBoleto CB
INNER JOIN Boleto B ON CB.boleto_id = B.ID_BOLETO
INNER JOIN Evento E ON B.evento_id = E.id_evento
WHERE EXTRACTVALUE(CB.inf_compra,'//estado_pago') = 'Reembolsado';

------------------------14-------------------------------------------------------------------------------------------------
SELECT
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(L.inf_lugar, '/Lugar/nombre_lugar') AS NombreLugar,
    COUNT(*) AS TotalDePersonas,
    SUM(TO_NUMBER(EXTRACTVALUE(B.inf_boleto, '//precio_boleto'))) AS TotalGanancias
FROM CompraBoleto CB
INNER JOIN Boleto B ON CB.boleto_id = B.ID_BOLETO
INNER JOIN Evento E ON B.evento_id = E.id_evento
INNER JOIN Lugar L ON E.lugar_id = L.id_lugar
WHERE EXTRACTVALUE(CB.inf_compra,'//estado_pago') = 'Pagado'
GROUP BY EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento'),
        EXTRACTVALUE(L.inf_lugar, '/Lugar/nombre_lugar');

-------------------------15--------------------------------------------------------------------------------------------------
SELECT
    EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento') AS NombreEvento,
    EXTRACTVALUE(B.inf_boleto, '//tipo_boleto') AS TipoBoleto,
    EXTRACTVALUE(U.inf_usuario, '/Usuario/nombre') AS NombreUsuario,
    COUNT(*) AS CantidadReembolsos
FROM CompraBoleto CB
INNER JOIN Boleto B ON CB.boleto_id = B.ID_BOLETO
INNER JOIN Evento E ON B.evento_id = E.id_evento
INNER JOIN Usuario U ON CB.usuario_id = U.id_usuario
WHERE EXTRACTVALUE(CB.inf_compra, '//estado_pago') = 'Reembolsado'
GROUP BY EXTRACTVALUE(E.inf_evento, '/Evento/nombre_evento'),
        EXTRACTVALUE(B.inf_boleto, '//tipo_boleto'),
        EXTRACTVALUE(U.inf_usuario, '/Usuario/nombre');







UPDATE Usuario
SET inf_usuario = UPDATEXML(
    inf_usuario,
    '/Usuario/estado_cuenta/text()',
    'Suspendido'
)
WHERE id_usuario = 1;

UPDATE Evento
SET inf_evento = UPDATEXML(
    inf_evento,
    '/Evento/estatus_evento/text()',
    'Programado'
)
WHERE EXTRACTVALUE(inf_evento, '/Evento/estatus_evento') = 'Realizado';

UPDATE Evento
SET inf_evento = UPDATEXML(
    inf_evento,
    '/Evento/fecha/text()',
    '2024-01-10'
)
WHERE id_evento = 1;

SELECT * FROM Evento WHERE id_evento = 1;


CREATE OR REPLACE TRIGGER verificar_capacidad_boletos
BEFORE INSERT OR UPDATE ON Boleto
FOR EACH ROW
DECLARE
    cantidad_boletos_actual INTEGER;
    capacidad_maxima_lugar INTEGER;
BEGIN
    -- Obtener la cantidad de boletos emitidos para el evento relacionado
    SELECT COUNT(*) INTO cantidad_boletos_actual FROM Boleto WHERE evento_id = :NEW.evento_id;

    -- Obtener la capacidad máxima del lugar del evento
    SELECT EXTRACTVALUE(l.inf_lugar, '/Lugar/capacidad_maxima') INTO capacidad_maxima_lugar
    FROM Lugar l
    JOIN Evento e ON e.lugar_id = l.id_lugar
    WHERE e.id_evento = :NEW.evento_id;

    -- Verificar si se supera la capacidad máxima
    IF cantidad_boletos_actual + 1 > capacidad_maxima_lugar THEN
        -- Si se supera, lanzar una excepción para prevenir la inserción o actualización
        RAISE_APPLICATION_ERROR(-20002, 'La cantidad de boletos supera la capacidad máxima del lugar.');
END IF;
END;

INSERT INTO Lugar (id_lugar,inf_lugar) VALUES (11,XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Lugar Prueba</nombre_lugar>
  <direccion>Mi casa</direccion>
  <tipo_lugar>auditorio</tipo_lugar>
  <latitud>51.5074</latitud> 
  <longitud>-0.1278</longitud>
  <capacidad_maxima>2</capacidad_maxima>
  <capacidad_vip>1</capacidad_vip>
  <capacidad_preferencial>1</capacidad_preferencial>
  <capacidad_general>0</capacidad_general>
</Lugar>
'));

INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (12, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 12</nombre_evento>
    <fecha>2024-01-19</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 12</descripcion>
    <precio_vip>129.12</precio_vip>
    <precio_preferencial>102.66</precio_preferencial>
    <precio_general>34.9</precio_general>
    <categoria_evento>Exposicion</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
</Evento>'), 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (221, XMLTYPE('<Asiento><numero_asiento>1</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKKKKK, Fila 219, Asiento 219</ubicacion></Asiento>'),11, 12);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (222, XMLTYPE('<Asiento><numero_asiento>2</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección LLLLLL, Fila 220, Asiento 220</ubicacion></Asiento>'),11, 12);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (223, XMLTYPE('<Asiento><numero_asiento>3</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección LLLLLL, Fila 220, Asiento 220</ubicacion></Asiento>'),11, 12);

INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(111, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>285.00</precio_boleto></Boleto>'), 12, 221);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(112, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>13.00</precio_boleto></Boleto>'), 12, 222); 
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(113, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>13.00</precio_boleto></Boleto>'), 12, 223); 



UPDATE CompraBoleto
SET inf_compra = UPDATEXML(
    inf_compra,
    '/CompraBoleto/estado_pago/text()',
    'Reembolsado'
)
WHERE id_compra = 1;

SELECT (EXTRACTVALUE(e.inf_evento, '/Evento/fecha'))
    FROM Evento e
    JOIN Boleto b ON b.evento_id = e.id_evento
    WHERE b.id_boleto = 1;


    CREATE OR REPLACE TRIGGER verificar_cancelacion_compra
BEFORE UPDATE ON CompraBoleto -- Asumiendo que la cancelación se maneja mediante una eliminación
FOR EACH ROW
DECLARE
    fecha_evento DATE;
BEGIN
    -- Obtener la fecha y hora del evento asociado al boleto comprado
    SELECT TO_DATE(EXTRACTVALUE(e.inf_evento, '/Evento/fecha'), 'YYYY-MM-DD') INTO fecha_evento
    FROM Evento e
    JOIN Boleto b ON b.evento_id = e.id_evento
    WHERE b.id_boleto = :NEW.boleto_id;


    -- Verificar si la fecha y hora actuales son anteriores a la fecha y hora del evento
    IF fecha_evento - SYSDATE < 1 THEN
        -- Si no es así, lanzar una excepción para prevenir la actualización
        RAISE_APPLICATION_ERROR(-20001, 'No se puede cambiar la información del boleto con menos de un dia de anticipacion a la fecha del evento.');
END IF;
END;

CREATE OR REPLACE TRIGGER verificar_cancelacion_compra
BEFORE UPDATE ON CompraBoleto -- Asumiendo que la cancelación se maneja mediante una eliminación
FOR EACH ROW
DECLARE
    fecha_evento DATE;
BEGIN
    -- Obtener la fecha y hora del evento asociado al boleto comprado
    SELECT TO_DATE(EXTRACTVALUE(e.inf_evento, '/Evento/fecha'), 'YYYY-MM-DD') INTO fecha_evento
    FROM Evento e
    JOIN Boleto b ON b.evento_id = e.id_evento
    WHERE b.id_boleto = :OLD.boleto_id;

    -- Verificar si la fecha y hora actuales son anteriores a la fecha y hora del evento
    IF fecha_evento - SYSDATE < 1 THEN
        -- Si no es así, lanzar una excepción para prevenir la actualización
        
    END IF;
END;


UPDATE Evento
SET inf_evento = UPDATEXML(
    inf_evento,
    '/Evento/estatus_evento/text()',
    'Cancelado'
)
WHERE id_evento = 1;