package com.inube.adopcion.dto;

import com.inube.adopcion.model.MascotaModel;
import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class VacunaResquestDTO {
    private String idMascota;

    private String nombreVacuna;
    private String descripcion;
}
