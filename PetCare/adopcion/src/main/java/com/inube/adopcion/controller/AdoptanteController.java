package com.inube.adopcion.controller;

import com.inube.adopcion.dto.ApiResponse;
import com.inube.adopcion.dto.MascotasResponseDTO;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.service.AdoptanteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.inube.adopcion.util.UtilConstants.*;

@RestController
@RequestMapping("/api/adoptantes")
@RequiredArgsConstructor
public class AdoptanteController {
    private final AdoptanteService service;

    @PostMapping
    public ResponseEntity<ApiResponse<?>> guardar (@RequestBody AdoptanteModel adoptante){
        return ResponseEntity.ok(new ApiResponse<>(true,MSG8,service.guardar(adoptante)));
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
    public ResponseEntity<ApiResponse<?>> actualizar (@PathVariable String id, @RequestBody AdoptanteModel adoptante){
        return ResponseEntity.ok(
                new ApiResponse<>(true,MSG9,service.actualizar(id,adoptante)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<?>> eliminar (@PathVariable String id){
        service.eliminar(id);
        return ResponseEntity.ok(new ApiResponse<>(true,MSG10,null));
    }

    @GetMapping("/{id}/mascotas")
    public ResponseEntity<ApiResponse<List<MascotasResponseDTO>>> listarPorAdoptante(@PathVariable String id){
        List<MascotasResponseDTO> mascotas = service.listarPorAdoptante(id);
        return ResponseEntity.ok(new ApiResponse<>(true, MSG1,mascotas));
    }

}
