package aca.empleado;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EmpCurriculum {
	private String idEmpleado;
	private String lugarNac;
	private String tProfesional;
	private String gPosgrado;
	private String tUniversitario;
	private String respActual;
	private String respAnterior;
	private String expDocente;
	private String fNacimiento;
	private String nacionalidad;
	
	public EmpCurriculum(){
		idEmpleado		= "";
		lugarNac		= "";
		tProfesional	= "";
		gPosgrado		= "";
		tUniversitario	= "";
		respActual		= "";
		respAnterior	= "";
		expDocente		= "";
		fNacimiento		= "";
		nacionalidad	= "";
	}

	public String getFNacimiento() {
		return fNacimiento;
	}

	public void setFNacimiento(String nacimiento) {
		fNacimiento = nacimiento;
	}

	public String getNacionalidad() {
		return nacionalidad;
	}

	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}

	/**
	 * @return the idEmpleado
	 */
	public String getIdEmpleado() {
		return idEmpleado;
	}

	/**
	 * @param idEmpleado the idEmpleado to set
	 */
	public void setIdEmpleado(String idEmpleado) {
		this.idEmpleado = idEmpleado;
	}

	/**
	 * @return the lugarNac
	 */
	public String getLugarNac() {
		return lugarNac;
	}

	/**
	 * @param lugarNac the lugarNac to set
	 */
	public void setLugarNac(String lugarNac) {
		this.lugarNac = lugarNac;
	}

	/**
	 * @return the tProfesional
	 */
	public String getTProfesional() {
		return tProfesional;
	}

	/**
	 * @param profesional the tProfesional to set
	 */
	public void setTProfesional(String profesional) {
		tProfesional = profesional;
	}

	/**
	 * @return the gPosgrado
	 */
	public String getGPosgrado() {
		return gPosgrado;
	}

	/**
	 * @param posgrado the gPosgrado to set
	 */
	public void setGPosgrado(String posgrado) {
		gPosgrado = posgrado;
	}

	/**
	 * @return the tUniversitario
	 */
	public String getTUniversitario() {
		return tUniversitario;
	}

	/**
	 * @param universitario the tUniversitario to set
	 */
	public void setTUniversitario(String universitario) {
		tUniversitario = universitario;
	}

	/**
	 * @return the respActual
	 */
	public String getRespActual() {
		return respActual;
	}

	/**
	 * @param respActual the respActual to set
	 */
	public void setRespActual(String respActual) {
		this.respActual = respActual;
	}

	/**
	 * @return the respAnterior
	 */
	public String getRespAnterior() {
		return respAnterior;
	}

	/**
	 * @param respAnterior the respAnterior to set
	 */
	public void setRespAnterior(String respAnterior) {
		this.respAnterior = respAnterior;
	}

	/**
	 * @return the expDocente
	 */
	public String getExpDocente() {
		return expDocente;
	}

	/**
	 * @param expDocente the expDocente to set
	 */
	public void setExpDocente(String expDocente) {
		this.expDocente = expDocente;
	}
	
	public boolean insertReg(Connection conn) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		try{
			ps = conn.prepareStatement("INSERT INTO" +
				" EMP_CURRICULUM(ID_EMPLEADO, LUGAR_NAC, T_PROFESIONAL, G_POSGRADO," +
				" T_UNIVERSITARIO, RESP_ACTUAL, RESP_ANTERIOR, EXP_DOCENTE, F_NACIMIENTO, NACIONALIDAD)" +
				" VALUES(?, ?, ?, ?," +
				" ?, ?, ?, ?, TO_DATE(?,'DD/MM/YYYY'), TO_NUMBER(?,'999'))");
			
			ps.setString(1, idEmpleado);
			ps.setString(2, lugarNac);
			ps.setString(3, tProfesional);			
			ps.setString(4, gPosgrado);
			ps.setString(5, tUniversitario);
			ps.setString(6, respActual);
			ps.setString(7, respAnterior);
			ps.setString(8, expDocente);
			ps.setString(9, fNacimiento);
			ps.setString(10, nacionalidad);
			
			if(ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;			
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCurriculum|insertReg|:"+ex);			
		}finally{
			if(ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE EMP_CURRICULUM" +
				" SET LUGAR_NAC = ?," +
				" T_PROFESIONAL = ?," +
				" G_POSGRADO = ?," +
				" T_UNIVERSITARIO = ?," +
				" RESP_ACTUAL = ?," +
				" RESP_ANTERIOR = ?," +
				" EXP_DOCENTE = ?, " +
				" F_NACIMIENTO = TO_DATE(?, 'DD/MM/YYYY')," +
				" NACIONALIDAD = TO_NUMBER(?,'999')" +
				" WHERE ID_EMPLEADO = ?");
			
			ps.setString(1, lugarNac);
			ps.setString(2, tProfesional);			
			ps.setString(3, gPosgrado);
			ps.setString(4, tUniversitario);
			ps.setString(5, respActual);
			ps.setString(6, respAnterior);
			ps.setString(7, expDocente);
			ps.setString(8, fNacimiento);
			ps.setString(9, nacionalidad);
			ps.setString(10, idEmpleado);
						
			if(ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCurriculum|updateReg|:"+ex);		
		}finally{
			if(ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean deleteReg(Connection conn) throws Exception{
		PreparedStatement ps 	= null;
		boolean ok 				= false;
		try{
			ps = conn.prepareStatement("DELETE FROM EMP_CURRICULUM"+
				" WHERE ID_EMPLEADO = ?");
			
			ps.setString(1, idEmpleado);
			
			if(ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCurriculum|deleteReg|:"+ex);			
		}finally{
			if(ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		idEmpleado		= rs.getString("ID_EMPLEADO");
		lugarNac		= rs.getString("LUGAR_NAC");
		tProfesional	= rs.getString("T_PROFESIONAL");
		gPosgrado		= rs.getString("G_POSGRADO");
		tUniversitario	= rs.getString("T_UNIVERSITARIO");
		respActual		= rs.getString("RESP_ACTUAL");
		respAnterior	= rs.getString("RESP_ANTERIOR");
		expDocente		= rs.getString("EXP_DOCENTE");
		fNacimiento		= rs.getString("F_NACIMIENTO");
		nacionalidad	= rs.getString("NACIONALIDAD");
	}
	
	public void mapeaRegId(Connection con, String idEmpleado) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ID_EMPLEADO, LUGAR_NAC, T_PROFESIONAL, G_POSGRADO," +
					" T_UNIVERSITARIO, RESP_ACTUAL, RESP_ANTERIOR, EXP_DOCENTE, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" NACIONALIDAD FROM EMP_CURRICULUM " +
					" WHERE ID_EMPLEADO = ?");
			
			ps.setString(1, idEmpleado);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCurriculum|mapeaRegId|:"+ex);
		}finally{
			if(rs!=null) rs.close();
			if(ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 		ok 		= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM EMP_CURRICULUM" +
					" WHERE ID_EMPLEADO = ?");
		
		ps.setString(1, idEmpleado);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCurriculum|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
}

