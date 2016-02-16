/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class CatHorarioPeriodo {
	private String horarioId;
	private String periodoId;
	private String horaInicio;
	private String minInicio;
	private String horafin;
	private String minfin;
	
	public CatHorarioPeriodo(){
		horarioId	= "";
		periodoId	= "";
		horaInicio	= "";
		minInicio	= "";
		horafin		= "";
		minfin		= "";
	}

	
	
	public String getHorarioId() {
		return horarioId;
	}



	public void setHorarioId(String horarioId) {
		this.horarioId = horarioId;
	}


	public String getPeriodoId() {
		return periodoId;
	}



	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}


	public String getHoraInicio() {
		return horaInicio;
	}



	public void setHoraInicio(String horaInicio) {
		this.horaInicio = horaInicio;
	}



	public String getMinInicio() {
		return minInicio;
	}



	public void setMinInicio(String minInicio) {
		this.minInicio = minInicio;
	}



	public String getHorafin() {
		return horafin;
	}



	public void setHorafin(String horafin) {
		this.horafin = horafin;
	}



	public String getMinfin() {
		return minfin;
	}



	public void setMinfin(String minfin) {
		this.minfin = minfin;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_HORARIO_PERIODO" +
					"( HORARIO_ID, PERIODO_ID, HORA_INICIO, MINUTO_INICIO, HORA_FINAL, MINUTO_FINAL )" +
					" VALUES( TO_NUMBER(?,'99999'),TO_NUMBER(?, '99'), ?, ?, ?, ? )");
			
			ps.setString(1, horarioId);
			ps.setString(2, periodoId);
			ps.setString(3, horaInicio);
			ps.setString(4, minInicio);
			ps.setString(5, horafin);
			ps.setString(6, minfin);

			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioPeriodo|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_HORARIO_PERIODO " +
					" SET HORA_INICIO = ? ," +
					" MINUTO_INICIO = ? ," +
					" HORA_FINAL = ?, " +
					" MINUTO_FINAL = ? " +
					" WHERE HORARIO_ID = TO_NUMBER(?,'99999') " +
					" AND PERIODO_ID = TO_NUMBER(?, '99')");			
			
			ps.setString(1, horaInicio);
			ps.setString(2, minInicio);
			ps.setString(3, horafin);
			ps.setString(4, minfin);
			ps.setString(5, horarioId);
			ps.setString(6, periodoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioPeriodo|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_HORARIO_PERIODO" +
					" WHERE HORARIO_ID =  TO_NUMBER(?,'99999') " +
					" AND PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, horarioId);
			ps.setString(2, periodoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioPeriodo|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		horarioId	= rs.getString("HORARIO_ID");
		periodoId	= rs.getString("PERIODO_ID");
		horaInicio	= rs.getString("HORA_INICIO");
		horafin		= rs.getString("HORA_FINAL");
		minInicio	= rs.getString("MINUTO_INICIO");
		minfin		= rs.getString("MINUTO_FINAL");
	}
	
	public void mapeaRegId(Connection con, String horarioId, String periodoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT HORARIO_ID, PERIODO_ID," +
					" HORA_INICIO, MINUTO_INICIO,  " +
					" HORA_FINAL, MINUTO_FINAL " +
					" FROM CAT_HORARIO_PERIODO " +
					" WHERE HORARIO_ID = TO_NUMBER(?,'99999')" +
					" AND PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, horarioId);
			ps.setString(2, periodoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioPeriodo|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_HORARIO_PERIODO" +
					" WHERE HORARIO_ID = TO_NUMBER(?,'99999')" +
					" AND PERIODO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, horarioId);
			ps.setString(2, periodoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioPeriodo|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public boolean existeHorario(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_HORARIO_PERIODO" +
					" WHERE HORARIO_ID = TO_NUMBER(?,'99999')");
			ps.setString(1, horarioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioPeriodo|existeHorario|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
}
