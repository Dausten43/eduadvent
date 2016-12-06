/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Elifo
 *
 */
public class CicloGrupo {
	private String cicloGrupoId;
	private String cicloId;
	private String grupoNombre;
	private String empleadoId;
	private String horarioId;
	private String salonId;
	private String nivelId;
	private String grado;
	private String grupo;
	private String planId;
	
	public CicloGrupo(){
		cicloGrupoId	= "";
		cicloId			= "";
		grupoNombre		= "";
		empleadoId		= "";
		horarioId		= "";
		salonId			= "";
		nivelId			= "";
		grado			= "";
		grupo			= "";
		planId			= "";
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
	 * @return Returns the cicloId.
	 */
	public String getCicloId() {
		return cicloId;
	}
	

	/**
	 * @param cicloId The cicloId to set.
	 */
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
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
	 * @return Returns the grupoNombre.
	 */
	public String getGrupoNombre() {
		return grupoNombre;
	}
	

	/**
	 * @param grupoNombre The grupoNombre to set.
	 */
	public void setGrupoNombre(String grupoNombre) {
		this.grupoNombre = grupoNombre;
	}
	

	/**
	 * @return Returns the horarioId.
	 */
	public String getHorarioId() {
		return horarioId;
	}
	

	/**
	 * @param horarioId The horarioId to set.
	 */
	public void setHorarioId(String horarioId) {
		this.horarioId = horarioId;
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
	 * @return the grado
	 */
	public String getGrado() {
		return grado;
	}

	/**
	 * @param grado the grado to set
	 */
	public void setGrado(String grado) {
		this.grado = grado;
	}

	/**
	 * @return the grupo
	 */
	public String getGrupo() {
		return grupo;
	}

	/**
	 * @param grupo the grupo to set
	 */
	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	/**
	 * @return the nivelId
	 */
	public String getNivelId() {
		return nivelId;
	}

	/**
	 * @param nivelId the nivelId to set
	 */
	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}

	/**
	 * @return the planId
	 */
	public String getPlanId() {
		return planId;
	}

	/**
	 * @param planId the planId to set
	 */
	public void setPlanId(String planId) {
		this.planId = planId;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO" +
					" (CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE, EMPLEADO_ID," +
					" HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID)" +
					" VALUES(?, ?, ?, ?," +
					" TO_NUMBER(?, '999'), TO_NUMBER(?, '99'),TO_NUMBER(?, '99')," +
					" TO_NUMBER(?, '99'), ?, ?)");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cicloId);
			ps.setString(3, grupoNombre);
			ps.setString(4, empleadoId);
			ps.setString(5, horarioId);
			ps.setString(6, salonId);
			ps.setString(7, nivelId);
			ps.setString(8, grado);
			ps.setString(9, grupo);
			ps.setString(10, planId);
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO" +
					" SET CICLO_ID = ?," +
					" GRUPO_NOMBRE = ?," +
					" EMPLEADO_ID = ?," +
					" HORARIO_ID = TO_NUMBER(?, '999')," +
					" SALON_ID = TO_NUMBER(?, '99')," +
					" NIVEL_ID = TO_NUMBER(?, '99')," +
					" GRADO = TO_NUMBER(?, '99')," +
					" GRUPO = ?," +
					" PLAN_ID = ?" +
					" WHERE CICLO_GRUPO_ID = ?");			
			ps.setString(1, cicloId);
			ps.setString(2, grupoNombre);
			ps.setString(3, empleadoId);
			ps.setString(4, horarioId);
			ps.setString(5, salonId);
			ps.setString(6, nivelId);
			ps.setString(7, grado);
			ps.setString(8, grupo);
			ps.setString(9, planId);
			ps.setString(10, cicloGrupoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO" +
					" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cicloId			= rs.getString("CICLO_ID");
		grupoNombre		= rs.getString("GRUPO_NOMBRE");
		empleadoId		= rs.getString("EMPLEADO_ID");
		horarioId		= rs.getString("HORARIO_ID");
		salonId			= rs.getString("SALON_ID");
		nivelId			= rs.getString("NIVEL_ID");
		grado			= rs.getString("GRADO");
		grupo			= rs.getString("GRUPO");
		planId			= rs.getString("PLAN_ID");
	}
	
	public void mapeaRegId(Connection con, String cicloGrupoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE," +
					" EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID" +
					" FROM CICLO_GRUPO" +
					" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public List<CicloGrupo> mapClicloGrupo(Connection con, String ciclo_id) throws SQLException{
		List<CicloGrupo> salida = new ArrayList();
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE," +
					" EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID" +
					" FROM CICLO_GRUPO" +
					" WHERE CICLO_ID = ?");
			ps.setString(1, ciclo_id);
			
			rs = ps.executeQuery();
			
			while(rs.next()){
				CicloGrupo cg = new CicloGrupo();
				cg.mapeaReg(rs);
				salida.add(cg);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return salida;
	}
	
	public void mapeaRegId(Connection con, String nivelId, String grado, String grupo, String cicloId, String planId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE," +
				" EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID" +
				" FROM CICLO_GRUPO" +
				" WHERE NIVEL_ID = TO_NUMBER(?, '99')" +
				" AND GRADO = TO_NUMBER(?, '99')" +
				" AND GRUPO = ?" +
				" AND CICLO_ID = ?" +
				" AND PLAN_ID = ?");
		ps.setString(1, nivelId);
		ps.setString(2, grado);
		ps.setString(3, grupo);
		ps.setString(4, cicloId);
		ps.setString(5, planId);
		
		rs = ps.executeQuery();
		
		if(rs.next()){
			mapeaReg(rs);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
	}
	
	public void mapeaRegId(Connection con, String empleadoId, String cicloId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CICLO_ID, GRUPO_NOMBRE," +
					" EMPLEADO_ID, HORARIO_ID, SALON_ID, NIVEL_ID, GRADO, GRUPO, PLAN_ID" +
					" FROM CICLO_GRUPO" +
					" WHERE EMPLEADO_ID = ?" +
					" AND CICLO_ID = ?");
			ps.setString(1, empleadoId);
			ps.setString(2, cicloId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeGradoGrupo(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO" +
					" WHERE GRADO = TO_NUMBER(?,'99') AND GRUPO = ? AND CICLO_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND PLAN_ID = ? ");
			ps.setString(1, grado);
			ps.setString(2, grupo);
			ps.setString(3, cicloId);
			ps.setString(4, nivelId);
			ps.setString(5, planId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|existeGradoGrupo|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO" +
					" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public static String getCicloGrupoId(Connection conn, String nivelId, String grado, String grupo, String cicloId, String planId) throws SQLException{
				
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String grupoId 			= "X";
		
		try{
			ps = conn.prepareStatement("SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO" +
					" WHERE NIVEL_ID = ?" +
					" AND GRADO = ?" +
					" AND GRUPO = ?" +
					" AND CICLO_ID = ?" +
					" AND PLAN_ID = ?");
			ps.setInt(1, Integer.parseInt(nivelId));
			ps.setInt(2, Integer.parseInt(grado));
			ps.setString(3, grupo);
			ps.setString(4, cicloId);
			ps.setString(5, planId);			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				grupoId = rs.getString("CICLO_GRUPO_ID");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getCicloGrupoId|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return grupoId;
	}
	
	public boolean existeReg(Connection conn, String nivelId, String grado, String grupo, String cicloId, String planId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{			
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO" +
					" WHERE NIVEL_ID = TO_NUMBER(?, '99')" +
					" AND GRADO = TO_NUMBER(?, '99')" +
					" AND GRUPO = ?" +
					" AND CICLO_ID = ?" +
					" AND PLAN_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, grado);
			ps.setString(3, grupo);
			ps.setString(4, cicloId);
			ps.setString(5, planId);
			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;				
			}else{
				ok = false;				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public static String getSecuencial( Connection conn, String cicloId) throws SQLException{		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		String numero 			= "001";
		int temp				= 1;
		
		try{
			ps = conn.prepareStatement("SELECT MAX(SUBSTR(CICLO_GRUPO_ID,9,4)) AS NUMERO" +
					" FROM CICLO_GRUPO" +
					" WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);		
			
			rs= ps.executeQuery();		
			if(rs.next()){
				temp = rs.getInt("NUMERO");
				temp++;
				if(temp == 0)
					temp = 1;
				if(temp < 10)
					numero = "00"+temp;
				else if(temp >= 10 && temp < 100)
					numero = "0"+temp;
				else if(temp >= 100)
					numero = String.valueOf(temp);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getSecuencial|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numero;
	}
	
	public static String getMaestroBase( Connection conn, String nivelId, String grado, String grupo, String cicloId) throws SQLException{		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		String maestro 			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT EMPLEADO_ID FROM CICLO_GRUPO" +
					" WHERE NIVEL_ID = TO_NUMBER(?, '99')" +
					" AND GRADO = TO_NUMBER(?, '99')" +
					" AND GRUPO = ?" +
					" AND CICLO_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, grado);
			ps.setString(3, grupo);
			ps.setString(4, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maestro = rs.getString("EMPLEADO_ID");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getMaestroBase|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maestro;
	}
	
	public static boolean getEsMaestroPlantaEnCualquierCiclo( Connection conn, String empleadoId, String cicloId) throws SQLException{		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		boolean esMaestro 		= false;
		
		try{
			ps = conn.prepareStatement("SELECT EMPLEADO_ID FROM CICLO_GRUPO" +
					" WHERE EMPLEADO_ID = ? ");					
			ps.setString(1, empleadoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				if (rs.getString("EMPLEADO_ID").equals(empleadoId)){
					esMaestro = true;
				}
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getEsMaestroPlantaEnCualquierCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return esMaestro;
	}
	
	public static boolean getEsMaestroPlanta( Connection conn, String empleadoId, String cicloId) throws SQLException{		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		boolean esMaestro 		= false;
		
		try{
			ps = conn.prepareStatement("SELECT EMPLEADO_ID FROM CICLO_GRUPO" +
					" WHERE EMPLEADO_ID = ?" +
					" AND CICLO_ID = ?");					
			ps.setString(1, empleadoId);
			ps.setString(2, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				if (rs.getString("EMPLEADO_ID").equals(empleadoId)){
					esMaestro = true;
				}
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getEsMaestroPlanta|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return esMaestro;
	}
	
	public static boolean esMaestroCiclo( Connection conn, String empleadoId, String cicloId) throws SQLException{		
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		boolean esMaestro 		= false;
		
		try{
			ps = conn.prepareStatement("SELECT DISTINCT(CICLO_ID) AS CICLO FROM CICLO_GRUPO" +
					" WHERE CICLO_ID = ?" +
					" AND CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO_CURSO WHERE EMPLEADO_ID = ?)");
			ps.setString(1, cicloId);
			ps.setString(2, empleadoId);			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				if (rs.getString("CICLO").equals(cicloId)){
					esMaestro = true;
				}
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|esMaestroCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return esMaestro;
	}
	
	public static String getGrupoNombre( Connection conn, String cicloGrupoId ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;		
		String nombreGrupo		= "x";
		
		try{
			ps = conn.prepareStatement("SELECT GRUPO_NOMBRE FROM CICLO_GRUPO" +
					" WHERE CICLO_GRUPO_ID = ?");					
			ps.setString(1, cicloGrupoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombreGrupo = rs.getString("GRUPO_NOMBRE");				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getGrupoNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombreGrupo;
	}
	
public static String getGradoGrupo( Connection conn, String cicloGrupoId ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;		
		String gradoGrupo		= "x";
		String grado			= "";
		String grupo			= "";
		
		try{
			ps = conn.prepareStatement("SELECT GRADO,GRUPO FROM CICLO_GRUPO" +
					" WHERE CICLO_GRUPO_ID = ?");					
			ps.setString(1, cicloGrupoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				grado	   = rs.getString("GRADO");
				grupo	   = rs.getString("GRUPO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getGradoGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		gradoGrupo = grado+" "+grupo;
		return gradoGrupo;
	}
	
	public static String getCicloId( Connection conn, String cicloGrupoId ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String ciclo			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT CICLO_ID FROM CICLO_GRUPO WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);
			
			rs= ps.executeQuery();
			if(rs.next()){
				ciclo = rs.getString("CICLO_ID");				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getGrupoNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ciclo;
	}
	
	public static String getCicloGrupoId( Connection conn, String cicloId, String planId, String grado, String grupo ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String ciclo			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO " +
					" WHERE CICLO_ID = ?" +
					" AND PLAN_ID = ?" +
					" AND GRADO = TO_NUMBER(?, '99')" +
					" AND GRUPO = ?");
			ps.setString(1, cicloId);
			ps.setString(2, planId);
			ps.setString(3, grado);
			ps.setString(4, grupo);
			
			rs= ps.executeQuery();
			if(rs.next()){
				ciclo = rs.getString("CICLO_GRUPO_ID");				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getCicloGrupoId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ciclo;
	}
	
	public static int getMaxEval(Connection conn, String cicloGrupoId ) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;
		int maximo 				= 0;		
		try{						
			ps = conn.prepareStatement("SELECT MAX(EVALUACION_ID) AS MAX FROM CICLO_GRUPO_EVAL "+
				" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				maximo = rs.getInt("MAX");			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getMaxEval|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return maximo;
	}
	
	public static String getNivelGrupo(Connection conn, String cicloGrupoId ) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;
		String nivelId 			= "";		
		try{						
			ps = conn.prepareStatement("SELECT NIVEL_ID FROM CICLO_GRUPO "+
				" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				nivelId = rs.getString("NIVEL_ID");			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|getNivelGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return nivelId;
	}
	
	public static boolean existeGradoyGrupo(Connection conn, String escuelaId, String grado, String grupo ) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;
		boolean ok 				= false;		
		try{						
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO " +
					"WHERE GRADO = TO_NUMBER(?, '99') AND GRUPO = ? AND (SELECT ESCUELA_ID FROM PLAN WHERE PLAN_ID = CICLO_GRUPO.PLAN_ID) = ? ");
			
			ps.setString(1, grado);
			ps.setString(2, grupo);
			ps.setString(3, escuelaId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				ok = true;	
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupo|existeGradoyGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	
}