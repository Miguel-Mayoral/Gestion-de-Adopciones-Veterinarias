package com.inube.adopcion.service;


import com.inube.adopcion.dto.MascotaRequestDTO;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.MascotaModel;
import com.inube.adopcion.model.VacunaModel;
import com.inube.adopcion.repository.AdoptanteRepository;
import com.inube.adopcion.repository.MascotaRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static com.inube.adopcion.util.UtilConstants.*;

@Service
@RequiredArgsConstructor
public class MascotaService {

    private final AdoptanteRepository adoptanteRepository;

    private final MascotaRepository repository;

    public MascotaModel registrarMascota(MascotaRequestDTO request){

        AdoptanteModel adoptante =
                adoptanteRepository.findById(request.getIdAdoptante()).orElseThrow(() -> new RuntimeException(MSG15));

        if(adoptante.getEstado()==0){
            System.out.println("Adoptante no activo");
            return null;
        }

        MascotaModel mascota =
                repository.findById(request.getIdMascota()).orElseThrow(() -> new RuntimeException(MSG20));
        mascota.setAdoptante(adoptante);
        mascota.setFechaAdopcion(LocalDateTime.now());
      //  mascota.setIdMascota("PET-" + String.format("%06d", repository.obtenerSiguienteId()));
        return repository.save(mascota);
    }

    public MascotaModel guardar(MascotaModel mascota){
          mascota.setIdMascota("PET-" + String.format("%06d", repository.obtenerSiguienteId()));
        return repository.save(mascota);
    }

    public List<MascotaModel> listar(){
        return repository.findByEstado(CODEPOS);
    }

    public MascotaModel buscarPorId(String id){
        return repository.findById(id).orElseThrow(()->new RuntimeException(MSG16));
    }

    public MascotaModel actualizar(String id, MascotaModel request){

        MascotaModel mascota = buscarPorId(id);
        mascota.setNombre(request.getNombre());
        mascota.setEspecie(request.getEspecie());
        mascota.setRaza(request.getRaza());
        mascota.setSexo(request.getSexo());
        mascota.setFechaAdopcion(request.getFechaAdopcion());
        mascota.setAdoptante(request.getAdoptante());

        return repository.save(mascota);
    }

    public void eliminar(String  id){
        MascotaModel mascota = buscarPorId(id);
        mascota.setEstado(CODENEG);
        repository.save(mascota);
    }
}
