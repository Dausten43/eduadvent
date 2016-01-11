//Clase  para la tabla CAT_NIVEL
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatGrupoLista {
	
	public ArrayList<CatGrupo> getListAll(Connection conn, String orden ) throws SQLException{
		
		ArrayList<CatGrupo> lisGrupo 	= new ArrayList<CatGrupo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO FROM CAT_GRUPO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatGrupo grupo = new CatGrupo();				
				grupo.mapeaReg(rs);
				lisGrupo.add(grupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisGrupo;
	}
	
	public HashMap<String,CatGrupo> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatGrupo> map = new HashMap<String,CatGrupo>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO FROM CAT_GRUPO "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatGrupo obj = new CatGrupo();
				obj.mapeaReg(rs);
				llave = obj.getFolio();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatGrupo> getListNivel(Connection conn, String nivelId, String orden ) throws SQLException{
		
		ArrayList<CatGrupo> lisGrupo 	= new ArrayList<CatGrupo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO " +
					" FROM CAT_GRUPO WHERE NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatGrupo grupo = new CatGrupo();				
				grupo.mapeaReg(rs);
				lisGrupo.add(grupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|getListNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisGrupo;
	}
	
	public ArrayList<CatGrupo> getListNivel(Connection conn, String escuelaId, String nivelId, String orden ) throws SQLException{
		
		ArrayList<CatGrupo> lisGrupo 	= new ArrayList<CatGrupo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO" +
					" FROM CAT_GRUPO WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatGrupo grupo = new CatGrupo();				
				grupo.mapeaReg(rs);
				lisGrupo.add(grupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|getListNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisGrupo;
	}
	
	public ArrayList<CatGrupo> getListGrupos(Connection conn, String cicloId, String planId, String escuelaId, String nivelId, String orden ) throws SQLException{
		
		ArrayList<CatGrupo> lisGrupo 	= new ArrayList<CatGrupo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO FROM CAT_GRUPO" +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') " +
					" AND TO_CHAR(NIVEL_ID,'99')||GRADO||GRUPO NOT IN" +
					"	(SELECT TO_CHAR(NIVEL_ID,'99')||GRADO||GRUPO FROM CICLO_GRUPO " +
					"	WHERE CICLO_ID = '"+cicloId+"'" +
					" 	AND PLAN_ID = '"+planId+"') "+ orden;
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatGrupo grupo = new CatGrupo();		
				grupo.mapeaReg(rs);
				lisGrupo.add(grupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|getListGrupos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisGrupo;
	}
	
	public ArrayList<CatGrupo> getListGruposAlta(Connection conn, String cicloId, String planId, String escuelaId, String nivelId, String orden ) throws SQLException{		
		ArrayList<CatGrupo> lisGrupo 	= new ArrayList<CatGrupo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO FROM CAT_GRUPO" +
				" WHERE ESCUELA_ID = '"+escuelaId+"'"+
				" AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') " +					
				" AND TO_CHAR(NIVEL_ID,'99')||GRADO||GRUPO IN" +
				"	(SELECT TO_CHAR(NIVEL_ID,'99')||GRADO||GRUPO FROM CICLO_GRUPO " +
				"	WHERE CICLO_ID = '"+cicloId+"'" +
				" 	AND PLAN_ID = '"+planId+"') "+ orden;
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatGrupo grupo = new CatGrupo();		
				grupo.mapeaReg(rs);
				lisGrupo.add(grupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|getListGrupos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisGrupo;
	}
	
	public ArrayList<CatGrupo> listGruposEnCiclo(Connection conn, String cicloId, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatGrupo> lisGrupo 	= new ArrayList<CatGrupo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = " SELECT FOLIO, NIVEL_ID, GRADO, GRUPO, ESCUELA_ID, TURNO FROM CAT_GRUPO"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND TRIM(TO_CHAR(NIVEL_ID,'99'))||TRIM(TO_CHAR(GRADO,'99'))||GRUPO IN "
					+ "		(SELECT TRIM(TO_CHAR(NIVEL,'99'))||TRIM(TO_CHAR(GRADO,'99'))||GRUPO FROM ALUM_CICLO WHERE CICLO_ID = '"+cicloId+"') " + orden;
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatGrupo grupo = new CatGrupo();
				grupo.mapeaReg(rs);
				lisGrupo.add(grupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|listGruposEnCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisGrupo;
	}
	
	public String getGrupos(Connection conn, String escuelaId, String nivelId ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String grupos		= "-";
		
		try{
			comando = "SELECT GRADO||GRUPO AS GRUPOS FROM CAT_GRUPO" +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') ";
			rs = st.executeQuery(comando);
			while (rs.next()){				
				grupos+= rs.getString("GRUPOS")+"-";
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatGrupoLista|getListNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return grupos;
	}
}