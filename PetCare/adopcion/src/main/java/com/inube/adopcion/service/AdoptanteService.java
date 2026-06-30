package com.inube.adopcion.service;


import com.inube.adopcion.dto.MascotasResponseDTO;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.MascotaModel;
import com.inube.adopcion.repository.AdoptanteRepository;
import com.inube.adopcion.repository.MascotaRepository;
import com.inube.adopcion.util.UtilConstants;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

import static com.inube.adopcion.util.UtilConstants.*;

@Service
@RequiredArgsConstructor
public class AdoptanteService {
    private final AdoptanteRepository repository;
    private final MascotaRepository mascotaRepository;


    public AdoptanteModel guardar(AdoptanteModel adoptante){
        adoptante.setIdAdoptante("ADO-" + String.format("%06d", repository.obtenerSiguienteId()));
        return repository.save(adoptante);
    }

    public List<AdoptanteModel> listar(){
        return repository.findByEstado(CODEPOS);
    }

    public AdoptanteModel buscarPorId(String id){
        return repository.findById(id).orElseThrow(()->new RuntimeException(MSG15));
    }

    public AdoptanteModel actualizar(String id, AdoptanteModel request){

        AdoptanteModel adoptante = buscarPorId(id);
        adoptante.setNombre(request.getNombre());
        adoptante.setApellido(request.getApellido());
        adoptante.setTelefono(request.getTelefono());
        adoptante.setCorreo(request.getCorreo());
        adoptante.setDireccion(request.getDireccion());

        return repository.save(adoptante);
    }

    public void eliminar(String  id){
        AdoptanteModel adoptante = buscarPorId(id);
        adoptante.setEstado(CODENEG);
        repository.save(adoptante);
    }



    public List<MascotasResponseDTO> listarPorAdoptante(String idAdoptante) {

        List<MascotaModel> mascotas =
                mascotaRepository.findByAdoptanteIdAdoptanteAndEstado(
                        idAdoptante,
                        UtilConstants.CODEPOS
                );

        return mascotas.stream().map(mascota -> {

            MascotasResponseDTO dto = new MascotasResponseDTO();

            dto.setIdMascota(mascota.getIdMascota());
            dto.setNombre(mascota.getNombre());
            dto.setEspecie(mascota.getEspecie());
            dto.setRaza(mascota.getRaza());
            dto.setEdad(mascota.getEdad());
            dto.setSexo(mascota.getSexo());
            dto.setUrlImagen(mascota.getUrl_imagen());
            dto.setFechaIngreso(mascota.getFechaIngreso());
            dto.setFechaAdopcion(mascota.getFechaAdopcion());

            return dto;

        }).toList();
    }


}
