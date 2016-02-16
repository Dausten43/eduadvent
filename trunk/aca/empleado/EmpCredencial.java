/**
 * 
 */
package aca.empleado;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 * @author Jose Torres
 *
 */
public class EmpCredencial {
	private String codigoId;
	private String especialidadId;
	private String nivel;
	private String vigenciaIni;
	private String vigenciaFin;
	private String grado;
	
	
	public EmpCredencial(){
		codigoId     	= "";
		especialidadId	= "";
		nivel		    = "";
		vigenciaIni		= "";
		vigenciaFin		= "";
		grado			= "";
	}

	public String getGrado() {
		return grado;
	}

	public void setGrado(String grado) {
		this.grado = grado;
	}

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getEspecialidadId() {
		return especialidadId;
	}

	public void setEspecialidadId(String especialidadId) {
		this.especialidadId = especialidadId;
	}

	public String getNivel() {
		return nivel;
	}

	public void setNivel(String nivel) {
		this.nivel = nivel;
	}

	public String getVigenciaIni() {
		return vigenciaIni;
	}

	public void setVigenciaIni(String vigenciaIni) {
		this.vigenciaIni = vigenciaIni;
	}
	
	public String getVigenciaFin() {
		return vigenciaFin;
	}
	
	public void setVigenciaFin(String vigenciaFin) {
		this.vigenciaFin = vigenciaFin;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO EMP_CREDENCIAL" +
					" (CODIGO_ID, ESPECIALIDAD_ID, NIVEL," +
					" VIGENCIA_INI, VIGENCIA_FIN, GRADO)" +
					" VALUES(?, TO_NUMBER(?, '99'),?," +
					" ?, ?, ?)");
			
			ps.setString( 1, codigoId);
			ps.setString( 2, especialidadId);
			ps.setString( 3, nivel);
			ps.setString( 4, vigenciaIni);
			ps.setString( 5, vigenciaFin);
			ps.setString( 6, grado);
						
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCredencial|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok			 = false;
		try{
			ps = conn.prepareStatement("UPDATE EMP_CREDENCIAL" +
					" SET ESPECIALIDAD_ID = TO_NUMBER(?, '99')," +
					" NIVEL 		= ?," +
					" VIGENCIA_INI 	= ?," +
					" VIGENCIA_FIN	= ?," +
					" GRADO = ? " +
					" WHERE CODIGO_ID = ?");
			
			ps.setString( 1, especialidadId);
			ps.setString( 2, nivel);
			ps.setString( 3, vigenciaIni);
			ps.setString( 4, vigenciaFin);
			ps.setString( 5, grado);
			ps.setString( 6, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCredencial|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok 			 = false;
		
		try{
			ps = conn.prepareStatement("DELETE FROM EMP_CREDENCIAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCredencial|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();			
		}
		
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		especialidadId	= rs.getString("ESPECIALIDAD_ID");
		nivel			= rs.getString("NIVEL");
		vigenciaIni		= rs.getString("VIGENCIA_INI");
		vigenciaFin		= rs.getString("VIGENCIA_FIN");
		grado			= rs.getString("GRADO");
	
	}
	
	public void mapeaRegId(Connection con, String codigoId) throws SQLException{
		PreparedStatement ps =null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, ESPECIALIDAD_ID, NIVEL," +
					" VIGENCIA_INI, VIGENCIA_FIN, GRADO" +
					" FROM EMP_CREDENCIAL" +
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCredencial|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM EMP_CREDENCIAL" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCredencial|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
}
