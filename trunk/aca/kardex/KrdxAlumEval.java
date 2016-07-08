/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Elifo
 *
 */
public class KrdxAlumEval {
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String evaluacionId;
	private String nota;
	
	public KrdxAlumEval(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		evaluacionId	= "";
		nota			= "";
	}
	
	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getCicloGrupoId() {
		return cicloGrupoId;
	}

	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}

	public String getCursoId() {
		return cursoId;
	}

	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}

	public String getEvaluacionId() {
		return evaluacionId;
	}

	public void setEvaluacionId(String evaluacionId) {
		this.evaluacionId = evaluacionId;
	}

	public String getNota() {
		return nota;
	}

	public void setNota(String nota) {
		this.nota = nota;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_EVAL" +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, NOTA)" +
					" VALUES(?, ?, ?," +
					" TO_NUMBER(?, '99')," +
					" TO_NUMBER(?, '999.99') )");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			ps.setString(5, nota);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}

	public boolean insertReg(Connection conn, String cursoBase, String decimal ) throws SQLException{
		
		//PreparedStatement ps = null;
		Statement st = conn.createStatement();
		String comando						= "";		
		boolean ok 							= false;
		
		try{
			comando = "INSERT INTO KRDX_ALUM_EVAL(CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, NOTA, FALTA, CONDUCTA, PROMEDIO_ID)"
					+ " SELECT "
					+ " CODIGO_ID, "
					+ " CICLO_GRUPO_ID, "
					+ " '"+cursoBase+"' AS CURSO_ID, "
					+ " EVALUACION_ID,"
					+ " CAST(AVG(NOTA) AS DECIMAL(10,"+decimal+")) AS NOTA,"
					+ " CAST(AVG(FALTA) AS DECIMAL(10, "+decimal+")) AS FALTA,"
					+ " CAST(AVG(CONDUCTA) AS DECIMAL(10, "+decimal+")) AS CONDUCTA, "
					+ " PROMEDIO_ID"
					+ " FROM krdx_alum_eval "
					+ " WHERE CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CURSO_BASE = '"+cursoBase+"')"
					+ " GROUP BY CODIGO_ID, CICLO_GRUPO_ID, EVALUACION_ID, "
					+ " PROMEDIO_ID ORDER BY CODIGO_ID";
			
			
			st.executeUpdate(comando);
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|insertReg|:"+ex);
		}finally{
			st.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_EVAL" +
					" SET NOTA = TO_NUMBER(?, '999.99')" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, nota);
			ps.setString(2, codigoId);			
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);			
			ps.setString(5, evaluacionId);			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA LAS NOTAS DE TODOS LOS ALUMNOS EN UNA EVALUACION
	 * */
	public static boolean deleteNotasEval(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			if ( ps.executeUpdate() >= 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|deleteNotasEval|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA LAS NOTAS DE LAS EVALUACIONES DEL ALUMNO EN UNA MATERIA
	 * */
	public static boolean deleteRegMateria(Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			if ( ps.executeUpdate() >= 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|deleteRegMateria|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA LAS NOTAS DE LAS EVALUACIONES DEL ALUMNO EN TODAS LAS MATERIAS DEL GRUPO
	 * */
	public static boolean deleteRegGrupo(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);			
			
			if ( ps.executeUpdate() >= 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|deleteRegGrupo|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA LAS NOTAS DE LAS EVALUACIONES DE UNA MATERIAS
	 * */
	public static boolean deleteGrupoEval(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			if ( ps.executeUpdate() >= 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|deleteGrupoEval|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		evaluacionId	= rs.getString("EVALUACION_ID");
		nota			= rs.getString("NOTA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID," +
					" CURSO_ID, EVALUACION_ID, NOTA " +
					" FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?"+
					" AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	public boolean existeReg(Connection conn, String cursoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EVAL" +
					" WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	
	
	public static boolean existeReg(Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static int alumNotaEval(Connection conn, String codigoId, String cicloGrupoId, String cursoId, int evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		int nota	 			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(TO_NUMBER(TO_CHAR(NOTA,'999'),'999'),0) AS NOTA FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");	
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setInt(4, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nota = rs.getInt("NOTA");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|alumNotaEval|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nota;
	}
	
	public static String getNotaEval(Connection conn, String codigoId, String cicloGrupoId, String cursoId, int evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nota	 			= "-";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(NOTA,0) AS CAL FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = ?");	
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setInt(4, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nota = rs.getString("CAL");				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|getNotaEval|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nota;
	}
	
	public static String getNotaEval(Connection conn, String codigoId, String cicloGrupoId, String cursoId, int evaluacionId, String decimales, String redondeo) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nota	 			= "-";
		
		try{
			
			if(redondeo.equals("T")){
				ps = conn.prepareStatement("SELECT TRUNC(AVG(NOTA),'"+decimales+"') AS CAL FROM KRDX_ALUM_EVAL" +
						" WHERE CODIGO_ID = ?" +
						" AND CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?" +
						" AND EVALUACION_ID = ?");	
				ps.setString(1, codigoId);
				ps.setString(2, cicloGrupoId);
				ps.setString(3, cursoId);
				ps.setInt(4, evaluacionId);
			}else{
				ps = conn.prepareStatement("SELECT ROUND(AVG(NOTA),'"+decimales+"') AS CAL FROM KRDX_ALUM_EVAL" +
						" WHERE CODIGO_ID = ?" +
						" AND CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?" +
						" AND EVALUACION_ID = ?");	
				ps.setString(1, codigoId);
				ps.setString(2, cicloGrupoId);
				ps.setString(3, cursoId);
				ps.setInt(4, evaluacionId);
			}
			

			
			rs= ps.executeQuery();		
			if(rs.next()){
				nota = rs.getString("CAL");				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|getNotaEval|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nota;
	}
	
	
	public static float alumNotaEvalPuntoDecimal(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		float nota	 			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(TO_NUMBER(TO_CHAR(NOTA,'999'),'999'),0) AS NOTA FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");	
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nota = rs.getInt("NOTA");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|alumNotaEval|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nota;
	}
	
	public static boolean tieneEvaluacionesElAlumno(Connection conn, String codigoId, String cicloGrupoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean tiene			= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CODIGO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tiene = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|tieneEvaluacionesElAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tiene;
	}
	
	public static boolean tieneEvaluaciones(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean tiene			= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tiene = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|tieneEvaluaciones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tiene;
	}
	
	public static boolean tieneEvaluaciones(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean tiene			= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				tiene = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|tieneEvaluaciones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tiene;
	}
	
	public static double calculoPorPromedio(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String codigoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		double promedio			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(SUM(NOTA),0)/COALESCE(COUNT(CODIGO_ID),1) AS PROMEDIO" +
				" FROM KRDX_ALUM_ACTIV" +
				" WHERE CICLO_GRUPO_ID = ?" +
				" AND CURSO_ID = ?" +
				" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
				" AND CODIGO_ID = ?" +
				" AND NOTA != 0");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				promedio = rs.getDouble("PROMEDIO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|calculoPorPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return promedio;
	}
	
	
	public static double calculoPorPromedio(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String codigoId, String decimales, String redondeo) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		double promedio			= 0;
		
		try{
			if(redondeo.equals("TRUNK")){
			ps = conn.prepareStatement("SELECT TRUNC(AVG(NOTA),'"+decimales+"') AS PROMEDIO " +
				" FROM KRDX_ALUM_ACTIV" +
				" WHERE CICLO_GRUPO_ID = ?" +
				" AND CURSO_ID = ?" +
				" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
				" AND CODIGO_ID = ?" +
				" AND NOTA != 0");
			}else{
				ps = conn.prepareStatement("SELECT ROUND(AVG(NOTA),'"+decimales+"') AS PROMEDIO " +
						" FROM KRDX_ALUM_ACTIV" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?" +
						" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
						" AND CODIGO_ID = ?" +
						" AND NOTA != 0");
			}
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				promedio = rs.getDouble("PROMEDIO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|calculoPorPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return promedio;
	}
	
	public static double calculoPorValor(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String codigoId, String escala) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		double promedio			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT SUM(NOTA*B.VALOR)/100 AS PROMEDIO FROM KRDX_ALUM_ACTIV A, CICLO_GRUPO_ACTIVIDAD B"+
				" WHERE A.CICLO_GRUPO_ID = ?"+
				" AND A.CURSO_ID = ?"+
				" AND A.EVALUACION_ID = ?" +
				" AND A.CODIGO_ID = ?"+
				" AND B.CICLO_GRUPO_ID = A.CICLO_GRUPO_ID"+
				" AND B.CURSO_ID = A.CURSO_ID"+
				" AND B.EVALUACION_ID = A.EVALUACION_ID"+
				" AND B.ACTIVIDAD_ID = A.ACTIVIDAD_ID"+
				" AND A.NOTA != 0");			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){				
				promedio = rs.getDouble("PROMEDIO");
				if (escala.equals("10")){
					promedio = promedio / 10;
				}
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEval|calculoPorValor|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return promedio;
	}
	
}
