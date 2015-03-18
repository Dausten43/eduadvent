// Bean de la VISTA ALUMNO_PROM
package  aca.vista;
import java.sql.*;

public class AlumnoProm{
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String promedio;
	private String puntosEval;
	private String puntosAlum;
	private String puntosAjuste;
	
	public AlumnoProm(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		promedio		= "";
		puntosEval		= "";
		puntosAlum		= "";	
		puntosAjuste	= "";
	}
	
	
	/**
	 * @return the puntosAjuste
	 */
	public String getPuntosAjuste() {
		return puntosAjuste;
	}
	
	/**
	 * @param puntosAjuste the puntosAjuste to set
	 */
	public void setPuntosAjuste(String puntosAjuste) {
		this.puntosAjuste = puntosAjuste;
	}

	/**
	 * @return the codigoId
	 */
	public String getCodigoId() {
		return codigoId;
	}

	/**
	 * @param codigoId the codigoId to set
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}


	/**
	 * @return the cicloGrupoId
	 */
	public String getCicloGrupoId() {
		return cicloGrupoId;
	}


	/**
	 * @param cicloGrupoId the cicloGrupoId to set
	 */
	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}


	/**
	 * @return the cursoId
	 */
	public String getCursoId() {
		return cursoId;
	}


	/**
	 * @param cursoId the cursoId to set
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}


	/**
	 * @return the promedio
	 */
	public String getPromedio() {
		return promedio;
	}


	/**
	 * @param promedio the promedio to set
	 */
	public void setPromedio(String promedio) {
		this.promedio = promedio;
	}


	/**
	 * @return the puntosEval
	 */
	public String getPuntosEval() {
		return puntosEval;
	}


	/**
	 * @param puntosEval the puntosEval to set
	 */
	public void setPuntosEval(String puntosEval) {
		this.puntosEval = puntosEval;
	}


	/**
	 * @return the puntosAlum
	 */
	public String getPuntosAlum() {
		return puntosAlum;
	}

	/**
	 * @param puntosAlum the puntosAlum to set
	 */
	public void setPuntosAlum(String puntosAlum) {
		this.puntosAlum = puntosAlum;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId			= rs.getString("CODIGO_ID");
		cicloGrupoId		= rs.getString("CICLO_GRUPO_ID");
		cursoId				= rs.getString("CURSO_ID");
		promedio			= rs.getString("PROMEDIO");
		puntosEval			= rs.getString("PUNTOS_EVAL");
		puntosAlum			= rs.getString("PUNTOS_ALUM");
		puntosAjuste	    = rs.getString("PUNTOS_AJUSTE");
	}
	
	public void mapeaRegId( Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT"+
				" CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO, PUNTOS_EVAL, PUNTOS_ALUM, PUNTOS_AJUSTE" +
				" FROM ALUMNO_PROM" +
				" WHERE CODIGO_ID = ?"+			
				" AND CICLO_GRUPO_ID = ?"+
				" AND CURSO_ID = ?");
			ps.setString(1, codigoId );
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoProm|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUMNO_PROM"+
					" WHERE CODIGO_ID = ?"+			
					" AND CICLO_GRUPO_ID = ?"+
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId );
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
						
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoProm|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
}