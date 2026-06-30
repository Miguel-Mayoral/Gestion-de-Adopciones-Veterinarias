package com.inube.adopcion.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name="vacunas")
@Data
public class VacunaModel {
    @Id
    @Column(name="id_vacuna")
    private String idVacuna;

    @Column(name = "nombre_vacuna")
    private String nombreVacuna;

    @Column(name = "descripcion")
    private String descripcion;

    @Column(name = "fecha_aplicacion")
    private LocalDateTime fecha_aplicacion;

    @Column(name = "proxima_aplicacion")
    private LocalDateTime proxima_aplicacion;

    @ManyToOne
    @JoinColumn(name = "id_mascota")
    private MascotaModel mascota;

    @Column(name = "estado")
    private Integer estado = 1;
}
