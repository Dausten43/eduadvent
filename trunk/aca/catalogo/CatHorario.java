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
public class CatHorario {
	private String horarioId;
	private String horarioNombre;
	private String escuelaId;
	private String estado;
	
	public CatHorario(){
		horarioId		= "";
		horarioNombre 	= "";
		escuelaId		= "";
		estado			= "";
	}

	
	public String getHorarioId() {
		return horarioId;
	}


	public void setHorarioId(String horarioId) {
		this.horarioId = horarioId;
	}


	public String getHorarioNombre() {
		return horarioNombre;
	}


	public void setHorarioNombre(String horarioNombre) {
		this.horarioNombre = horarioNombre;
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

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_HORARIO" +
					"( HORARIO_NOMBRE, ESCUELA_ID,  ESTADO )" +
					" VALUES( ?,?,? )");
			
			ps.setString(1, horarioNombre);
			ps.setString(2, escuelaId);
			ps.setString(3, estado);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorario|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_HORARIO" +
					" SET HORARIO_NOMBRE = ?, " +
					" ESCUELA_ID = ?, " +
					" ESTADO = ? "+
					" WHERE HORARIO_ID = ? ");			
			
			
			ps.setString(1, horarioNombre);
			ps.setString(2, escuelaId);
			ps.setString(3, estado);
			ps.setLong(4,new Long(horarioId));
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorario|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_HORARIO" +
					" WHERE HORARIO_ID =  ? ");
			ps.setLong(1, new Long(horarioId));
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorario|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		horarioId		= rs.getString("HORARIO_ID");
		escuelaId		= rs.getString("ESCUELA_ID");
		horarioNombre	= rs.getString("HORARIO_NOMBRE");
		estado			= rs.getString("ESTADO");
	}
	
	public void mapeaRegId(Connection con, String horarioId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT HORARIO_ID, ESCUELA_ID," +
					" HORARIO_NOMBRE, ESTADO " +
					" FROM CAT_HORARIO" +
					" WHERE HORARIO_ID = TO_NUMBER(?,'99999')");
			ps.setString(1, horarioId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorario|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_HORARIO" +
					" WHERE HORARIO_ID = TO_NUMBER(?,'9999')" );
			ps.setString(1, horarioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorario|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public static String getHorarioNombre(Connection conn, String horarioId) throws SQLException{
		String resultado		= "";
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT HORARIO_NOMBRE FROM CAT_HORARIO" +
					" WHERE HORARIO_ID = ?" );
			ps.setString(1, horarioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				resultado = rs.getString("HORARIO_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorario|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return resultado;
	}
}
