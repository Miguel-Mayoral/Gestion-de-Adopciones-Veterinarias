package com.inube.adopcion.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MascotasResponseDTO {

    private String idMascota;

    private String nombre;

    private String especie;

    private String raza;

    private Integer edad;

    private String sexo;

    private String urlImagen;

    private LocalDateTime fechaIngreso;

    private LocalDateTime fechaAdopcion;

    private String idAdoptante;
}