// Bean del Catálogo Planes
package  aca.plan;
import java.sql.*;

public class Plan{
	
	private String planId;
	private String planNombre;
	private String nivelId;
	private String escuelaId;
	private String estado;
	private String validaHorario;
	private String titulo;
	
	
	
	@Override
	public String toString() {
		return "Plan [planId=" + planId + ", planNombre=" + planNombre + ", nivelId=" + nivelId + ", escuelaId="
				+ escuelaId + ", estado=" + estado + ", validaHorario=" + validaHorario + ", titulo=" + titulo + "]";
	}

	public Plan(){
		planId			= "";
		planNombre		= "";
		nivelId			= "";
		escuelaId		= "";
		estado			= "";
		validaHorario	= "";
		titulo 			= "";
	}

	public String getPlanId() {
		return planId;
	}

	public void setPlanId(String planId) {
		this.planId = planId;
	}

	public String getPlanNombre() {
		return planNombre;
	}

	public void setPlanNombre(String planNombre) {
		this.planNombre = planNombre;
	}

	public String getNivelId() {
		return nivelId;
	}

	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}

	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getValidaHorario() {
		return validaHorario;
	}

	public void setValidaHorario(String validaHorario) {
		this.validaHorario = validaHorario;
	}
	
	/**
	 * @return the titulo
	 */
	public String getTitulo() {
		return titulo;
	}

	/**
	 * @param titulo the titulo to set
	 */
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	
	public boolean insertReg(Connection conn) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO PLAN"+
				"(PLAN_ID, PLAN_NOMBRE, NIVEL_ID, ESCUELA_ID, ESTADO, VALIDA_HORARIO, TITULO)"+
				" VALUES( ?, ?, TO_NUMBER(?,'99'), ?, ?, ?, ?)");
					
			ps.setString(1, planId);
			ps.setString(2, planNombre);
			ps.setString(3, nivelId);
			ps.setString(4, escuelaId);
			ps.setString(5, estado);
			ps.setString(6, validaHorario);
			ps.setString(7, titulo);
						
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
						
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE PLAN"+
				" SET PLAN_NOMBRE = ?," +
				" NIVEL_ID = TO_NUMBER(?,'99')," +
				" ESCUELA_ID = ?, " +
				" ESTADO = ?, VALIDA_HORARIO = ?," +
				" TITULO = ? "+
				" WHERE PLAN_ID = ?");
			ps.setString(1, planNombre);
			ps.setString(2, nivelId);
			ps.setString(3, escuelaId);
			ps.setString(4, estado);
			ps.setString(5, validaHorario);
			ps.setString(6, titulo);
			ps.setString(7, planId);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
					
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM PLAN "+
				"WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
						
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs) throws SQLException{
		planId 			= rs.getString("PLAN_ID");
		planNombre 		= rs.getString("PLAN_NOMBRE");
		nivelId	 		= rs.getString("NIVEL_ID");
		escuelaId		= rs.getString("ESCUELA_ID");
		estado			= rs.getString("ESTADO");
		validaHorario	= rs.getString("VALIDA_HORARIO");
		titulo			= rs.getString("TITULO");
	}
	
	public void mapeaRegId(Connection conn, String planId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT PLAN_ID, PLAN_NOMBRE, NIVEL_ID, ESCUELA_ID, ESTADO, VALIDA_HORARIO, TITULO "+
								" FROM PLAN WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
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
			ps = conn.prepareStatement("SELECT * FROM PLAN"+
				" WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn, String escuelaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "01";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTRING(PLAN_ID,5,6),'99'))+1,'00')),'01') " +
					"AS MAXIMO FROM PLAN WHERE ESCUELA_ID = '"+escuelaId+"'");
			rs= ps.executeQuery();
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public int getNumCursos(Connection conn) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		int nCursos=0;	
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(CURSO_ID) AS CURSOS FROM PLAN_CURSO "+
				"WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				nCursos = rs.getInt("CURSOS");			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|getNumCursos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nCursos;
	}
	
	public static String getNombrePlan(Connection conn, String planId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		String nombrePlan 		= "-";	
		
		try{
			ps = conn.prepareStatement("SELECT PLAN_NOMBRE FROM PLAN"+
				" WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				nombrePlan = rs.getString("PLAN_NOMBRE");			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|getNombrePlan|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nombrePlan;
	}
	
	public static String getNivel(Connection conn, String planId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		String nivel 			= "0";	
		
		try{
			ps = conn.prepareStatement("SELECT NIVEL_ID FROM PLAN"+
				" WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				nivel = rs.getString("NIVEL_ID");			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|getNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nivel;
	}
	
	public static int getNumCursos(Connection conn, String planId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		int nCursos=0;	
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(CURSO_ID) AS CURSOS FROM PLAN_CURSO "+
				"WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				nCursos = rs.getInt("CURSOS");			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|getNumCursos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nCursos;
	}
	
	public static String getNumGrados(Connection conn, String planId) throws SQLException{
		
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String grado			= "0"; 
		try{
			ps = conn.prepareStatement("SELECT MAX(GRADO) AS MAXIMO FROM PLAN_CURSO WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			rs = ps.executeQuery();
			if (rs.next())
				grado = rs.getString("MAXIMO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getNumGrados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return grado;
	}
	
	public static String getTitulo(Connection conn, String planId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		String titulo 			= "0";	
		
		try{
			ps = conn.prepareStatement("SELECT TITULO FROM PLAN WHERE PLAN_ID = ?");
			ps.setString(1, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				titulo = rs.getString("TITULO");			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|getTitulo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return titulo;
	}
	
	
	public boolean planSiendoUsado(Connection conn, String planId) throws SQLException{
		boolean 		ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_CURSO "
					+ " WHERE CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE PLAN_ID = ?)");
			ps.setString(1, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.Plan|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
}