-- Limpia objetos existentes para recrear el esquema
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE citas_seguimiento CASCADE CONSTRAINTS'; -- Elimina tabla CITAS_SEGUIMIENTO
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_citas_seguimiento_bit_id'; -- Elimina secuencia
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE citas_seguimiento_bit CASCADE CONSTRAINTS'; -- Elimina tabla bitácora
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/


-- Tabla de citas de seguimiento
CREATE TABLE citas_seguimiento (
    id_cita VARCHAR2(36) PRIMARY KEY,                   -- ID único
    id_mascota VARCHAR2(36),                            -- FK mascota
    fecha_cita TIMESTAMP,                         -- Fecha cita
    motivo VARCHAR2(200),                         -- Motivo
    observaciones VARCHAR2(500),                  -- Observaciones
    estatus VARCHAR2(50),                         -- Estatus
    estado NUMBER DEFAULT 1,                      -- Estado

    CONSTRAINT fk_id_mascota_citas_seguimiento
        FOREIGN KEY (id_mascota)
        REFERENCES mascotas(id_mascota)          -- Clave foránea
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE citas_seguimiento IS 'Tabla que almacena las citas de seguimiento';

COMMENT ON COLUMN citas_seguimiento.id_cita IS 'Llave primaria de la tabla citas_seguimiento';
COMMENT ON COLUMN citas_seguimiento.id_mascota IS 'Llave foranea de la mascota';
COMMENT ON COLUMN citas_seguimiento.fecha_cita IS 'Fecha programada de la cita';
COMMENT ON COLUMN citas_seguimiento.motivo IS 'Motivo de la cita';
COMMENT ON COLUMN citas_seguimiento.observaciones IS 'Observaciones de la cita';
COMMENT ON COLUMN citas_seguimiento.estatus IS 'Estatus de la cita';
COMMENT ON COLUMN citas_seguimiento.estado IS 'Bandera para borrado logico';


-- Tabla de bitácora de citas de seguimiento
CREATE TABLE citas_seguimiento_bit (
    id_cita_bit VARCHAR2(36) PRIMARY KEY,               -- ID de bitácora
    id_cita VARCHAR2(36) NOT NULL,                      -- ID de la cita

    id_mascota VARCHAR2(36),
    fecha_cita TIMESTAMP,
    motivo VARCHAR2(200),
    observaciones VARCHAR2(500),
    estatus VARCHAR2(50),

    estado NUMBER DEFAULT 1,

    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    fecha_modificacion TIMESTAMP,                       -- Fecha modificación
    accion VARCHAR2(10) NOT NULL,                       -- INSERT/UPDATE/DELETE
    ip VARCHAR2(30) NOT NULL                            -- IP origen
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE citas_seguimiento_bit IS 'Tabla de bitacora de citas de seguimiento';

COMMENT ON COLUMN citas_seguimiento_bit.id_cita_bit IS 'Llave primaria de la bitacora';
COMMENT ON COLUMN citas_seguimiento_bit.id_cita IS 'Llave primaria de la cita';

COMMENT ON COLUMN citas_seguimiento_bit.id_mascota IS 'Llave foranea de la mascota';
COMMENT ON COLUMN citas_seguimiento_bit.fecha_cita IS 'Fecha de la cita de seguimiento';
COMMENT ON COLUMN citas_seguimiento_bit.motivo IS 'Motivo de la cita';
COMMENT ON COLUMN citas_seguimiento_bit.observaciones IS 'Observaciones de la cita';
COMMENT ON COLUMN citas_seguimiento_bit.estatus IS 'Estatus de la cita';

COMMENT ON COLUMN citas_seguimiento_bit.estado IS 'Bandera para borrado logico';

COMMENT ON COLUMN citas_seguimiento_bit.fecha_creacion IS 'Fecha de creacion del registro';
COMMENT ON COLUMN citas_seguimiento_bit.fecha_modificacion IS 'Fecha de modificacion del registro';
COMMENT ON COLUMN citas_seguimiento_bit.accion IS 'Operacion realizada';
COMMENT ON COLUMN citas_seguimiento_bit.ip IS 'IP origen de la operacion';


-- Secuencia para generar IDs consecutivos
CREATE SEQUENCE seq_citas_seguimiento_bit_id START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_citas_seguimiento_aud
AFTER INSERT OR UPDATE ON citas_seguimiento
FOR EACH ROW
DECLARE
    V_ACCION VARCHAR2(20);
    V_FECHA_CREACION TIMESTAMP := NULL;
    V_FECHA_MODIFICACION TIMESTAMP := NULL;
    V_ID_BITACORA VARCHAR2(36);

BEGIN

    V_ID_BITACORA := 'CIT_BIT-' || LPAD(seq_citas_seguimiento_bit_id.NEXTVAL, 6, '0');

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

    INSERT INTO citas_seguimiento_bit (
        id_cita_bit,
        id_cita,
        id_mascota,
        fecha_cita,
        motivo,
        observaciones,
        estatus,
        estado,
        fecha_creacion,
        fecha_modificacion,
        accion,
        ip
    )
    VALUES (
        V_ID_BITACORA,
        :NEW.id_cita,
        :NEW.id_mascota,
        :NEW.fecha_cita,
        :NEW.motivo,
        :NEW.observaciones,
        :NEW.estatus,
        :NEW.estado,
        V_FECHA_CREACION,
        V_FECHA_MODIFICACION,
        V_ACCION,
        FN_GET_IP()
    );

END;
/
commit ;