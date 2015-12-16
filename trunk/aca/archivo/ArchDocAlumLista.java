package aca.archivo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ArchDocAlumLista {
	
	public ArrayList<ArchDocAlum> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ArchDocAlum> lisArchDocAlum	= new ArrayList<ArchDocAlum>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, FECHA, USUARIO, COMENTARIO FROM ARCH_DOCALUM "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchDocAlum clas = new ArchDocAlum();				
				clas.mapeaReg(rs);
				lisArchDocAlum.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlumLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchDocAlum;
	}
	
	public ArrayList<ArchDocAlum> getListArchDocAlum(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<ArchDocAlum> lisArchDocAlum	= new ArrayList<ArchDocAlum>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, FECHA, USUARIO, COMENTARIO FROM ARCH_DOCALUM WHERE CODIGO_ID = '"+codigoId+"'" +orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchDocAlum clas = new ArchDocAlum();				
				clas.mapeaReg(rs);
				lisArchDocAlum.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlumLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisArchDocAlum;
	}
	
	public static String getNombreDocumento(Connection conn, String documentoid, String escuelaId ) throws SQLException{
		
		String nombre           = "";
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando	        = "";
		
		try{
			comando = "SELECT DOCUMENTO_NOMBRE FROM ARCH_DOCUMENTO WHERE DOCUMENTO_ID = TO_NUMBER('"+documentoid+"', '99') AND ESCUELA_ID = '"+escuelaId+"' ";
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				nombre = rs.getString(1);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlumLista|getNombreReligion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return nombre;
	}	
}