package aca.alumno;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class AlumMensajeLista {
	public ArrayList<AlumMensaje> getListAll(Connection Conn, String escuelaId, String maestroId,String codigoId, String sql ) throws SQLException{
		
		ArrayList<AlumMensaje> lis 	= new ArrayList<AlumMensaje>();
		Statement st 				= Conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = " SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID , CURSO_ID, " +
					" TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI AM') AS FECHA, MAESTRO_ID, PADRE_ID, COMENTARIO, LEIDO, FROM_MAESTRO, FROM_PADRE" +
					" FROM ALUM_MENSAJE WHERE SUBSTRING(MAESTRO_ID,1,3) = '"+escuelaId+"'" +
					" AND MAESTRO_ID= '"+maestroId+"' AND CODIGO_ID = '"+codigoId+"' " +sql+" ORDER BY TO_CHAR(FECHA, 'YYYY/MM/DD HH24:MI AM') DESC, FOLIO ";		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumMensaje obj = new AlumMensaje();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumMensajeLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}
	
	public ArrayList<AlumMensaje> getListCicloGrupoId(Connection Conn, String escuelaId, String maestroId, String cicloGrupoId, String orden ) throws SQLException{
		
		ArrayList<AlumMensaje> lis 	= new ArrayList<AlumMensaje>();
		Statement st 				= Conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = " SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID , CURSO_ID, " +
					" TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, MAESTRO_ID, PADRE_ID, COMENTARIO, LEIDO, FROM_MAESTRO, FROM_PADRE" +
					" FROM ALUM_MENSAJE WHERE SUBSTRING(MAESTRO_ID,1,3) = '"+escuelaId+"'" +
					" AND MAESTRO_ID= '"+maestroId+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +orden;		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumMensaje obj = new AlumMensaje();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumMensajeLista|getListCicloGrupoId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}

}
