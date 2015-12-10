// Bean de Alum_Foto
package  aca.est;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EstEncuesta{
	private String encuestaId;
	private String encuestaNombre;
	private String fecha;
	private String usuario;
	private String fechaLimite;
	private String uniones;
		
	public EstEncuesta(){
		encuestaId		= "";
		encuestaNombre	= "";
		fecha			= "";
		usuario			= "";
		fechaLimite		= "";
		uniones			= "";
	}	
	
	public String getEncuestaId() {
		return encuestaId;
	}

	public void setEncuestaId(String encuestaId) {
		this.encuestaId = encuestaId;
	}

	public String getEncuestaNombre() {
		return encuestaNombre;
	}

	public void setEncuestaNombre(String encuestaNombre) {
		this.encuestaNombre = encuestaNombre;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	
	public String getFechaLimite() {
		return fechaLimite;
	}

	public void setFechaLimite(String fechaLimite) {
		this.fechaLimite = fechaLimite;
	}

	public String getUniones() {
		return uniones;
	}

	public void setUniones(String uniones) {
		this.uniones = uniones;
	}

	public boolean insertRegByte(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO EST_ENCUESTA"+ 
				"(ENCUESTA_ID, ENCUESTA_NOMBRE, FECHA, USUARIO, FECHA_LIMITE, UNIONES) "+
				"VALUES( TO_NUMBER(?,'99999'),?, TO_DATE(?, 'DD/MM/YYYY'), ?, TO_DATE(?, 'DD/MM/YYYY'), ?)");
			ps.setString(1, encuestaId);
			ps.setString(2, encuestaNombre);			
			ps.setString(3, fecha);
			ps.setString(4, usuario);
			ps.setString(5, fechaLimite);
			ps.setString(6, uniones);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstEncuesta|insertRegByte|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;		
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("UPDATE EST_ENCUESTA "+ 
				"SET ENCUESTA_NOMBRE = ?, "+
				"FECHA = TO_DATE(?, 'DD/MM/YYYY'), "+
				"USUARIO = ?, FECHA_LIMITE = TO_DATE(?, 'DD/MM/YYYY'), UNIONES = ? "+
				"WHERE ENCUESTA_ID = TO_NUMBER(?,'99999')");
			
			ps.setString(1, encuestaNombre);			
			ps.setString(2, fecha);
			ps.setString(3, usuario);
			ps.setString(4, fechaLimite);
			ps.setString(5, uniones);
			ps.setString(6, encuestaId);
			
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;	
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstEncuesta|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		try{
			ps = conn.prepareStatement("DELETE FROM EST_ENCUESTA "+ 
				"WHERE ENCUESTA_ID = TO_NUMBER(?,'99999') ");
			ps.setString(1, encuestaId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstEncuesta|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		encuestaId			= rs.getString("ENCUESTA_ID");
		encuestaNombre		= rs.getString("ENCUESTA_NOMBRE");
		fecha				= rs.getString("FECHA");
		usuario				= rs.getString("USUARIO");
		fechaLimite			= rs.getString("FECHA_LIMITE");
		uniones				= rs.getString("UNIONES");
	}
	
	
	public void mapeaRegId( Connection conn, String encuestaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
		ps = conn.prepareStatement("SELECT "+
			" ENCUESTA_ID, ENCUESTA_NOMBRE, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, USUARIO, FECHA_LIMITE, UNIONES"+
			" FROM EST_ENCUESTA"+ 
			" WHERE ENCUESTA_ID = TO_NUMBER(?,'99999')");
		ps.setString(1, encuestaId);
		
		rs = ps.executeQuery();
		if (rs.next()){
			mapeaReg(rs);
		}
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstEncuesta|mapeaRegId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}

	public boolean existeReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		boolean 		ok 		= false;
		ResultSet 		rs		= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM EST_ENCUESTA "+ 
				"WHERE ENCUESTA_ID = TO_NUMBER(?,'99999')");
			ps.setString(1, encuestaId);
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstEncuesta|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String encuestaId) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String maximo			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT TO_CHAR((MAX(TO_NUMBER(ENCUESTA_ID,'99999')+1))) AS MAXIMO FROM EST_ENCUESTA WHERE ENCUESTA_ID = TO_NUMBER(?, '99999') "  ); 
			ps.setString(1, encuestaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");	
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstEncuesta|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}	
	
	public String maximoReg(Connection conn) throws SQLException{
		String maximo 			= "1";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT MAX(ENCUESTA_ID)+1 MAXIMO FROM EST_ENCUESTA"); 
			//ps.setString(1,  encuestaId);
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");
				if(maximo == null){
					maximo = "1";
				}
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstEncuesta|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;		
	}
}