package aca.vista;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AlumnoSaldo {
	
	private String codigoId;
	private String escuelaId;
	private String nivelId;
	private String grado;
	private String grupo;
	private String saldo;
	
	public AlumnoSaldo(){
		codigoId	= "";
		escuelaId	= "";
		nivelId		= "";
		grado		= "";
		grupo		= "";
		saldo		= "";	
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




	public String getNivelId() {
		return nivelId;
	}




	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}




	public String getGrado() {
		return grado;
	}




	public void setGrado(String grado) {
		this.grado = grado;
	}




	public String getGrupo() {
		return grupo;
	}




	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}




	public String getSaldo() {
		return saldo;
	}




	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}




	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId	= rs.getString("CODIGO_ID");
		escuelaId	= rs.getString("ESCUELA_ID");
		nivelId		= rs.getString("NIVEL_ID");
		grado		= rs.getString("GRADO");
		grupo		= rs.getString("GRUPO");
		saldo		= rs.getString("SALDO");
	}
	
	public void mapeaRegId( Connection conn, String codigoId, String escuelaId, String nivelId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT"+
				" CODIGO_ID, ESCUELA_ID, NIVEL_ID, GRADO, GRUPO, SALDO" +
				" FROM ALUMNO_SALDO" +
				" WHERE CODIGO_ID = ?"+			
				" AND ESCUELA_ID = ?"+
				" AND NIVEL_ID = ?");
			ps.setString(1, codigoId );
			ps.setString(2, escuelaId);
			ps.setString(3, nivelId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoSaldo|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM ALUMNO_SALDO"+
					" WHERE CODIGO_ID = ?"+			
					" AND ESCUELA_ID = ?"+
					" AND NIVEL_ID = ?");
			ps.setString(1, codigoId );
			ps.setString(2, escuelaId);
			ps.setString(3, nivelId);
						
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoSaldo|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	

}
