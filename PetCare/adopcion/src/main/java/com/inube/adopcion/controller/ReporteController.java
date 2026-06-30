package com.inube.adopcion.controller;


import com.inube.adopcion.dto.ApiResponse;
import com.inube.adopcion.repository.VacunaRepository;
import com.inube.adopcion.service.VacunaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static com.inube.adopcion.util.UtilConstants.MSG1;

@RestController
@RequestMapping("/api/reportes")
@RequiredArgsConstructor
public class ReporteController {

    private final VacunaRepository service;


    @GetMapping("/mascotas-vacunadas")
    public ResponseEntity<ApiResponse<?>> reporte (){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG1,service.mascotasVacunadas()));
    }
}
