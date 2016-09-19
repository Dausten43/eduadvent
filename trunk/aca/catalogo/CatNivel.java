/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Jose Torres
 *
 */
public class CatNivel {
	private String nivelId;
	private String nivelNombre;
	private String gradoIni;
	private String gradoFin;
	private String metodo;
	private String titulo;
	private String notaMinima;
	private String nombreCorto;
	
	public CatNivel(){
		nivelId		= "";
		nivelNombre	= "";
		gradoIni	= "1";
		gradoFin	= "6";
		metodo		= "";
		titulo		= "";
		notaMinima	= "";
		nombreCorto = "";
	}

	
	public String getNombreCorto() {
		return nombreCorto;
	}

	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
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
	 * @return the nivelNombre
	 */
	public String getNivelNombre() {
		return nivelNombre;
	}


	/**
	 * @param nivelNombre the nivelNombre to set
	 */
	public void setNivelNombre(String nivelNombre) {
		this.nivelNombre = nivelNombre;
	}


	/**
	 * @return the gradoIni
	 */
	public String getGradoIni() {
		return gradoIni;
	}


	/**
	 * @param gradoIni the gradoIni to set
	 */
	public void setGradoIni(String gradoIni) {
		this.gradoIni = gradoIni;
	}


	/**
	 * @return the gradoFin
	 */
	public String getGradoFin() {
		return gradoFin;
	}


	/**
	 * @param gradoFin the gradoFin to set
	 */
	public void setGradoFin(String gradoFin) {
		this.gradoFin = gradoFin;
	}


	/**
	 * @return the metodo
	 */
	public String getMetodo() {
		return metodo;
	}


	/**
	 * @param metodo the metodo to set
	 */
	public void setMetodo(String metodo) {
		this.metodo = metodo;
	}


	/**
	 * @return the titulo
	 */
	public String getTitulo() {
		return titulo;
	}


	/**
	 * @param titulo the titulo to set
	 */
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}


	
	public String getNotaMinima() {
		return notaMinima;
	}


	public void setNotaMinima(String notaMinima) {
		this.notaMinima = notaMinima;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_NIVEL " +
					"(NIVEL_ID, NIVEL_NOMBRE, GRADO_INI, GRADO_FIN, METODO, TITULO, NOTAMINIMA, NOMBRE_CORTO) " +
					"VALUES(TO_NUMBER(?, '99'), ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?,?,TO_NUMBER(?, '99'),?)");
			
			ps.setString(1, nivelId);
			ps.setString(2, nivelNombre);
			ps.setString(3, gradoIni);
			ps.setString(4, gradoFin);
			ps.setString(5, metodo);
			ps.setString(6, titulo);
			ps.setString(7, notaMinima);
			ps.setString(8, nombreCorto);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_NIVEL " +
					"SET NIVEL_NOMBRE = ?, " +
					"GRADO_INI = TO_NUMBER(?, '99'), " +
					"GRADO_FIN = TO_NUMBER(?, '99'), " +
					"METODO = ?, TITULO = ?, NOTAMINIMA = TO_NUMBER(?, '99'), " +
					"NOMBRE_CORTO = ?  "+
					"WHERE NIVEL_ID = TO_NUMBER(?, '99')");
			ps.setString(1, nivelNombre);
			ps.setString(2, gradoIni);
			ps.setString(3, gradoFin);
			ps.setString(4, metodo);
			ps.setString(5, titulo);
			ps.setString(6, notaMinima);
			ps.setString(7, nombreCorto);
			ps.setString(8, nivelId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_NIVEL" +
					" WHERE NIVEL_ID = TO_NUMBER(?, '99')");
			ps.setString(1, nivelId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		nivelId			= rs.getString("NIVEL_ID");
		nivelNombre		= rs.getString("NIVEL_NOMBRE");
		gradoIni		= rs.getString("GRADO_INI");
		gradoFin		= rs.getString("GRADO_FIN");
		metodo			= rs.getString("METODO");
		titulo			= rs.getString("TITULO");
		notaMinima		= rs.getString("NOTAMINIMA");
		nombreCorto		= rs.getString("NOMBRE_CORTO");
	}
	
	public void mapeaRegId(Connection con, String nivelId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT NIVEL_ID, NIVEL_NOMBRE, GRADO_INI, GRADO_FIN, METODO, TITULO, NOTAMINIMA, NOMBRE_CORTO " +
					" FROM CAT_NIVEL" +
					" WHERE NIVEL_ID = TO_NUMBER(?, '99')");
			ps.setString(1, nivelId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_NIVEL" +
					" WHERE NIVEL_ID = TO_NUMBER(?, '99')");
			ps.setString(1, nivelId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(NIVEL_ID)+1,'1') AS MAXIMO FROM CAT_NIVEL");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getNivelNombre(Connection conn, int nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT NIVEL_NOMBRE FROM CAT_NIVEL " +
					"WHERE NIVEL_ID = ?");
			ps.setInt(1, nivelId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("NIVEL_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
	
	public static String getNivelNombre(Connection conn, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT NIVEL_NOMBRE FROM CAT_NIVEL " +
					"WHERE NIVEL_ID = TO_NUMBER(?, '99')");
			ps.setString(1, nivelId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("NIVEL_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getNivelNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
	
	public static String getNivelNombreCorto(Connection conn, int nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT NOMBRE_CORTO FROM CAT_NIVEL " +
					"WHERE NIVEL_ID = ?");
			ps.setInt(1, nivelId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("NOMBRE_CORTO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getNivelNombreCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
	
	public static String getNivelNombreCorto(Connection conn, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= " ";
		
		try{
			ps = conn.prepareStatement("SELECT NOMBRE_CORTO FROM CAT_NIVEL " +
					"WHERE NIVEL_ID = TO_NUMBER(?, '99')");
			ps.setString(1, nivelId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("NOMBRE_CORTO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getNivelNombreCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
	
	public static String getTitulo(Connection conn, String nivelId) throws SQLException{
		
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String titulo		= "x";
		
		try{			
			comando = "SELECT TITULO FROM CAT_NIVEL WHERE NIVEL_ID = TO_NUMBER('"+nivelId+"','99')" ;
			rs = st.executeQuery(comando);
			if (rs.next()){
				titulo = rs.getString("TITULO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getTitulo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();			
		}
		
		return titulo;
	}
	
	public static String getGradoNombre(int grado) throws SQLException{		
		String strGrado			= "x";
		
		try{
			switch (grado){
			case 1: { strGrado = "PRIMER"; break; }
			case 2: { strGrado = "SEGUNDO"; break; }
			case 3: { strGrado = "TERCER"; break; }
			case 4: { strGrado = "CUARTO"; break; }
			case 5: { strGrado = "QUINTO"; break; }
			case 6: { strGrado = "SEXTO"; break; }
			case 7: { strGrado = "SEPTIMO"; break; }
			case 8: { strGrado = "OCTAVO"; break; }
			case 9: { strGrado = "NOVENO"; break; }
			case 10:{ strGrado = "DECIMO"; break; }
			case 11:{ strGrado = "UNDECIMO"; break; }
			case 12:{ strGrado = "DUODECIMO"; break; }
		} 
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getGradoNombre|:"+ex);
		}
		
		return strGrado;
	}
	
	public static String getGradoNombreCorto(int grado) throws SQLException{		
		String strGrado			= "-";
		
		try{
			switch (grado){
			case 1: { strGrado = "PRIMERO"; break; }
			case 2: { strGrado = "SEGUNDO"; break; }
			case 3: { strGrado = "TERCERO"; break; }
			case 4: { strGrado = "CUARTO"; break; }
			case 5: { strGrado = "QUINTO"; break; }
			case 6: { strGrado = "SEXTO"; break; }
			case 7: { strGrado = "SEPTIMO"; break; }
			case 8: { strGrado = "OCTAVO"; break; }
			case 9: { strGrado = "NOVENO"; break; }
			case 10:{ strGrado = "DECIMO"; break; }
			case 11:{ strGrado = "UNDECIMO"; break;}
			case 12:{ strGrado = "DUODECIMO"; break;}
		} 
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getGradoNombre|:"+ex);
		}
		
		return strGrado;
	}
	
	
	public static int getNivelId(Connection conn, String cursoId) throws SQLException{
		
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando			= "";
		int nivel 				= 0;
		
		try{
			comando = "SELECT NIVEL_ID FROM PLAN WHERE PLAN_ID " +
					" IN(SELECT PLAN_ID FROM PLAN_CURSO WHERE CURSO_ID = '"+cursoId+"' )";
			
			rs = st.executeQuery(comando);
			if(rs.next()){
				nivel = rs.getInt("NIVEL_ID");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getNivelId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return nivel;
	}
	
	public static String getMetodo(Connection conn, int nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String metodo			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT METODO FROM CAT_NIVEL " +
					"WHERE NIVEL_ID = ?");
			ps.setInt(1, nivelId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				metodo = rs.getString("METODO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivel|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return metodo;
	}
	
	public static boolean tienePlan(Connection conn, String nivelId, String escuelaId ) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		boolean ok 				= false;
		
		try{
			ps = conn.prepareStatement("SELECT PLAN_ID "+
					"FROM PLAN WHERE NIVEL_ID = TO_NUMBER(?, '99') AND ESCUELA_ID = ? "); 
			
			ps.setString(1, nivelId);
			ps.setString(2, escuelaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;	
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatFacultad|esDirector|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String getNotaMinima(Connection conn, String nivelId ) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String minima			= "5";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(NOTAMINIMA,5) AS MINIMA FROM CAT_NIVEL WHERE NIVEL_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, nivelId);
			
			rs = ps.executeQuery();
			if (rs.next())
				minima = rs.getString("MINIMA");
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatFacultad|esDirector|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return minima;
	}
	
}