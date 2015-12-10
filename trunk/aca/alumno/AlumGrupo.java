package aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AlumGrupo {
	private String codigoId;
	private String cicloGrupoId;		
	private String orden;

	
	
	public AlumGrupo(){
		codigoId 			= "";
		cicloGrupoId		= "";
		orden				= "";

	}
	
	


	public String getCodigoId() {
		return codigoId;
	}




	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}




	public String getCicloGrupoId() {
		return cicloGrupoId;
	}




	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}




	public String getOrden() {
		return orden;
	}




	public void setOrden(String orden) {
		this.orden = orden;
	}




	public boolean insertReg(Connection conn ) throws Exception{				
		PreparedStatement ps 	= null;
		boolean ok 				= false;		 
		
		try{			
			ps = conn.prepareStatement("INSERT INTO ALUM_GRUPO"+
					" ( CODIGO_ID, CICLO_GRUPO_ID, ORDEN) "+
					" VALUES( ?, ?, TO_NUMBER(?, '999'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, orden);
			
			if (ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumGrupo|insertReg|:"+ex);
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
			ps = conn.prepareStatement("UPDATE ALUM_GRUPO "+
				" SET ORDEN = TO_NUMBER(?, '999'), " +
				" WHERE  CODIGO_ID= ? "+
				" AND CICLO_GRUPO_ID = ? ");		
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(5, orden);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumGrupo|updateReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		try{
			PreparedStatement ps = conn.prepareStatement("DELETE FROM ALUM_GRUPO "+
				"WHERE  CODIGO_ID= ? "+
				"AND CICLO_GRUPO_ID = ? ");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			
			if (ps.executeUpdate()!= -1)
				ok = true;
			else
				ok = false;
			
			if (ps!=null) ps.close();
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumGrupo|deleteReg|:"+ex);
			ex.printStackTrace();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		orden			= rs.getString("ORDEN");
		
	}
	
	public void mapeaRegId( Connection conn, String constanciaId, String cicloGrupoId ) throws SQLException{
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		
		try{
			ps = conn.prepareStatement("SELECT *" +
				" FROM ALUM_GRUPO"+
				" WHERE  CODIGO_ID= ?"+
				" AND CICLO_GRUPO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
		
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumGrupo|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM ALUM_GRUPO "+
				"WHERE  CODIGO_ID= ? "+
				"AND CICLO_GRUPO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumGrupo|existeReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	
	public String maximoReg(Connection conn, String cicloGrupoId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ORDEN)+1,'1') AS MAXIMO " +
					"FROM ALUM_GRUPO ");
			
			ps.setString(1, cicloGrupoId);
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumGrupo|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}

	
}
