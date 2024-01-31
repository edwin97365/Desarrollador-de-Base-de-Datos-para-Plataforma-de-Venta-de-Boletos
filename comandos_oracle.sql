CONNECT / AS SYSDBA;
CREATE USER PROYECTO IDENTIFIED BY PROYECTO; 
GRANT CONNECT, RESOURCE TO PROYECTO; 
CREATE DIRECTORY PROYECTO AS 'C:\PROYECTO';  
--Crear la carpeta c:\PROYECTO previo a la ejeucición de este comando.
GRANT READ, WRITE ON DIRECTORY PROYECTO TO PROYECTO; 
DISCONNECT;
CONNECT PROYECTO/PROYECTO; 
ALTER SESSION SET NLS_TERRITORY='MEXICO'; 
SET PAGESIZE 500; 
SET LINESIZE 300; 
SET LONG 2000;
/
--guardar los archivos en la carpeta antes de ejecutar--
--se debe ejecutar antes de las entidades--

BEGIN
DBMS_XMLSCHEMA.REGISTERSCHEMA(SCHEMAURL  => 'usuario.xsd',
                              SCHEMADOC  => BFILENAME('PROYECTO',
                                                       'usuario.xsd'),
                              LOCAL  => TRUE,
                              GENTYPES  => FALSE,
                              GENTABLES  => FALSE
                              ); 
END;
/
BEGIN
DBMS_XMLSCHEMA.REGISTERSCHEMA(SCHEMAURL  => 'asiento.xsd',
                              SCHEMADOC  => BFILENAME('PROYECTO',
                                                       'asiento.xsd'),
                              LOCAL  => TRUE,
                              GENTYPES  => FALSE,
                              GENTABLES  => FALSE
                              ); 
END;
/
BEGIN
DBMS_XMLSCHEMA.REGISTERSCHEMA(SCHEMAURL  => 'boleto.xsd',
                              SCHEMADOC  => BFILENAME('PROYECTO',
                                                       'boleto.xsd'),
                              LOCAL  => TRUE,
                              GENTYPES  => FALSE,
                              GENTABLES  => FALSE
                              ); 
END;
/
BEGIN
DBMS_XMLSCHEMA.REGISTERSCHEMA(SCHEMAURL  => 'evento.xsd',
                              SCHEMADOC  => BFILENAME('PROYECTO',
                                                       'evento.xsd'),
                              LOCAL  => TRUE,
                              GENTYPES  => FALSE,
                              GENTABLES  => FALSE
                              ); 
END;

BEGIN
DBMS_XMLSCHEMA.REGISTERSCHEMA(SCHEMAURL  => 'compraboleto.xsd',
                              SCHEMADOC  => BFILENAME('PROYECTO',
                                                       'compraboleto.xsd'),
                              LOCAL  => TRUE,
                              GENTYPES  => FALSE,
                              GENTABLES  => FALSE
                              ); 
END;
/

BEGIN
DBMS_XMLSCHEMA.REGISTERSCHEMA(SCHEMAURL  => 'lugar.xsd',
                              SCHEMADOC  => BFILENAME('PROYECTO',
                                                       'lugar.xsd'),
                              LOCAL  => TRUE,
                              GENTYPES  => FALSE,
                              GENTABLES  => FALSE
                              ); 
END;
/

--Crear primero los schemas
CREATE TABLE Usuario (
    id_usuario NUMBER PRIMARY KEY,
    inf_usuario XMLTYPE
)
XMLTYPE COLUMN inf_usuario
    STORE AS CLOB
    XMLSCHEMA "usuario.xsd"
    ELEMENT "Usuario";

CREATE TABLE Lugar (
    id_lugar NUMBER PRIMARY KEY,
    inf_lugar XMLTYPE
)
XMLTYPE COLUMN inf_lugar
    STORE AS CLOB
    XMLSCHEMA "lugar.xsd"
    ELEMENT "Lugar";

CREATE TABLE Evento (
    id_evento NUMBER PRIMARY KEY,
    inf_evento XMLTYPE,
    lugar_id NUMBER REFERENCES Lugar(id_lugar)
)
XMLTYPE COLUMN inf_evento
    STORE AS CLOB
    XMLSCHEMA "evento.xsd"
    ELEMENT "Evento";

CREATE TABLE Asiento (
    id_asiento NUMBER PRIMARY KEY,
    inf_asiento XMLTYPE,
    lugar_id NUMBER REFERENCES Lugar(id_lugar),
    evento_id NUMBER REFERENCES Evento(id_evento)
)
XMLTYPE COLUMN inf_asiento
    STORE AS CLOB
    XMLSCHEMA "asiento.xsd"
    ELEMENT "Asiento";

CREATE TABLE Boleto (
    id_boleto NUMBER PRIMARY KEY,
    inf_boleto XMLTYPE,
    evento_id NUMBER REFERENCES Evento(id_evento),
    asiento_id NUMBER REFERENCES Asiento(id_asiento)
)
XMLTYPE COLUMN inf_boleto
    STORE AS CLOB
    XMLSCHEMA "boleto.xsd"
    ELEMENT "Boleto";

CREATE TABLE CompraBoleto (
    id_compra NUMBER PRIMARY KEY,
    inf_compra XMLTYPE,
    boleto_id NUMBER REFERENCES Boleto(id_boleto),
    usuario_id NUMBER REFERENCES Usuario(id_usuario)
)
XMLTYPE COLUMN inf_compra
    STORE AS CLOB
    XMLSCHEMA "compraboleto.xsd"
    ELEMENT "CompraBoleto";


--despues de crear las entidades--

CREATE OR REPLACE TRIGGER valida_usuario
BEFORE INSERT OR UPDATE ON Usuario
FOR EACH ROW 
BEGIN
    IF(:NEW.inf_usuario IS NOT NULL) THEN 
        :NEW.inf_usuario.schemavalidate();
    END IF;
END;
/

CREATE OR REPLACE TRIGGER valida_asiento
BEFORE INSERT OR UPDATE ON Asiento
FOR EACH ROW
BEGIN
    IF(:NEW.inf_asiento IS NOT NULL) THEN 
        :NEW.inf_asiento.schemavalidate();
    END IF;
END;
/

CREATE OR REPLACE TRIGGER valida_boleto
BEFORE INSERT OR UPDATE ON Boleto
FOR EACH ROW
BEGIN
    IF(:NEW.inf_boleto IS NOT NULL) THEN 
        :NEW.inf_boleto.schemavalidate();
    END IF;
END;
/

CREATE OR REPLACE TRIGGER valida_evento
BEFORE INSERT OR UPDATE ON Evento
FOR EACH ROW
BEGIN
    IF(:NEW.inf_evento IS NOT NULL) THEN 
        :NEW.inf_evento.schemavalidate();
    END IF;
END;
/

CREATE OR REPLACE TRIGGER valida_compraboleto
BEFORE INSERT OR UPDATE ON CompraBoleto
FOR EACH ROW
BEGIN
    IF(:NEW.inf_compra IS NOT NULL) THEN 
        :NEW.inf_compra.schemavalidate();
    END IF;
END;
/

CREATE OR REPLACE TRIGGER valida_lugar
BEFORE INSERT OR UPDATE ON Lugar
FOR EACH ROW
BEGIN
    IF(:NEW.inf_lugar IS NOT NULL) THEN 
        :NEW.inf_lugar.schemavalidate();
    END IF;
END;
/
--INSERTS-----------------------------------------------------------------------------
--Usuarios--------------------------------

INSERT INTO Usuario VALUES (1, XMLType('<Usuario><nombre>Maria Lopez</nombre><correo_electronico>maria.lopez@example.com</correo_electronico><telefono>1234567890</telefono><direccion>Calle Falsa 123</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (2, XMLType('<Usuario><nombre>Carlos Jimenez</nombre><correo_electronico>carlos.jimenez@example.com</correo_electronico><telefono>2345678901</telefono><direccion>Avenida Siempre Viva 456</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (3, XMLType('<Usuario><nombre>Ana Torres</nombre><correo_electronico>ana.torres@example.com</correo_electronico><telefono>3456789012</telefono><direccion>Plaza Central 789</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (4, XMLType('<Usuario><nombre>Pedro Martinez</nombre><correo_electronico>pedro.martinez@example.com</correo_electronico><telefono>4567890123</telefono><direccion>Barrio Antiguo 101</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (5, XMLType('<Usuario><nombre>Laura García</nombre><correo_electronico>laura.garcia@example.com</correo_electronico><telefono>5678901234</telefono><direccion>Urbanización Los Alamos 202</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (6, XMLType('<Usuario><nombre>Jorge Alonso</nombre><correo_electronico>jorge.alonso@example.com</correo_electronico><telefono>1234567891</telefono><direccion>Callejón de los Sueños 707</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (7, XMLType('<Usuario><nombre>Roberto Ruiz</nombre><correo_electronico>roberto.ruiz@example.com</correo_electronico><telefono>6789012345</telefono><direccion>Camino Largo 303</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (8, XMLType('<Usuario><nombre>Sofia Castro</nombre><correo_electronico>sofia.castro@example.com</correo_electronico><telefono>7890123456</telefono><direccion>Ruta del Sol 404</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (9, XMLType('<Usuario><nombre>Luis Méndez</nombre><correo_electronico>luis.mendez@example.com</correo_electronico><telefono>8901234567</telefono><direccion>Avenida de la Luna 505</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

INSERT INTO Usuario VALUES (10, XMLType('<Usuario><nombre>Carmen Ortiz</nombre><correo_electronico>carmen.ortiz@example.com</correo_electronico><telefono>9012345678</telefono><direccion>Paseo de los Olivos 606</direccion><estado_cuenta>activo</estado_cuenta></Usuario>'));

-------Lugar----------------------------------
INSERT INTO Lugar (id_lugar,inf_lugar) VALUES (1,XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Estadio Nacional</nombre_lugar>
  <direccion>123 Main Street, Ciudad, País</direccion>
  <tipo_lugar>estadio</tipo_lugar>
  <latitud>40.7128</latitud>
  <longitud>-74.0060</longitud>
  <capacidad_maxima>50000</capacidad_maxima>
  <capacidad_vip>5000</capacidad_vip>
  <capacidad_preferencial>10000</capacidad_preferencial>
  <capacidad_general>35000</capacidad_general>
</Lugar>
'));

INSERT INTO Lugar (id_lugar,inf_lugar) VALUES (2,XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Coliseo Imperial</nombre_lugar>
  <direccion>456 Secondary Road, Imperial City, Empire</direccion>
  <tipo_lugar>Teatro</tipo_lugar>
  <latitud>48.8566</latitud>
  <longitud>2.3522</longitud>
  <capacidad_maxima>30000</capacidad_maxima>
  <capacidad_vip>3000</capacidad_vip>
  <capacidad_preferencial>7000</capacidad_preferencial>
  <capacidad_general>20000</capacidad_general>
</Lugar>
'));

INSERT INTO Lugar (id_lugar,inf_lugar) VALUES (3,XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Parque Verde</nombre_lugar>
  <direccion>789 Park Ave, Green City, Natureland</direccion>
  <tipo_lugar>Parque</tipo_lugar>
  <latitud>37.7749</latitud>
  <longitud>-122.4194</longitud>
  <capacidad_maxima>15000</capacidad_maxima>
  <capacidad_vip>1500</capacidad_vip>
  <capacidad_preferencial>3000</capacidad_preferencial>
  <capacidad_general>10500</capacidad_general>
</Lugar>
'));


INSERT INTO Lugar (id_lugar,inf_lugar) VALUES (4,XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Sala de Conciertos Harmony</nombre_lugar>
  <direccion>101 Music Street, Melody Town, Symphony</direccion>
  <tipo_lugar>Sala de conciertos</tipo_lugar>
  <latitud>51.5074</latitud>
  <longitud>-0.1278</longitud>
  <capacidad_maxima>10000</capacidad_maxima>
  <capacidad_vip>1000</capacidad_vip>
  <capacidad_preferencial>2000</capacidad_preferencial>
  <capacidad_general>7000</capacidad_general>
</Lugar>
'));

INSERT INTO Lugar (id_lugar,inf_lugar) VALUES (5,XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Auditorio Ciudad Luz</nombre_lugar>
  <direccion>202 Bright Blvd, Luminous City, Radiance</direccion>
  <tipo_lugar>auditorio</tipo_lugar>
  <latitud>35.6895</latitud>
  <longitud>139.6917</longitud>
  <capacidad_maxima>20000</capacidad_maxima>
  <capacidad_vip>2000</capacidad_vip>
  <capacidad_preferencial>5000</capacidad_preferencial>
  <capacidad_general>13000</capacidad_general>
</Lugar>
'));

INSERT INTO Lugar (id_lugar, inf_lugar) VALUES (6, XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Plaza Central</nombre_lugar>
  <direccion>321 Plaza Road, Central City, PlazaLand</direccion>
  <tipo_lugar>Parque</tipo_lugar>
  <latitud>34.0522</latitud>
  <longitud>-118.2437</longitud>
  <capacidad_maxima>10000</capacidad_maxima>
  <capacidad_vip>1000</capacidad_vip>
  <capacidad_preferencial>2000</capacidad_preferencial>
  <capacidad_general>7000</capacidad_general>
</Lugar>
'));

INSERT INTO Lugar (id_lugar, inf_lugar) VALUES (7, XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Estadio Azul</nombre_lugar>
  <direccion>456 Stadium Ave, Sporty City, Athletic</direccion>
  <tipo_lugar>estadio</tipo_lugar>
  <latitud>40.7128</latitud>
  <longitud>-74.0060</longitud>
  <capacidad_maxima>60000</capacidad_maxima>
  <capacidad_vip>6000</capacidad_vip>
  <capacidad_preferencial>12000</capacidad_preferencial>
  <capacidad_general>42000</capacidad_general>
</Lugar>
'));

INSERT INTO Lugar (id_lugar, inf_lugar) VALUES (8, XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Teatro del Sol</nombre_lugar>
  <direccion>789 Theater St, Artistic Town, Cultureville</direccion>
  <tipo_lugar>Teatro</tipo_lugar>
  <latitud>41.8781</latitud>
  <longitud>-87.6298</longitud>
  <capacidad_maxima>5000</capacidad_maxima>
  <capacidad_vip>500</capacidad_vip>
  <capacidad_preferencial>1000</capacidad_preferencial>
  <capacidad_general>3500</capacidad_general>
</Lugar>
'));

INSERT INTO Lugar (id_lugar, inf_lugar) VALUES (9, XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Arena Ciudad Fuego</nombre_lugar>
  <direccion>101 Arena Path, Fiery City, Blaze</direccion>
  <tipo_lugar>auditorio</tipo_lugar>
  <latitud>37.7749</latitud>
  <longitud>-122.4194</longitud>
  <capacidad_maxima>25000</capacidad_maxima>
  <capacidad_vip>2500</capacidad_vip>
  <capacidad_preferencial>5000</capacidad_preferencial>
  <capacidad_general>17500</capacidad_general>
</Lugar>
'));


INSERT INTO Lugar (id_lugar, inf_lugar) VALUES (10, XMLType('<?xml version="1.0" ?>
<Lugar>
  <nombre_lugar>Palacio de las Artes</nombre_lugar>
  <direccion>789 Art Avenue, Artistic Town, Artville</direccion>
  <tipo_lugar>Sala de conciertos</tipo_lugar>
  <latitud>42.3601</latitud>
  <longitud>-71.0589</longitud>
  <capacidad_maxima>8000</capacidad_maxima>
  <capacidad_vip>800</capacidad_vip>
  <capacidad_preferencial>1600</capacidad_preferencial>
  <capacidad_general>5600</capacidad_general>
</Lugar>
'));

----------evento-------------------------------

INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (1, XMLTYPE('
    <Evento>
        <nombre_evento>Evento 1</nombre_evento>
        <fecha>2024-01-10</fecha>
        <hora>05:58:09</hora>
        <descripcion>Descripción del Evento 1</descripcion>
        <precio_vip>31.28</precio_vip>
        <precio_preferencial>51.65</precio_preferencial>
        <precio_general>84.15</precio_general>
        <categoria_evento>Concierto</categoria_evento>
        <estatus_evento>Realizado</estatus_evento>
    </Evento>'), 1);

    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (2, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 2</nombre_evento>
    <fecha>2024-01-23</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 2</descripcion>
    <precio_vip>94.54</precio_vip>
    <precio_preferencial>130.8</precio_preferencial>
    <precio_general>66.15</precio_general>
    <categoria_evento>Obra de teatro</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
    </Evento>'), 2);


    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (3, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 3</nombre_evento>
    <fecha>2024-01-26</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 3</descripcion>
    <precio_vip>64.01</precio_vip>
    <precio_preferencial>97.28</precio_preferencial>
    <precio_general>81.06</precio_general>
    <categoria_evento>Exposicion</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
</Evento>
'), 3);


    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (4, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 4</nombre_evento>
    <fecha>2024-01-16</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 4</descripcion>
    <precio_vip>32.06</precio_vip>
    <precio_preferencial>13.95</precio_preferencial>
    <precio_general>63.95</precio_general>
    <categoria_evento>Conferencia</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
</Evento>'), 4);


    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (5, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 5</nombre_evento>
    <fecha>2024-01-21</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 5</descripcion>
    <precio_vip>138.79</precio_vip>
    <precio_preferencial>67.13</precio_preferencial>
    <precio_general>36.18</precio_general>
    <categoria_evento>Festival</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
</Evento>'), 5);

    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (6, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 6</nombre_evento>
    <fecha>2024-02-04</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 6</descripcion>
    <precio_vip>77.05</precio_vip>
    <precio_preferencial>99.43</precio_preferencial>
    <precio_general>75.54</precio_general>
    <categoria_evento>Conferencia</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
</Evento>
'), 6);


    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (7, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 7</nombre_evento>
    <fecha>2024-02-01</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 7</descripcion>
    <precio_vip>173.0</precio_vip>
    <precio_preferencial>129.64</precio_preferencial>
    <precio_general>72.54</precio_general>
    <categoria_evento>Evento deportivo</categoria_evento>
    <estatus_evento>Cancelado</estatus_evento>
    </Evento>'), 7);


    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (8, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 8</nombre_evento>
    <fecha>2024-02-04</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 8</descripcion>
    <precio_vip>190.56</precio_vip>
    <precio_preferencial>15.41</precio_preferencial>
    <precio_general>65.28</precio_general>
    <categoria_evento>Concierto</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
</Evento>'), 8);

    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (9, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 9</nombre_evento>
    <fecha>2024-02-07</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 9</descripcion>
    <precio_vip>198.21</precio_vip>
    <precio_preferencial>123.34</precio_preferencial>
    <precio_general>52.99</precio_general>
    <categoria_evento>Exposicion</categoria_evento>
    <estatus_evento>Cancelado</estatus_evento>
</Evento>
'), 9);

    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (10, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 10</nombre_evento>
    <fecha>2024-01-16</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 10</descripcion>
    <precio_vip>134.87</precio_vip>
    <precio_preferencial>31.63</precio_preferencial>
    <precio_general>53.37</precio_general>
    <categoria_evento>Obra de teatro</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
    </Evento>'), 10);

    INSERT INTO Evento (id_evento, inf_evento, lugar_id)
VALUES (11, XMLTYPE('
    <Evento>
    <nombre_evento>Evento 11</nombre_evento>
    <fecha>2024-01-18</fecha>
    <hora>06:05:22</hora>
    <descripcion>Descripción del Evento 11</descripcion>
    <precio_vip>129.12</precio_vip>
    <precio_preferencial>102.66</precio_preferencial>
    <precio_general>34.9</precio_general>
    <categoria_evento>Exposicion</categoria_evento>
    <estatus_evento>Programado</estatus_evento>
</Evento>'), 2);

----asientos------------
INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (1, XMLTYPE('<Asiento><numero_asiento>1</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección A, Fila 1, Asiento 1</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (2, XMLTYPE('<Asiento><numero_asiento>2</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección B, Fila 2, Asiento 2</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (3, XMLTYPE('<Asiento><numero_asiento>3</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección C, Fila 3, Asiento 3</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (4, XMLTYPE('<Asiento><numero_asiento>4</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección D, Fila 4, Asiento 4</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (5, XMLTYPE('<Asiento><numero_asiento>5</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección E, Fila 5, Asiento 5</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (6, XMLTYPE('<Asiento><numero_asiento>6</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección F, Fila 6, Asiento 6</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (7, XMLTYPE('<Asiento><numero_asiento>7</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección G, Fila 7, Asiento 7</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (8, XMLTYPE('<Asiento><numero_asiento>8</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección H, Fila 8, Asiento 8</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (9, XMLTYPE('<Asiento><numero_asiento>9</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección I, Fila 9, Asiento 9</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (10, XMLTYPE('<Asiento><numero_asiento>10</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección J, Fila 10, Asiento 10</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (11, XMLTYPE('<Asiento><numero_asiento>11</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección K, Fila 11, Asiento 11</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (12, XMLTYPE('<Asiento><numero_asiento>12</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección L, Fila 12, Asiento 12</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (13, XMLTYPE('<Asiento><numero_asiento>13</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección M, Fila 13, Asiento 13</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (14, XMLTYPE('<Asiento><numero_asiento>14</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección N, Fila 14, Asiento 14</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (15, XMLTYPE('<Asiento><numero_asiento>15</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección O, Fila 15, Asiento 15</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (16, XMLTYPE('<Asiento><numero_asiento>16</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección P, Fila 16, Asiento 16</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (17, XMLTYPE('<Asiento><numero_asiento>17</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección Q, Fila 17, Asiento 17</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (18, XMLTYPE('<Asiento><numero_asiento>18</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección R, Fila 18, Asiento 18</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (19, XMLTYPE('<Asiento><numero_asiento>19</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección S, Fila 19, Asiento 19</ubicacion></Asiento>'), 1, 1);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (20, XMLTYPE('<Asiento><numero_asiento>20</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección T, Fila 20, Asiento 20</ubicacion></Asiento>'), 1, 1);


INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (21, XMLTYPE('<Asiento><numero_asiento>21</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección U, Fila 21, Asiento 21</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (22, XMLTYPE('<Asiento><numero_asiento>22</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección V, Fila 22, Asiento 22</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (23, XMLTYPE('<Asiento><numero_asiento>23</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección W, Fila 23, Asiento 23</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (24, XMLTYPE('<Asiento><numero_asiento>24</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección X, Fila 24, Asiento 24</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (25, XMLTYPE('<Asiento><numero_asiento>25</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección Y, Fila 25, Asiento 25</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (26, XMLTYPE('<Asiento><numero_asiento>26</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección Z, Fila 26, Asiento 26</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (27, XMLTYPE('<Asiento><numero_asiento>27</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AA, Fila 27, Asiento 27</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (28, XMLTYPE('<Asiento><numero_asiento>28</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección BB, Fila 28, Asiento 28</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (29, XMLTYPE('<Asiento><numero_asiento>29</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CC, Fila 29, Asiento 29</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (30, XMLTYPE('<Asiento><numero_asiento>30</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección DD, Fila 30, Asiento 30</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (31, XMLTYPE('<Asiento><numero_asiento>31</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección EE, Fila 31, Asiento 31</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (32, XMLTYPE('<Asiento><numero_asiento>32</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección FF, Fila 32, Asiento 32</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (33, XMLTYPE('<Asiento><numero_asiento>33</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección GG, Fila 33, Asiento 33</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (34, XMLTYPE('<Asiento><numero_asiento>34</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección HH, Fila 34, Asiento 34</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (35, XMLTYPE('<Asiento><numero_asiento>35</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección II, Fila 35, Asiento 35</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (36, XMLTYPE('<Asiento><numero_asiento>36</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección JJ, Fila 36, Asiento 36</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (37, XMLTYPE('<Asiento><numero_asiento>37</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección KK, Fila 37, Asiento 37</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (38, XMLTYPE('<Asiento><numero_asiento>38</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección LL, Fila 38, Asiento 38</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (39, XMLTYPE('<Asiento><numero_asiento>39</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección MM, Fila 39, Asiento 39</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (40, XMLTYPE('<Asiento><numero_asiento>40</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección NN, Fila 40, Asiento 40</ubicacion></Asiento>'), 2, 2);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (41, XMLTYPE('<Asiento><numero_asiento>41</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección OO, Fila 41, Asiento 41</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (42, XMLTYPE('<Asiento><numero_asiento>42</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección PP, Fila 42, Asiento 42</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (43, XMLTYPE('<Asiento><numero_asiento>43</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección QQ, Fila 43, Asiento 43</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (44, XMLTYPE('<Asiento><numero_asiento>44</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección RR, Fila 44, Asiento 44</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (45, XMLTYPE('<Asiento><numero_asiento>45</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección SS, Fila 45, Asiento 45</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (46, XMLTYPE('<Asiento><numero_asiento>46</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección TT, Fila 46, Asiento 46</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (47, XMLTYPE('<Asiento><numero_asiento>47</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección UU, Fila 47, Asiento 47</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (48, XMLTYPE('<Asiento><numero_asiento>48</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección VV, Fila 48, Asiento 48</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (49, XMLTYPE('<Asiento><numero_asiento>49</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección WW, Fila 49, Asiento 49</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (50, XMLTYPE('<Asiento><numero_asiento>50</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección XX, Fila 50, Asiento 50</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (51, XMLTYPE('<Asiento><numero_asiento>51</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección YY, Fila 51, Asiento 51</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (52, XMLTYPE('<Asiento><numero_asiento>52</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección ZZ, Fila 52, Asiento 52</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (53, XMLTYPE('<Asiento><numero_asiento>53</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AAA, Fila 53, Asiento 53</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (54, XMLTYPE('<Asiento><numero_asiento>54</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección BBB, Fila 54, Asiento 54</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (55, XMLTYPE('<Asiento><numero_asiento>55</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CCC, Fila 55, Asiento 55</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (56, XMLTYPE('<Asiento><numero_asiento>56</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección DDD, Fila 56, Asiento 56</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (57, XMLTYPE('<Asiento><numero_asiento>57</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección EEE, Fila 57, Asiento 57</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (58, XMLTYPE('<Asiento><numero_asiento>58</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección FFF, Fila 58, Asiento 58</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (59, XMLTYPE('<Asiento><numero_asiento>59</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección GGG, Fila 59, Asiento 59</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (60, XMLTYPE('<Asiento><numero_asiento>60</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección HHH, Fila 60, Asiento 60</ubicacion></Asiento>'), 3, 3);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (61, XMLTYPE('<Asiento><numero_asiento>61</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección III, Fila 61, Asiento 61</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (62, XMLTYPE('<Asiento><numero_asiento>62</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección JJJ, Fila 62, Asiento 62</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (63, XMLTYPE('<Asiento><numero_asiento>63</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKK, Fila 63, Asiento 63</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (64, XMLTYPE('<Asiento><numero_asiento>64</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección LLL, Fila 64, Asiento 64</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (65, XMLTYPE('<Asiento><numero_asiento>65</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección MMM, Fila 65, Asiento 65</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (66, XMLTYPE('<Asiento><numero_asiento>66</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección NNN, Fila 66, Asiento 66</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (67, XMLTYPE('<Asiento><numero_asiento>67</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección OOO, Fila 67, Asiento 67</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (68, XMLTYPE('<Asiento><numero_asiento>68</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección PPP, Fila 68, Asiento 68</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (69, XMLTYPE('<Asiento><numero_asiento>69</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección QQQ, Fila 69, Asiento 69</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (70, XMLTYPE('<Asiento><numero_asiento>70</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección RRR, Fila 70, Asiento 70</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (71, XMLTYPE('<Asiento><numero_asiento>71</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección SSS, Fila 71, Asiento 71</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (72, XMLTYPE('<Asiento><numero_asiento>72</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección TTT, Fila 72, Asiento 72</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (73, XMLTYPE('<Asiento><numero_asiento>73</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección UUU, Fila 73, Asiento 73</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (74, XMLTYPE('<Asiento><numero_asiento>74</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección VVV, Fila 74, Asiento 74</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (75, XMLTYPE('<Asiento><numero_asiento>75</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección WWW, Fila 75, Asiento 75</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (76, XMLTYPE('<Asiento><numero_asiento>76</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección XXX, Fila 76, Asiento 76</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (77, XMLTYPE('<Asiento><numero_asiento>77</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección YYY, Fila 77, Asiento 77</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (78, XMLTYPE('<Asiento><numero_asiento>78</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección ZZZ, Fila 78, Asiento 78</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (79, XMLTYPE('<Asiento><numero_asiento>79</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AAAA, Fila 79, Asiento 79</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (80, XMLTYPE('<Asiento><numero_asiento>80</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección BBBB, Fila 80, Asiento 80</ubicacion></Asiento>'), 4, 4);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (81, XMLTYPE('<Asiento><numero_asiento>81</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CCCC, Fila 81, Asiento 81</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (82, XMLTYPE('<Asiento><numero_asiento>82</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección DDDD, Fila 82, Asiento 82</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (83, XMLTYPE('<Asiento><numero_asiento>83</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección EEEE, Fila 83, Asiento 83</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (84, XMLTYPE('<Asiento><numero_asiento>84</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección FFFF, Fila 84, Asiento 84</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (85, XMLTYPE('<Asiento><numero_asiento>85</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección GGGG, Fila 85, Asiento 85</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (86, XMLTYPE('<Asiento><numero_asiento>86</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección HHHH, Fila 86, Asiento 86</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (87, XMLTYPE('<Asiento><numero_asiento>87</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección IIII, Fila 87, Asiento 87</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (88, XMLTYPE('<Asiento><numero_asiento>88</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección JJJJ, Fila 88, Asiento 88</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (89, XMLTYPE('<Asiento><numero_asiento>89</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKKK, Fila 89, Asiento 89</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (90, XMLTYPE('<Asiento><numero_asiento>90</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección LLLL, Fila 90, Asiento 90</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (91, XMLTYPE('<Asiento><numero_asiento>91</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección MMMM, Fila 91, Asiento 91</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (92, XMLTYPE('<Asiento><numero_asiento>92</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección NNNN, Fila 92, Asiento 92</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (93, XMLTYPE('<Asiento><numero_asiento>93</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección OOOO, Fila 93, Asiento 93</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (94, XMLTYPE('<Asiento><numero_asiento>94</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección PPPP, Fila 94, Asiento 94</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (95, XMLTYPE('<Asiento><numero_asiento>95</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección QQQQ, Fila 95, Asiento 95</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (96, XMLTYPE('<Asiento><numero_asiento>96</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección RRRR, Fila 96, Asiento 96</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (97, XMLTYPE('<Asiento><numero_asiento>97</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección SSSS, Fila 97, Asiento 97</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (98, XMLTYPE('<Asiento><numero_asiento>98</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección TTTT, Fila 98, Asiento 98</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (99, XMLTYPE('<Asiento><numero_asiento>99</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección UUUU, Fila 99, Asiento 99</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (100, XMLTYPE('<Asiento><numero_asiento>100</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección VVVV, Fila 100, Asiento 100</ubicacion></Asiento>'), 5, 5);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (101, XMLTYPE('<Asiento><numero_asiento>101</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección WWWW, Fila 101, Asiento 101</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (102, XMLTYPE('<Asiento><numero_asiento>102</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección XXXX, Fila 102, Asiento 102</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (103, XMLTYPE('<Asiento><numero_asiento>103</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección YYYY, Fila 103, Asiento 103</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (104, XMLTYPE('<Asiento><numero_asiento>104</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección ZZZZ, Fila 104, Asiento 104</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (105, XMLTYPE('<Asiento><numero_asiento>105</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AAAA, Fila 105, Asiento 105</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (106, XMLTYPE('<Asiento><numero_asiento>106</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección BBBB, Fila 106, Asiento 106</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (107, XMLTYPE('<Asiento><numero_asiento>107</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CCCC, Fila 107, Asiento 107</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (108, XMLTYPE('<Asiento><numero_asiento>108</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección DDDD, Fila 108, Asiento 108</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (109, XMLTYPE('<Asiento><numero_asiento>109</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección EEEE, Fila 109, Asiento 109</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (110, XMLTYPE('<Asiento><numero_asiento>110</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección FFFF, Fila 110, Asiento 110</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (111, XMLTYPE('<Asiento><numero_asiento>111</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección GGGG, Fila 111, Asiento 111</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (112, XMLTYPE('<Asiento><numero_asiento>112</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección HHHH, Fila 112, Asiento 112</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (113, XMLTYPE('<Asiento><numero_asiento>113</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección IIII, Fila 113, Asiento 113</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (114, XMLTYPE('<Asiento><numero_asiento>114</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección JJJJ, Fila 114, Asiento 114</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (115, XMLTYPE('<Asiento><numero_asiento>115</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKKK, Fila 115, Asiento 115</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (116, XMLTYPE('<Asiento><numero_asiento>116</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección LLLL, Fila 116, Asiento 116</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (117, XMLTYPE('<Asiento><numero_asiento>117</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección MMMM, Fila 117, Asiento 117</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (118, XMLTYPE('<Asiento><numero_asiento>118</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección NNNN, Fila 118, Asiento 118</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (119, XMLTYPE('<Asiento><numero_asiento>119</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección OOOO, Fila 119, Asiento 119</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (120, XMLTYPE('<Asiento><numero_asiento>120</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección PPPP, Fila 120, Asiento 120</ubicacion></Asiento>'), 6, 6);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (121, XMLTYPE('<Asiento><numero_asiento>121</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección QQQQ, Fila 121, Asiento 121</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (122, XMLTYPE('<Asiento><numero_asiento>122</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección RRRR, Fila 122, Asiento 122</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (123, XMLTYPE('<Asiento><numero_asiento>123</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección SSSS, Fila 123, Asiento 123</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (124, XMLTYPE('<Asiento><numero_asiento>124</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección TTTT, Fila 124, Asiento 124</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (125, XMLTYPE('<Asiento><numero_asiento>125</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección UUUU, Fila 125, Asiento 125</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (126, XMLTYPE('<Asiento><numero_asiento>126</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección VVVV, Fila 126, Asiento 126</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (127, XMLTYPE('<Asiento><numero_asiento>127</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección WWWW, Fila 127, Asiento 127</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (128, XMLTYPE('<Asiento><numero_asiento>128</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección XXXX, Fila 128, Asiento 128</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (129, XMLTYPE('<Asiento><numero_asiento>129</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección YYYY, Fila 129, Asiento 129</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (130, XMLTYPE('<Asiento><numero_asiento>130</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección ZZZZ, Fila 130, Asiento 130</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (131, XMLTYPE('<Asiento><numero_asiento>131</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AAAA, Fila 131, Asiento 131</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (132, XMLTYPE('<Asiento><numero_asiento>132</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección BBBB, Fila 132, Asiento 132</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (133, XMLTYPE('<Asiento><numero_asiento>133</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CCCC, Fila 133, Asiento 133</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (134, XMLTYPE('<Asiento><numero_asiento>134</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección DDDD, Fila 134, Asiento 134</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (135, XMLTYPE('<Asiento><numero_asiento>135</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección EEEE, Fila 135, Asiento 135</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (136, XMLTYPE('<Asiento><numero_asiento>136</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección FFFF, Fila 136, Asiento 136</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (137, XMLTYPE('<Asiento><numero_asiento>137</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección GGGG, Fila 137, Asiento 137</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (138, XMLTYPE('<Asiento><numero_asiento>138</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección HHHH, Fila 138, Asiento 138</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (139, XMLTYPE('<Asiento><numero_asiento>139</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección IIII, Fila 139, Asiento 139</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (140, XMLTYPE('<Asiento><numero_asiento>140</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección JJJJ, Fila 140, Asiento 140</ubicacion></Asiento>'), 7, 7);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (141, XMLTYPE('<Asiento><numero_asiento>141</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKKK, Fila 141, Asiento 141</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (142, XMLTYPE('<Asiento><numero_asiento>142</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección LLLL, Fila 142, Asiento 142</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (143, XMLTYPE('<Asiento><numero_asiento>143</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección MMMM, Fila 143, Asiento 143</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (144, XMLTYPE('<Asiento><numero_asiento>144</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección NNNN, Fila 144, Asiento 144</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (145, XMLTYPE('<Asiento><numero_asiento>145</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección OOOO, Fila 145, Asiento 145</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (146, XMLTYPE('<Asiento><numero_asiento>146</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección PPPP, Fila 146, Asiento 146</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (147, XMLTYPE('<Asiento><numero_asiento>147</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección QQQQ, Fila 147, Asiento 147</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (148, XMLTYPE('<Asiento><numero_asiento>148</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección RRRR, Fila 148, Asiento 148</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (149, XMLTYPE('<Asiento><numero_asiento>149</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección SSSS, Fila 149, Asiento 149</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (150, XMLTYPE('<Asiento><numero_asiento>150</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección TTTT, Fila 150, Asiento 150</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (151, XMLTYPE('<Asiento><numero_asiento>151</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección UUUU, Fila 151, Asiento 151</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (152, XMLTYPE('<Asiento><numero_asiento>152</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección VVVV, Fila 152, Asiento 152</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (153, XMLTYPE('<Asiento><numero_asiento>153</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección WWWW, Fila 153, Asiento 153</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (154, XMLTYPE('<Asiento><numero_asiento>154</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección XXXX, Fila 154, Asiento 154</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (155, XMLTYPE('<Asiento><numero_asiento>155</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección YYYY, Fila 155, Asiento 155</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (156, XMLTYPE('<Asiento><numero_asiento>156</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección ZZZZ, Fila 156, Asiento 156</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (157, XMLTYPE('<Asiento><numero_asiento>157</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AAAA, Fila 157, Asiento 157</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (158, XMLTYPE('<Asiento><numero_asiento>158</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección BBBB, Fila 158, Asiento 158</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (159, XMLTYPE('<Asiento><numero_asiento>159</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CCCC, Fila 159, Asiento 159</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (160, XMLTYPE('<Asiento><numero_asiento>160</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección DDDD, Fila 160, Asiento 160</ubicacion></Asiento>'), 8, 8);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (161, XMLTYPE('<Asiento><numero_asiento>161</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección EEEE, Fila 161, Asiento 161</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (162, XMLTYPE('<Asiento><numero_asiento>162</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección FFFF, Fila 162, Asiento 162</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (163, XMLTYPE('<Asiento><numero_asiento>163</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección GGGG, Fila 163, Asiento 163</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (164, XMLTYPE('<Asiento><numero_asiento>164</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección HHHH, Fila 164, Asiento 164</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (165, XMLTYPE('<Asiento><numero_asiento>165</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección IIII, Fila 165, Asiento 165</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (166, XMLTYPE('<Asiento><numero_asiento>166</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección JJJJ, Fila 166, Asiento 166</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (167, XMLTYPE('<Asiento><numero_asiento>167</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKKK, Fila 167, Asiento 167</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (168, XMLTYPE('<Asiento><numero_asiento>168</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección LLLL, Fila 168, Asiento 168</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (169, XMLTYPE('<Asiento><numero_asiento>169</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección MMMM, Fila 169, Asiento 169</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (170, XMLTYPE('<Asiento><numero_asiento>170</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección NNNN, Fila 170, Asiento 170</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (171, XMLTYPE('<Asiento><numero_asiento>171</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección OOOO, Fila 171, Asiento 171</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (172, XMLTYPE('<Asiento><numero_asiento>172</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección PPPP, Fila 172, Asiento 172</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (173, XMLTYPE('<Asiento><numero_asiento>173</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección QQQQ, Fila 173, Asiento 173</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (174, XMLTYPE('<Asiento><numero_asiento>174</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección RRRR, Fila 174, Asiento 174</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (175, XMLTYPE('<Asiento><numero_asiento>175</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección SSSS, Fila 175, Asiento 175</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (176, XMLTYPE('<Asiento><numero_asiento>176</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección TTTT, Fila 176, Asiento 176</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (177, XMLTYPE('<Asiento><numero_asiento>177</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección UUUU, Fila 177, Asiento 177</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (178, XMLTYPE('<Asiento><numero_asiento>178</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección VVVV, Fila 178, Asiento 178</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (179, XMLTYPE('<Asiento><numero_asiento>179</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección WWWW, Fila 179, Asiento 179</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (180, XMLTYPE('<Asiento><numero_asiento>180</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección XXXX, Fila 180, Asiento 180</ubicacion></Asiento>'), 9, 9);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (181, XMLTYPE('<Asiento><numero_asiento>181</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección YYYY, Fila 181, Asiento 181</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (182, XMLTYPE('<Asiento><numero_asiento>182</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección ZZZZ, Fila 182, Asiento 182</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (183, XMLTYPE('<Asiento><numero_asiento>183</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AAAAA, Fila 183, Asiento 183</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (184, XMLTYPE('<Asiento><numero_asiento>184</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección BBBBB, Fila 184, Asiento 184</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (185, XMLTYPE('<Asiento><numero_asiento>185</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CCCCC, Fila 185, Asiento 185</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (186, XMLTYPE('<Asiento><numero_asiento>186</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección DDDDD, Fila 186, Asiento 186</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (187, XMLTYPE('<Asiento><numero_asiento>187</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección EEEEE, Fila 187, Asiento 187</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (188, XMLTYPE('<Asiento><numero_asiento>188</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección FFFFF, Fila 188, Asiento 188</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (189, XMLTYPE('<Asiento><numero_asiento>189</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección GGGGG, Fila 189, Asiento 189</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (190, XMLTYPE('<Asiento><numero_asiento>190</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección HHHHH, Fila 190, Asiento 190</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (191, XMLTYPE('<Asiento><numero_asiento>191</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección IIIII, Fila 191, Asiento 191</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (192, XMLTYPE('<Asiento><numero_asiento>192</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección JJJJJ, Fila 192, Asiento 192</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (193, XMLTYPE('<Asiento><numero_asiento>193</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKKKK, Fila 193, Asiento 193</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (194, XMLTYPE('<Asiento><numero_asiento>194</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección LLLLL, Fila 194, Asiento 194</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (195, XMLTYPE('<Asiento><numero_asiento>195</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección MMMMM, Fila 195, Asiento 195</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (196, XMLTYPE('<Asiento><numero_asiento>196</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección NNNNN, Fila 196, Asiento 196</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (197, XMLTYPE('<Asiento><numero_asiento>197</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección OOOOO, Fila 197, Asiento 197</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (198, XMLTYPE('<Asiento><numero_asiento>198</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección PPPPP, Fila 198, Asiento 198</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (199, XMLTYPE('<Asiento><numero_asiento>199</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección QQQQQ, Fila 199, Asiento 199</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (200, XMLTYPE('<Asiento><numero_asiento>200</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección RRRRR, Fila 200, Asiento 200</ubicacion></Asiento>'), 10, 10);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (201, XMLTYPE('<Asiento><numero_asiento>201</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección SSSSS, Fila 201, Asiento 201</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (202, XMLTYPE('<Asiento><numero_asiento>202</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección TTTTT, Fila 202, Asiento 202</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (203, XMLTYPE('<Asiento><numero_asiento>203</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección UUUUU, Fila 203, Asiento 203</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (204, XMLTYPE('<Asiento><numero_asiento>204</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección VVVVV, Fila 204, Asiento 204</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (205, XMLTYPE('<Asiento><numero_asiento>205</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección WWWWW, Fila 205, Asiento 205</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (206, XMLTYPE('<Asiento><numero_asiento>206</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección XXXXX, Fila 206, Asiento 206</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (207, XMLTYPE('<Asiento><numero_asiento>207</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección YYYYY, Fila 207, Asiento 207</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (208, XMLTYPE('<Asiento><numero_asiento>208</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección ZZZZZ, Fila 208, Asiento 208</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (209, XMLTYPE('<Asiento><numero_asiento>209</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección AAAAAA, Fila 209, Asiento 209</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (210, XMLTYPE('<Asiento><numero_asiento>210</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección BBBBBB, Fila 210, Asiento 210</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (211, XMLTYPE('<Asiento><numero_asiento>211</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección CCCCCC, Fila 211, Asiento 211</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (212, XMLTYPE('<Asiento><numero_asiento>212</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección DDDDDD, Fila 212, Asiento 212</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (213, XMLTYPE('<Asiento><numero_asiento>213</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección EEEEEE, Fila 213, Asiento 213</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (214, XMLTYPE('<Asiento><numero_asiento>214</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección FFFFFF, Fila 214, Asiento 214</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (215, XMLTYPE('<Asiento><numero_asiento>215</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección GGGGGG, Fila 215, Asiento 215</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (216, XMLTYPE('<Asiento><numero_asiento>216</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección HHHHHH, Fila 216, Asiento 216</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (217, XMLTYPE('<Asiento><numero_asiento>217</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección IIIIII, Fila 217, Asiento 217</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (218, XMLTYPE('<Asiento><numero_asiento>218</numero_asiento><estado_asiento>Cancelado</estado_asiento><ubicacion>Sección JJJJJJ, Fila 218, Asiento 218</ubicacion></Asiento>'), 2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (219, XMLTYPE('<Asiento><numero_asiento>219</numero_asiento><estado_asiento>Disponible</estado_asiento><ubicacion>Sección KKKKKK, Fila 219, Asiento 219</ubicacion></Asiento>'),2, 11);

INSERT INTO Asiento (id_asiento, inf_asiento, lugar_id, evento_id)
VALUES (220, XMLTYPE('<Asiento><numero_asiento>220</numero_asiento><estado_asiento>Ocupado</estado_asiento><ubicacion>Sección LLLLLL, Fila 220, Asiento 220</ubicacion></Asiento>'), 2, 11);



------BOLETO------------------------

INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES 
(1,XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>150.00</precio_boleto></Boleto>'),1, 1);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(2, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>200.00</precio_boleto></Boleto>'), 1, 2);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(3, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>120.00</precio_boleto></Boleto>'), 1, 3);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(4, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>80.00</precio_boleto></Boleto>'), 1, 4);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(5, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>210.00</precio_boleto></Boleto>'), 1, 5);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(6, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>115.00</precio_boleto></Boleto>'), 1, 6);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(7, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>90.00</precio_boleto></Boleto>'), 1, 7);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(8, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>220.00</precio_boleto></Boleto>'), 1, 8);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(9, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>130.00</precio_boleto></Boleto>'), 1, 9);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(10, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>85.00</precio_boleto></Boleto>'), 1, 10);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(11, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>205.00</precio_boleto></Boleto>'), 2, 21);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(12, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>125.00</precio_boleto></Boleto>'), 2, 22);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(13, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>95.00</precio_boleto></Boleto>'), 2, 23);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(14, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>230.00</precio_boleto></Boleto>'), 2, 24);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(15, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>140.00</precio_boleto></Boleto>'), 2, 25);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(16, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>75.00</precio_boleto></Boleto>'), 2, 26);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(17, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>215.00</precio_boleto></Boleto>'), 2, 27);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(18, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>110.00</precio_boleto></Boleto>'), 2, 28);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(19, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>100.00</precio_boleto></Boleto>'), 2, 29);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(20, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>250.00</precio_boleto></Boleto>'), 2, 30);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(21, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>135.00</precio_boleto></Boleto>'), 3, 41);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(22, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>70.00</precio_boleto></Boleto>'), 3, 42);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(23, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>240.00</precio_boleto></Boleto>'), 3, 43);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(24, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>150.00</precio_boleto></Boleto>'), 3, 44);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(25, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>65.00</precio_boleto></Boleto>'), 3, 45);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(26, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>260.00</precio_boleto></Boleto>'), 3, 46);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(27, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>145.00</precio_boleto></Boleto>'), 3, 47);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(28, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>60.00</precio_boleto></Boleto>'), 3, 48);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(29, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>275.00</precio_boleto></Boleto>'), 3, 49);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(30, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>155.00</precio_boleto></Boleto>'), 3, 50);



INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES 
(31, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>55.00</precio_boleto></Boleto>'), 4, 61);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(32, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>280.00</precio_boleto></Boleto>'), 4, 62);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(33, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>160.00</precio_boleto></Boleto>'), 4, 63);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(34, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>50.00</precio_boleto></Boleto>'), 4, 64);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(35, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>290.00</precio_boleto></Boleto>'), 4, 65);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(36, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>165.00</precio_boleto></Boleto>'), 4, 66);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(37, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>45.00</precio_boleto></Boleto>'), 4, 67);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(38, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>300.00</precio_boleto></Boleto>'), 4, 68);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(39, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>170.00</precio_boleto></Boleto>'), 4, 69);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(40, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>40.00</precio_boleto></Boleto>'), 4, 70);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(41, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>310.00</precio_boleto></Boleto>'), 5, 81);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(42, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>175.00</precio_boleto></Boleto>'), 5, 82);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(43, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>35.00</precio_boleto></Boleto>'), 5, 83);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(44, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>320.00</precio_boleto></Boleto>'), 5, 84);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(45, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>180.00</precio_boleto></Boleto>'), 5, 85);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(46, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>30.00</precio_boleto></Boleto>'), 5, 86);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(47, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>330.00</precio_boleto></Boleto>'), 5, 87);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(48, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>185.00</precio_boleto></Boleto>'), 5, 88);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(49, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>25.00</precio_boleto></Boleto>'), 5, 89);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(50, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>340.00</precio_boleto></Boleto>'), 5, 90);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(51, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>190.00</precio_boleto></Boleto>'), 6, 101);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(52, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>20.00</precio_boleto></Boleto>'), 6, 102);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(53, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>350.00</precio_boleto></Boleto>'), 6, 103);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(54, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>195.00</precio_boleto></Boleto>'), 6, 104);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(55, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>15.00</precio_boleto></Boleto>'), 6, 105);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(56, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>360.00</precio_boleto></Boleto>'), 6, 106);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES

INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES 
(57, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>370.00</precio_boleto></Boleto>'), 6, 107);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(58, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>200.00</precio_boleto></Boleto>'), 6, 108);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(59, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>10.00</precio_boleto></Boleto>'), 6, 109);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(60, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>380.00</precio_boleto></Boleto>'), 6, 110);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(61, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>205.00</precio_boleto></Boleto>'), 7, 121);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(62, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>5.00</precio_boleto></Boleto>'), 7, 122);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(63, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>390.00</precio_boleto></Boleto>'), 7, 123);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(64, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>210.00</precio_boleto></Boleto>'), 7, 124);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(65, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>0.00</precio_boleto></Boleto>'), 7, 125);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(66, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>400.00</precio_boleto></Boleto>'), 7, 126);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(67, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>215.00</precio_boleto></Boleto>'), 7, 127);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(68, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>0.50</precio_boleto></Boleto>'), 7, 128);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(69, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>410.00</precio_boleto></Boleto>'), 7, 129);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(70, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>220.00</precio_boleto></Boleto>'), 7, 130);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(71, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>1.00</precio_boleto></Boleto>'), 8, 141);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(72, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>420.00</precio_boleto></Boleto>'), 8, 142);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(73, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>225.00</precio_boleto></Boleto>'), 8, 143);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(74, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>2.00</precio_boleto></Boleto>'), 8, 144);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(75, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>430.00</precio_boleto></Boleto>'), 8, 145);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(76, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>230.00</precio_boleto></Boleto>'), 8, 146);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(77, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>3.00</precio_boleto></Boleto>'), 8, 147);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(78, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>440.00</precio_boleto></Boleto>'), 8, 148);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(79, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>235.00</precio_boleto></Boleto>'), 8, 149);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(80, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>4.00</precio_boleto></Boleto>'), 8, 150);



INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES 
(81, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>450.00</precio_boleto></Boleto>'), 9, 161);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(82, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>460.00</precio_boleto></Boleto>'), 9, 162);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(83, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>240.00</precio_boleto></Boleto>'), 9, 163);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(84, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>5.50</precio_boleto></Boleto>'), 9, 164);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(85, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>470.00</precio_boleto></Boleto>'), 9, 165);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(86, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>245.00</precio_boleto></Boleto>'), 9, 166);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(87, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>6.00</precio_boleto></Boleto>'), 9, 167);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(88, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>480.00</precio_boleto></Boleto>'), 9, 168);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(89, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>250.00</precio_boleto></Boleto>'), 9, 169);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(90, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>7.00</precio_boleto></Boleto>'), 9, 170);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(91, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>490.00</precio_boleto></Boleto>'), 10, 181);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(92, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>255.00</precio_boleto></Boleto>'), 10,182);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(93, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>8.00</precio_boleto></Boleto>'), 10,183);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(94, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>500.00</precio_boleto></Boleto>'), 10,184);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(95, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>260.00</precio_boleto></Boleto>'), 10,185);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(96, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>9.00</precio_boleto></Boleto>'), 10,186);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(97, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>510.00</precio_boleto></Boleto>'), 10,187);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(98, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>265.00</precio_boleto></Boleto>'), 10,188);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(99, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>10.50</precio_boleto></Boleto>'), 10,189);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(100, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>520.00</precio_boleto></Boleto>'), 10, 190);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(101, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>270.00</precio_boleto></Boleto>'), 11, 201);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(102, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>530.00</precio_boleto></Boleto>'), 11, 202);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(103, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>275.00</precio_boleto></Boleto>'), 11, 203);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(104, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>11.00</precio_boleto></Boleto>'), 11, 204);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(105, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>540.00</precio_boleto></Boleto>'), 11, 205);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(106, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>280.00</precio_boleto></Boleto>'), 11, 206);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(107, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>12.00</precio_boleto></Boleto>'), 11, 207);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(108, XMLType('<Boleto><tipo_boleto>VIP</tipo_boleto><precio_boleto>550.00</precio_boleto></Boleto>'), 11, 208);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(109, XMLType('<Boleto><tipo_boleto>Preferencial</tipo_boleto><precio_boleto>285.00</precio_boleto></Boleto>'), 11, 209);
INSERT INTO Boleto (id_boleto, inf_boleto, evento_id, asiento_id)
VALUES
(110, XMLType('<Boleto><tipo_boleto>General</tipo_boleto><precio_boleto>13.00</precio_boleto></Boleto>'), 11, 210); 

-----compraboleto----------------------------

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (1, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-01T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 1, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (2, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-02T11:00:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 2, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (3, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-03T10:15:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 3, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (4, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-04T10:30:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 4, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (5, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-05T09:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 5, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (6, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-06T09:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 6, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (7, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-07T09:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 7, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (8, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-08T09:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 8, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (9, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 9, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (10, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-10T10:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 10, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (11, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-11T10:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 11, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (12, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-12T10:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 12, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (13, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-13T11:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 13, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (14, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-14T11:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 14, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (15, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-15T11:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 15, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (16, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-16T11:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 16, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (17, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-17T12:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 17, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (18, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-18T12:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 18, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (19, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-19T12:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 19, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (20, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-21T13:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 20, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (21, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-22T13:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 21, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (22, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-01T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 22, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (23, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-02T11:00:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 23, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (24, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-03T10:15:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 24, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (25, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-04T10:30:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 25, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (26, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-05T09:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 26, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (27, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-06T09:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 27, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (28, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-07T09:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 28, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (29, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-08T09:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 29, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (30, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 30, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (31, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 31, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (32, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 32, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (33, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 33, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (34, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 34, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (35, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 35, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (36, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 36,5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (37, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 37, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (38, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 38, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (39, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 39, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (40, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-10T10:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 40, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (41, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-11T10:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 41, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (42, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-12T10:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 42, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (43, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-13T11:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 43, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (44, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-14T11:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 44, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (45, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-15T11:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 45, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (46, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-16T11:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 46, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (47, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-17T12:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 47, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (48, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-18T12:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 48, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (49, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-19T12:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 49, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (50, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-20T12:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 50, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (51, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-21T13:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 51, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (52, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-22T13:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 52, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (53, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-01T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 53, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (54, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-02T11:00:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 54, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (55, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-03T10:15:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 55, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (56, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-04T10:30:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 56, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (57, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-05T09:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 57, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (58, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-06T09:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 58, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (59, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-07T09:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 59, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (60, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-08T09:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 60, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (61, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 61, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (62, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-10T10:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 62, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (63, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-11T10:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 63, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (64, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-12T10:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 64, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (65, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-13T11:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 65, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (66, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-14T11:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 66, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (67, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-15T11:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 67, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (68, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-16T11:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 68, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (69, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-17T12:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 69, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (70, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-18T12:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 70, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (71, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-19T12:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 71, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (72, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-20T12:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 72, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (73, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-21T13:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 73, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (74, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-22T13:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 74, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (75, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-01T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 75, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (76, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-02T11:00:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 76, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (77, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-03T10:15:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 77, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (78, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-04T10:30:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 78, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (79, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-05T09:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 79, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (80, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-06T09:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 80, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (81, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-07T09:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 81, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (82, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-08T09:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 82, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (83, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 83, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (84, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 84, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (85, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 85, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (86, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 86, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (87, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 87, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (88, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 88, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (89, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 89,5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (90, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 90, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (91, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 91, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (92, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-09T10:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 92, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (93, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-10T10:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 93, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (94, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-11T10:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 94, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (95, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-12T10:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 95, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (96, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-13T11:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 96, 3);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (97, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-14T11:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 97, 4);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (98, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-15T11:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 98, 5);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (99, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-16T11:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 99, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (100, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-17T12:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 100, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (101, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-18T12:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 101, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (102, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-19T12:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 102, 9);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (103, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-20T12:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 103, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (104, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-21T13:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 104, 1);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (105, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-22T13:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 105, 2);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (106, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-20T12:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 106, 10);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (107, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-16T11:45:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 107, 6);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (108, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-17T12:00:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pendiente</estado_pago></CompraBoleto>'), 108, 7);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (109, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-18T12:15:00</fecha_hora_compra><estatus_compra>Cancelada</estatus_compra><metodo_pago>Tarjeta de Crédito</metodo_pago><estado_pago>Reembolsado</estado_pago></CompraBoleto>'), 109, 8);

INSERT INTO CompraBoleto (id_compra, inf_compra, boleto_id, usuario_id)
VALUES (110, XMLType('<CompraBoleto><fecha_hora_compra>2024-01-19T12:30:00</fecha_hora_compra><estatus_compra>Compra Finalizada</estatus_compra><metodo_pago>PayPal</metodo_pago><estado_pago>Pagado</estado_pago></CompraBoleto>'), 110, 9);


----TRIGERS VALIDADORES------------------
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

/

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

/