package com.inube.adopcion.repository;

import com.inube.adopcion.model.AdoptanteModel;
import com.inube.adopcion.model.ChipRastreoModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChipRastreoRepository extends JpaRepository<ChipRastreoModel,String> {
    List<ChipRastreoModel> findByEstado(Integer estado);

    @Query(value = "SELECT seq_chip_rastreo_bit_id.NEXTVAL FROM DUAL", nativeQuery = true)
    Long obtenerSiguienteId();
}
