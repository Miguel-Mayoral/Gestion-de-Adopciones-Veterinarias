-- Limpia objetos existentes para recrear el esquema
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mascotas CASCADE CONSTRAINTS'; -- Elimina tabla MASCOTAS
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mascotas_bit_id'; -- Elimina secuencia
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mascotas'; -- Elimina secuencia
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mascotas_bit CASCADE CONSTRAINTS'; -- Elimina tabla bitácora
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora error si no existe
END;
/


-- Tabla de mascotas
CREATE TABLE mascotas (
    id_mascota VARCHAR2(36) PRIMARY KEY,                -- ID único
    nombre VARCHAR2(100),                         -- Nombre
    especie VARCHAR2(50),                         -- Especie
    raza VARCHAR2(100),                           -- Raza
    edad NUMBER,                                  -- Edad
    sexo VARCHAR2(10),                            -- Sexo
    url_imagen VARCHAR2(500),                     -- Colocar una imagen de ref.
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de ingreso
    fecha_adopcion TIMESTAMP,                     -- Fecha de adopción
    id_adoptante VARCHAR2(36),                          -- ID adoptante
    estado NUMBER DEFAULT 1,                       -- Estado

    CONSTRAINT fk_id_adoptante_mascotas
        FOREIGN KEY (id_adoptante)
        REFERENCES adoptantes(id_adoptante)      -- Clave foránea
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE mascotas IS 'Tabla que almacena la informacion de las mascotas';

COMMENT ON COLUMN mascotas.id_mascota IS 'Llave primaria de la tabla mascotas';
COMMENT ON COLUMN mascotas.nombre IS 'Nombre de la mascota';
COMMENT ON COLUMN mascotas.especie IS 'Especie de la mascota';
COMMENT ON COLUMN mascotas.raza IS 'Raza de la mascota';
COMMENT ON COLUMN mascotas.edad IS 'Edad de la mascota';
COMMENT ON COLUMN mascotas.sexo IS 'Sexo de la mascota';
COMMENT ON COLUMN mascotas.url_imagen IS 'URL de la imagen de la mascota';
COMMENT ON COLUMN mascotas.fecha_ingreso IS 'Fecha de ingreso de la mascota';
COMMENT ON COLUMN mascotas.fecha_adopcion IS 'Fecha de adopcion de la mascota';
COMMENT ON COLUMN mascotas.id_adoptante IS 'Llave foranea del adoptante';
COMMENT ON COLUMN mascotas.estado IS 'Bandera para borrado logico';

-- Tabla de bitácora de mascotas
CREATE TABLE mascotas_bit (
    id_mascota_bit VARCHAR2(36) PRIMARY KEY,            -- ID de bitácora
    id_mascota VARCHAR2(36) NOT NULL,                   -- ID de la mascota

    nombre VARCHAR2(100),
    especie VARCHAR2(50),
    raza VARCHAR2(100),
    edad NUMBER,
    sexo VARCHAR2(10),
    url_imagen VARCHAR2(500),
    fecha_ingreso TIMESTAMP,
    fecha_adopcion TIMESTAMP,
    id_adoptante VARCHAR2(36),

    estado NUMBER DEFAULT 1,

    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
    fecha_modificacion TIMESTAMP,                       -- Fecha modificación
    accion VARCHAR2(10) NOT NULL,                       -- INSERT/UPDATE/DELETE
    ip VARCHAR2(30) NOT NULL                            -- IP origen
);

-- Documentación de la tabla y columnas
COMMENT ON TABLE mascotas_bit IS 'Tabla de bitacora de las mascotas';

COMMENT ON COLUMN mascotas_bit.id_mascota_bit IS 'Llave primaria de la bitacora';
COMMENT ON COLUMN mascotas_bit.id_mascota IS 'Llave primaria de la mascota';

COMMENT ON COLUMN mascotas_bit.nombre IS 'Nombre de la mascota';
COMMENT ON COLUMN mascotas_bit.especie IS 'Especie de la mascota';
COMMENT ON COLUMN mascotas_bit.raza IS 'Raza de la mascota';
COMMENT ON COLUMN mascotas_bit.edad IS 'Edad de la mascota';
COMMENT ON COLUMN mascotas_bit.sexo IS 'Sexo de la mascota';
COMMENT ON COLUMN mascotas_bit.url_imagen IS 'URL de la imagen de la mascota';
COMMENT ON COLUMN mascotas_bit.fecha_ingreso IS 'Fecha de ingreso de la mascota';
COMMENT ON COLUMN mascotas_bit.fecha_adopcion IS 'Fecha de adopcion de la mascota';
COMMENT ON COLUMN mascotas_bit.id_adoptante IS 'Llave foranea del adoptante';

COMMENT ON COLUMN mascotas_bit.estado IS 'Bandera para borrado logico';

COMMENT ON COLUMN mascotas_bit.fecha_creacion IS 'Fecha de creacion del registro';
COMMENT ON COLUMN mascotas_bit.fecha_modificacion IS 'Fecha de modificacion del registro';
COMMENT ON COLUMN mascotas_bit.accion IS 'Operacion realizada';
COMMENT ON COLUMN mascotas_bit.ip IS 'IP origen de la operacion';


-- Secuencia para generar IDs consecutivos
CREATE SEQUENCE seq_mascotas_bit_id START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_mascotas START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE NOCYCLE;


CREATE OR REPLACE TRIGGER trg_mascotas_aud
AFTER INSERT OR UPDATE ON mascotas
FOR EACH ROW
DECLARE
    V_ACCION VARCHAR2(20);
    V_FECHA_CREACION TIMESTAMP := NULL;
    V_FECHA_MODIFICACION TIMESTAMP := NULL;
    V_ID_BITACORA VARCHAR2(30);

BEGIN

    V_ID_BITACORA := 'MAS_BIT-' || LPAD(seq_mascotas_bit_id.NEXTVAL, 6, '0');

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

    INSERT INTO mascotas_bit (
        id_mascota_bit,
        id_mascota,
        nombre,
        especie,
        raza,
        edad,
        sexo,
        url_imagen,
        fecha_ingreso,
        fecha_adopcion,
        id_adoptante,
        estado,
        fecha_creacion,
        fecha_modificacion,
        accion,
        ip
    )
    VALUES (
        V_ID_BITACORA,
        :NEW.id_mascota,
        :NEW.nombre,
        :NEW.especie,
        :NEW.raza,
        :NEW.edad,
        :NEW.sexo,
        :NEW.url_imagen,
        :NEW.fecha_ingreso,
        :NEW.fecha_adopcion,
        :NEW.id_adoptante,
        :NEW.estado,
        V_FECHA_CREACION,
        V_FECHA_MODIFICACION,
        V_ACCION,
        FN_GET_IP()
    );

END;
/

commit ;