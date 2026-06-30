package com.inube.adopcion.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name="citas_seguimiento")
@Data
public class CitaSeguimientoModel {
    @Id
    @Column(name="id_cita")
    private String idCita;

    @ManyToOne
    @JoinColumn(name = "id_mascota")
    private MascotaModel mascota;

    @Column(name = "fecha_cita")
    private LocalDateTime fechaCita= LocalDateTime.now();

    @Column(name = "motivo")
    private String motivo;

    @Column(name = "observaciones")
    private String observaciones;

    @Column(name = "estatus")
    private String estatus;

    @Column(name = "estado")
    private Integer estado = 1;
}
