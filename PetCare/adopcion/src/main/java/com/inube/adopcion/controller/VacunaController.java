package com.inube.adopcion.controller;

import com.inube.adopcion.dto.ApiResponse;
import com.inube.adopcion.dto.MascotaRequestDTO;
import com.inube.adopcion.dto.VacunaResquestDTO;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.ChipRastreoModel;
import com.inube.adopcion.model.VacunaModel;
import com.inube.adopcion.service.AdoptanteService;
import com.inube.adopcion.service.VacunaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static com.inube.adopcion.util.UtilConstants.*;
import static com.inube.adopcion.util.UtilConstants.MSG10;


@RestController
@RequestMapping("/api/vacunas")
@RequiredArgsConstructor
public class VacunaController {
    private final VacunaService service;

    @PostMapping
    public ResponseEntity<ApiResponse<?>> registrarVacuna (@RequestBody VacunaResquestDTO request){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG5,service.registrarVacuna(request)));
    }

    @PostMapping("/guardar")
    public ResponseEntity<ApiResponse<?>> guardar (@RequestBody VacunaModel vacuna){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG17,service.guardar(vacuna)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<?>> listar (){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG1,service.listar()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<?>> buscarPorId (@PathVariable String id){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG1,service.buscarPorId(id)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<?>> actualizar (@PathVariable String id, @RequestBody VacunaModel vacuna){
        return ResponseEntity.ok(
                new ApiResponse<>(true,MSG18,service.actualizar(id,vacuna)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<?>> eliminar (@PathVariable String id){
        service.eliminar(id);
        return ResponseEntity.ok(new ApiResponse<>(true,MSG19,null));
    }
}
