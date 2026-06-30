-- Limpia objetos existentes para recrear el esquema
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE adoptantes CASCADE CONSTRAINTS'; -- Elimina tabla ADOPTANTES
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_adoptantes_bit_id'; -- Elimina secuencia
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE adoptantes_bit CASCADE CONSTRAINTS'; -- Elimina tabla bitácora
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

-- Tabla de adoptantes
CREATE TABLE adoptantes (
    id_adoptante VARCHAR2(36) PRIMARY KEY,              -- ID único
    nombre VARCHAR2(100),                         -- Nombre
    apellido VARCHAR2(100),                       -- Apellido
    telefono VARCHAR2(20),                        -- Teléfono
    correo VARCHAR2(150) UNIQUE,                  -- Correo único
    direccion VARCHAR2(200),                      -- Dirección
    estado NUMBER DEFAULT 1,                      -- Estado
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Fecha de registro
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE adoptantes IS 'Tabla que almacena la informacion de los adoptantes';

COMMENT ON COLUMN adoptantes.id_adoptante IS 'Llave primaria de la tabla adoptantes';
COMMENT ON COLUMN adoptantes.nombre IS 'Nombre del adoptante';
COMMENT ON COLUMN adoptantes.apellido IS 'Apellido del adoptante';
COMMENT ON COLUMN adoptantes.telefono IS 'Telefono del adoptante';
COMMENT ON COLUMN adoptantes.correo IS 'Correo del adoptante';
COMMENT ON COLUMN adoptantes.direccion IS 'Direccion del adoptante';
COMMENT ON COLUMN adoptantes.estado IS 'Bandera para borrado logico';
COMMENT ON COLUMN adoptantes.fecha_registro IS 'Fecha de registro del adoptante';

-- Tabla de bitácora de adoptantes
CREATE TABLE adoptantes_bit (
    id_adoptante_bit VARCHAR2(36) PRIMARY KEY,          -- ID de bitácora
    id_adoptante VARCHAR2(36) NOT NULL,                 -- ID del adoptante

    nombre VARCHAR2(100),
    apellido VARCHAR2(100),
    telefono VARCHAR2(20),
    correo VARCHAR2(150),
    direccion VARCHAR2(200),

    estado NUMBER DEFAULT 1,
    fecha_registro TIMESTAMP,

    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    fecha_modificacion TIMESTAMP,                       -- Fecha modificación
    accion VARCHAR2(10) NOT NULL,                       -- INSERT/UPDATE/DELETE
    ip VARCHAR2(30) NOT NULL                            -- IP origen
);


-- Documentación de la tabla y columnas
COMMENT ON TABLE adoptantes_bit IS 'Tabla de bitacora de adoptantes';

COMMENT ON COLUMN adoptantes_bit.id_adoptante_bit IS 'Llave primaria de la bitacora';
COMMENT ON COLUMN adoptantes_bit.id_adoptante IS 'Llave primaria del adoptante';

COMMENT ON COLUMN adoptantes_bit.nombre IS 'Nombre del adoptante';
COMMENT ON COLUMN adoptantes_bit.apellido IS 'Apellido del adoptante';
COMMENT ON COLUMN adoptantes_bit.telefono IS 'Telefono del adoptante';
COMMENT ON COLUMN adoptantes_bit.correo IS 'Correo del adoptante';
COMMENT ON COLUMN adoptantes_bit.direccion IS 'Direccion del adoptante';

COMMENT ON COLUMN adoptantes_bit.estado IS 'Bandera para borrado logico';
COMMENT ON COLUMN adoptantes_bit.fecha_registro IS 'Fecha de registro del adoptante';

COMMENT ON COLUMN adoptantes_bit.fecha_creacion IS 'Fecha de creacion del registro';
COMMENT ON COLUMN adoptantes_bit.fecha_modificacion IS 'Fecha de modificacion del registro';
COMMENT ON COLUMN adoptantes_bit.accion IS 'Operacion realizada';
COMMENT ON COLUMN adoptantes_bit.ip IS 'IP origen de la operacion';


-- Secuencia para generar IDs consecutivos
CREATE SEQUENCE seq_adoptantes_bit_id START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_adoptantes_aud
AFTER INSERT OR UPDATE ON adoptantes
FOR EACH ROW
DECLARE
    V_ACCION VARCHAR2(20);
    V_FECHA_CREACION TIMESTAMP := NULL;
    V_FECHA_MODIFICACION TIMESTAMP := NULL;
    V_ID_BITACORA VARCHAR2(30);

BEGIN

    V_ID_BITACORA := 'ADO_BIT-' || LPAD(seq_adoptantes_bit_id.NEXTVAL, 6, '0');

    IF INSERTING THEN

        V_ACCION := 'INSERT';
        V_FECHA_CREACION := SYSTIMESTAMP;

    ELSIF UPDATING THEN

        V_FECHA_MODIFICACION := SYSTIMESTAMP;
        V_FECHA_CREACION := :OLD.fecha_registro;

        IF :OLD.estado = 1 AND :NEW.estado = 0 THEN

            V_ACCION := 'DACTIVE';

        ELSIF :OLD.estado = 0 AND :NEW.estado = 1 THEN

            V_ACCION := 'ACTIVE';

        ELSE

            V_ACCION := 'UPDATE';

        END IF;

    END IF;

    INSERT INTO adoptantes_bit (
        id_adoptante_bit,
        id_adoptante,
        nombre,
        apellido,
        telefono,
        correo,
        direccion,
        estado,
        fecha_registro,
        fecha_creacion,
        fecha_modificacion,
        accion,
        ip
    )
    VALUES (
        V_ID_BITACORA,
        :NEW.id_adoptante,
        :NEW.nombre,
        :NEW.apellido,
        :NEW.telefono,
        :NEW.correo,
        :NEW.direccion,
        :NEW.estado,
        :NEW.fecha_registro,
        V_FECHA_CREACION,
        V_FECHA_MODIFICACION,
        V_ACCION,
        FN_GET_IP()
    );

END;
/



-- Obtiene la IP o nombre del host de la conexión
CREATE OR REPLACE FUNCTION FN_GET_IP
RETURN VARCHAR2
IS
BEGIN
    -- Obtiene IP o host de la sesión actual
    RETURN NVL(
        SYS_CONTEXT('USERENV','IP_ADDRESS'),
        SYS_CONTEXT('USERENV','HOST')
    );

EXCEPTION
    -- Retorna valor por defecto si ocurre un error
    WHEN OTHERS THEN
        RETURN 'LOCALHOST';
END FN_GET_IP;
/
commit ;