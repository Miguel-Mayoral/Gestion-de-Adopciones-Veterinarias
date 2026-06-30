-- Limpia objetos existentes para recrear el esquema
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE chip_rastreo CASCADE CONSTRAINTS'; -- Elimina tabla CHIP_RASTREO
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_chip_rastreo_bit_id'; -- Elimina secuencia
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE chip_rastreo_bit CASCADE CONSTRAINTS'; -- Elimina tabla bitácora
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/


-- Tabla de chips de rastreo
CREATE TABLE chip_rastreo (
    id_chip VARCHAR2(36) PRIMARY KEY,                    -- ID único
    codigo_chip VARCHAR2(100) UNIQUE,             -- Código chip
    fecha_implantacion TIMESTAMP,                 -- Fecha implantación
    fabricante VARCHAR2(100),                     -- Fabricante
    id_mascota VARCHAR2(36),                            -- FK mascota
    estado NUMBER DEFAULT 1,                      -- Estado

    CONSTRAINT fk_id_mascota_chip_rastreo
        FOREIGN KEY (id_mascota)
        REFERENCES mascotas(id_mascota)          -- Clave foránea
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE chip_rastreo IS 'Tabla que almacena los chips de rastreo';

COMMENT ON COLUMN chip_rastreo.id_chip IS 'Llave primaria de la tabla chip_rastreo';
COMMENT ON COLUMN chip_rastreo.codigo_chip IS 'Codigo unico del chip';
COMMENT ON COLUMN chip_rastreo.fecha_implantacion IS 'Fecha de implantacion del chip';
COMMENT ON COLUMN chip_rastreo.fabricante IS 'Fabricante del chip';
COMMENT ON COLUMN chip_rastreo.id_mascota IS 'Llave foranea de la mascota';
COMMENT ON COLUMN chip_rastreo.estado IS 'Bandera para borrado logico';

-- Tabla de bitácora de chips de rastreo
CREATE TABLE chip_rastreo_bit (
    id_chip_bit VARCHAR2(36) PRIMARY KEY,               -- ID de bitácora
    id_chip VARCHAR2(36) NOT NULL,                      -- ID del chip

    codigo_chip VARCHAR2(100),
    fecha_implantacion TIMESTAMP,
    fabricante VARCHAR2(100),
    id_mascota VARCHAR2(36),

    estado NUMBER DEFAULT 1,

    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    fecha_modificacion TIMESTAMP,                       -- Fecha modificación
    accion VARCHAR2(10) NOT NULL,                       -- INSERT/UPDATE/DELETE
    ip VARCHAR2(30) NOT NULL                            -- IP origen
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE chip_rastreo_bit IS 'Tabla de bitacora de chips de rastreo';

COMMENT ON COLUMN chip_rastreo_bit.id_chip_bit IS 'Llave primaria de la bitacora';
COMMENT ON COLUMN chip_rastreo_bit.id_chip IS 'Llave primaria del chip';

COMMENT ON COLUMN chip_rastreo_bit.codigo_chip IS 'Codigo del chip de rastreo';
COMMENT ON COLUMN chip_rastreo_bit.fecha_implantacion IS 'Fecha de implantacion del chip';
COMMENT ON COLUMN chip_rastreo_bit.fabricante IS 'Fabricante del chip';
COMMENT ON COLUMN chip_rastreo_bit.id_mascota IS 'Llave foranea de la mascota';

COMMENT ON COLUMN chip_rastreo_bit.estado IS 'Bandera para borrado logico';

COMMENT ON COLUMN chip_rastreo_bit.fecha_creacion IS 'Fecha de creacion del registro';
COMMENT ON COLUMN chip_rastreo_bit.fecha_modificacion IS 'Fecha de modificacion del registro';
COMMENT ON COLUMN chip_rastreo_bit.accion IS 'Operacion realizada';
COMMENT ON COLUMN chip_rastreo_bit.ip IS 'IP origen de la operacion';


-- Secuencia para generar IDs consecutivos
CREATE SEQUENCE seq_chip_rastreo_bit_id START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE NOCYCLE;


CREATE OR REPLACE TRIGGER trg_chip_rastreo_aud
AFTER INSERT OR UPDATE ON chip_rastreo
FOR EACH ROW
DECLARE
    V_ACCION VARCHAR2(20);
    V_FECHA_CREACION TIMESTAMP := NULL;
    V_FECHA_MODIFICACION TIMESTAMP := NULL;
    V_ID_BITACORA VARCHAR2(30);

BEGIN

    -- Genera ID de bitácora
    V_ID_BITACORA := 'CHP_BIT-' || LPAD(seq_chip_rastreo_bit_id.NEXTVAL, 6, '0');

    -- Registro creado
    IF INSERTING THEN

        V_ACCION := 'INSERT';
        V_FECHA_CREACION := SYSTIMESTAMP;

    -- Registro modificado
    ELSIF UPDATING THEN

        V_FECHA_MODIFICACION := SYSTIMESTAMP;

        -- Cambio de estado
        IF :OLD.estado = 1 AND :NEW.estado = 0 THEN

            V_ACCION := 'DACTIVE';

        ELSIF :OLD.estado = 0 AND :NEW.estado = 1 THEN

            V_ACCION := 'ACTIVE';

        ELSE

            V_ACCION := 'UPDATE';

        END IF;

    END IF;

    -- Inserta en bitácora
    INSERT INTO chip_rastreo_bit (
        id_chip_bit,
        id_chip,
        codigo_chip,
        fecha_implantacion,
        fabricante,
        id_mascota,
        estado,
        fecha_creacion,
        fecha_modificacion,
        accion,
        ip
    )
    VALUES (
        V_ID_BITACORA,
        :NEW.id_chip,
        :NEW.codigo_chip,
        :NEW.fecha_implantacion,
        :NEW.fabricante,
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