package aca.usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioIdioma {
	
	private String codigoId;
	private String idioma;
	
	
	
	public UsuarioIdioma(){
		codigoId		= "";
		idioma		    = "";		
	}
	
	
	public String getCodigoId() {
		return codigoId;
	}


	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}


	public String getIdioma() {
		return idioma;
	}


	public void setIdioma(String idioma) {
		this.idioma = idioma;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO USUARIO_IDIOMA" +
					"(CODIGO_ID, IDIOMA)" +
					" VALUES(?,?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, idioma);		
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioIdioma|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE USUARIO_IDIOMA" +
					" SET IDIOMA = ?" +
					" WHERE CODIGO_ID = ? ");			
			ps.setString(1, idioma);
			ps.setString(2, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioIdioma|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM USUARIO_IDIOMA " +
					"WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioIdioma|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		idioma		    = rs.getString("IDIOMA");		
	}
	
	public void mapeaRegId(Connection con, String codigoId, String idioma) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, IDIOMA" +
					" FROM USUARIO_IDIOMA WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioIdioma|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			//System.out.println("SELECT * FROM USUARIO_MENU WHERE CODIGO_ID = '"+codigoId+"' AND OPCION_ID = TO_NUMBER('"+opcionId+"','999')");
			ps = conn.prepareStatement("SELECT * FROM USUARIO_IDIOMA WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioIdioma|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	

	
}
