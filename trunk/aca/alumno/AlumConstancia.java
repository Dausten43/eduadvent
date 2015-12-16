package aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AlumConstancia {
	private String constanciaId;
	private String escuelaId;		
	private String constanciaNombre;
	private String constancia;
	private String codigoId;
	
	public AlumConstancia(){
		constanciaId		= "";
		escuelaId			= "";
		constanciaNombre 	= "";
		constancia 			= "";
		codigoId 			= "";
	}
	

	public String getConstanciaId() {
		return constanciaId;
	}

	public void setConstanciaId(String constanciaId) {
		this.constanciaId = constanciaId;
	}

	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getConstanciaNombre() {
		return constanciaNombre;
	}

	public void setConstanciaNombre(String constanciaNombre) {
		this.constanciaNombre = constanciaNombre;
	}

	public String getConstancia() {
		return constancia;
	}

	public void setConstancia(String constancia) {
		this.constancia = constancia;
	}
	
	public String getCodigoId() {
		return codigoId;
	}


	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}


	public boolean insertReg(Connection conn ) throws Exception{				
		PreparedStatement ps 	= null;
		boolean ok 				= false;		 
		
		try{			
			ps = conn.prepareStatement("INSERT INTO ALUM_CONSTANCIA"+
					" (CONSTANCIA_ID, ESCUELA_ID, CONSTANCIA_NOMBRE, CONSTANCIA, CODIGO_ID ) "+
					" VALUES(TO_NUMBER(?, '999'), ?, ?, ?, ? )");
			
			ps.setString(1, constanciaId);
			ps.setString(2, escuelaId);
			ps.setString(3, constanciaNombre);
			ps.setString(4, constancia);
			ps.setString(5, codigoId);
			
			if (ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumConstancia|insertReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_CONSTANCIA "+
				" SET CONSTANCIA_NOMBRE = ?, " +
				" CONSTANCIA = ?, " +
				" CODIGO_ID = ? " +
				" WHERE CONSTANCIA_ID = TO_NUMBER(?, '999') "+
				" AND ESCUELA_ID = ? ");			
			ps.setString(1, constanciaNombre);
			ps.setString(2, constancia);
			ps.setString(3, codigoId);
			ps.setString(4, constanciaId);
			ps.setString(5, escuelaId);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumConstancia|updateReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		try{
			PreparedStatement ps = conn.prepareStatement("DELETE FROM ALUM_CONSTANCIA "+
				"WHERE CONSTANCIA_ID = TO_NUMBER(?, '999') "+
				"AND ESCUELA_ID = ? ");
			ps.setString(1, constanciaId);
			ps.setString(2, escuelaId);
			
			if (ps.executeUpdate()!= -1)
				ok = true;
			else
				ok = false;
			
			if (ps!=null) ps.close();
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumConstancia|deleteReg|:"+ex);
			ex.printStackTrace();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		constanciaId 		= rs.getString("CONSTANCIA_ID");
		escuelaId 			= rs.getString("ESCUELA_ID");
		constanciaNombre	= rs.getString("CONSTANCIA_NOMBRE");
		constancia 	 		= rs.getString("CONSTANCIA");
		codigoId 			= rs.getString("CODIGO_ID");
	}
	
	public void mapeaRegId( Connection conn, String constanciaId, String escuelaId ) throws SQLException{
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUM_CONSTANCIA"
					+ " WHERE CONSTANCIA_ID = TO_NUMBER(?, '999')"
					+ " AND ESCUELA_ID = ?");
			ps.setString(1, constanciaId);
			ps.setString(2, escuelaId);
		
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumConstancia|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;		
		ResultSet 		rs		= null;
		boolean 		ok 		= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUM_CONSTANCIA"
					+ " WHERE CONSTANCIA_ID = TO_NUMBER(?, '999')"
					+ " AND ESCUELA_ID = ?");
			ps.setString(1, constanciaId);
			ps.setString(2, escuelaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumConstancia|existeReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	
	public String maximoReg(Connection conn, String escuelaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(CONSTANCIA_ID)+1,'1') AS MAXIMO " +
					"FROM ALUM_CONSTANCIA WHERE ESCUELA_ID = ? ");
			
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumConstancia|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}

	
}
