-- Habilitar el script de creación de usuarios comunes (solo si es necesario)
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- Crear el usuario
CREATE USER OmarRivera IDENTIFIED BY sistema;

-- Otorgar privilegios de conexión y operaciones básicas
GRANT CREATE SESSION TO OmarRivera;        -- Permitir que el usuario se conecte
GRANT CREATE TABLE TO OmarRivera;          -- Permitir la creación de tablas
GRANT CREATE VIEW TO OmarRivera;           -- Permitir la creación de vistas
GRANT CREATE PROCEDURE TO OmarRivera;      -- Permitir la creación de procedimientos
GRANT CREATE SEQUENCE TO OmarRivera;       -- Permitir la creación de secuencias
GRANT CREATE TRIGGER TO OmarRivera;        -- Permitir la creación de triggers

-- Otorgar permisos para manipulación de datos en todas las tablas
GRANT INSERT ANY TABLE TO OmarRivera;      -- Permitir insertar en cualquier tabla
GRANT UPDATE ANY TABLE TO OmarRivera;      -- Permitir actualizar cualquier tabla
GRANT DELETE ANY TABLE TO OmarRivera;      -- Permitir eliminar registros en cualquier tabla
GRANT SELECT ANY TABLE TO OmarRivera;      -- Permitir seleccionar en cualquier tabla

-- Permitir alteraciones en la estructura de las tablas
GRANT ALTER ANY TABLE TO OmarRivera;       -- Permitir modificar la estructura de cualquier tabla
-- GRANT INDEX ANY TABLE TO OmarRivera;       -- Permitir crear índices en cualquier tabla

-- Verificar los privilegios otorgados al usuario
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'OMARRIVERA';

-- (Opcional) Verificar que el usuario fue creado correctamente
SELECT USERNAME FROM ALL_USERS;

-- Verificar todos los detalles de los usuarios en la base de datos
SELECT * FROM DBA_USERS;

-- Otorgar cuota ilimitada en el tablespace 'USERS' al usuario OmarRivera
ALTER USER OmarRivera QUOTA UNLIMITED ON USERS;

-- (Opcional) Si deseas asignar una cuota específica en lugar de ilimitada
-- ALTER USER OmarRivera QUOTA 50M ON USERS;  -- 50 megabytes de espacio

