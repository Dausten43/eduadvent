package aca.vista;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

// 
public class UsuariosLista {
	public ArrayList<Usuarios> getListUsuarios(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<Usuarios> lisUsuarios 	= new ArrayList<Usuarios>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, " +
					" GENERO, ESTADO FROM USUARIOS WHERE ESCUELA_ID = '"+escuelaId+"' "+ orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Usuarios usuario = new Usuarios();				
				usuario.mapeaReg(rs);
				lisUsuarios.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.UsuariosLista|getListUsuarios|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisUsuarios;
	}
	
	public static String getNombreCorto(Connection conn, String codigoId ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String nombreCorto	= "";
		
		try{
			comando = "SELECT TRIM(SUBSTR(NOMBRE,1, (CASE POSITION(' ' IN NOMBRE) WHEN 0 THEN LENGTH(NOMBRE) ELSE POSITION(' ' IN NOMBRE) END)  ))||' '||TRIM(APATERNO) AS NOMBRE_CORTO" +
					" FROM USUARIOS WHERE CODIGO_ID = '"+codigoId+"'";
			
			rs = st.executeQuery(comando);			
			if (rs.next()){				
				nombreCorto = rs.getString("NOMBRE_CORTO");	
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.UsuariosLista|getNombreCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return nombreCorto;
	}
	
	public ArrayList<Usuarios> getListBusqueda(Connection conn, String escuelaId, String nombreCompleto,String orden ) throws SQLException{
		ArrayList<Usuarios> lisUsuarios 	= new ArrayList<Usuarios>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, GENERO, ESTADO" +
					" FROM USUARIOS WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND UPPER(NOMBRE)||' '||UPPER(APATERNO)||' '||UPPER(AMATERNO) LIKE '%"+nombreCompleto.toUpperCase()+"%'"+ orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Usuarios usuario = new Usuarios();				
				usuario.mapeaReg(rs);
				lisUsuarios.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.UsuariosLista|getListBusqueda|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisUsuarios;
	}

}
