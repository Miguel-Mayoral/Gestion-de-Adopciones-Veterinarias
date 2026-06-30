package com.inube.adopcion.service;

import com.inube.adopcion.model.ChipRastreoModel;
import com.inube.adopcion.repository.ChipRastreoRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import static com.inube.adopcion.util.UtilConstants.*;

@Service
@RequiredArgsConstructor
public class ChipRastreoService {
    private final ChipRastreoRepository repository;

    public ChipRastreoModel guardar(ChipRastreoModel chipRastreo){
        chipRastreo.setIdChip("CHIP-" + String.format("%06d", repository.obtenerSiguienteId()));
        return repository.save(chipRastreo);
    }

    public List<ChipRastreoModel> listar(){
        return repository.findByEstado(CODEPOS);
    }

    public ChipRastreoModel buscarPorId(String id){
        return repository.findById(id).orElseThrow(()->new RuntimeException(MSG14));
    }

    public ChipRastreoModel actualizar(String id, ChipRastreoModel request){

        ChipRastreoModel chipRastreo = buscarPorId(id);
        chipRastreo.setCodigoChip(request.getCodigoChip());
        chipRastreo.setFechaImplantacion(request.getFechaImplantacion());
        chipRastreo.setFabricante(request.getFabricante());
        chipRastreo.setMascota(request.getMascota());

        return repository.save(chipRastreo);
    }

    public void eliminar(String  id){
        ChipRastreoModel chipRastreo = buscarPorId(id);
        chipRastreo.setEstado(CODENEG);
        repository.save(chipRastreo);
    }
}
