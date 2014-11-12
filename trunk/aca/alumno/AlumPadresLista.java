// Clase para la tabla de AlumPersonal
package aca.alumno;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;


public class AlumPadresLista{
		
	public ArrayList<AlumPadres> getListAll(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<AlumPadres> lisPadres 	= new ArrayList<AlumPadres>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CODIGO_PADRE, CODIGO_MADRE, CODIGO_TUTOR " +
					"FROM ALUM_PADRES WHERE SUBSTR(CODIGO_ID,1,3)='"+escuelaId+"' "+orden;		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPadres padre = new AlumPadres();
				padre.mapeaReg(rs);
				lisPadres.add(padre);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadresLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisPadres;
	}
	
	public ArrayList<AlumPadres> getListTutor(Connection Conn, String codigoTutor, String orden ) throws SQLException{
		
		ArrayList<AlumPadres> lisPadres 	= new ArrayList<AlumPadres>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CODIGO_PADRE, CODIGO_MADRE, CODIGO_TUTOR " +
					" FROM ALUM_PADRES " +
					" WHERE CODIGO_PADRE='"+codigoTutor+"'" +
					" OR CODIGO_MADRE = '"+codigoTutor+"'" +
					" OR CODIGO_TUTOR = '"+codigoTutor+"' "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPadres padre = new AlumPadres();
				padre.mapeaReg(rs);
				lisPadres.add(padre);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadresLista|getListTutor|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisPadres;
	}
	
	public HashMap<String,AlumPadres> getMapAll(Connection conn) throws SQLException{
		
		HashMap<String,AlumPadres> map = new HashMap<String,AlumPadres>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT CODIGO_ID, CODIGO_PADRE, CODIGO_MADRE, CODIGO_TUTOR FROM ALUM_PADRES ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumPadres obj = new AlumPadres();
				obj.mapeaReg(rs);
				llave = obj.getCodigoId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadresLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,AlumPadres> getMapEscuela(Connection conn, String escuelaId) throws SQLException{
		
		HashMap<String,AlumPadres> map = new HashMap<String,AlumPadres>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		if (escuelaId.length()==1) escuelaId = "0"+escuelaId;
		try{
			comando = "SELECT CODIGO_ID, CODIGO_PADRE, CODIGO_MADRE, CODIGO_TUTOR FROM ALUM_PADRES WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"'";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumPadres obj = new AlumPadres();
				obj.mapeaReg(rs);
				llave = obj.getCodigoId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPadresLista|getMapEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}

