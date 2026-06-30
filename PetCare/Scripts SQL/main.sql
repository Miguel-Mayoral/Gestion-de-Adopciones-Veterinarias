
INSERT INTO adoptantes(id_adoptante,nombre,apellido,telefono,correo,direccion,estado)
VALUES (
    'VET-000001',
    'Veterinaria Patitas Felices',
    NULL,
    '9531234567',
    'contacto@patitasfelices.com',
    'Av. Benito Juárez 125, Huajuapan de León, Oaxaca',
    1
);


INSERT INTO mascotas (id_mascota,nombre,especie,raza,edad,sexo,url_imagen,fecha_adopcion,id_adoptante,estado)
VALUES ('MAS-000002','Luna','Perro','Pastor Aleman',2,'Hembra','https://ejemplo.com/luna.jpg',NULL,'VET-000001',1);

INSERT INTO mascotas (id_mascota,nombre,especie,raza,edad,sexo,url_imagen,fecha_adopcion,id_adoptante,estado)
VALUES ('MAS-000003','Michi','Gato','Siames',1,'Macho','https://ejemplo.com/michi.jpg',NULL,'VET-000001',1);

INSERT INTO mascotas (id_mascota,nombre,especie,raza,edad,sexo,url_imagen,fecha_adopcion,id_adoptante,estado)
VALUES ('MAS-000004','Nala','Gato','Persa',4,'Hembra','https://ejemplo.com/nala.jpg',NULL,'VET-000001',1);

INSERT INTO mascotas (id_mascota,nombre,especie,raza,edad,sexo,url_imagen,fecha_adopcion,id_adoptante,estado)
VALUES ('MAS-000005','Rocky','Perro','Pitbull',5,'Macho','https://ejemplo.com/rocky.jpg',NULL,'VET-000001',1);



INSERT INTO vacunas(id_vacuna,nombre_vacuna,descripcion,fecha_aplicacion,proxima_aplicacion,id_mascota,estado)
VALUES ('VAC-000001','Rabia','Vacuna antirrabica anual',TIMESTAMP '2026-01-15 10:00:00',TIMESTAMP '2027-01-15 10:00:00','MAS-000002',1);

INSERT INTO vacunas(id_vacuna,nombre_vacuna,descripcion,fecha_aplicacion,proxima_aplicacion,id_mascota,estado)
VALUES ('VAC-000002','Moquillo','Vacuna contra moquillo canino',TIMESTAMP '2026-02-10 09:30:00',TIMESTAMP '2027-02-10 09:30:00','MAS-000002',1);

INSERT INTO vacunas(id_vacuna,nombre_vacuna,descripcion,fecha_aplicacion,proxima_aplicacion,id_mascota,estado)
VALUES ('VAC-000003','Triple Felina','Proteccion contra rinotraqueitis, calicivirus y panleucopenia',TIMESTAMP '2026-03-05 11:00:00',TIMESTAMP '2027-03-05 11:00:00','MAS-000003',1);

INSERT INTO vacunas(id_vacuna,nombre_vacuna,descripcion,fecha_aplicacion,proxima_aplicacion,id_mascota,estado)
VALUES ('VAC-000004','Leucemia Felina','Vacuna preventiva contra leucemia felina',TIMESTAMP '2026-03-12 12:15:00',TIMESTAMP '2027-03-12 12:15:00','MAS-000004',1);

INSERT INTO vacunas(id_vacuna,nombre_vacuna,descripcion,fecha_aplicacion,proxima_aplicacion,id_mascota,estado)
VALUES ('VAC-000005','Parvovirus','Vacuna preventiva contra parvovirus canino',TIMESTAMP '2026-04-20 08:45:00',TIMESTAMP '2027-04-20 08:45:00','MAS-000005',1);



INSERT INTO chip_rastreo(id_chip,codigo_chip,fecha_implantacion,fabricante,id_mascota,estado)
VALUES ('CHP-000001','985141000123456',TIMESTAMP '2026-01-20 09:30:00','PetTrack','MAS-000002',1);

INSERT INTO chip_rastreo(id_chip,codigo_chip,fecha_implantacion,fabricante,id_mascota,estado)
VALUES ('CHP-000002','985141000654321',TIMESTAMP '2026-02-15 11:00:00','AnimalSecure','MAS-000004',1);



INSERT INTO citas_seguimiento(id_cita,id_mascota,fecha_cita,motivo,observaciones,estatus,estado)
VALUES ('CIT-000001','MAS-000002',TIMESTAMP '2026-07-10 10:00:00','Revision post adopcion','La mascota presenta buen estado general','PROGRAMADA',1);

INSERT INTO citas_seguimiento(id_cita,id_mascota,fecha_cita,motivo,observaciones,estatus,estado)
VALUES ('CIT-000002','MAS-000003',TIMESTAMP '2026-07-12 09:30:00','Control de vacunacion','Verificar esquema completo de vacunas','PROGRAMADA',1);

INSERT INTO citas_seguimiento(id_cita,id_mascota,fecha_cita,motivo,observaciones,estatus,estado)
VALUES ('CIT-000003','MAS-000004',TIMESTAMP '2026-07-15 11:15:00','Seguimiento de adaptacion','Evaluar comportamiento en el nuevo hogar','PROGRAMADA',1);

INSERT INTO citas_seguimiento(id_cita,id_mascota,fecha_cita,motivo,observaciones,estatus,estado)
VALUES ('CIT-000004','MAS-000005',TIMESTAMP '2026-07-18 16:00:00','Revision nutricional','Revisar peso y alimentacion recomendada','PROGRAMADA',1);

INSERT INTO citas_seguimiento(id_cita,id_mascota,fecha_cita,motivo,observaciones,estatus,estado)
VALUES ('CIT-000005','MAS-000002',TIMESTAMP '2026-08-01 10:30:00','Control de chip de rastreo','Validar funcionamiento del dispositivo implantado','PROGRAMADA',1);
Commit ;

SELECT id_mascota
FROM mascotas;



select * from ADOPTANTES;
select * from MASCOTAS;
select * from VACUNAS;
select * from CHIP_RASTREO;
select * from citas_seguimiento;
