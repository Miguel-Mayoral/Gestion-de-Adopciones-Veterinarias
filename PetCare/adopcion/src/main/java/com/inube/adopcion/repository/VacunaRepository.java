package com.inube.adopcion.repository;

import com.inube.adopcion.dto.MascotasVacunadasDTO;
import com.inube.adopcion.model.VacunaModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VacunaRepository extends JpaRepository<VacunaModel,String>{
    List<VacunaModel> findByMascotaIdMascotaAndEstado(String idMascota, Integer estado);
    List<VacunaModel> findByEstado(Integer estado);

        @Query("""
        SELECT new com.inube.adopcion.dto.MascotasVacunadasDTO(
            v.mascota.especie,
            COUNT(v.idVacuna)
        )
        FROM VacunaModel v
        WHERE v.estado = 1
        AND v.mascota.estado = 1
        GROUP BY v.mascota.especie
        ORDER BY COUNT(v.idVacuna) DESC
        """)
    List<MascotasVacunadasDTO> mascotasVacunadas();

    @Query(value = "SELECT seq_vacunas_bit_id.NEXTVAL FROM DUAL", nativeQuery = true)
    Long obtenerSiguienteId();
}
