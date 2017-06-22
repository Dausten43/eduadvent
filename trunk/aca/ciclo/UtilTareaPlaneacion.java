package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UtilTareaPlaneacion {
	
	public int tareasDiaGrupo(Connection con, String ciclo_gpo_id, String fecha )throws SQLException{
		int salida = 0;
		try{
			PreparedStatement pst =con.prepareStatement("select sum(tareas.cuantas) as t from ("
					+ "select 'A', count(*) cuantas from CICLO_GRUPO_TAREA where CICLO_GRUPO_ID='"+ciclo_gpo_id+"' and FECHA::date= to_date('"+fecha+"','dd/mm/yyyy')"
					+ " AND SUBSTRING(CICLO_GRUPO_ID, 1, 8) IN (select ciclo_id from ciclo where ciclo_id = SUBSTR('"+ciclo_gpo_id+"',1,8) and nivel_academico_sistema::integer>=3)"
					+ " union "
					+ "select 'B', count(*) cuantas from CICLO_GRUPO_ACTIVIDAD WHERE CICLO_GRUPO_ID='"+ciclo_gpo_id+"' and MOSTRAR='S' and FECHA::date= to_date('"+fecha+"','dd/mm/yyyy')"
					+ " AND SUBSTRING(CICLO_GRUPO_ID, 1, 8) IN (select ciclo_id from ciclo where ciclo_id = SUBSTR('"+ciclo_gpo_id+"',1,8) and nivel_academico_sistema::integer>=3)"
					+ ") tareas");
			ResultSet rs = pst.executeQuery();
			if(rs.next()){
				salida=rs.getInt("t");
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle ){
			System.err.println("Error en tareasDiaGrupo " + sqle);
		}
		
		return salida;
	}

}
