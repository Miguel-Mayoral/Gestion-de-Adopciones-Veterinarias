package com.inube.adopcion.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MascotasVacunadasDTO {
    private String especie;
    private Long totalVacunas;
}
