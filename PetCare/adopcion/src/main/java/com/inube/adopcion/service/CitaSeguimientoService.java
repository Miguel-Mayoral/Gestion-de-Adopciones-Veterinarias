package com.inube.adopcion.service;

import com.inube.adopcion.model.ChipRastreoModel;
import com.inube.adopcion.model.CitaSeguimientoModel;
import com.inube.adopcion.repository.ChipRastreoRepository;
import com.inube.adopcion.repository.CitaSeguimientoRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

import static com.inube.adopcion.util.UtilConstants.*;

@Service
@RequiredArgsConstructor
public class CitaSeguimientoService {
    private final CitaSeguimientoRepository repository;

    public CitaSeguimientoModel guardar(CitaSeguimientoModel citaSeguimiento){
        citaSeguimiento.setIdCita("CITA-" + String.format("%06d", repository.obtenerSiguienteId()));
        return repository.save(citaSeguimiento);
    }

    public List<CitaSeguimientoModel> listar(){
        return repository.findByEstado(CODEPOS);
    }

    public CitaSeguimientoModel buscarPorId(String id){
        return repository.findById(id).orElseThrow(()->new RuntimeException(MSG14));
    }

    public CitaSeguimientoModel actualizar(String id, CitaSeguimientoModel request){

        CitaSeguimientoModel citaSeguimiento = buscarPorId(id);
        citaSeguimiento.setMascota(request.getMascota());
        citaSeguimiento.setFechaCita(request.getFechaCita());
        citaSeguimiento.setMotivo(request.getMotivo());
        citaSeguimiento.setObservaciones(request.getObservaciones());
        citaSeguimiento.setEstado(request.getEstado());

        return repository.save(citaSeguimiento);
    }

    public void eliminar(String  id){
        CitaSeguimientoModel citaSeguimiento = buscarPorId(id);
        citaSeguimiento.setEstado(CODENEG);
        repository.save(citaSeguimiento);
    }
}
