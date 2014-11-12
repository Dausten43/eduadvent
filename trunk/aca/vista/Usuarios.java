package aca.vista;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Usuarios {
	private String codigoId;
	private String escuelaId;
	private String nombre;
	private String aPaterno;
	private String aMaterno;
	private String genero;	
	private String estado;
	
	public Usuarios(){
		codigoId		= "";
		escuelaId		= "";
		nombre			= "";
		aPaterno		= "";
		aMaterno		= "";
		genero			= "";
		estado			= "";
	}
	

	public String getCodigoId() {
		return codigoId;
	}


	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}


	public String getEscuelaId() {
		return escuelaId;
	}


	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}


	public String getNombre() {
		return nombre;
	}


	public void setNombre(String nombre) {
		this.nombre = nombre;
	}


	public String getaPaterno() {
		return aPaterno;
	}


	public void setaPaterno(String aPaterno) {
		this.aPaterno = aPaterno;
	}


	public String getaMaterno() {
		return aMaterno;
	}


	public void setaMaterno(String aMaterno) {
		this.aMaterno = aMaterno;
	}


	public String getGenero() {
		return genero;
	}


	public void setGenero(String genero) {
		this.genero = genero;
	}


	public String getEstado() {
		return estado;
	}


	public void setEstado(String estado) {
		this.estado = estado;
	}


	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId			= rs.getString("CODIGO_ID");
		escuelaId 			= rs.getString("ESCUELA_ID");
		aPaterno			= rs.getString("APATERNO");
		aMaterno			= rs.getString("AMATERNO");
		nombre				= rs.getString("NOMBRE");
		genero 				= rs.getString("GENERO");
		estado	 			= rs.getString("ESTADO");		
	}
	
	public void mapeaRegId( Connection conn, String codigoId, String escuelaId ) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, " +
					" APATERNO, AMATERNO, GENERO, ESTADO " +
					" FROM USUARIOS WHERE CODIGO_ID = ?  " +
					" AND ESCUELA_ID =  ? " );
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.vista.Usuarios|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps= null;
		
		try{
			ps = conn.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, " +
					" APATERNO, AMATERNO, GENERO, ESTADO " +
					" FROM USUARIOS WHERE CODIGO_ID = ? " +
					" AND ESCUELA_ID = ? ");
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.Usuarios|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public static String getNombreUsuario(Connection conn, String codigoId ) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String nombreCorto	= "";
		
		try{
			comando = "SELECT TRIM(NOMBRE)||' '||TRIM(APATERNO)||' '||TRIM(AMATERNO) AS NOMBRE_USUARIO" +
					" FROM USUARIOS WHERE CODIGO_ID = '"+codigoId+"'";
			
			rs = st.executeQuery(comando);			
			if (rs.next()){				
				nombreCorto = rs.getString("NOMBRE_USUARIO");	
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.Usuarios|getNombreUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return nombreCorto;
	}

}
