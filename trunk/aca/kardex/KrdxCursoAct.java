/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class KrdxCursoAct {
	private String codigoId;
	private String cicloGrupoId;
	private String cursoId;
	private String nota;
	private String fNota;
	private String tipoCalId;
	private String comentario;
	private String notaExtra;
	private String fExtra;
	private String notaExtra2;
	private String fExtra2;
	private String orden;
	
	public KrdxCursoAct(){
		codigoId		= "";
		cicloGrupoId	= "";
		cursoId			= "";
		nota			= "";
		fNota			= "";
		tipoCalId		= "";
		comentario		= "";
		notaExtra		= "";
		fExtra			= "";
		notaExtra2		= "";
		fExtra2			= "";
		orden 			= "0";
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
	 * @return Returns the codigoId.
	 */
	public String getCodigoId() {
		return codigoId;
	}
	
	/**
	 * @param codigoId The codigoId to set.
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	/**
	 * @return Returns the comentario.
	 */
	public String getComentario() {
		return comentario;
	}
	
	/**
	 * @param comentario The comentario to set.
	 */
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	/**
	 * @return Returns the cursoId.
	 */
	public String getCursoId() {
		return cursoId;
	}

	/**
	 * @param cursoId The cursoId to set.
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}

	/**
	 * @return Returns the fExtra.
	 */
	public String getFExtra() {
		return fExtra;
	}
	
	/**
	 * @param extra The fExtra to set.
	 */
	public void setFExtra(String extra) {
		fExtra = extra;
	}

	/**
	 * @return Returns the fNota.
	 */
	public String getFNota() {
		return fNota;
	}

	/**
	 * @param nota The fNota to set.
	 */
	public void setFNota(String nota) {
		fNota = nota;
	}

	/**
	 * @return Returns the nota.
	 */
	public String getNota() {
		return nota;
	}
	
	/**
	 * @param nota The nota to set.
	 */
	public void setNota(String nota) {
		this.nota = nota;
	}
	
	/**
	 * @return Returns the notaExtra.
	 */
	public String getNotaExtra() {
		return notaExtra;
	}

	/**
	 * @param notaExtra The notaExtra to set.
	 */
	public void setNotaExtra(String notaExtra) {
		this.notaExtra = notaExtra;
	}
	
	/**
	 * @return Returns the tipoCalId.
	 */
	public String getTipoCalId() {
		return tipoCalId;
	}
	
	/**
	 * @param tipoCalId The tipoCalId to set.
	 */
	public void setTipoCalId(String tipoCalId) {
		this.tipoCalId = tipoCalId;
	}
	
	public String getNotaExtra2() {
		return notaExtra2;
	}

	public void setNotaExtra2(String notaExtra2) {
		this.notaExtra2 = notaExtra2;
	}

	public String getfExtra2() {
		return fExtra2;
	}

	public void setfExtra2(String fExtra2) {
		this.fExtra2 = fExtra2;
	}	

	/**
	 * @return the orden
	 */
	public String getOrden() {
		return orden;
	}

	/**
	 * @param orden the orden to set
	 */
	public void setOrden(String orden) {
		this.orden = orden;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok 		= false;		
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("INSERT INTO KRDX_CURSO_ACT" +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, NOTA," +
					" F_NOTA, TIPOCAL_ID, COMENTARIO, NOTA_EXTRA, F_EXTRA, NOTA_EXTRA2, F_EXTRA2)" +
					" VALUES(?, ?, ?," +
					" TO_NUMBER(?, '999.9'), TO_DATE(?, 'DD/MM/YYYY'),TO_NUMBER(?, '99'), ?," +
					" TO_NUMBER(?, '999.9'), TO_DATE(?, 'DD/MM/YYYY'), TO_NUMBER(?, '999.9'), TO_DATE(?, 'DD/MM/YYYY') )");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			ps.setString(4, nota);
			ps.setString(5, fNota);
			ps.setString(6, tipoCalId);
			ps.setString(7, comentario);
			ps.setString(8, notaExtra);
			ps.setString(9, fExtra);
			ps.setString(10, notaExtra2);
			ps.setString(11, fExtra2);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean insertRegMateria(Connection conn ) throws SQLException{
		boolean ok 		= false;		
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("INSERT INTO KRDX_CURSO_ACT" +
					" (CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, TIPOCAL_ID)" +
					" VALUES(?, ?, ?, TO_NUMBER(?, '99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);			
			ps.setString(4, tipoCalId);			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|insertRegMateria|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateEstado(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_CURSO_ACT" +
					" SET TIPOCAL_ID = TO_NUMBER(?, '99') " +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");			
			
			ps.setString(1, tipoCalId);
			ps.setString(2, codigoId);
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|updateEstado|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateOrden(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_CURSO_ACT" +
					" SET ORDEN = TO_NUMBER(?, '999') " +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");			
			
			ps.setString(1, orden);
			ps.setString(2, codigoId);
			ps.setString(3, cicloGrupoId);
			ps.setString(4, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|updateOrden|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_CURSO_ACT" +
					" SET NOTA = TO_NUMBER(?, '999.9')," +
					" F_NOTA = TO_DATE(?, 'DD/MM/YYYY')," +
					" TIPOCAL_ID = TO_NUMBER(?, '99')," +
					" COMENTARIO = ?," +
					" NOTA_EXTRA = TO_NUMBER(?, '999.9')," +
					" F_EXTRA = TO_DATE(?, 'DD/MM/YYYY')," +
					" NOTA_EXTRA2 = TO_NUMBER(?, '999.9')," +
					" F_EXTRA2 = TO_DATE(?, 'DD/MM/YYYY')"+
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");			
			ps.setString(1, nota);
			ps.setString(2, fNota);
			ps.setString(3, tipoCalId);
			ps.setString(4, comentario);
			ps.setString(5, notaExtra);
			ps.setString(6, fExtra);
			ps.setString(7, notaExtra2);
			ps.setString(8, fExtra2);
			ps.setString(9, codigoId);
			ps.setString(10, cicloGrupoId);
			ps.setString(11, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_CURSO_ACT" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA TODOS LOS ALUMNOS REGISTRADOS EN EL GRUPO
	 * */
	public static boolean deleteAlumGrupo(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_CURSO_ACT" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			if ( ps.executeUpdate() >= 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|deleteAlumGrupo|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteRegInscripcion(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_CURSO_ACT" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|deleteRegInscripcion|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		nota			= rs.getString("NOTA");
		fNota			= rs.getString("F_NOTA");
		tipoCalId		= rs.getString("TIPOCAL_ID");
		comentario		= rs.getString("COMENTARIO");
		notaExtra		= rs.getString("NOTA_EXTRA");
		fExtra			= rs.getString("F_EXTRA");
		notaExtra2		= rs.getString("NOTA_EXTRA2");
		fExtra2			= rs.getString("F_EXTRA2");
		orden			= rs.getString("ORDEN");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, NOTA," +
					" TO_CHAR(F_NOTA, 'DD/MM/YYYY') AS F_NOTA, TIPOCAL_ID, COMENTARIO," +
					" NOTA_EXTRA, TO_CHAR(F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA, NOTA_EXTRA2, TO_CHAR(F_EXTRA2, 'DD/MM/YYYY') AS F_EXTRA2, ORDEN" +
					" FROM KRDX_CURSO_ACT" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_ACT" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);
			ps.setString(3, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoAct|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static boolean existeReg(Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_ACT "+
				"WHERE CODIGO_ID = ? "+
				"AND CICLO_GRUPO_ID = ?" +
				"AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);	
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|existeReg--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	public static boolean tieneAlumnos(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_ACT "+
				"WHERE CICLO_GRUPO_ID = ?" +
				"AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);	
			ps.setString(2, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|tieneAlumnos--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	public static int cantidadAlumnos(Connection conn, String cicloGrupoId) throws SQLException{
		
		PreparedStatement ps		= null;
		ResultSet 		rs			= null;
		int 			cantidad	= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(DISTINCT(CODIGO_ID)) FROM KRDX_CURSO_ACT" +
					" WHERE CICLO_GRUPO_ID = ?");
			ps.setString(1, cicloGrupoId);			
			
			rs = ps.executeQuery();
			if (rs.next())
				cantidad = rs.getInt(1);			
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|cantidadAlumnos--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return cantidad;
	}
	
	public static String cantidadAlumnos(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		String 			cantidad	= "";
		ResultSet 		rs			= null;
		PreparedStatement ps		= null;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(CODIGO_ID) FROM KRDX_CURSO_ACT" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);	
			ps.setString(2, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				cantidad = rs.getString(1);
			else
				cantidad = "0";
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|cantidadAlumnos--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return cantidad;
	}	
	
	public static boolean tieneMateriasAsignadas(Connection conn, String codigoId, String cicloId) throws SQLException{
		boolean	tieneMaterias	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_ACT" +
					" WHERE CICLO_GRUPO_ID LIKE ?||'%'" +
					" AND CODIGO_ID = ?");
			ps.setString(1, cicloId);	
			ps.setString(2, codigoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				tieneMaterias = true;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|tieneMateriasAsignadas--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return tieneMaterias;
	}
	
	public static boolean tieneMaterias(Connection conn, String codigoId) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps= null;
		 
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_ACT "+
				"WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|tieneMaterias--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	public static String getAlumGrupo(Connection conn, String codigoId, String cicloId, String grado) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;		
		String grupo 			= "x";		
		
		try{
			cicloId = cicloId+"%";			
			ps = conn.prepareStatement("SELECT DISTINCT(CICLO_GRUPO_ID) AS GRUPO FROM KRDX_CURSO_ACT "+
				" WHERE CODIGO_ID = ?" +
				" AND CICLO_GRUPO_ID LIKE ?" +
				" AND TIPOCAL_ID IN (1,2,3,4,5,6)" +
				" AND GRUPO_GRADO(CICLO_GRUPO_ID) = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			ps.setString(3, grado);
			
			rs = ps.executeQuery();
			if (rs.next())
				grupo = rs.getString("GRUPO");
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|getAlumGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return grupo;
	}
	
	public static String getAlumGrupo(Connection conn, String codigoId, String cicloId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;		
		String grupo 			= "x";		
		
		try{
			cicloId = cicloId+"%";
			ps = conn.prepareStatement("SELECT DISTINCT(CICLO_GRUPO_ID) AS GRUPO FROM KRDX_CURSO_ACT "+
				" WHERE CODIGO_ID = ?" +
				" AND CICLO_GRUPO_ID LIKE ?" +
				" AND TIPOCAL_ID IN (1,2,3,4,5,6)");
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			
			rs = ps.executeQuery();
			if (rs.next())
				grupo = rs.getString("GRUPO");
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|getAlumGrupo--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return grupo;
	}
	
	public static String getAlumPlan(Connection conn, String codigoId, String cicloId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;		
		String plan 			= "x";		
		
		try{
			cicloId = cicloId+"%";
			ps = conn.prepareStatement("SELECT DISTINCT(SUBSTR(CURSO_ID,1,6)) AS PLAN FROM KRDX_CURSO_ACT "+
				" WHERE CODIGO_ID = ?" +
				" AND CICLO_GRUPO_ID LIKE ?" +
				" AND TIPOCAL_ID IN (1,2,3,4,5,6)");
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			
			rs = ps.executeQuery();
			if (rs.next())
				plan = rs.getString("PLAN");
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|getAlumPlan--static|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return plan;
	}
	
	public static boolean getMatAlumTieneActiv(Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;		
		boolean	tieneNotas		= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_ACTIV" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");			
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);	
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				tieneNotas = true;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|getMatAlumTieneActiv|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return tieneNotas;
	}
	
	public static boolean getMatAlumTieneEval(Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;		
		boolean	tieneNotas		= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_ALUM_EVAL" +
					" WHERE CODIGO_ID = ?" +
					" AND CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);	
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				tieneNotas = true;
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|getMatAlumTieneEval|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return tieneNotas;
	}
	
	public static String getCantidadAlumnosConExtra(Connection conn, String escuelaId, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet 		rs		= null;		
		String  cantidad		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS CANTIDAD "
					+ " FROM KRDX_CURSO_ACT "
					+ " WHERE SUBSTR(CODIGO_ID,1,3) = ?"
					+ " AND CICLO_GRUPO_ID = ?"
					+ " AND CURSO_ID = ?"
					+ " AND NOTA < (SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = KRDX_CURSO_ACT.CURSO_ID) ");
			
			ps.setString(1, escuelaId);
			ps.setString(2, cicloGrupoId);	
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				cantidad = rs.getString("CANTIDAD");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|getCantidadAlumnosConExtra|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return cantidad;
	}
	
	public static boolean getAlumnoReprobado(Connection conn, String codigoId, String cicloGrupoId, String cursoId) throws SQLException{
		PreparedStatement ps		= null;
		ResultSet 		rs 			= null;		
		boolean	alumnoReprobado		= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_ACT"
					+ " WHERE CODIGO_ID = ?"
					+ " AND CICLO_GRUPO_ID = ?"
					+ " AND CURSO_ID = ?"
					+ " AND NOTA < (SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = KRDX_CURSO_ACT.CURSO_ID)");
			ps.setString(1, codigoId);
			ps.setString(2, cicloGrupoId);	
			ps.setString(3, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				alumnoReprobado = true;			
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoAct|getAlumnoReprobado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		return alumnoReprobado;
	}
	
}
