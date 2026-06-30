package com.inube.adopcion.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name="adoptantes")
@Data
public class AdoptanteModel {

    @Id
    @Column(name="id_adoptante")
    private String idAdoptante;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "apellido")
    private String apellido;

    @Column(name = "telefono")
    private String telefono;

    @Column(name = "correo")
    private String correo;

    @Column(name = "direccion")
    private String direccion;

    @Column(name = "estado")
    private Integer estado = 1;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro = LocalDateTime.now();

    // Si se necesita saber las mascotas de un adoptante
    //@OneToMany(mappedBy = "idAdoptante", fetch = FetchType.LAZY)
    //private List<MascotaModel> mascotas;
}
