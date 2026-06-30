package com.inube.adopcion.controller;

import com.inube.adopcion.dto.ApiResponse;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.ChipRastreoModel;
import com.inube.adopcion.service.AdoptanteService;
import com.inube.adopcion.service.ChipRastreoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static com.inube.adopcion.util.UtilConstants.*;
import static com.inube.adopcion.util.UtilConstants.MSG10;

@RestController
@RequestMapping("/api/chips")
@RequiredArgsConstructor
public class ChipRastreoController {
    private final ChipRastreoService service;

    @PostMapping
    public ResponseEntity<ApiResponse<?>> guardar (@RequestBody ChipRastreoModel chipRastreo){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG11,service.guardar(chipRastreo)));
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
    public ResponseEntity<ApiResponse<?>> actualizar (@PathVariable String id, @RequestBody ChipRastreoModel chipRastreo){
        return ResponseEntity.ok(
                new ApiResponse<>(true,MSG12,service.actualizar(id,chipRastreo)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<?>> eliminar (@PathVariable String id){
        service.eliminar(id);
        return ResponseEntity.ok(new ApiResponse<>(true,MSG13,null));
    }
}
