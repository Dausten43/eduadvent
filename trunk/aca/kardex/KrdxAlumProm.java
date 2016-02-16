package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class KrdxAlumProm {
	
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String promedioId;
	private String nota;
	private String valor;
	
	public KrdxAlumProm(){
		
		codigoId 		= "";
		cicloGrupoId  	= "";
		cursoId 		= "";
		promedioId		= "";
		nota			= "";
		valor			= "";
	}

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getCicloGrupoId() {
		return cicloGrupoId;
	}

	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}

	public String getCursoId() {
		return cursoId;
	}

	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}

	public String getPromedioId() {
		return promedioId;
	}

	public void setPromedioId(String promedioId) {
		this.promedioId = promedioId;
	}

	public String getNota() {
		return nota;
	}

	public void setNota(String nota) {
		this.nota = nota;
	}
	
	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_PROM(CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO_ID, NOTA, VALOR)"
					+ " VALUES(?, ?, ?,"
					+ " TO_NUMBER(?, '99'),"
					+ " TO_NUMBER(?, '999.999'),"
					+ " TO_NUMBER(?, '999.99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			ps.setString(5, nota);
			ps.setString(6, valor);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumpRrom|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_PROM " +
					" SET " +
					" NOTA = TO_NUMBER(?,'999.999')," +
					" VALOR = TO_NUMBER(?,'999.99')"+
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?, '99')");			
			
			ps.setString(1, nota);
			ps.setString(2, valor);
			ps.setString(3, codigoId);			
			ps.setString(4, cicloGrupoId);
			ps.setString(5, cursoId);			
			ps.setString(6, promedioId);			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumpRrom|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_PROM " +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumpRrom|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		promedioId		= rs.getString("PROMEDIO_ID");
		nota			= rs.getString("NOTA");
		valor			= rs.getString("VALOR");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String promedioId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID," +
					" CURSO_ID, PROMEDIO_ID, NOTA, VALOR " +
					" FROM KRDX_ALUM_PROM" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?"+
					" AND PROMEDIO_ID = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumpRrom|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_PROM" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND PROMEDIO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, promedioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumProm|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
}
