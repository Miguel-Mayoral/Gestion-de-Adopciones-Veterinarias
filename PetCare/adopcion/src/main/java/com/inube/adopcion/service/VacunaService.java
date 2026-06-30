package com.inube.adopcion.service;


import com.inube.adopcion.dto.MascotaRequestDTO;
import com.inube.adopcion.dto.VacunaResquestDTO;
import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.MascotaModel;
import com.inube.adopcion.model.VacunaModel;
import com.inube.adopcion.repository.MascotaRepository;
import com.inube.adopcion.repository.VacunaRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

import static com.inube.adopcion.util.UtilConstants.*;

@Service
@RequiredArgsConstructor
public class VacunaService {
    private final VacunaRepository repository;
    private final MascotaRepository mascotaRepository;

    public VacunaModel registrarVacuna(VacunaResquestDTO request){

        MascotaModel mascota =
                mascotaRepository.findById(request.getIdMascota()).orElseThrow(() -> new RuntimeException(MSG16));

        if(mascota.getEstado()==0){
            System.out.println("Mascota no activo");
            return null;
        }

        VacunaModel vacuna = new VacunaModel();

        vacuna.setNombreVacuna(request.getNombreVacuna());
        vacuna.setDescripcion(request.getDescripcion());
        vacuna.setMascota(mascota);
        vacuna.setFecha_aplicacion(LocalDateTime.now());
        vacuna.setProxima_aplicacion(vacuna.getFecha_aplicacion().plusMonths(3));
        vacuna.setIdVacuna("VAC-" + String.format("%06d", repository.obtenerSiguienteId()));
        return repository.save(vacuna);
    }

    public VacunaModel guardar(VacunaModel vacuna){
        vacuna.setIdVacuna("VAC-" + String.format("%06d", repository.obtenerSiguienteId()));
        return repository.save(vacuna);
    }

    public List<VacunaModel> listar(){
        return repository.findByEstado(CODEPOS);
    }

    public VacunaModel buscarPorId(String id){
        return repository.findById(id).orElseThrow(()->new RuntimeException(MSG14));
    }

    public VacunaModel actualizar(String id, VacunaModel request){

        VacunaModel vacuna = buscarPorId(id);
        vacuna.setNombreVacuna(request.getNombreVacuna());
        vacuna.setDescripcion(request.getDescripcion());
        vacuna.setFecha_aplicacion(request.getFecha_aplicacion());
        vacuna.setProxima_aplicacion(request.getProxima_aplicacion());
        vacuna.setMascota(request.getMascota());

        return repository.save(vacuna);
    }

    public void eliminar(String  id){
        VacunaModel vacuna = buscarPorId(id);
        vacuna.setEstado(CODENEG);
        repository.save(vacuna);
    }
}
