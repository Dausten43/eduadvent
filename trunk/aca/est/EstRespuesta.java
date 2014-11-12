// Bean de Alum_Foto
package  aca.est;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EstRespuesta{
	private String encuestaId;
	private String escuelaId;
	private String preguntaId;
	private String respuesta;
	private String fecha;
		
	public EstRespuesta(){
		encuestaId			= "";
		escuelaId			= "";
		preguntaId			= "";
		respuesta			= "";
		fecha				= "";
	}		
	
	public String getEncuestaId() {
		return encuestaId;
	}

	public void setEncuestaId(String encuestaId) {
		this.encuestaId = encuestaId;
	}

	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getPreguntaId() {
		return preguntaId;
	}

	public void setPreguntaId(String preguntaId) {
		this.preguntaId = preguntaId;
	}

	public String getRespuesta() {
		return respuesta;
	}

	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public boolean insertReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO EST_RESPUESTA"+ 
				"(ENCUESTA_ID, ESCUELA_ID, PREGUNTA_ID, RESPUESTA, FECHA) "+
				"VALUES( TO_NUMBER(?,'99999'),?,TO_NUMBER(?,'999'), ?, TO_DATE(?, 'DD/MM/YYYY'))");
			
			ps.setString(1, encuestaId);
			ps.setString(2, escuelaId);			
			ps.setString(3, preguntaId);
			ps.setString(4, respuesta);
			ps.setString(5, fecha);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstRespuesta|insertRegByte|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;		
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("UPDATE EST_RESPUESTA "+ 
				" SET RESPUESTA = ?, "+
				" FECHA = TO_DATE(?, 'DD/MM/YYYY')"+
				" WHERE ESCUELA_ID = ? " +
				" AND ENCUESTA_ID = TO_NUMBER(?,'99999') " +
				" AND PREGUNTA_ID = TO_NUMBER(?,'999')");
			
			ps.setString(1, respuesta);
			ps.setString(2, fecha);
			ps.setString(3, escuelaId);
			ps.setString(4, encuestaId);
			ps.setString(5, preguntaId);
			
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;	
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstRespuesta|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		try{
			ps = conn.prepareStatement("DELETE FROM EST_RESPUESTA "+ 
				"WHERE ESCUELA_ID = ? AND ENCUESTA_ID = TO_NUMBER(?,'99999') AND PREGUNTA_ID = TO_NUMBER(?,'999') ");

			ps.setString(1, escuelaId);
			ps.setString(2, encuestaId);
			ps.setString(3, preguntaId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstRespuesta|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		encuestaId				= rs.getString("ENCUESTA_ID");
		escuelaId				= rs.getString("ESCUELA_ID");
		preguntaId				= rs.getString("PREGUNTA_ID");
		fecha					= rs.getString("FECHA");
		respuesta				= rs.getString("RESPUESTA");
	}
	
	
	public void mapeaRegId( Connection conn, String escuelaId, String encuestaId, String preguntaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
		ps = conn.prepareStatement("SELECT "+
			" ENCUESTA_ID, ESCUELA_ID, PREGUNTA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RESPUESTA"+
			" FROM EST_RESPUESTA"+ 
			" WHERE ESCUELA_ID = ? AND ENCUESTA_ID = TO_NUMBER(?,'99999') AND PREGUNTA_ID = TO_NUMBER(?,'999')");
		
		ps.setString(1, escuelaId);
		ps.setString(2, encuestaId);
		ps.setString(3, preguntaId);
		
		rs = ps.executeQuery();
		if (rs.next()){
			mapeaReg(rs);
		}
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstRespuesta|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM EST_RESPUESTA "+ 
				"WHERE ESCUELA_ID = ? AND ENCUESTA_ID = TO_NUMBER(?,'99999') AND PREGUNTA_ID = TO_NUMBER(?,'999')");
			
			ps.setString(1, escuelaId);
			ps.setString(2, encuestaId);
			ps.setString(3, preguntaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstRespuesta|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
}