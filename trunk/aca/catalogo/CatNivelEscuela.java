
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatNivelEscuela {
	private String escuelaId;
	private String nivelId;
	private String notaminima;
	private String titulo;
	private String gradoIni;
	private String gradoFin;
	private String nivelNombre;
	private String peso;
	private String funcionId;
	private String director;
	private String registro;
	
	public CatNivelEscuela(){
		escuelaId			= "";
		nivelId				= "";
		notaminima			= "";
		titulo 				= "";
		gradoIni			= "";
		gradoFin			= "";
		nivelNombre			= "";
		peso				= "";
		funcionId			= "";
		director			= "";
		registro            = "";
	}


	public String getRegistro() {
		return registro;
	}


	public void setRegistro(String registro) {
		this.registro = registro;
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

	public String getNotaminima() {
		return notaminima;
	}

	public void setNotaminima(String notaminima) {
		this.notaminima = notaminima;
	}
	
	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getGradoIni() {
		return gradoIni;
	}

	public void setGradoIni(String gradoIni) {
		this.gradoIni = gradoIni;
	}

	public String getGradoFin() {
		return gradoFin;
	}

	public void setGradoFin(String gradoFin) {
		this.gradoFin = gradoFin;
	}

	public String getNivelNombre() {
		return nivelNombre;
	}

	public void setNivelNombre(String nivelNombre) {
		this.nivelNombre = nivelNombre;
	}
	
	public String getPeso() {
		return peso;
	}

	public void setPeso(String peso) {
		this.peso = peso;
	}
	
	public String getFuncionId() {
		return funcionId;
	}

	public void setFuncionId(String funcionId) {
		this.funcionId = funcionId;
	}

	public String getDirector() {
		return director;
	}


	public void setDirector(String director) {
		this.director = director;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_NIVEL_ESCUELA " +
					" (ESCUELA_ID, NIVEL_ID, NOTAMINIMA, GRADO_INI, GRADO_FIN, NIVEL_NOMBRE, TITULO, PESO, FUNCION_ID, DIRECTOR, REGISTRO)" +
					" VALUES(?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?, ?, TO_NUMBER(?, '99'), ?, ?, ?)");
			
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, notaminima);
			ps.setString(4, gradoIni);
			ps.setString(5, gradoFin);
			ps.setString(6, nivelNombre);
			ps.setString(7, titulo);
			ps.setString(8, peso);
			ps.setString(9, funcionId);
			ps.setString(10,director);
		    ps.setString(11, registro);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.catNivelEscuela|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_NIVEL_ESCUELA" +
					" SET NOTAMINIMA = TO_NUMBER(?, '99'), GRADO_INI = TO_NUMBER(?, '99'), GRADO_FIN = TO_NUMBER(?, '99'), NIVEL_NOMBRE = ?, TITULO = ?, PESO = TO_NUMBER(?, '99'), FUNCION_ID = ?, DIRECTOR = ?, REGISTRO = ? " +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') ");			
			ps.setString(1, notaminima);
			ps.setString(2, gradoIni);
			ps.setString(3, gradoFin);
			ps.setString(4, nivelNombre);
			ps.setString(5, titulo);
			ps.setString(6, peso);
			ps.setString(7, funcionId);
			ps.setString(8,director);
			ps.setString(9, registro);
			ps.setString(10, escuelaId);
			ps.setString(11, nivelId);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_NIVEL_ESCUELA" +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId			= rs.getString("ESCUELA_ID");
		nivelId				= rs.getString("NIVEL_ID");
		notaminima			= rs.getString("NOTAMINIMA");
		gradoIni			= rs.getString("GRADO_INI");
		gradoFin			= rs.getString("GRADO_FIN");
		nivelNombre			= rs.getString("NIVEL_NOMBRE");
		titulo				= rs.getString("TITULO");
		peso				= rs.getString("PESO");
		funcionId			= rs.getString("FUNCION_ID");
		director			= rs.getString("DIRECTOR");
		registro			= rs.getString("REGISTRO");
	}
	
	public void mapeaRegId(Connection con, String nivelId, String escuelaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT * " +
					" FROM CAT_NIVEL_ESCUELA WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			
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
			ps = conn.prepareStatement("SELECT * FROM CAT_NIVEL_ESCUELA WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static String getNotaMinima(Connection conn, String nivelId, String escuelaId ) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String minima			= "5";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(NOTAMINIMA,5) AS MINIMA FROM CAT_NIVEL_ESCUELA WHERE NIVEL_ID = TO_NUMBER(?, '99') AND ESCUELA_ID = ? ");	
			ps.setString(1, nivelId);
			ps.setString(2, escuelaId);
			
			rs = ps.executeQuery();
			if (rs.next())
				minima = rs.getString("MINIMA");
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|getNotaMinima|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return minima;
	}
	
	
	public static String getNivelNombre(Connection conn, String escuelaId, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "-";
		
		if(nivelId.equals("")){
			nivelId = "-1";
		}
		
		try{
			ps = conn.prepareStatement("SELECT NIVEL_NOMBRE FROM CAT_NIVEL_ESCUELA " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') AND ESCUELA_ID = '"+escuelaId+"' ");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("NIVEL_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|getNivelNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
	
	
	public static String getTitulo(Connection conn, String escuelaId, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "-";
		
		try{
			ps = conn.prepareStatement("SELECT TITULO FROM CAT_NIVEL_ESCUELA " +
					"WHERE NIVEL_ID = TO_NUMBER(?, '99') AND ESCUELA_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("TITULO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|getTitulo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
	
	public static String getPeso(Connection conn, String escuelaId, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "-";
		
		try{
			ps = conn.prepareStatement("SELECT PESO FROM CAT_NIVEL_ESCUELA " +
					"WHERE NIVEL_ID = TO_NUMER(?, '99') AND ESCUELA_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("PESO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|getPeso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
	
	public static String getFuncionId(Connection conn, String escuelaId, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String funcion			= "";
		
		try{
			ps = conn.prepareStatement("SELECT FUNCION_ID FROM CAT_NIVEL_ESCUELA " +
					"WHERE NIVEL_ID = TO_NUMBER(?, '99') AND ESCUELA_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				funcion = rs.getString("FUNCION_ID");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|getFuncionId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return funcion;
	}
	
	
	public static String getDirector(Connection conn, String escuelaId, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String funcion			= "";
		
		try{
			ps = conn.prepareStatement("SELECT DIRECTOR FROM CAT_NIVEL_ESCUELA " +
					"WHERE NIVEL_ID = TO_NUMBER(?, '99') AND ESCUELA_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				funcion = rs.getString("DIRECTOR");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|getDirector|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return funcion;
	}
	
	public static String getRegistro(Connection conn, String escuelaId, String nivelId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String funcion			= "";
		
		try{
			ps = conn.prepareStatement("SELECT REGISTRO FROM CAT_NIVEL_ESCUELA " +
					"WHERE NIVEL_ID = TO_NUMBER(?, '99') AND ESCUELA_ID = ?");
			ps.setString(1, nivelId);
			ps.setString(2, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				funcion = rs.getString("REGISTRO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuela|getRegistro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return funcion;
	}
	
	
}
