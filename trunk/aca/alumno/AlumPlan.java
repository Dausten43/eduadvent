// Bean del Cat�logo Planes
package  aca.alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import aca.util.Fecha;

public class AlumPlan{
	private String codigoId;
	private String planId;	
	private String fInicio;
	private String fGraduacion;
	private String estado;
	private String grado;
	private String grupo;
	
	public AlumPlan(){
		codigoId	= "";
		planId			= "";		
		fInicio			= "";
		fGraduacion 	= "";
		estado			= "";
		grado			= "";
		grupo			= "";
	}
	
	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getPlanId() {
		return planId;
	}

	public void setPlanId(String planId) {
		this.planId = planId;
	}

	public String getFInicio() {
		return fInicio;
	}

	public void setFInicio(String inicio) {
		fInicio = inicio;
	}

	public String getFGraduacion() {
		return fGraduacion;
	}

	public void setFGraduacion(String graduacion) {
		fGraduacion = graduacion;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
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

	public boolean insertReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			//System.out.println("Datos:"+codigoId+":"+planId+":"+fInicio+":"+fGraduacion+":"+estado+":"+grado+":"+grupo);
			ps = conn.prepareStatement("INSERT INTO ALUM_PLAN"+
				"(CODIGO_ID, PLAN_ID, F_INICIO, F_GRADUACION, ESTADO, GRADO, GRUPO) "+
				"VALUES( ?, ?, "+
				"TO_DATE(?,'DD/MM/YYYY'), "+
				"TO_DATE(?,'DD/MM/YYYY'), ?, TO_NUMBER(?, '99'),? )");
			ps.setString(1, codigoId);
			ps.setString(2, planId);			
			ps.setString(3, fInicio);
			ps.setString(4, fGraduacion);
			ps.setString(5, estado);
			ps.setString(6, grado);
			ps.setString(7, grupo);
						
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_PLAN "+
				"SET F_INICIO = TO_DATE(?,'DD/MM/YYYY'), "+
				"F_GRADUACION = TO_DATE(?,'DD/MM/YYYY'), "+
				"ESTADO = ?, GRADO = TO_NUMBER(?, '99'), GRUPO = ? "+								
				"WHERE CODIGO_ID = ? "+
				"AND PLAN_ID = ?");
			ps.setString(1, fInicio);
			ps.setString(2, fGraduacion);
			ps.setString(3, estado);
			ps.setString(4, grado);
			ps.setString(5, grupo);
			ps.setString(6, codigoId);			
			ps.setString(7, planId);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateRegDesactivarPlan(Connection conn, String codigoId, String planId ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("UPDATE ALUM_PLAN SET ESTADO = '0' WHERE CODIGO_ID = ? AND PLAN_ID = ?");			
			ps.setString(1, codigoId);						
			ps.setString(2, planId);
			
			if ( ps.executeUpdate()== 1){			
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|updateRegDesactivarPlan|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateRegDesactivarPlan(Connection conn, String planId ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("UPDATE ALUM_PLAN" +
					" SET ESTADO = '0' WHERE CODIGO_ID = ? AND PLAN_ID = '"+planId+"' ");			
			ps.setString(1, codigoId);						
			if ( ps.executeUpdate()== 1){			
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|updateRegInactivarPlan|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateFechaGraduacion(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_PLAN "+
				"SET F_GRADUACION = TO_DATE(?,'DD/MM/YYYY') "+							
				"WHERE CODIGO_ID = ? "+
				"AND PLAN_ID = ?");
			ps.setString(1, fGraduacion);			
			ps.setString(2, codigoId);			
			ps.setString(3, planId);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|updateFechaGraduacion|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean grabaPlanActual(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_PLAN SET ESTADO = '0' WHERE CODIGO_ID=? ");
			ps.setString(1, codigoId);
			ps.executeUpdate();
			if (this.existeReg(conn)){				
				this.mapeaRegId(conn, codigoId, planId);
				estado = "1";
				if (this.updateReg(conn)) ok=true;
			}else{				
				fInicio = Fecha.getHoy();
				estado 	= "1";
				if (this.insertReg(conn)) ok=true;
			}									
						
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|grabaPlanActual|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean updateGradoGrupo(Connection conn, String grado, String grupo) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ALUM_PLAN SET ESTADO = '0' WHERE CODIGO_ID = ? ");
			ps.setString(1, codigoId);
			ps.executeUpdate();					
			if (this.existeReg(conn)){				
				this.mapeaRegId(conn, codigoId, planId);
				this.estado = "1";
				this.grado = grado;
				this.grupo = grupo;
				if (this.updateReg(conn)) ok=true;
			}else{				
				fInicio = Fecha.getHoy();
				estado 	= "1";
				this.grado = grado;
				this.grupo = grupo;
				if (this.insertReg(conn)) ok=true;
			}			
						
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|updateGradoGrupo|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ALUM_PLAN "+
				"WHERE CODIGO_ID = ? "+
				"AND PLAN_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, planId);
			
			if (ps.executeUpdate()!= -1)
				ok = true;
			else
				ok = false;			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|deleteReg|:"+ex);			
		}finally{		
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteAllReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ALUM_PLAN "+
				"WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			if (ps.executeUpdate()!= -1)
				ok = true;
			else
				ok = false;
						
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|deleteAllReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();

		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId 			= rs.getString("CODIGO_ID");
		planId 				= rs.getString("PLAN_ID");		
		fInicio	 			= rs.getString("F_INICIO");
		fGraduacion			= rs.getString("F_GRADUACION");
		estado				= rs.getString("ESTADO");
		grado				= rs.getString("GRADO");		
		grupo				= rs.getString("GRUPO");		
		
	}
	
	public void mapeaRegId( Connection conn, String codigoId, String planId ) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("SELECT "+
					"CODIGO_ID, PLAN_ID, TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO, " +
					"TO_CHAR(F_GRADUACION,'DD/MM/YYYY') AS F_GRADUACION, ESTADO, GRADO, GRUPO " +
				"FROM ALUM_PLAN "+
				"WHERE CODIGO_ID = ? "+
				"AND PLAN_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, planId);
			
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
	
	public boolean mapeaRegActual( Connection conn, String codigoId ) throws SQLException{
		ResultSet rs 	= null;
		boolean	ok 		= false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("SELECT CODIGO_ID, PLAN_ID, TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO, " +
					"TO_CHAR(F_GRADUACION,'DD/MM/YYYY') AS F_GRADUACION, ESTADO, GRADO, GRUPO " +
				"FROM ALUM_PLAN "+
				"WHERE CODIGO_ID = ? "+
				"AND ESTADO = '1'");
			ps.setString(1, codigoId);		
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
				ok = true; 
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCiclo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok; 
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 		ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ALUM_PLAN "+
				"WHERE CODIGO_ID = ? "+
				"AND PLAN_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, planId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public ArrayList<String> getPlanesAlumno( Connection conn, String codigoId) throws SQLException{
		ResultSet rs = null;
		ArrayList<String> planes=new ArrayList<String>();
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM ALUM_PLAN WHERE CODIGO_ID=?");
		ps.setString(1, codigoId);
		
		rs = ps.executeQuery();
		while (rs.next()){
			planes.add(rs.getString(2));
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		return planes;
	}
	
	public static String getPlanActual(Connection conn, String codigoId) throws SQLException{

		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		String 			plan	= "x";
		
		try{
			ps = conn.prepareStatement("SELECT PLAN_ID FROM ALUM_PLAN "+
			"WHERE CODIGO_ID = ? AND ESTADO = '1'");
			ps.setString(1, codigoId);	
			
			rs = ps.executeQuery();
			if (rs.next())
				plan = rs.getString("PLAN_ID");
				
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|getPlanActual|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return plan;
	}
	
	public static int getNivelAlumno(Connection conn, String codigoId) throws SQLException{

		PreparedStatement ps	= null;
		ResultSet 		rs		= null;
		int 			nivel	= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(NIVEL_ID,0) AS NIVEL_ID FROM PLAN " +
					"WHERE PLAN_ID =(SELECT PLAN_ID FROM ALUM_PLAN WHERE CODIGO_ID = ? AND ESTADO = '1')");
			ps.setString(1, codigoId);		
			
			rs = ps.executeQuery();
			if (rs.next())
				nivel = rs.getInt("NIVEL_ID");
				
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlan|getNivelAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nivel;
	}
	
	
	
}
