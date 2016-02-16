package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CicloBloqueActividad {
	private String cicloId;
	private String bloqueId;
	private String actividadId;
	private String actividadNombre;
	private String fecha;
	private String valor;
	private String tipoactId;
	private String etiquetaId;
	
	public CicloBloqueActividad(){
		cicloId			= "";
		bloqueId		= "";
		actividadId		= "";
		actividadNombre	= "";
		fecha			= "";
		valor			= "";
		tipoactId		= "";
		etiquetaId		= "";
	}
	
	
	public String getCicloId() {
		return cicloId;
	}

	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}

	public String getBloqueId() {
		return bloqueId;
	}

	public void setBloqueId(String bloqueId) {
		this.bloqueId = bloqueId;
	}

	public String getActividadId() {
		return actividadId;
	}

	public void setActividadId(String actividadId) {
		this.actividadId = actividadId;
	}

	public String getActividadNombre() {
		return actividadNombre;
	}

	public void setActividadNombre(String actividadNombre) {
		this.actividadNombre = actividadNombre;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

	public String getTipoactId() {
		return tipoactId;
	}

	public void setTipoactId(String tipoactId) {
		this.tipoactId = tipoactId;
	}

	public String getEtiquetaId() {
		return etiquetaId;
	}

	public void setEtiquetaId(String etiquetaId) {
		this.etiquetaId = etiquetaId;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_BLOQUE_ACTIVIDAD" +
					" (CICLO_ID, BLOQUE_ID, ACTIVIDAD_ID, ACTIVIDAD_NOMBRE, FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID)" +
					" VALUES(?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99')," +
					" ?, TO_DATE(?, 'DD/MM/YYYY'), TO_NUMBER(?, '999.99'),TO_NUMBER(?, '99'), TO_NUMBER(?, '999'))");
			
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			ps.setString(3, actividadId);
			ps.setString(4, actividadNombre);
			ps.setString(5, fecha);
			ps.setString(6, valor);
			ps.setString(7, tipoactId);
			ps.setString(8, etiquetaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_BLOQUE_ACTIVIDAD" +
					" SET ACTIVIDAD_NOMBRE = ?," +
					" FECHA = TO_DATE(?, 'DD/MM/YYYY')," +
					" VALOR = TO_NUMBER(?, '999.99'), TIPOACT_ID = TO_NUMBER(?, '99'), ETIQUETA_ID = TO_NUMBER(?, '999') " +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99') AND ACTIVIDAD_ID = TO_NUMBER(?, '99') ");			
			ps.setString(1, actividadNombre);
			ps.setString(2, fecha);
			ps.setString(3, valor);
			ps.setString(4, tipoactId);
			ps.setString(5, etiquetaId);
			ps.setString(6, cicloId);
			ps.setString(7, bloqueId);
			ps.setString(8, actividadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_BLOQUE_ACTIVIDAD" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99') AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			ps.setString(3, actividadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloId			= rs.getString("CICLO_ID");
		bloqueId		= rs.getString("BLOQUE_ID");
		actividadId		= rs.getString("ACTIVIDAD_ID");
		actividadNombre	= rs.getString("ACTIVIDAD_NOMBRE");
		fecha			= rs.getString("FECHA");
		valor			= rs.getString("VALOR");
		tipoactId		= rs.getString("TIPOACT_ID");
		etiquetaId		= rs.getString("ETIQUETA_ID");
	}
	
	public void mapeaRegId(Connection con, String cicloId, String bloqueId, String actividadId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CICLO_ID, BLOQUE_ID, ACTIVIDAD_ID," +
					" ACTIVIDAD_NOMBRE, " +
					" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID " +
					" FROM CICLO_BLOQUE_ACTIVIDAD" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99') AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			ps.setString(3, actividadId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_BLOQUE_ACTIVIDAD" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99') AND ACTIVIDAD_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			ps.setString(3, actividadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public static boolean existeActividades(Connection conn, String cicloId, String bloqueId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_BLOQUE_ACTIVIDAD" +
					" WHERE CICLO_ID = ?" +
					" AND BLOQUE_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|existeActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String cicloId, String bloqueId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ACTIVIDAD_ID)+1, '1') AS MAXIMO FROM CICLO_BLOQUE_ACTIVIDAD" +
					" WHERE CICLO_ID = ? AND BLOQUE_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, bloqueId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return maximo;
	}
	
}
