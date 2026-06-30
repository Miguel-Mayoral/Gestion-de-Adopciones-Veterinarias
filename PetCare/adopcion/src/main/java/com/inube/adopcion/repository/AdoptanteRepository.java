package com.inube.adopcion.repository;


import com.inube.adopcion.model.AdoptanteModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdoptanteRepository extends JpaRepository<AdoptanteModel,String> {
    List<AdoptanteModel> findByEstado(Integer estado);

    @Query(value = "SELECT seq_adoptantes_bit_id.NEXTVAL FROM DUAL", nativeQuery = true)
    Long obtenerSiguienteId();
}
