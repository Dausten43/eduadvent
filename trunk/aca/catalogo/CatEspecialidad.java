/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatEspecialidad {
	private String especialidadId;
	private String especialidadNombre;
	
	
	public CatEspecialidad(){
		especialidadId			= "";
		especialidadNombre		= "";
		
	}

	
	public String getEspecialidadId() {
		return especialidadId;
	}


	public void setEspecialidadId(String especialidadId) {
		this.especialidadId = especialidadId;
	}


	public String getEspecialidadNombre() {
		return especialidadNombre;
	}


	public void setEspecialidadNombre(String especialidadNombre) {
		this.especialidadNombre = especialidadNombre;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ESPECIALIDAD" +
					" (ESPECIALIDAD_ID, ESPECIALIDAD_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '99'), ?)");
			
			ps.setString(1, especialidadId);
			ps.setString(2, especialidadNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEspecialidad|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_ESPECIALIDAD" +
					" SET ESPECIALIDAD_NOMBRE = ? " +
					" WHERE ESPECIALIDAD_ID = TO_NUMBER(?, '99')");			
			
			ps.setString(1, especialidadNombre);
			ps.setString(2, especialidadId);
						
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEspecialidad|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ESPECIALIDAD" +
					" WHERE ESPECIALIDAD_ID = TO_NUMBER(?, '99')");
			ps.setString(1, especialidadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEspecialidad|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		especialidadId			= rs.getString("ESPECIALIDAD_ID");
		especialidadNombre		= rs.getString("ESPECIALIDAD_NOMBRE");
		
	}
	
	public void mapeaRegId(Connection con, String especialidadId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ESPECIALIDAD_ID, ESPECIALIDAD_NOMBRE " +
					" FROM CAT_ESPECIALIDAD WHERE ESPECIALIDAD_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, especialidadId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEspecialidad|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_ESPECIALIDAD WHERE ESPECIALIDAD_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, especialidadId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEspecialidad|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ESPECIALIDAD_ID)+1,'1') AS MAXIMO FROM CAT_ESPECIALIDAD");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEspecialidad|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getNombre(Connection conn, int especialidadId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "";		
		
		try{
			ps = conn.prepareStatement("SELECT ESPECIALIDAD_NOMBRE"
					+ " FROM CAT_ESPECIALIDAD WHERE ESPECIALIDAD_ID = ?");
			ps.setInt(1, especialidadId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("ESPECIALIDAD_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEspecialidad|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}		
}
