// Bean del Historico de Inscripcion
package  aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class AlumCiclo{
	private String codigoId;
	private String cicloId;		
	private String estado;
	private String periodoId;
	private String clasfinId;
	private String planId;
	private String fecha;
	private String nivel;
	private String grado;
	private String grupo;
	
	public AlumCiclo(){
		codigoId		= "";
		cicloId			= "";
		estado			= "";
		periodoId		= "";
		clasfinId		= "";
		planId			= "";
		fecha			= "";
		nivel			= "";
		grado			= "";
		grupo			= "";
	}
	
	public String getClasfinId() {
		return clasfinId;
	}

	public void setClasfinId(String clasfinId) {
		this.clasfinId = clasfinId;
	}

	public String getPlanId() {
		return planId;
	}

	public void setPlanId(String planId) {
		this.planId = planId;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getNivel() {
		return nivel;
	}

	public void setNivel(String nivel) {
		this.nivel = nivel;
	}

	public String getGrado() {
		return grado;
	}

	public void setGrado(String grado) {
		this.grado = grado;
	}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getCicloId() {
		return cicloId;
	}

	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}

	public String getPeriodoId() {
		return periodoId;
	}

	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public boolean insertReg(Connection conn ) throws Exception{				
		PreparedStatement ps 	= null;
		boolean ok 				= false;		 
		
		try{			
			//comando = "INSERT INTO ALUM_CICLO (CODIGO_ID, CICLO_ID, PERIODO_ID, ESTADO) VALUES( '"+codigoId+"', '"+cicloId+"', TO_NUMBER('"+periodoId+"', '99'),'"+estado+"' )";			
			ps = conn.prepareStatement("INSERT INTO ALUM_CICLO"+
					"(CODIGO_ID, CICLO_ID, ESTADO, PERIODO_ID, CLASFIN_ID, PLAN_ID, FECHA, NIVEL, GRADO, GRUPO) "+
			"VALUES( ?, ?, ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?, localtimestamp, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			ps.setString(3, estado);
			ps.setString(4, periodoId);
			ps.setString(5, clasfinId);
			ps.setString(6, planId);
			ps.setString(7, nivel);
			ps.setString(8, grado);
			ps.setString(9, grupo);
			
			if (ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|insertReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_CICLO "+
				" SET ESTADO = ?," +
				" CLASFIN_ID = TO_NUMBER(?, '99')," +
				" PLAN_ID = ?," +
				" FECHA = localtimestamp," +
				" NIVEL = TO_NUMBER(?, '99')," +
				" GRADO = TO_NUMBER(?, '99')," +
				" GRUPO = ? "+
				" WHERE CODIGO_ID = ? "+
				" AND CICLO_ID = ?" +
				" AND PERIODO_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, estado);
			ps.setString(2, clasfinId);
			ps.setString(3, planId);
			ps.setString(4, nivel);
			ps.setString(5, grado);
			ps.setString(6, grupo);
			ps.setString(7, codigoId);
			ps.setString(8, cicloId);
			ps.setString(9, periodoId);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|updateReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static boolean updateEstado(Connection conn, String codigoId, String cicloId, String estado) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_CICLO "+
				" SET ESTADO = ?" +
				" WHERE CODIGO_ID = ? "+
				" AND CICLO_ID = ?");			
			
			ps.setString(1, estado);
			ps.setString(2, codigoId);
			ps.setString(3, cicloId);
			
			if (ps.executeUpdate() > 0)
				ok = true;	
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|updateEstado|:"+ex);
			ex.printStackTrace();
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		try{
			PreparedStatement ps = conn.prepareStatement("DELETE FROM ALUM_CICLO "+
				"WHERE CODIGO_ID = ? "+
				"AND CICLO_ID = ?" +
				"AND PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			ps.setString(3, periodoId);
			
			if (ps.executeUpdate()!= -1)
				ok = true;
			else
				ok = false;
			
			if (ps!=null) ps.close();
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|deleteReg|:"+ex);
			ex.printStackTrace();
		}
		return ok;
	}
	
	public boolean deleteAllReg(Connection conn ) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("DELETE FROM ALUM_CICLO WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			if (ps.executeUpdate()!= -1)
				ok = true;
			else
				ok = false;		
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|deleteAllReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId 		= rs.getString("CODIGO_ID");
		cicloId 		= rs.getString("CICLO_ID");
		estado			= rs.getString("ESTADO");
		periodoId 		= rs.getString("PERIODO_ID");
		clasfinId 		= rs.getString("CLASFIN_ID");
		planId 			= rs.getString("PLAN_ID");
		fecha 			= rs.getString("FECHA");
		nivel 			= rs.getString("NIVEL");
		grado 			= rs.getString("GRADO");
		grupo 			= rs.getString("GRUPO");
	}
	
	public void mapeaRegId( Connection conn, String codigoId, String cicloId, String periodoId ) throws SQLException{
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		
		try{
			ps = conn.prepareStatement("SELECT *" +
				" FROM ALUM_CICLO"+
				" WHERE CODIGO_ID = ?"+
				" AND CICLO_ID = ?" +
				" AND PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			ps.setString(3, periodoId);
		
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;		
		ResultSet 		rs		= null;
		boolean 		ok 		= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUM_CICLO "+
				"WHERE CODIGO_ID = ? "+
				"AND CICLO_ID = ?" +
				"AND PERIODO_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			ps.setString(3, periodoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|existeReg|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public static boolean estaInscrito(Connection conn, String codigoId, String cicloId, String periodoId) throws SQLException{
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		boolean ok			= false;
	
		try{
			comando = "SELECT * FROM" +
					" ALUM_CICLO" +
					" WHERE CODIGO_ID = '"+codigoId+"'" +
					" AND CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')" +
					" AND ESTADO = 'I'";
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				ok = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|estaInscrito|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs != null) rs.close();
			if (st != null) st.close();
		}
		
		return ok;
	}
	
	
	public static boolean estaInscritoPlanNivelGradpGrupo(Connection conn, String codigoId, String cicloId, String periodoId, String planId, String nivel, String grado, String grupo) throws SQLException{
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		boolean ok			= false;
	
		try{
			comando = "SELECT * FROM" +
					" ALUM_CICLO" +
					" WHERE CODIGO_ID = '"+codigoId+"'" +
					" AND CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')" +
					" AND PLAN_ID = '"+planId+"'" +
					" AND NIVEL = TO_NUMBER('"+nivel+"', '99')" +
					" AND GRADO = TO_NUMBER('"+grado+"', '99')" +
					" AND GRUPO = '"+grupo+"'" +
					" AND ESTADO = 'I'";
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				ok = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|estaInscrito|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs != null) rs.close();
			if (st != null) st.close();
		}
		
		return ok;
	}
	
	
	public static boolean estaInscritoConOtrosDatos(Connection conn, String codigoId, String cicloId, String periodoId, String planId, String nivel, String grado, String grupo) throws SQLException{
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		boolean ok			= false;
	
		try{
			comando = "SELECT * FROM" +
					" ALUM_CICLO" +
					" WHERE CODIGO_ID = '"+codigoId+"'" +
					" AND CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')" +
					" AND (PLAN_ID != '"+planId+"'" +
					" OR NIVEL != TO_NUMBER('"+nivel+"', '99')" +
					" OR GRADO != TO_NUMBER('"+grado+"', '99')" +
					" OR GRUPO != '"+grupo+"') " +
					" AND ESTADO = 'I'";
			
			rs = st.executeQuery(comando);
			if (rs.next()){
				ok = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|estaInscrito|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs != null) rs.close();
			if (st != null) st.close();
		}
		
		return ok;
	}
	
}
