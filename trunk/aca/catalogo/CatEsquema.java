
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatEsquema {
	private String escuelaId;
	private String nivelId;
	private String grado;
	private String esquemaEvaluacion;
	private String subNivel;
	private String gradoNombre;
	private String semestreNombre;
	
	public CatEsquema(){
		escuelaId			= "";
		nivelId				= "";
		grado				= "";
		esquemaEvaluacion 	= "";
		subNivel			= "";
		gradoNombre			= "";
		semestreNombre		= "";
	}


	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getNivelId() {
		return nivelId;
	}

	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}
	
	public String getGrado() {
		return grado;
	}

	public void setGrado(String grado) {
		this.grado = grado;
	}

	public String getEsquemaEvaluacion() {
		return esquemaEvaluacion;
	}

	public void setEsquemaEvaluacion(String esquemaEvaluacion) {
		this.esquemaEvaluacion = esquemaEvaluacion;
	}
	
	public String getSubNivel() {
		return subNivel;
	}


	public void setSubNivel(String subNivel) {
		this.subNivel = subNivel;
	}
	
	public String getGradoNombre() {
		return gradoNombre;
	}


	public void setGradoNombre(String gradoNombre) {
		this.gradoNombre = gradoNombre;
	}
	
	public String getSemestreNombre() {
		return semestreNombre;
	}

	public void setSemestreNombre(String semestreNombre) {
		this.semestreNombre = semestreNombre;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ESQUEMA " +
					" (ESCUELA_ID, NIVEL_ID, GRADO, ESQUEMA_EVALUACION, SUB_NIVEL, GRADO_NOMBRE, SEMESTRE_NOMBRE)" +
					" VALUES(?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?,TO_NUMBER(?, '99'),?,?)");
			
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, grado);
			ps.setString(4, esquemaEvaluacion);
			ps.setString(5, subNivel);
			ps.setString(6, gradoNombre);
			ps.setString(7, semestreNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquema|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_ESQUEMA" +
					" SET ESQUEMA_EVALUACION = ?, SUB_NIVEL = TO_NUMBER(?, '99'), GRADO_NOMBRE = ?, SEMESTRE_NOMBRE = ? " +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND GRADO = TO_NUMBER(?, '99') ");			
			
			ps.setString(1, esquemaEvaluacion);
			ps.setString(2, subNivel);
			ps.setString(3, gradoNombre);
			ps.setString(4, semestreNombre);
			ps.setString(5, escuelaId);
			ps.setString(6, nivelId);
			ps.setString(7, grado);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquema|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ESQUEMA" +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND GRADO = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, grado);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquema|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId			= rs.getString("ESCUELA_ID");
		nivelId				= rs.getString("NIVEL_ID");
		grado				= rs.getString("GRADO");
		esquemaEvaluacion	= rs.getString("ESQUEMA_EVALUACION");
		subNivel			= rs.getString("SUB_NIVEL");
		gradoNombre			= rs.getString("GRADO_NOMBRE");
		semestreNombre		= rs.getString("SEMESTRE_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String nivelId, String escuelaId, String grado) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, NIVEL_ID, GRADO, ESQUEMA_EVALUACION, SUB_NIVEL, GRADO_NOMBRE, SEMESTRE_NOMBRE " +
					" FROM CAT_ESQUEMA WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND GRADO = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, grado);
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacion|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_ESQUEMA WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99')  AND GRADO = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, grado);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquema|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static String getImagen(String nota) throws SQLException{
		String resultado = "";
		
		if(aca.util.Utilerias.isNumeric(nota)){
			nota = String.valueOf(new Double(nota).intValue());
		}
			
		if(nota.equals("10")){
			resultado = "/icon-ok.png";
		}else if(nota.equals("5")){
			resultado = "/icon-arrow-right.png";
		}else if(nota.equals("0")){
			resultado = "/icon-close.png";
		}else{
			resultado = "/transparent.png";
		}
		
		return resultado;
	}
	
	public static String getCaracter(String nota) throws SQLException{
		String resultado = "";
		
		if(aca.util.Utilerias.isNumeric(nota)){
			nota = String.valueOf(new Double(nota).intValue());
		}
		
		if(nota.equals("10")){
			resultado = "&#10004;";
		}else if(nota.equals("5")){
			resultado = "&#10140;";
		}else if(nota.equals("0")){
			resultado = "&#10006";
		}else{
			resultado = nota;
		}
		
		return resultado;
	}
	
	/* OBTIENE EL NOMBRE DEL GRADO EN EL NIVEL DE UNA ESCUELA */
	public static String getNombreGrado(Connection conn, String escuelaId, String nivelId, String grado) throws SQLException{
		
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String nombre			= "X"; 
		try{
			ps = conn.prepareStatement("SELECT COALESCE(GRADO_NOMBRE,'X') AS GRADO_NOMBRE FROM CAT_ESQUEMA WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?,'99') AND GRADO = TO_NUMBER(?,'99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, grado);
			rs = ps.executeQuery();
			if (rs.next())
				nombre = rs.getString("GRADO_NOMBRE");
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCurso|getPunto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nombre;
	}
	
}
