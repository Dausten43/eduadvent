// Bean de la tabla KRDX_ALUMNO_EVAL
package  aca.vista;
import java.sql.*;

public class AlumEval{
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String evaluacionId;
	private String evaluacionNombre;
	private String fecha;	
	private String nota;
	private String valor;
	private String tipo;
	
	public AlumEval(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		evaluacionId	= "";
		evaluacionNombre= "";
		fecha			= "";
		nota			= "";
		valor			= "";
		tipo			= "";
	}
	
				
	/**
	 * @return Returns the cicloGrupoId.
	 */
	public String getCicloGrupoId() {
		return cicloGrupoId;
	}
	

	/**
	 * @param cicloGrupoId The cicloGrupoId to set.
	 */
	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}


	/**
	 * @return Returns the codigoId.
	 */
	public String getCodigoId() {
		return codigoId;
	}
	

	/**
	 * @param codigoId The codigoId to set.
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}
	

	/**
	 * @return Returns the cursoId.
	 */
	public String getCursoId() {
		return cursoId;
	}
	

	/**
	 * @param cursoId The cursoId to set.
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}
	

	/**
	 * @return Returns the evaluacionId.
	 */
	public String getEvaluacionId() {
		return evaluacionId;
	}
	

	/**
	 * @param evaluacionId The evaluacionId to set.
	 */
	public void setEvaluacionId(String evaluacionId) {
		this.evaluacionId = evaluacionId;
	}


	/**
	 * @return Returns the evaluacionNombre.
	 */
	public String getEvaluacionNombre() {
		return evaluacionNombre;
	}
	

	/**
	 * @param evaluacionNombre The evaluacionNombre to set.
	 */
	public void setEvaluacionNombre(String evaluacionNombre) {
		this.evaluacionNombre = evaluacionNombre;
	}
	

	/**
	 * @return Returns the fecha.
	 */
	public String getFecha() {
		return fecha;
	}
	

	/**
	 * @param fecha The fecha to set.
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	

	/**
	 * @return Returns the nota.
	 */
	public String getNota() {
		return nota;
	}
	

	/**
	 * @param nota The nota to set.
	 */
	public void setNota(String nota) {
		this.nota = nota;
	}
	

	/**
	 * @return Returns the tipo.
	 */
	public String getTipo() {
		return tipo;
	}
	

	/**
	 * @param tipo The tipo to set.
	 */
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	

	/**
	 * @return Returns the valor.
	 */
	public String getValor() {
		return valor;
	}
	

	/**
	 * @param valor The valor to set.
	 */
	public void setValor(String valor) {
		this.valor = valor;
	}
	

	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId			= rs.getString("CODIGO_ID");
		cicloGrupoId 		= rs.getString("CICLO_GRUPO_ID");
		cursoId				= rs.getString("CURSO_ID");
		evaluacionId		= rs.getString("EVALUACION_ID");
		evaluacionNombre	= rs.getString("EVALUACION_NOMBRE");
		fecha 				= rs.getString("FECHA");
		nota	 			= rs.getString("NOTA");		
		valor 				= rs.getString("VALOR");
		tipo 				= rs.getString("TIPO");
	}
	
	public void mapeaRegId( Connection conn, String codigoId, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT "+
				"A.CODIGO_ID, " +
				"A.CICLO_GRUPO_ID, " +
				"A.CURSO_ID, " +
				"A.EVALUACION_ID, " +
				"B.EVALUACION_NOMBRE, " +
				"TO_CHAR(B.FECHA,'DD/MM/YYYY') AS FECHA, " +
				"A.NOTA, " +
				"B.VALOR, " +
				"B.TIPO "+
				"FROM KRDX_ALUM_EVAL A, CICLO_GRUPO_EVAL B " +
				"WHERE A.CODIGO_ID = ? "+
				"AND A.CICLO_GRUPO_ID = ? "+
				"AND A.CURSO_ID = ? "+
				"AND A.EVALUACION_ID = TO_NUMBER(?,'99')" +
				"AND B.CICLO_GRUPO_ID||B.CURSO_ID = A.CICLO_GRUPO_ID||A.CURSO_ID " +
				"AND B.EVALUACION_ID = A.EVALUACION_ID");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumEval|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT "+
				"A.CODIGO_ID, " +
				"A.CICLO_GRUPO_ID, " +
				"A.CURSO_ID, " +
				"A.EVALUACION_ID, " +
				"B.EVALUACION_NOMBRE, " +
				"TO_CHAR(B.FECHA,'DD/MM/YYYY') AS FECHA, " +
				"A.NOTA " +
				"B.VALOR, " +
				"B.TIPO "+
				"FROM KRDX_ALUM_EVAL A, CICLO_GRUPO_EVAL B "+
				"WHERE A.CODIGO_ID = ? "+
				"AND A.CICLO_GRUPO_ID = ? "+
				"AND A.CURSO_ID = ? "+
				"AND A.EVALUACION_ID = TO_NUMBER(?,'99')" +
				"AND B.CICLO_GRUPO_ID||B.CURSO_ID = A.CICLO_GRUPO_ID||A.CURSO_ID " +
				"AND B.EVALUACION_ID = A.EVALUACION_ID");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumEval|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public static String getAlumPromCurso(Connection Conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String dev 			= "";
		double evaluacion 	= 0;
		try{
			//comando = "SELECT TO_CHAR(FLOOR(ROUND(((SUM(DECODE(TIPO, 'P', NOTA, (VALOR*NOTA/100)))*100)/SUM(VALOR))+0.5,2)),'999.99') AS PROMEDIO "+			
			
			// CALCULA EL PROMEDIO DEL ALUMNO, SIN CONSIDERAR PUNTOS EXTRAS  
			comando = "SELECT " +
					"((SUM(" +
							" CASE B.TIPO WHEN 'P' THEN A.NOTA ELSE (B.VALOR*A.NOTA/100) END" +
						 ")*100)/" +
						 " CASE TRUNC((SUM(B.VALOR)-1)/100) WHEN 0 THEN SUM(B.VALOR) ELSE 100 END" +
					") * 0.10 AS PROMEDIO "+
				"FROM KRDX_ALUM_EVAL A, CICLO_GRUPO_EVAL B "+
				"WHERE A.CODIGO_ID = '"+codigoId+"' "+
				"AND A.CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+
				"AND A.CURSO_ID = '"+cursoId+"' "+				
				"AND B.CICLO_GRUPO_ID||B.CURSO_ID = A.CICLO_GRUPO_ID||A.CURSO_ID " +
				"AND B.EVALUACION_ID = A.EVALUACION_ID "+				
				"AND B.TIPO != 'E' " +
				"AND A.NOTA != 0";	
			rs = st.executeQuery(comando);
			if (rs.next()){
				evaluacion = rs.getDouble("PROMEDIO");
				double pextra = 0; 
		
				// CALCULA LOS PUNTOS EXTRAS DEL ALUMNO
				comando = "SELECT SUM(A.NOTA) AS PEXTRA " +
					"FROM KRDX_ALUM_EVAL A, CICLO_GRUPO_EVAL B "+
					"WHERE A.CODIGO_ID = '"+codigoId+"' "+
					"AND A.CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+
					"AND A.CURSO_ID = '"+cursoId+"' "+				
					"AND B.CICLO_GRUPO_ID||B.CURSO_ID = A.CICLO_GRUPO_ID||A.CURSO_ID " +
					"AND B.EVALUACION_ID = A.EVALUACION_ID "+
					"AND TIPO = 'E'";
				rs = st.executeQuery(comando);
				if (rs.next()) pextra = rs.getDouble("PEXTRA");				
				evaluacion += pextra;
				if (evaluacion>10)	evaluacion = 10;
				
				// Elimina el redondeo tomando un digito decimal después del punto.
				dev = String.valueOf(evaluacion);
				dev = dev.substring(0,dev.indexOf(".")+2);				
/*				
				comando = "SELECT TO_CHAR("+evaluacion+",'99.9') FROM CAT_NIVEL WHERE NIVEL_ID=1";
				rs = st.executeQuery(comando);
				if (rs.next()) dev = rs.getString(1);
*/								
			}				
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumEval|getAlumnoPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return dev;
	}
	
}