// Bean de Alum_Foto
package  aca.est;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EstPregunta{
	private String encuestaId;
	private String preguntaNombre;
	private String preguntaId;
	private String tipo;
		
	public EstPregunta(){
		encuestaId			= "";
		preguntaNombre		= "";
		preguntaId			= "";
		tipo				= "";
	}	
	
	public String getEncuestaId() {
		return encuestaId;
	}

	public void setEncuestaId(String encuestaId) {
		this.encuestaId = encuestaId;
	}

	public String getPreguntaNombre() {
		return preguntaNombre;
	}

	public void setPreguntaNombre(String preguntaNombre) {
		this.preguntaNombre = preguntaNombre;
	}

	public String getPreguntaId() {
		return preguntaId;
	}

	public void setPreguntaId(String preguntaId) {
		this.preguntaId = preguntaId;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public boolean insertRegByte(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO EST_PREGUNTA"+ 
				"(ENCUESTA_ID, PREGUNTA_NOMBRE, PREGUNTA_ID, TIPO) "+
				"VALUES( TO_NUMBER(?,'99999'), ?, TO_NUMBER(?,'999'), ?)");
			ps.setString(1, encuestaId);
			ps.setString(2, preguntaNombre);			
			ps.setString(3, preguntaId);
			ps.setString(4, tipo);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstPregunta|insertRegByte|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;		
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("UPDATE EST_PREGUNTA "+ 
				"SET PREGUNTA_NOMBRE = ?, "+
				"TIPO = ?"+
				"WHERE ENCUESTA_ID = TO_NUMBER(?,'99999') AND PREGUNTA_ID = TO_NUMBER(?,'999')");
			
			ps.setString(1, preguntaNombre);			
			ps.setString(2, tipo);
			ps.setString(3, encuestaId);
			ps.setString(4, preguntaId);
			
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;	
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstPregunta|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		try{
			ps = conn.prepareStatement("DELETE FROM EST_PREGUNTA "+ 
				"WHERE ENCUESTA_ID = TO_NUMBER(?,'99999') AND PREGUNTA_ID = TO_NUMBER(?,'999') ");
			ps.setString(1, encuestaId);
			ps.setString(2, preguntaId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstPregunta|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		encuestaId			= rs.getString("ENCUESTA_ID");
		preguntaNombre		= rs.getString("PREGUNTA_NOMBRE");
		preguntaId			= rs.getString("PREGUNTA_ID");
		tipo				= rs.getString("TIPO");
	}
	
	
	public void mapeaRegId( Connection conn, String encuestaId, String preguntaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
		ps = conn.prepareStatement("SELECT "+
			" ENCUESTA_ID, PREGUNTA_NOMBRE, AS PREGUNTA_ID, TIPO"+
			" FROM EST_PREGUNTA"+ 
			" WHERE ENCUESTA_ID = TO_NUMBER(?,'99999') AND PREGUNTA_ID = TO_NUMBER(?,'999')");
		ps.setString(1, encuestaId);
		ps.setString(2, preguntaId);
		
		rs = ps.executeQuery();
		if (rs.next()){
			mapeaReg(rs);
		}
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstPregunta|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM EST_PREGUNTA "+ 
				"WHERE ENCUESTA_ID = TO_NUMBER(?,'99999') AND PREGUNTA_ID = TO_NUMBER(?,'999')");
			ps.setString(1, encuestaId);
			ps.setString(2, preguntaId);
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstPregunta|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
}