-- Limpia objetos existentes para recrear el esquema
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE vacunas CASCADE CONSTRAINTS'; -- Elimina tabla VACUNAS
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_vacunas_bit_id'; -- Elimina secuencia
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE vacunas_bit CASCADE CONSTRAINTS'; -- Elimina tabla bitácora
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/


-- Tabla de vacunas
CREATE TABLE vacunas (
    id_vacuna VARCHAR2(36),                             -- ID único
    nombre_vacuna VARCHAR2(100),                  -- Nombre vacuna
    descripcion VARCHAR2(200),                    -- Descripción
    fecha_aplicacion TIMESTAMP,                   -- Fecha aplicación
    proxima_aplicacion TIMESTAMP,                 -- Próxima aplicación
    id_mascota VARCHAR2(36),                            -- FK mascota
    estado NUMBER DEFAULT 1,                      -- Estado

    CONSTRAINT pk_id_vacuna_vacunas
        PRIMARY KEY (id_vacuna),                 -- Clave primaria

    CONSTRAINT fk_id_mascota_vacunas
        FOREIGN KEY (id_mascota)
        REFERENCES mascotas(id_mascota)          -- Clave foránea
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE vacunas IS 'Tabla que almacena las vacunas de las mascotas';

COMMENT ON COLUMN vacunas.id_vacuna IS 'Llave primaria de la tabla vacunas';
COMMENT ON COLUMN vacunas.nombre_vacuna IS 'Nombre de la vacuna aplicada';
COMMENT ON COLUMN vacunas.descripcion IS 'Descripcion de la vacuna';
COMMENT ON COLUMN vacunas.fecha_aplicacion IS 'Fecha de aplicacion de la vacuna';
COMMENT ON COLUMN vacunas.proxima_aplicacion IS 'Fecha de la siguiente aplicacion';
COMMENT ON COLUMN vacunas.id_mascota IS 'Llave foranea de la mascota';
COMMENT ON COLUMN vacunas.estado IS 'Bandera para borrado logico';

-- Tabla de bitácora de vacunas
CREATE TABLE vacunas_bit (
    id_vacuna_bit VARCHAR2(36) PRIMARY KEY,             -- ID de bitácora
    id_vacuna VARCHAR2(36) NOT NULL,                    -- ID de la vacuna

    nombre_vacuna VARCHAR2(100),
    descripcion VARCHAR2(200),
    fecha_aplicacion TIMESTAMP,
    proxima_aplicacion TIMESTAMP,
    id_mascota VARCHAR2(36),

    estado NUMBER DEFAULT 1,

    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    fecha_modificacion TIMESTAMP,                       -- Fecha modificación
    accion VARCHAR2(10) NOT NULL,                       -- INSERT/UPDATE/DELETE
    ip VARCHAR2(30) NOT NULL                            -- IP origen
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE vacunas_bit IS 'Tabla de bitacora de las vacunas';

COMMENT ON COLUMN vacunas_bit.id_vacuna_bit IS 'Llave primaria de la bitacora';
COMMENT ON COLUMN vacunas_bit.id_vacuna IS 'Llave primaria de la vacuna';
COMMENT ON COLUMN vacunas_bit.nombre_vacuna IS 'Nombre de la vacuna aplicada';
COMMENT ON COLUMN vacunas_bit.descripcion IS 'Descripcion de la vacuna';
COMMENT ON COLUMN vacunas_bit.fecha_aplicacion IS 'Fecha de aplicacion de la vacuna';
COMMENT ON COLUMN vacunas_bit.proxima_aplicacion IS 'Fecha de la siguiente aplicacion';
COMMENT ON COLUMN vacunas_bit.id_mascota IS 'Llave foranea de la mascota';
COMMENT ON COLUMN vacunas_bit.estado IS 'Bandera para borrado logico';

COMMENT ON COLUMN vacunas_bit.fecha_creacion IS 'Fecha de creacion del registro';
COMMENT ON COLUMN vacunas_bit.fecha_modificacion IS 'Fecha de modificacion del registro';
COMMENT ON COLUMN vacunas_bit.accion IS 'Operacion realizada';
COMMENT ON COLUMN vacunas_bit.ip IS 'IP origen de la operacion';

-- Secuencia para generar IDs consecutivos
CREATE SEQUENCE seq_vacunas_bit_id START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_vacunas_aud
AFTER INSERT OR UPDATE ON vacunas
FOR EACH ROW
DECLARE
    V_ACCION VARCHAR2(20);
    V_FECHA_CREACION TIMESTAMP := NULL;
    V_FECHA_MODIFICACION TIMESTAMP := NULL;
    V_ID_BITACORA VARCHAR2(36);

BEGIN

    V_ID_BITACORA := 'VAC_BIT-' || LPAD(seq_vacunas_bit_id.NEXTVAL, 6, '0');

    IF INSERTING THEN

        V_ACCION := 'INSERT';
        V_FECHA_CREACION := SYSTIMESTAMP;

    ELSIF UPDATING THEN

        V_FECHA_MODIFICACION := SYSTIMESTAMP;

        IF :OLD.estado = 1 AND :NEW.estado = 0 THEN

            V_ACCION := 'DACTIVE';

        ELSIF :OLD.estado = 0 AND :NEW.estado = 1 THEN

            V_ACCION := 'ACTIVE';

        ELSE

            V_ACCION := 'UPDATE';

        END IF;

    END IF;

    INSERT INTO vacunas_bit (
        id_vacuna_bit,
        id_vacuna,
        nombre_vacuna,
        descripcion,
        fecha_aplicacion,
        proxima_aplicacion,
        id_mascota,
        estado,
        fecha_creacion,
        fecha_modificacion,
        accion,
        ip
    )
    VALUES (
        V_ID_BITACORA,
        :NEW.id_vacuna,
        :NEW.nombre_vacuna,
        :NEW.descripcion,
        :NEW.fecha_aplicacion,
        :NEW.proxima_aplicacion,
        :NEW.id_mascota,
        :NEW.estado,
        V_FECHA_CREACION,
        V_FECHA_MODIFICACION,
        V_ACCION,
        FN_GET_IP()
    );

END;
/
commit ;