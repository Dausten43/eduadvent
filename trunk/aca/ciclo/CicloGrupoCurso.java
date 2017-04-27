/**
 * 
 */
package aca.ciclo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Jose Torres
 *
 */
public class CicloGrupoCurso {
	private String cicloGrupoId;
	

	private String cursoId;
	private String empleadoId;
	private String horario;
	private String salonId;
	private String estado;
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "CicloGrupoCurso [cicloGrupoId=" + cicloGrupoId + ", cursoId=" + cursoId + ", empleadoId=" + empleadoId
				+ ", horario=" + horario + ", salonId=" + salonId + ", estado=" + estado + "]";
	}
	
	public CicloGrupoCurso(){
		cicloGrupoId	= "";
		cursoId			= "";
		empleadoId		= "";
		horario			= "";
		salonId			= "";
		estado 			= "1";
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
	 * @return Returns the empleadoId.
	 */
	public String getEmpleadoId() {
		return empleadoId;
	}
	

	/**
	 * @param empleadoId The empleadoId to set.
	 */
	public void setEmpleadoId(String empleadoId) {
		this.empleadoId = empleadoId;
	}
	

	/**
	 * @return Returns the horario.
	 */
	public String getHorario() {
		return horario;
	}
	

	/**
	 * @param horario The horario to set.
	 */
	public void setHorario(String horario) {
		this.horario = horario;
	}
	

	/**
	 * @return Returns the salonId.
	 */
	public String getSalonId() {
		return salonId;
	}
	

	/**
	 * @param salonId The salonId to set.
	 */
	public void setSalonId(String salonId) {
		this.salonId = salonId;
	}
	
		
	/**
	 * @return Returns the estado.
	 */
	public String getEstado() {
		return estado;
	}
	

	/**
	 * @param estado The estado to set.
	 */
	public void setEstado(String estado) {
		this.estado = estado;
	}
	

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
 		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_CURSO" +
					" (CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO)" +
					" VALUES(?, ?, ?, ?, TO_NUMBER(?, '99'), ?)");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, empleadoId);
			ps.setString(4, horario);
			ps.setString(5, salonId);
			ps.setString(6, estado);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;		
		boolean ok = false;		
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO_CURSO" +
					" SET EMPLEADO_ID = ?," +
					" HORARIO = ?," +
					" SALON_ID = TO_NUMBER(?, '99')," +
					" ESTADO = ?" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, empleadoId);
			ps.setString(2, horario);
			ps.setString(3, salonId);
			ps.setString(4, estado);
			ps.setString(5, cicloGrupoId);
			ps.setString(6, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps 	= null;
		PreparedStatement ps2	= null;
		ResultSet rs			= null;
		boolean delAct			= false;
		boolean delEval			= false;
		boolean ok 				= false;
		int numEval 			= 0;
		int numAct 				= 0;
		try{
			
			/* ========== ACTIVIDADES ========== */
			
			ps2 = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS NUM_ACT FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps2.setString(1, cicloGrupoId);
			ps2.setString(2, cursoId);
			rs =  ps2.executeQuery();
			if (rs.next()){
				numAct = rs.getInt("NUM_ACT");
			}
			
			// Cierra objetos
			if (ps2!=null) ps2.close();
			if (rs!=null) rs.close();
			
			if (numAct > 0){				
				ps2 = conn.prepareStatement("DELETE FROM CICLO_GRUPO_ACTIVIDAD" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?");				
				ps2.setString(1, cicloGrupoId);
				ps2.setString(2, cursoId);
				if(ps2.executeUpdate()>= 1){					
					delAct = true;
				}
			}else{
				delAct = true;
			}
			
			// Cierra objetos
			if (ps2!=null) ps2.close();
			
			/* ========== EVALUACIONES ========== */
			
			ps2 = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS NUM_EVAL FROM CICLO_GRUPO_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps2.setString(1, cicloGrupoId);
			ps2.setString(2, cursoId);
			rs =  ps2.executeQuery();
			if (rs.next()){
				numEval = rs.getInt("NUM_EVAL");
			}
			
			// Cierra los objetos
			if (ps2!=null) ps2.close();
			if (rs!=null) rs.close();
			
			if (numEval > 0){				
				ps2 = conn.prepareStatement("DELETE FROM CICLO_GRUPO_EVAL" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?");				
				ps2.setString(1, cicloGrupoId);
				ps2.setString(2, cursoId);
				if(ps2.executeUpdate()>= 1){					
					delEval = true;
				}
			}else{
				delEval = true;
			}
			
			/* ========== GRUPO ========== */
			
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			if ( ps.executeUpdate()== 1 && delEval && delAct){				
					ok = true;
			}else{
										
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
			if (ps2!=null) ps2.close();
			if (rs!=null) rs.close();
		}
		
		return ok;
	}
	
	public boolean deleteAllReg(Connection conn, String cicloGrupoId ) throws SQLException{
		PreparedStatement ps 	= null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|deleteAllReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		empleadoId		= rs.getString("EMPLEADO_ID");
		horario			= rs.getString("HORARIO");
		salonId			= rs.getString("SALON_ID");
		estado			= rs.getString("ESTADO");
	}
	
	public void mapeaRegId(Connection con, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID," +
					" HORARIO, SALON_ID, ESTADO" +
					" FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|existeReg|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean existeRegCursoId(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_CURSO" +
					" WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|existeRegCursoId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean existeMaestro(Connection conn, String empleadoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_CURSO" +
					" WHERE EMPLEADO_ID = ?");
			ps.setString(1, empleadoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|existeMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean conAlumnos(Connection conn ) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 			rs	= null;
		PreparedStatement	ps= null;
		
		try{
			ps = conn.prepareStatement("SELECT CICLO_GRUPO_ID "+ 
				"FROM KRDX_CURSO_ACT "+ 
				"WHERE CICLO_GRUPO_ID = ? "+
				"AND TIPOCAL_ID IN (1,2,3,4,5,6)");
			ps.setString(1, cicloGrupoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|conAlumnos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	public static boolean esMaestroPorHoras(Connection conn, String empleadoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID NOT IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO" +
												 " WHERE EMPLEADO_ID = ?)" +
					" AND EMPLEADO_ID = ?");
			ps.setString(1, empleadoId);
			ps.setString(2, empleadoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|esMaestroPorHoras|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public static String getMaestro(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
			
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maestro 			= "";
		
		try{
			ps = conn.prepareStatement("SELECT EMPLEADO_ID FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maestro = rs.getString("EMPLEADO_ID");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|getMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maestro;
	}
	
	public static boolean daEsteCurso(Connection conn, String cicloGrupoId, String cursoId, String empleadoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND EMPLEADO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, empleadoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|daEsteCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static int numCursosGrupo(Connection conn, String cicloGrupoId) throws SQLException{
		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		int  numCursos 			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				numCursos = rs.getInt(1);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numCursosGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numCursos;
	}
	
	public static int numCursosMaestro(Connection conn, String cicloId, String empleadoId) throws SQLException{
		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		int  numCursos 			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) FROM CICLO_GRUPO_CURSO" +
					" WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = ?" +
					" AND EMPLEADO_ID = ?");
			ps.setString(1, cicloId);
			ps.setString(2, empleadoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				numCursos = rs.getInt(1);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numCursosMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numCursos;
	}
	
	public static int numCursosMaestroxNivel(Connection conn, String empleadoId, String cicloId, String nivelId) throws SQLException{
		
		int numCursos = 0;
		Statement st  = conn.createStatement();
		ResultSet rs  = null;
		String comando	= "";
		
		try{
			comando = "SELECT COUNT(CURSO_ID) FROM CICLO_GRUPO_CURSO A" +
					" WHERE EMPLEADO_ID = '"+empleadoId+"' AND CICLO_GRUPO_ID IN " +
					"(SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO " +
					"  WHERE CICLO_GRUPO_ID = A.CICLO_GRUPO_ID AND CICLO_ID = '"+cicloId+"' AND NIVEL_ID= '"+nivelId+"' )";
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				numCursos = rs.getInt(1);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numCursosMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return numCursos;
	}
	
	public static int numCursosEvaluados(Connection conn, String cicloId, String empleadoId, int evaluacionId) throws SQLException{
		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		int  numCursos 			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) FROM CICLO_GRUPO_CURSO" +
					" WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = ? " +
					" AND EMPLEADO_ID = ?" +
					" AND CICLO_GRUPO_ID||CURSO_ID IN " +
					"  (SELECT CICLO_GRUPO_ID||CURSO_ID FROM CICLO_GRUPO_EVAL " +
					"  WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = ? AND EVALUACION_ID = ? " +
					"  AND ESTADO = 'C')");
			ps.setString(1, cicloId);
			ps.setString(2, empleadoId);
			ps.setString(3, cicloId);
			ps.setInt(4, evaluacionId);
			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				numCursos = rs.getInt(1);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numCursosEvaluados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numCursos;
	}
	
	public int numCursosEvaluadosPorNivel(Connection conn, String cicloId, String empleadoId, int evaluacionId, String nivelId) throws SQLException{
		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		int  numCursos 			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) FROM CICLO_GRUPO_CURSO" +
					" WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = ? " +
					" 	AND EMPLEADO_ID = ?" +
					" 	AND CICLO_GRUPO_ID||CURSO_ID IN " +
					"  		(SELECT CICLO_GRUPO_ID||CURSO_ID FROM CICLO_GRUPO_EVAL " +
					"  			WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = ? AND EVALUACION_ID = ? " +
					"  			AND ESTADO = 'C')" +
					" 	AND CICLO_GRUPO_ID IN" +
					"		(SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO" +
					"			WHERE CICLO_GRUPO_ID = CICLO_GRUPO_CURSO.CICLO_GRUPO_ID " +
					" 			AND CICLO_ID = '"+cicloId+"' AND NIVEL_ID= '"+nivelId+"')");
			ps.setString(1, cicloId);
			ps.setString(2, empleadoId);
			ps.setString(3, cicloId);
			ps.setInt(4, evaluacionId);
			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				numCursos = rs.getInt(1);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numCursosEvaluados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numCursos;
	}
	
	public static boolean esCursosEvaluado(Connection conn, String cicloGrupoId, String cursoId, int evaluacionId) throws SQLException{
		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		boolean  ok 			= false;
		
		try{
			ps = conn.prepareStatement("SELECT CURSO_ID FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ? " +
					" AND CURSO_ID = ?" +
					" AND CICLO_GRUPO_ID||CURSO_ID IN " +
					"	(SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_ALUM_EVAL WHERE EVALUACION_ID = ?)");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setInt(3, evaluacionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|esCursosEvaluado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public static boolean hayAbiertas(Connection conn, String cicloGrupoId) throws SQLException{
		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		boolean  ok 			= false;
		
		try{
			ps = conn.prepareStatement("SELECT CURSO_ID FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ? " +
					" AND ESTADO IN ('1','2')");
			ps.setString(1, cicloGrupoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|hayAbiertas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String getEstado(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String estado			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT ESTADO FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID = ? " +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				estado = rs.getString("ESTADO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|getEstado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return estado;
	}
	
	public static int numMatCiclo(Connection conn, String cicloId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int numMaterias 		= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS MATERIAS " +
				" FROM CICLO_GRUPO_CURSO"+
				" WHERE CICLO_GRUPO_ID LIKE ?||'%'");
			ps.setString(1, cicloId);			
			
			rs = ps.executeQuery();
			while(rs.next()){				
				numMaterias = rs.getInt("MATERIAS");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numMatCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return numMaterias;
	}
	
	public static int numMaetrosDIA(Connection conn) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int numMaterias 		= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(DISTINCT(EMPLEADO_ID)),0) AS TOTAL" +
				" FROM CICLO_GRUPO_CURSO" +
				" WHERE EMPLEADO_ID IN (SELECT EMPLEADO_ID FROM EMP_PERSONAL WHERE ESTADO = 'A')");
			
			rs = ps.executeQuery();
			while(rs.next()){				
				numMaterias = rs.getInt("TOTAL");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numMaetrosDIA|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return numMaterias;
	}
	
	public static int numMatPorCicloyNivel(Connection conn, String cicloId, String nivelId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int numMaterias 		= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS TOTAL FROM CICLO_GRUPO_CURSO " +
					"WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO WHERE CICLO_ID = ? AND NIVEL_ID = ?)");
			ps.setString(1, cicloId);
			ps.setString(2, nivelId);
			rs = ps.executeQuery();
			while(rs.next()){				
				numMaterias = rs.getInt("TOTAL");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCurso|numMatPorCicloyNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return numMaterias;
	}
	
}