/**
 * 
 */
package aca.cond;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class CondReporte {
	private String codigoId;
	private String tipoId;
	private String fecha;
	private String comentario;
	private String estado;
	private String folio;
	private String cicloId;
	private String empleadoId;
	private String compromiso;
	
	
	public CondReporte(){
		codigoId	= "";
		tipoId		= "";
		fecha		= "";
		comentario	= "";
		estado		= "";
		folio		= "";
		cicloId		= "";
		empleadoId	= "";
		compromiso 	= "";
	}
	
	
	
	public String getEmpleadoId() {
		return empleadoId;
	}



	public void setEmpleadoId(String empleadoId) {
		this.empleadoId = empleadoId;
	}



	public String getCicloId() {
		return cicloId;
	}





	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}





	public String getCodigoId() {
		return codigoId;
	}




	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}




	public String getComentario() {
		return comentario;
	}




	public void setComentario(String comentario) {
		this.comentario = comentario;
	}




	public String getEstado() {
		return estado;
	}




	public void setEstado(String estado) {
		this.estado = estado;
	}




	public String getFecha() {
		return fecha;
	}




	public void setFecha(String fecha) {
		this.fecha = fecha;
	}




	public String getFolio() {
		return folio;
	}




	public void setFolio(String folio) {
		this.folio = folio;
	}




	public String getTipoId() {
		return tipoId;
	}




	public void setTipoId(String tipoId) {
		this.tipoId = tipoId;
	}

	
	public String getCompromiso() {
		return compromiso;
	}



	public void setCompromiso(String compromiso) {
		this.compromiso = compromiso;
	}



	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO COND_REPORTE (CODIGO_ID, TIPO_ID, " +
					" FECHA, COMENTARIO, ESTADO, FOLIO, CICLO_ID, EMPLEADO_ID, COMPROMISO) " +
					" VALUES(?,TO_NUMBER(?,'9999999'),TO_DATE(?, 'DD/MM/YYYY'),?,?,TO_NUMBER(?,'99999'),?, ?,?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, tipoId);
			ps.setString(3, fecha);
			ps.setString(4, comentario);
			ps.setString(5, estado);
			ps.setString(6, folio);
			ps.setString(7, cicloId);
			ps.setString(8, empleadoId);
			ps.setString(9, compromiso);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}		
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condReporte|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{			
			 ps = conn.prepareStatement("UPDATE COND_REPORTE" +				
					" SET TIPO_ID = TO_NUMBER(?,'9999999')," +
					" FECHA = TO_DATE(?,'DD/MM/YYYY')," +					
					" COMENTARIO  = ?," +
					" ESTADO = ?, " +
					" EMPLEADO_ID = ?,  " +	
					" COMPROMISO = ?  " +	
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?,'99999')");			
			
			ps.setString(1, tipoId);
			ps.setString(2, fecha);
			ps.setString(3, comentario);
			ps.setString(4, estado);
			ps.setString(5, empleadoId);
			ps.setString(6, compromiso);
			ps.setString(7, codigoId);
			ps.setString(8, cicloId);
			ps.setString(9, folio);
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condReporte|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null; 
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM COND_REPORTE WHERE CODIGO_ID = ? " +
					"AND CICLO_ID = ? AND FOLIO = TO_NUMBER(?,'99999')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			ps.setString(3, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condReporte|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{			
			ps = conn.prepareStatement("SELECT * FROM COND_REPORTE " +
					"WHERE CICLO_ID = ? AND FOLIO = TO_NUMBER(?,'99999')");
			ps.setString(1, cicloId);
			ps.setString(2, folio);					
			
			rs= ps.executeQuery();		
		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condReporte|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		tipoId			= rs.getString("TIPO_ID");
		fecha			= rs.getString("FECHA");
		comentario		= rs.getString("COMENTARIO");
		estado			= rs.getString("ESTADO");
		folio			= rs.getString("FOLIO");
		cicloId			= rs.getString("CICLO_ID");
		empleadoId		= rs.getString("EMPLEADO_ID");
		compromiso		= rs.getString("COMPROMISO");
	}
	
	public void mapeaRegId(Connection con) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;	
		try{
			 ps = con.prepareStatement("SELECT CODIGO_ID, TIPO_ID, " +
					" TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, COMENTARIO," +
					" ESTADO, FOLIO, CICLO_ID, EMPLEADO_ID, COMPROMISO " +
					" FROM COND_REPORTE" +
					" WHERE CICLO_ID = ? AND FOLIO = TO_NUMBER(?,'99999')");	
			ps.setString(1, cicloId);
			ps.setString(2, folio);				
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.cond.CondReport|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,'1') AS MAXIMO " +
					"FROM COND_REPORTE");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.cond.CondReporte|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
}
