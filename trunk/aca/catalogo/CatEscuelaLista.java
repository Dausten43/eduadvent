 	//Clase  para la tabla CAT_ESCUELA
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatEscuelaLista {
	public ArrayList<CatEscuela> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatEscuela> lisCatEscuela 	= new ArrayList<CatEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT" +
					" ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, COALESCE(SECCION_ID,'-') AS SECCION_ID," +
					" UNION_ID,ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO" +
					" FROM CAT_ESCUELA "+orden;
			
			rs = st.executeQuery(comando);	
			while (rs.next()){
				
				CatEscuela escuela = new CatEscuela();
				escuela.mapeaReg(rs);
				lisCatEscuela.add(escuela);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatEscuela;
	}
	
	public HashMap<String,CatEscuela> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatEscuela> map = new HashMap<String,CatEscuela>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT " +
					" ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO, " + 
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID,ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO" +
					" FROM CAT_ESCUELA  "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatEscuela obj = new CatEscuela();
				obj.mapeaReg(rs);
				llave = obj.getEscuelaId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatEscuela> getListNoDelUsuario(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<CatEscuela> lisCatEscuela 	= new ArrayList<CatEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT" +
					" ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID,ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO " +
					" FROM CAT_ESCUELA" +
					" WHERE ESCUELA_ID NOT IN (SELECT ESCUELA_ID FROM USUARIO_ESCUELA WHERE CODIGO_ID = '"+codigoId+"') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEscuela escuela = new CatEscuela();		
				escuela.mapeaReg(rs);
				lisCatEscuela.add(escuela);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListNoDelUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCatEscuela;
	}
	
	public ArrayList<CatEscuela> getListDelUsuario(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<CatEscuela> lisCatEscuela 	= new ArrayList<CatEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		ResultSet rs2 	= null;
		String comando	= "";
		String escuelas = "0";
		
		try{
			comando = "SELECT SUBSTR(ESCUELA,2,LENGTH(ESCUELA)) AS ESC FROM USUARIO WHERE CODIGO_ID = '"+codigoId+"'";
			rs = st.executeQuery(comando);
			if (rs.next()){
				escuelas = rs.getString("ESC");
			}
			String[] escuela = escuelas.split("-");
			escuelas="";
			for(int i=0;i<escuela.length;i++){
				if (i==0){
					escuelas = escuelas +"'"+escuela[i]+"'";
				}else{
					escuelas = escuelas +",'"+escuela[i]+"'";
				}				
			}
			
			comando = "SELECT" +
					" ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID,ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO " +
					" FROM CAT_ESCUELA" +
					" WHERE ESCUELA_ID IN ("+escuelas+") "+orden;
			
			rs2 = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEscuela esc = new CatEscuela();	
				esc.mapeaReg(rs);
				lisCatEscuela.add(esc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListDelUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (rs2!=null) rs2.close();
			if (st!=null) st.close();
		}	
		
		return lisCatEscuela;
	}
	
	public ArrayList<CatEscuela> getListAsociacion(Connection conn, String asociacionId,String orden ) throws SQLException{
		ArrayList<CatEscuela> lisCatEscuela 	= new ArrayList<CatEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT " +
					"ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO, " +
					"PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID, ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO  " +
					"FROM CAT_ESCUELA WHERE ASOCIACION_ID = TO_NUMBER('"+asociacionId+"', '99') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEscuela escuela = new CatEscuela();				
				escuela.mapeaReg(rs);
				lisCatEscuela.add(escuela);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListAsociacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatEscuela;
	}
	
	public ArrayList<CatEscuela> getListAsociacion(Connection conn, String asociacionId,String distritoId, String orden ) throws SQLException{
		ArrayList<CatEscuela> lisCatEscuela 	= new ArrayList<CatEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT " +
					"ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO, " +
					"PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID, ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO  " +
					"FROM CAT_ESCUELA WHERE ASOCIACION_ID = TO_NUMBER"+asociacionId+", '99') AND DISTRITO = '"+distritoId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEscuela escuela = new CatEscuela();				
				escuela.mapeaReg(rs);
				lisCatEscuela.add(escuela);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListAsociacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatEscuela;
	}
	
	public ArrayList<CatEscuela> getListUnion(Connection conn, String unionId, String orden ) throws SQLException{
		ArrayList<CatEscuela> lisCatEscuela 	= new ArrayList<CatEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT " +
					"ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO, " +
					"PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID, LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID, ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO  " +
					"FROM CAT_ESCUELA WHERE UNION_ASOCIACION(ASOCIACION_ID) = "+unionId+" "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEscuela escuela = new CatEscuela();				
				escuela.mapeaReg(rs);
				lisCatEscuela.add(escuela);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListUnion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatEscuela;
	}
	
	public ArrayList<CatEscuela> getListNivel(Connection conn, String nivelId, String orden ) throws SQLException{
		ArrayList<CatEscuela> lisCatEscuela 	= new ArrayList<CatEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT " +
					" ESCUELA_ID, ESCUELA_NOMBRE, NOMBRE_CORTO, PAIS_ID, ESTADO_ID, CIUDAD_ID, COLONIA, DIRECCION, TELEFONO, FAX, ASOCIACION_ID," +
					" LOGO, ESTADO, FIRMA, SECCION_ID, UNION_ID, ORG_ID, DISTRITO, REGION_ID, ESLOGAN, SECTOR, ZONA, BARRIO_ID, WWW, REGISTRO  " +
					" FROM CAT_ESCUELA AS CE" +
					" WHERE ESCUELA_ID IN (SELECT ESCUELA_ID FROM CAT_NIVEL_ESCUELA WHERE NIVEL_ID = "+nivelId+")"+
					" AND ESCUELA_ID IN (SELECT ESCUELA_ID FROM PLAN WHERE ESCUELA_ID = CE.ESCUELA_ID AND NIVEL_ID = "+nivelId+" AND ESTADO = 'A') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEscuela escuela = new CatEscuela();				
				escuela.mapeaReg(rs);
				lisCatEscuela.add(escuela);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuelaLista|getListNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatEscuela;
	}
}