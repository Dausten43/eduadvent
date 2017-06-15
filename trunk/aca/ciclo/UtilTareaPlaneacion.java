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
					+ " union "
					+ "select 'B', count(*) cuantas from CICLO_GRUPO_ACTIVIDAD WHERE CICLO_GRUPO_ID='"+ciclo_gpo_id+"' and MOSTRAR='S' and FECHA::date= to_date('"+fecha+"','dd/mm/yyyy')"
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
