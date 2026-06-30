package com.inube.adopcion.controller;

import com.inube.adopcion.dto.ApiResponse;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.CitaSeguimientoModel;
import com.inube.adopcion.service.AdoptanteService;
import com.inube.adopcion.service.CitaSeguimientoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static com.inube.adopcion.util.UtilConstants.*;
import static com.inube.adopcion.util.UtilConstants.MSG10;


@RestController
@RequestMapping("/api/citas")
@RequiredArgsConstructor
public class CitaSeguimientoController {
    private final CitaSeguimientoService service;

    @PostMapping
    public ResponseEntity<ApiResponse<?>> guardar (@RequestBody CitaSeguimientoModel citaSeguimiento){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG2,service.guardar(citaSeguimiento)));
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
    public ResponseEntity<ApiResponse<?>> actualizar (@PathVariable String id, @RequestBody CitaSeguimientoModel citaSeguimiento){
        return ResponseEntity.ok(
                new ApiResponse<>(true,MSG3,service.actualizar(id,citaSeguimiento)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<?>> eliminar (@PathVariable String id){
        service.eliminar(id);
        return ResponseEntity.ok(new ApiResponse<>(true,MSG4,null));
    }
}
