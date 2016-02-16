/**
 * 
 */
package aca.usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioColor {
	
	private String codigoId;
	private String color;
	
	public UsuarioColor(){
		codigoId	= "";
		color		= "";
	}
	
	
	public String getCodigoId() {
		return codigoId;
	}


	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}


	public String getColor() {
		return color;
	}


	public void setColor(String color) {
		this.color = color;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO USUARIO_COLOR" +
					" (CODIGO_ID, COLOR)" +
					" VALUES(?,?)");
			ps.setString(1, codigoId);
			ps.setString(2, color);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioColor|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE USUARIO_COLOR" +
					" SET COLOR = ?" +
					" WHERE CODIGO_ID = ? ");			
			ps.setString(1, color);
			ps.setString(2, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioColor|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM USUARIO_COLOR" +
					" WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioColor|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		color			= rs.getString("COLOR");
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, COLOR" +
					" FROM USUARIO_COLOR WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioColor|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM USUARIO_COLOR WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioColor|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
}
