/**
 * 
 */
package aca.empleado;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres E.
 *
 */
public class EmpTipo {
	
	private String tipoId;
	private String tipoNombre;
	
	public EmpTipo(){
		tipoId		= "";
		tipoNombre	= "";
	}

	/**
	 * @return Returns the tipoId.
	 */
	public String getTipoId() {
		return tipoId;
	}
	

	/**
	 * @param tipoId The tipoId to set.
	 */
	public void setTipoId(String tipoId) {
		this.tipoId = tipoId;
	}
	

	/**
	 * @return Returns the tipoNombre.
	 */
	public String getTipoNombre() {
		return tipoNombre;
	}
	

	/**
	 * @param tipoNombre The tipoNombre to set.
	 */
	public void setTipoNombre(String tipoNombre) {
		this.tipoNombre = tipoNombre;
	}
	
	
	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO EMP_TIPO" +
					" (TIPO_ID, TIPO_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '99'),?)");
			ps.setString(1, tipoId);
			ps.setString(2, tipoNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpTipo|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps =null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE EMP_TIPO" +
					" SET TIPO_NOMBRE = ?" +
					" WHERE TIPO_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, tipoNombre);
			ps.setString(2, tipoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpTipo|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps =null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM EMP_TIPO" +
					" WHERE TIPO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, tipoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpTipo|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		tipoId		= rs.getString("TIPO_ID");
		tipoNombre	= rs.getString("TIPO_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String tipoId) throws SQLException{
		PreparedStatement ps =null;
		ResultSet rs = null;	
		try{
			ps = con.prepareStatement("SELECT TIPO_ID, TIPO_NOMBRE" +
					" FROM EMP_TIPO WHERE TIPO_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, tipoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpTipo|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM EMP_TIPO WHERE TIPO_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, tipoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpTipo|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
}
