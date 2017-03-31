/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class KrdxAlumExtra {
	
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String oportunidad;
	private String notaAnterior;
	private String notaExtra;
	private String promedio;
	private String fecha;
	
	public KrdxAlumExtra(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		oportunidad		= "";
		notaAnterior	= "";
		notaExtra		= "";
		promedio		= "";
		fecha			= "";
	}
		
	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
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
	
	public String getOportunidad() {
		return oportunidad;
	}

	public void setOportunidad(String oportunidad) {
		this.oportunidad = oportunidad;
	}

	public String getNotaAnterior() {
		return notaAnterior;
	}

	public void setNotaAnterior(String notaAnterior) {
		this.notaAnterior = notaAnterior;
	}

	public String getNotaExtra() {
		return notaExtra;
	}

	public void setNotaExtra(String notaExtra) {
		this.notaExtra = notaExtra;
	}

	public String getPromedio() {
		return promedio;
	}

	public void setPromedio(String promedio) {
		this.promedio = promedio;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_ALUM_EXTRA " +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, OPORTUNIDAD, NOTA_ANTERIOR, NOTA_EXTRA, PROMEDIO, FECHA)" +
					" VALUES(?, ?, ?," +
					" TO_NUMBER(?, '99'), TO_NUMBER(?, '999.99'),TO_NUMBER(?, '999.99'), TO_NUMBER(?, '999.99'), TO_DATE(?, 'DD/MM/YYYY'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, oportunidad);
			ps.setString(5, notaAnterior);
			ps.setString(6, notaExtra);
			ps.setString(7, promedio);
			ps.setString(8, fecha);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtra|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_ALUM_EXTRA " +
					" SET " +
					" NOTA_ANTERIOR = TO_NUMBER(?,'999.99')," +
					" NOTA_EXTRA = TO_NUMBER(?,'999.99'), "+
					" PROMEDIO = TO_NUMBER(?,'999.99'),"+
					" FECHA    = TO_DATE(?, 'DD/MM/YYYY')"+
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND OPORTUNIDAD = TO_NUMBER(?, '99')");			
			
			ps.setString(1, notaAnterior);
			ps.setString(2, notaExtra);	
			ps.setString(3, promedio);
			ps.setString(4, fecha);
			ps.setString(5, codigoId);
			ps.setString(6, cicloGrupoId);
			ps.setString(7, cursoId);
			ps.setString(8, oportunidad);
						
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtra|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_EXTRA " +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND OPORTUNIDAD = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, oportunidad);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtra|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		oportunidad		= rs.getString("OPORTUNIDAD");
		notaAnterior	= rs.getString("NOTA_ANTERIOR");
		notaExtra		= rs.getString("NOTA_EXTRA");
		promedio		= rs.getString("PROMEDIO");
		fecha    		= rs.getString("FECHA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId, String oportunidad) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID," +
					" CURSO_ID, OPORTUNIDAD, NOTA_ANTERIOR, NOTA_EXTRA, PROMEDIO, FECHA " +
					" FROM KRDX_ALUM_EXTRA" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?"+
					" AND OPORTUNIDAD = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, oportunidad);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtra|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EXTRA" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND OPORTUNIDAD = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, oportunidad);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtra|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static boolean tieneExtras(Connection conn, String codigoId, String cicloGrupoId, String cursoId ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EXTRA" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtra|tieneExtras|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String getPromedio(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String oportunidad ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String promedio 		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT PROMEDIO FROM KRDX_ALUM_EXTRA"
					+ " WHERE CODIGO_ID = ?"
					+ " AND CICLO_GRUPO_ID = ?"
					+ " AND CURSO_ID = ?"
					+ " AND OPORTUNIDAD = TO_NUMBER(?,'99')");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, oportunidad);
			
			rs = ps.executeQuery();		
			if(rs.next()){
				promedio = rs.getString("PROMEDIO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumExtra|getPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return promedio;
	}
	
	public ArrayList<KrdxAlumExtra> getAlumnoExtra(Connection con, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		ArrayList<KrdxAlumExtra> lisAlumnoExtra = new ArrayList<KrdxAlumExtra>();
		Statement st 		= con.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID," +
					" CURSO_ID, OPORTUNIDAD, NOTA_ANTERIOR, NOTA_EXTRA, PROMEDIO, FECHA " +
					" FROM KRDX_ALUM_EXTRA" +
					" WHERE CODIGO_ID ='"+codigoId+"'"+
					" AND CICLO_GRUPO_ID ='"+cicloGrupoId+"'"+
					" AND CURSO_ID = '"+cursoId+"'";
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumExtra alumno = new KrdxAlumExtra();				
				alumno.mapeaReg(rs);
				lisAlumnoExtra.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.krdxAlumExtra|getAlumnoExtra:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisAlumnoExtra;
	}
	
	public static HashMap<String, KrdxAlumExtra> mapAlumnoExtra(Connection con) throws SQLException{
		HashMap<String,KrdxAlumExtra> map 			= new HashMap<String, KrdxAlumExtra>();
		Statement st 								= con.createStatement();
		ResultSet rs 								= null;
		String comando								= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID," +
					" CURSO_ID, OPORTUNIDAD, NOTA_ANTERIOR, NOTA_EXTRA, PROMEDIO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA " +
					" FROM KRDX_ALUM_EXTRA";
			rs = st.executeQuery(comando);			
			while (rs.next()){
				KrdxAlumExtra kae = new KrdxAlumExtra();		
				kae.mapeaReg(rs);
				map.put(rs.getString("CODIGO_ID")+rs.getString("CICLO_GRUPO_ID")+rs.getString("CURSO_ID")+rs.getString("OPORTUNIDAD"), kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.krdxAlumExtra|getAlumnoExtra|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}	
	
}
