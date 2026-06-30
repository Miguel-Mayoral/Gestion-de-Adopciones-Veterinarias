package com.inube.adopcion.model;


import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name="mascotas")
@Data
public class MascotaModel {
    @Id
    @Column(name="id_mascota")
    private String idMascota;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "especie")
    private String especie;

    @Column(name = "raza")
    private String raza;

    @Column(name = "edad")
    private Integer edad;

    @Column(name = "sexo")
    private String sexo;

    @Column(name = "url_imagen")
    private String url_imagen;

    @Column(name = "fecha_ingreso")
    private LocalDateTime fechaIngreso= LocalDateTime.now();

    @Column(name = "fecha_adopcion")
    private LocalDateTime fechaAdopcion;

    @ManyToOne
    @JoinColumn(name = "id_adoptante")
    private AdoptanteModel adoptante;

    @Column(name = "estado")
    private Integer estado = 1;

    // Si se necesita saber las vacunas de una mascota
    //@OneToMany(mappedBy = "idMascota", fetch = FetchType.LAZY)
    //private List<VacunaModel> vacunas;

    // Si se necesita saber las citas de seguimiento de una mascota
    //@OneToMany(mappedBy = "idMascota", fetch = FetchType.LAZY)
    //private List<CitaSeguimientoModel> citasSeguimiento;
}
