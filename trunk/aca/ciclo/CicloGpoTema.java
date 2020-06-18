package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CicloGpoTema {

	private String cicloGrupoId;
	private String moduloId;
	private String temaId;
	private String temaNombre;
	private String descripcion;
	private String cursoId;
	private String orden;
	private String fecha;
	
	public CicloGpoTema(){
		cicloGrupoId	= "";
		moduloId		= "";
		temaId			= "";
		temaNombre		= "";
		descripcion		= "";
		cursoId			= "";
		orden 			= "";
		fecha 			= "";
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

	public String getModuloId() {
		return moduloId;
	}

	public void setModuloId(String moduloId) {
		this.moduloId = moduloId;
	}

	public String getTemaId() {
		return temaId;
	}

	public void setTemaId(String temaId) {
		this.temaId = temaId;
	}

	public String getTemaNombre() {
		return temaNombre;
	}

	public void setTemaNombre(String temaNombre) {
		this.temaNombre = temaNombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getOrden() {
		return orden;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public void setOrden(String orden) {
		this.orden = orden;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_TEMA" +
					" (CICLO_GRUPO_ID, MODULO_ID, TEMA_ID, TEMA_NOMBRE, DESCRIPCION, CURSO_ID, ORDEN, FECHA)" +
					" VALUES(?, ?, ?, ? , ?, ?, TO_NUMBER(?, '99.99'), to_date(?, 'dd/mm/yyyy'))");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, moduloId);
			ps.setString(3, temaId);
			ps.setString(4, temaNombre);
			ps.setString(5, descripcion);
			ps.setString(6, cursoId);
			ps.setString(7, orden);
			ps.setString(8, fecha);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean insertReg(Connection conn, String moduloId ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_TEMA" +
					" (CICLO_GRUPO_ID, MODULO_ID, TEMA_ID, TEMA_NOMBRE, DESCRIPCION, CURSO_ID, ORDEN, FECHA)" +
					" VALUES(?, ?, ?, ? , ?, ?, TO_NUMBER(?, '99.99'), to_date(?, 'dd/mm/yyyy'))");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, moduloId);
			ps.setString(3, temaId);
			ps.setString(4, temaNombre);
			ps.setString(5, descripcion);
			ps.setString(6, cursoId);
			ps.setString(7, orden);
			ps.setString(8, fecha);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO_TEMA" +
					" SET MODULO_ID = ?," +
					" TEMA_NOMBRE = ?," +
					" DESCRIPCION = ?, ORDEN = TO_NUMBER(?, '99.99'), fecha = to_date(?, 'dd/mm/yyyy') " +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TEMA_ID = ?" +
					" AND CURSO_ID = ? ");			
			ps.setString(1, moduloId);
			ps.setString(2, temaNombre);
			ps.setString(3, descripcion);
			ps.setString(4, orden);
			ps.setString(5, fecha);
			ps.setString(6, cicloGrupoId);
			ps.setString(7, temaId);
			ps.setString(8, cursoId);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	

	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_TEMA" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TEMA_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, temaId);
			ps.setString(3, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		moduloId		= rs.getString("MODULO_ID");
		temaId			= rs.getString("TEMA_ID");
		temaNombre		= rs.getString("TEMA_NOMBRE");
		descripcion		= rs.getString("DESCRIPCION");
		cursoId			= rs.getString("CURSO_ID");
		orden 			= rs.getString("ORDEN");
		fecha 			= rs.getString("FECHA");
		
	}
	
	public void mapeaRegId(Connection con, String cicloGrupoId, String temaId, String cursoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, MODULO_ID, TEMA_NOMBRE," +
					" TEMA_ID, DESCRIPCION, CURSO_ID, ORDEN, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA FROM CICLO_GRUPO_TEMA" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TEMA_ID = ? " +
					" AND CURSO_ID = ?");		
			ps.setString(1, cicloGrupoId);
			ps.setString(2, temaId);
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_TEMA" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND TEMA_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, temaId);
			ps.setString(3, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		String maximo 			= "01";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTRING(TEMA_ID,3,2),'99'))+1,'00')),'01') AS MAXIMO" +
					" FROM CICLO_GRUPO_TEMA " +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND MODULO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);			
			ps.setString(3, moduloId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				maximo = moduloId+rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	public String maximoOrden(Connection conn, String cicloGrupoId, String cursoId, String moduloId) throws SQLException{
		String maximo 			= "1.00";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT " +
					" COALESCE(MAX(ORDEN)+1, '1.00') AS MAXIMO " +
					" FROM CICLO_GRUPO_TEMA " +
					" WHERE CICLO_GRUPO_ID = ? " +
					" AND CURSO_ID = ? "+
					" AND MODULO_ID = ? ");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);		
			ps.setString(3, moduloId);
			
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|maximoOrden|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	public static String nombreTema(Connection conn, String cicloGrupoId, String cursoId, String temaId) throws SQLException{
				
		PreparedStatement ps	= null;
		ResultSet rs			= null;
		String tema 			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT TEMA_NOMBRE FROM CICLO_GRUPO_TEMA" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND TEMA_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			rs = ps.executeQuery();
			if (rs.next()){
				tema = rs.getString("TEMA_NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|nombreTema|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return tema;
	}
	
	public static int numTareas(Connection conn, String cicloGrupoId, String cursoId, String temaId) throws SQLException{
		
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		int numTareas			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(TAREA_ID) AS NUMTAREA FROM CICLO_GRUPO_TAREA " +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND TEMA_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, temaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				numTareas = rs.getInt("NUMTAREA");
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGpoTema|NumTareas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numTareas;
	}
			
}