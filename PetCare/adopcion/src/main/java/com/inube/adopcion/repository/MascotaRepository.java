package com.inube.adopcion.repository;
import com.inube.adopcion.model.MascotaModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MascotaRepository extends JpaRepository<MascotaModel,String> {
    List<MascotaModel> findByAdoptanteIdAdoptanteAndEstado(String idAdoptante, Integer estado);
    List<MascotaModel> findByEstado(Integer estado);

    @Query(value = "SELECT seq_mascotas.NEXTVAL FROM DUAL", nativeQuery = true)
    Long obtenerSiguienteId();
}
