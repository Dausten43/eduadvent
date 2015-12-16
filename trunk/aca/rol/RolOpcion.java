package aca.rol;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RolOpcion {	
	private String rolId;
	private String opcionId;
		
	public RolOpcion(){		
		rolId 		= "0";
		opcionId	= " ";
	}
	
	/**
	 * @return the rolId
	 */
	public String getRolId() {
		return rolId;
	}

	/**
	 * @param rolId the rolId to set
	 */
	public void setRolId(String rolId) {
		this.rolId = rolId;
	}

	/**
	 * @return the opcionId
	 */
	public String getopcionId() {
		return opcionId;
	}

	/**
	 * @param opcionId the opcionId to set
	 */
	public void setopcionId(String opcionId) {
		this.opcionId = opcionId;
	}

	public boolean insertReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO ROL_OPCION( ROL_ID, OPCION_ID)"
					+ " VALUES(TO_NUMBER(?, '999'), TO_NUMBER(?, '999')) ");
			ps.setString(1, rolId);
			ps.setString(2, opcionId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpcion|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ROL_OPCION "+ 
				" SET ROL_OPCION = TO_NUMBER(?, '999') "+
				"WHERE ROL_ID = TO_NUMBER(?, '999') ");
			ps.setString(1, opcionId);			
			ps.setString(2, rolId);
			
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpcion|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ROL_OPCION "+ 
				"WHERE ROL_ID = TO_NUMBER(?, '999') ");			
			ps.setString(1, rolId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpcion|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		rolId 		= rs.getString("ROL_ID");
		opcionId	= rs.getString("OPCION_ID");
	}
	
	public void mapeaRegId( Connection conn) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT ROL_ID, OPCION_ID FROM ROL_OPCION"
					+ " WHERE ROL_ID = TO_NUMBER(?, '999') ");
			ps.setString(1,rolId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpcion|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 		ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ROL_OPCION WHERE ROL_ID = TO_NUMBER(?, '999') AND OPCION_ID = TO_NUMBER(?, '999')");			
			ps.setString(1,rolId);
			ps.setString(2,opcionId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.rolOpcion.RolOpcion|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String paisId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ROL_ID)+1,'1') AS MAXIMO FROM ROL_OPCION");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.rol.RolOpcion|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
}