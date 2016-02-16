/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class CicloGrupoHorario {
	private String escuelaId;
	private String cursoId;
	private String cicloGrupoId;
	private String salonId;
	private String horarioId;
	private String dia;
	private String periodoId;
	public CicloGrupoHorario(){
		escuelaId		= "";
		cursoId			= "";
		cicloGrupoId	= "";
		salonId			= "";
		horarioId		= "";
		dia				= "";
		periodoId		= "";
	}
	
	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getCursoId() {
		return cursoId;
	}

	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}

	public String getCicloGrupoId() {
		return cicloGrupoId;
	}

	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}

	public String getSalonId() {
		return salonId;
	}

	public void setSalonId(String salonId) {
		this.salonId = salonId;
	}

	public String getHorarioId() {
		return horarioId;
	}

	public void setHorarioId(String horarioId) {
		this.horarioId = horarioId;
	}

	public String getDia() {
		return dia;
	}

	public void setDia(String dia) {
		this.dia = dia;
	}

	public String getPeriodoId() {
		return periodoId;
	}

	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_HORARIO" +
					" (ESCUELA_ID, CURSO_ID, CICLO_GRUPO_ID, SALON_ID, HORARIO_ID, DIA, PERIODO_ID)" +
					" VALUES(?, ?, ?, TO_NUMBER(?, '99999'), TO_NUMBER(?, '99999'), TO_NUMBER(?, '9'), TO_NUMBER(?, '99'))");
			ps.setString(1,escuelaId);
			ps.setString(2,cursoId);
			ps.setString(3,cicloGrupoId);
			ps.setString(4,salonId);
			ps.setString(5,horarioId);
			ps.setString(6,dia);
			ps.setString(7,periodoId);
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorario|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_HORARIO" +
					" WHERE ESCUELA_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND SALON_ID = TO_NUMBER(?, '99999')" +
					" AND HORARIO_ID = TO_NUMBER(?, '99999')" +
					" AND DIA = TO_NUMBER(?, '9')" +
					" AND PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1,escuelaId);
			ps.setString(2,cursoId);
			ps.setString(3,cicloGrupoId);
			ps.setString(4,salonId);
			ps.setString(5,horarioId);
			ps.setString(6,dia);
			ps.setString(7,periodoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorario|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId		= rs.getString("ESCUELA_ID");
		cursoId			= rs.getString("CURSO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		salonId			= rs.getString("SALON_ID");
		horarioId		= rs.getString("HORARIO_ID");
		dia				= rs.getString("DIA");
		periodoId		= rs.getString("PERIODO_ID");
	}
	
	public void mapeaRegId(Connection con, String cicloGrupoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID CURSO_ID, CICLO_GRUPO_ID, SALON_ID, HORARIO_ID, DIA, PERIODO_ID" +
					" FROM CICLO_GRUPO_HORARIO" +
					" WHERE ESCUELA_ID = ?," +
					" CURSO_ID = ?," +
					" CICLO_GRUPO_ID = ?," +
					" SALON_ID = ?," +
					" HORARIO_ID = TO_NUMBER(?, '99999')," +
					" DIA = TO_NUMBER(?, '9')," +
					" PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1,escuelaId);
			ps.setString(2,cursoId);
			ps.setString(3,cicloGrupoId);
			ps.setString(4,salonId);
			ps.setString(5,horarioId);
			ps.setString(6,dia);
			ps.setString(7,periodoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorario|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_HORARIO" +
					" WHERE ESCUELA_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND SALON_ID = TO_NUMBER(?, '99999')" +
					" AND HORARIO_ID = TO_NUMBER(?, '99999') " +
					" AND DIA = TO_NUMBER(?, '9')" +
					" AND PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1,escuelaId);
			ps.setString(2,cursoId);
			ps.setString(3,cicloGrupoId);
			ps.setString(4,salonId);
			ps.setString(5,horarioId);
			ps.setString(6,dia);
			ps.setString(7,periodoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorario|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	
	public static boolean existeHorario(Connection conn, String escuelaId, String horarioId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_HORARIO" +
					" WHERE ESCUELA_ID = ?" +
					" AND HORARIO_ID  = TO_NUMBER(?,'99999')");
			
			ps.setString(1,escuelaId);
			ps.setString(2,horarioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorario|existeHorario|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public static boolean existePeriodoHorario(Connection conn, String escuelaId, String horarioId, String periodoId) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_HORARIO" +
					" WHERE ESCUELA_ID = ?" +
					" AND HORARIO_ID = TO_NUMBER(?, '99999') " +
					" AND PERIODO_ID = TO_NUMBER(?,'99999')");
			
			ps.setString(1,escuelaId);
			ps.setString(2,horarioId);
			ps.setString(3,periodoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoHorario|existeHorario|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
}