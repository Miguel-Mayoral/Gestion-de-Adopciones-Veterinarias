package com.inube.adopcion.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name="chip_rastreo")
@Data
public class ChipRastreoModel {

    @Id
    @Column(name="id_chip")
    private String idChip;

    @Column(name = "codigo_chip")
    private String codigoChip;

    @Column(name = "fecha_implantacion")
    private LocalDateTime fechaImplantacion= LocalDateTime.now();

    @Column(name = "fabricante")
    private String fabricante;

    @ManyToOne
    @JoinColumn(name = "id_mascota")
    private MascotaModel mascota;

    @Column(name = "estado")
    private Integer estado = 1;
}
