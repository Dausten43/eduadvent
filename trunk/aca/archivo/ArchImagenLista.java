package aca.archivo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import aca.archivo.ArchImagen;

public class ArchImagenLista {
	
	public ArrayList<ArchImagen> getListAll(Connection conn, String escuelaId, String orden) throws SQLException{
		ArrayList<ArchImagen> lista	= new ArrayList<ArchImagen>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, HOJA, IMAGEN, NOMBRE" +
					" FROM ARCH_IMAGEN WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchImagen clas = new ArchImagen();				
				clas.mapeaReg(rs);
				lista.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagenLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lista;
	}
	
	public HashMap<String,ArchImagen> mapImagenAlumno(Connection conn, String escuelaId, String codigoId, String orden ) throws SQLException{
		
		HashMap<String,ArchImagen> map = new HashMap<String,ArchImagen>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, HOJA, IMAGEN, NOMBRE" +
					" FROM ARCH_IMAGEN" +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND CODIGO_ID = '"+codigoId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				ArchImagen obj = new ArchImagen();
				obj.mapeaReg(rs);
				llave = obj.getDocumentoId()+obj.getHoja();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagenLista|mapImagenAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapNumImagenes(Connection conn, String escuelaId, String codigoId, String orden ) throws SQLException{
		
		HashMap<String,String> map = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";		
		
		try{
			comando = "SELECT DOCUMENTO_ID, COALESCE(COUNT(HOJA),0) AS TOTAL" +
					" FROM ARCH_IMAGEN" +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND CODIGO_ID = '"+codigoId+"'" +
					" GROUP BY DOCUMENTO_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("DOCUMENTO_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagenLista|mapNumImagenes|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}