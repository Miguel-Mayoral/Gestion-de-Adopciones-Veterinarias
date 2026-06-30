package com.inube.adopcion.repository;

import com.inube.adopcion.model.ChipRastreoModel;
import com.inube.adopcion.model.CitaSeguimientoModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CitaSeguimientoRepository extends JpaRepository<CitaSeguimientoModel,String> {
    List<CitaSeguimientoModel> findByEstado(Integer estado);

    @Query(value = "SELECT seq_citas_seguimiento_bit_id.NEXTVAL FROM DUAL", nativeQuery = true)
    Long obtenerSiguienteId();
}
