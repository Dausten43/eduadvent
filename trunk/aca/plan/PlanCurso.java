// Bean del Catáogo Cursos
package  aca.plan;
import java.sql.*;

public class PlanCurso{
	
	private String planId;
	private String cursoId;	
	private String cursoNombre;
	private String cursoCorto;
	private String grado;	
	private String notaAc;
	private String tipocursoId;
	private String falta;
	private String conducta;
	private String orden;
	private String punto;
	private String horas;
	private String creditos;
	private String estado;
	private String tipoEvaluacion;
	private String aspectos;
	private String cursoBase;
	private String boleta;
	
	
	public PlanCurso(){
		planId			= "";
		cursoId			= "";
		cursoNombre		= "";
		cursoCorto		= "";
		grado			= "";
		notaAc			= "6";
		tipocursoId		= "1";
		falta			= "N";
		conducta		= "N";
		orden			= "";
		punto			= "";
		horas			= "";
		creditos		= "";
		estado 			= "A"; 
		tipoEvaluacion	= "C";
		aspectos		= "N";
		cursoBase		= "000-00AAAA00";
		boleta			= "";
	}
	
	/**
	 * @return the punto
	 */
	public String getPunto() {
		return punto;
	}

	/**
	 * @param punto the punto to set
	 */
	public void setPunto(String punto) {
		this.punto = punto;
	}

	/**
	 * @return the orden
	 */
	public String getOrden() {
		return orden;
	}

	/**
	 * @param orden the orden to set
	 */
	public void setOrden(String orden) {
		this.orden = orden;
	}

	public String getPlanId(){
		return planId;
	}
	
	public void setPlanId( String planId){
		this.planId = planId;
	}	
	
	public String getCursoId(){
		return cursoId;
	}
	
	public void setCursoId( String cursoId){
		this.cursoId = cursoId;
	}	
	
	public String getCursoNombre(){
		return cursoNombre;
	}
	
	public void setCursoNombre( String cursoNombre){
		this.cursoNombre = cursoNombre;
	}
	
	public String getGrado(){
		return grado;
	}
	
	public void setGrado( String grado){
		this.grado = grado;
	}
	
	public String getNotaAc(){
		return notaAc;
	}
	
	public void setNotaAc( String notaAc){
		this.notaAc = notaAc;
	}	
	
	/**
	 * @return the tipocursoId
	 */
	public String getTipocursoId() {
		return tipocursoId;
	}

	/**
	 * @param tipocursoId the tipocursoId to set
	 */
	public void setTipocursoId(String tipocursoId) {
		this.tipocursoId = tipocursoId;
	}
	
	
	/**
	 * @return the conducta
	 */
	public String getConducta() {
		return conducta;
	}

	/**
	 * @param conducta the conducta to set
	 */
	public void setConducta(String conducta) {
		this.conducta = conducta;
	}

	/**
	 * @return the falta
	 */
	public String getFalta() {
		return falta;
	}

	/**
	 * @param falta the falta to set
	 */
	public void setFalta(String falta) {
		this.falta = falta;
	}	
	
	/**
	 * @return the cursoCorto
	 */
	public String getCursoCorto() {
		return cursoCorto;
	}

	/**
	 * @param cursoCorto the cursoCorto to set
	 */
	public void setCursoCorto(String cursoCorto) {
		this.cursoCorto = cursoCorto;
	}
	
	
	/**
	 * @return the horas
	 */
	public String getHoras() {
		return horas;
	}

	/**
	 * @param horas the horas to set
	 */
	public void setHoras(String horas) {
		this.horas = horas;
	}	
	
	/**
	 * @return the creditos
	 */
	public String getCreditos() {
		return creditos;
	}

	/**
	 * @param creditos the creditos to set
	 */
	public void setCreditos(String creditos) {
		this.creditos = creditos;
	}	

	/**
	 * @return the estado
	 */
	public String getEstado() {
		return estado;
	}

	/**
	 * @param estado the estado to set
	 */
	public void setEstado(String estado) {
		this.estado = estado;
	}
	
	public String getTipoEvaluacion() {
		return tipoEvaluacion;
	}

	public void setTipoEvaluacion(String tipoEvaluacion) {
		this.tipoEvaluacion = tipoEvaluacion;
	}
	
	/* Evaluacion por competencias */
	public String getAspectos() {
		return aspectos;
	}

	public void setAspectos(String aspectos) {
		if(aspectos == null){
			this.aspectos = "N";
		}else{
			this.aspectos = aspectos;
		}
	}	

	/**
	 * @return the cursoBase
	 */
	public String getCursoBase() {
		return cursoBase;
	}

	/**
	 * @param cursoBase the cursoBase to set
	 */
	public void setCursoBase(String cursoBase) {
		this.cursoBase = cursoBase;
	}
	
	public String getBoleta() {
		return boleta;
	}

	public void setBoleta(String boleta) {
		this.boleta = boleta;
	}

	/**
	 * @param Connection the Connection to set
	 * @return boolean 
	 */
	public boolean insertReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{			
			ps = conn.prepareStatement("INSERT INTO PLAN_CURSO"+
				" (PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO, GRADO, NOTA_AC, TIPOCURSO_ID, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, "+
				" TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA)" +
				" VALUES( ?, UPPER(?), ?, ?, TO_NUMBER(?,'99'), TO_NUMBER(?,'999')," +
				" TO_NUMBER(?, '99'), ?, ?, " +
				" TO_NUMBER(?, '99'), ?," +
				" TO_NUMBER(?, '99.9')," +
				" TO_NUMBER(?, '99'), ?, ?, ?, ?,?)");	
					
			ps.setString(1, planId);
			ps.setString(2, cursoId);
			ps.setString(3, cursoNombre);
			ps.setString(4, cursoCorto);
			ps.setString(5, grado);
			ps.setString(6, notaAc);
			ps.setString(7, tipocursoId);
			ps.setString(8, falta);
			ps.setString(9, conducta);
			ps.setString(10, orden);
			ps.setString(11, punto);
			ps.setString(12, horas);
			ps.setString(13, creditos);
			ps.setString(14, estado);
			ps.setString(15, tipoEvaluacion);
			ps.setString(16, aspectos);
			ps.setString(17, cursoBase);
			ps.setString(18, boleta);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|insertReg|:"+ex);	
		}finally{
			if (ps!=null) ps.close();
		}		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;		
		try{
			ps = conn.prepareStatement("UPDATE PLAN_CURSO" + 
				" SET PLAN_ID = ?," +
				" CURSO_NOMBRE = ?," +
				" CURSO_CORTO = ?," +
				" GRADO = TO_NUMBER(?,'99')," +
				" NOTA_AC = TO_NUMBER(?,'999')," +
				" TIPOCURSO_ID = TO_NUMBER(?,'99')," +
				" FALTA = ?," +
				" CONDUCTA = ?," +
				" ORDEN = TO_NUMBER(?, '99')," +
				" PUNTO = ?," +
				" HORAS = TO_NUMBER(?,'99.9')," +
				" CREDITOS = TO_NUMBER(?,'99')," +
				" ESTADO = ?,"+
				" TIPO_EVALUACION = ?," +
				" ASPECTOS = ?, " +
				" CURSO_BASE = ?,"+
				" BOLETA = ?"+
				" WHERE CURSO_ID = ?");
			
			ps.setString(1, planId);			
			ps.setString(2, cursoNombre);
			ps.setString(3, cursoCorto);
			ps.setString(4, grado);
			ps.setString(5, notaAc);
			ps.setString(6, tipocursoId);
			ps.setString(7, falta);
			ps.setString(8, conducta);
			ps.setString(9, orden);
			ps.setString(10, punto);
			ps.setString(11, horas);
			ps.setString(12, creditos);
			ps.setString(13, estado);
			ps.setString(14, tipoEvaluacion);
			ps.setString(15, aspectos);
			ps.setString(16, cursoBase);
			ps.setString(17, boleta);
			ps.setString(18, cursoId);
			
			if (ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM PLAN_CURSO WHERE CURSO_ID = ? ");
			ps.setString(1, cursoId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static boolean deleteAllReg(Connection conn, String planId ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM PLAN_CURSO WHERE PLAN_ID = ? AND CURSO_ID NOT IN (SELECT CURSO_ID FROM CICLO_GRUPO_CURSO) ");
			ps.setString(1, planId);
			
			if (ps.executeUpdate()>= 1)
				ok = true;			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|deleteAllReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		planId 			= rs.getString("PLAN_ID");
		cursoId 		= rs.getString("CURSO_ID");
		cursoNombre 	= rs.getString("CURSO_NOMBRE");
		cursoCorto 		= rs.getString("CURSO_CORTO");
		grado	 		= rs.getString("GRADO");
		notaAc			= rs.getString("NOTA_AC");
		tipocursoId		= rs.getString("TIPOCURSO_ID");
		falta			= rs.getString("FALTA");
		conducta		= rs.getString("CONDUCTA");
		orden			= rs.getString("ORDEN");
		punto			= rs.getString("PUNTO");
		horas			= rs.getString("HORAS");
		creditos		= rs.getString("CREDITOS");
		estado 			= rs.getString("ESTADO");
		tipoEvaluacion	= rs.getString("TIPO_EVALUACION");
		aspectos		= rs.getString("ASPECTOS");
		cursoBase		= rs.getString("CURSO_BASE");
		boleta			= rs.getString("BOLETA");
	}
	
	public void mapeaRegId( Connection conn, String cursoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE," +
					" CURSO_CORTO, GRADO, NOTA_AC, TIPOCURSO_ID, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA" +
					" FROM PLAN_CURSO" +
					" WHERE CURSO_ID = ?");
			ps.setString(1,cursoId);
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 		ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1,cursoId);
			rs = ps.executeQuery();
			
			if (rs.next()){
				ok = true;
			}else{
				ok = false;
			}

		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public static boolean existeReg(Connection conn, String cursoId, String cicloId ) throws SQLException{
		boolean 		ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT EXISTS( SELECT 1 FROM CICLO_GRUPO_CURSO WHERE  CURSO_ID = ? AND CICLO_GRUPO_ID LIKE '"+cicloId.substring(0,6)+"%' ) AS EXISTE");
			ps.setString(1,cursoId);
			
			
			rs = ps.executeQuery();
			
			if (rs.next()){
				if (rs.getString("EXISTE").equals("t") ){
					ok = true;
				}
			}

		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public static int cuentaMaterias( Connection conn, String planId, String tipoCurso) throws SQLException, Exception{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int numMaterias			= 0;		
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS MATERIAS FROM PLAN_CURSO"+
			" WHERE PLAN_ID = ?");					
			ps.setString(1, planId);
			rs = ps.executeQuery();
			if (rs.next()){			
				numMaterias = rs.getInt("MATERIAS");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|cuentaMaterias|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return numMaterias;
	}

	public static String getCursoNombre(Connection conn, String cursoId ) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null;
		String nombre = "x"; 
		try{
			ps = conn.prepareStatement("SELECT CURSO_NOMBRE FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				nombre = rs.getString("CURSO_NOMBRE");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getCursoNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
	public static String getCursoBase(Connection conn, String cursoId ) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null;
		String nombre = "x"; 
		try{
			ps = conn.prepareStatement("SELECT CURSO_BASE FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				nombre = rs.getString("CURSO_BASE");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getCursoBase|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		return nombre;
	}
	
	public static String getPlanId(Connection conn, String cursoId ) throws SQLException{
		
		PreparedStatement ps = null;
		ResultSet rs = null;		
		String plan = "x"; 
		
		try{
			ps = conn.prepareStatement("SELECT PLAN_ID FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				plan = rs.getString("PLAN_ID");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getPlanId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return plan;
	}
	
	public static String getCursoCorto(Connection conn, String cursoId ) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null;
		String nombre = "x"; 
		try{
			ps = conn.prepareStatement("SELECT CURSO_CORTO FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				nombre = rs.getString("CURSO_CORTO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getMateria|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
	public static int getNumMateriasGrado(Connection conn, String planId, int grado ) throws SQLException{
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		int numMat				= 0; 
		try{				
			ps = conn.prepareStatement("SELECT COUNT(CURSO_ID) AS NUMMAT" +
					" FROM PLAN_CURSO" +
					" WHERE PLAN_ID = ? AND GRADO = TO_NUMBER(?, '99')");
			ps.setString(1, planId);	
			ps.setInt(2, grado);
			rs = ps.executeQuery();
			if (rs.next())
				numMat = rs.getInt("NUMMAT");
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getNumMateriasCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return numMat;
	}	
	
	public static int getGradoCurso(Connection conn, String cursoId ) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null;
		int grado = 0; 
		try{
			ps = conn.prepareStatement("SELECT GRADO FROM PLAN_CURSO WHERE CURSO_ID = ?");			
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				grado = rs.getInt("GRADO");		
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return grado;
	}
	
	public static String getTipocurso(Connection conn, String cursoId ) throws SQLException{
		
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String tipocurso		= "N"; 
		try{
			ps = conn.prepareStatement("SELECT TIPOCURSO_ID FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				tipocurso = rs.getString("TIPOCURSO_ID");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getOficial|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tipocurso;
	}
	
	public static String getNotaAC(Connection conn, String cursoId) throws SQLException{
		
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String notaAC		= "N"; 
		try{
			ps = conn.prepareStatement("SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				notaAC = rs.getString("NOTA_AC");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getNotaAC|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return notaAC;
	}
	
	public static String getPunto(Connection conn, String cursoId) throws SQLException{
		
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String notaAC		= "N"; 
		try{
			ps = conn.prepareStatement("SELECT PUNTO FROM PLAN_CURSO WHERE CURSO_ID = ?");
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			if (rs.next())
				notaAC = rs.getString("PUNTO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getPunto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return notaAC;
	}
	
	public static int cuentaMaterias( Connection conn, String planId) throws SQLException, Exception{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int numMaterias			= 0;		
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS MATERIAS FROM PLAN_CURSO"+
			" WHERE PLAN_ID = ?");					
			ps.setString(1, planId);
			rs = ps.executeQuery();
			if (rs.next()){			
				numMaterias = rs.getInt("MATERIAS");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|cuentaMaterias|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return numMaterias;
	}
	
}