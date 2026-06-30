package com.inube.adopcion.controller;

import com.inube.adopcion.dto.ApiResponse;
import com.inube.adopcion.dto.MascotaRequestDTO;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.MascotaModel;
import com.inube.adopcion.service.AdoptanteService;
import com.inube.adopcion.service.MascotaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static com.inube.adopcion.util.UtilConstants.*;
import static com.inube.adopcion.util.UtilConstants.MSG10;

@RestController
@RequestMapping("/api/mascotas")
@RequiredArgsConstructor
public class MascotaController {
    private final MascotaService service;

    @PostMapping
    public ResponseEntity<ApiResponse<?>> registrarMascota (@RequestBody MascotaRequestDTO request){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG5,service.registrarMascota(request)));
    }
    @PostMapping("/guardar")
    public ResponseEntity<ApiResponse<?>> guardar (@RequestBody MascotaModel mascota){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG5,service.guardar(mascota)));
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
    public ResponseEntity<ApiResponse<?>> actualizar (@PathVariable String id, @RequestBody MascotaModel mascota){
        return ResponseEntity.ok(
                new ApiResponse<>(true,MSG6,service.actualizar(id,mascota)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<?>> eliminar (@PathVariable String id){
        service.eliminar(id);
        return ResponseEntity.ok(new ApiResponse<>(true,MSG7,null));
    }
}
