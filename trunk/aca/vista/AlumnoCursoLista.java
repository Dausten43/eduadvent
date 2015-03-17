/**
 * 
 */
package aca.vista;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author Elifo
 *
 */
public class AlumnoCursoLista {
	public ArrayList<AlumnoCurso> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<AlumnoCurso> lisAlumno 	= new ArrayList<AlumnoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, CAL1, CAL2, CAL3, CAL4, CAL5, CAL6,CAL7,CAL8,CAL9,CAL10," +
					" TO_CHAR(NOTA, '999.9') AS NOTA, TO_CHAR(F_NOTA, 'DD/MM/YY') AS F_NOTA," +
					" TO_CHAR(NOTA_EXTRA, '999.9') AS NOTA_EXTRA," +
					" TO_CHAR(F_EXTRA, 'DD/MM/YY') AS F_EXTRA," +
					" TIPOCAL_ID, COMENTARIO, CICLO_ID," +
					" FALTA1, FALTA2, FALTA3, FALTA4, FALTA5,FALTA6,FALTA7,FALTA8,FALTA9,FALTA10" +
					" FROM ALUMNO_CURSO " +
					" WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"' "+orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumnoCurso ac = new AlumnoCurso();				
				ac.mapeaReg(rs);
				lisAlumno.add(ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCursoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisAlumno;
	}
	
	public ArrayList<AlumnoCurso> getListCurso(Connection conn, String cursoId, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<AlumnoCurso> lisAlumno 	= new ArrayList<AlumnoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT DISTINCT(CODIGO_ID) AS CODIGO_ID, ALUM_APELLIDO(CODIGO_ID), CICLO_GRUPO_ID, CURSO_ID," +
					" CAL1, CAL2, CAL3, CAL4, CAL5, CAL6,CAL7,CAL8,CAL9,CAL10," +
					" NOTA, F_NOTA, NOTA_EXTRA, F_EXTRA, TIPOCAL_ID, COMENTARIO, CICLO_ID," +
					" FALTA1, FALTA2, FALTA3, FALTA4, FALTA5,FALTA6,FALTA7,FALTA8,FALTA9,FALTA10" +
					" FROM ALUMNO_CURSO" +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'"+
					" AND CURSO_ID = '"+cursoId+"' "+orden;
			System.out.println("Comando:"+comando);
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumnoCurso ac = new AlumnoCurso();				
				ac.mapeaReg(rs);
				lisAlumno.add(ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCursoLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisAlumno;
	}
	
	public ArrayList<AlumnoCurso> getListAlumCurso(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<AlumnoCurso> lisAlumno 	= new ArrayList<AlumnoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, ALUM_APELLIDO(CODIGO_ID), CICLO_GRUPO_ID, CURSO_ID,"
					+ " CAL1, CAL2, CAL3, CAL4, CAL5, CAL6,CAL7,CAL8,CAL9,CAL10,"
					+ " NOTA, TO_CHAR(F_NOTA,'DD/MM/YYYY') AS F_NOTA, NOTA_EXTRA,"
					+ " TO_CHAR(F_EXTRA,'DD/MM/YYYY') AS F_EXTRA, TIPOCAL_ID, COMENTARIO, CICLO_ID,"
					+ " FALTA1, FALTA2, FALTA3, FALTA4, FALTA5, FALTA6, FALTA7, FALTA8, FALTA9, FALTA10"
					+ " FROM ALUMNO_CURSO"
					+ " WHERE CODIGO_ID = '"+codigoId+"' " + orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumnoCurso ac = new AlumnoCurso();
				ac.mapeaReg(rs);
				lisAlumno.add(ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCursoLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisAlumno;
	}
	
	public ArrayList<AlumnoCurso> getListAlumCurso(Connection conn, String codigoId, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<AlumnoCurso> lisAlumno 	= new ArrayList<AlumnoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, ALUM_APELLIDO(CODIGO_ID), CICLO_GRUPO_ID, CURSO_ID,"
					+ " CAL1, CAL2, CAL3, CAL4, CAL5, CAL6, CAL7, CAL8, CAL9, CAL10,"
					+ " NOTA, TO_CHAR(F_NOTA,'DD/MM/YYYY') AS F_NOTA, NOTA_EXTRA,"
					+ " TO_CHAR(F_EXTRA,'DD/MM/YYYY') AS F_EXTRA, TIPOCAL_ID, COMENTARIO, CICLO_ID,"
					+ " FALTA1, FALTA2, FALTA3, FALTA4, FALTA5, FALTA6, FALTA7, FALTA8, FALTA9, FALTA10"
					+ " FROM ALUMNO_CURSO"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumnoCurso ac = new AlumnoCurso();
				ac.mapeaReg(rs);
				lisAlumno.add(ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCursoLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisAlumno;
	}
	
	public static HashMap<String, AlumnoCurso> getMapNotas(Connection conn, String codigoId, String cicloGrupoId ) throws SQLException{
		
		HashMap<String,AlumnoCurso> lista = new HashMap<String,AlumnoCurso>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " select * from alumno_curso " +
					" where codigo_id = '"+codigoId+"' "+
					" and ciclo_grupo_id = '"+cicloGrupoId+"'  ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumnoCurso obj = new AlumnoCurso();
				obj.mapeaReg(rs);
				llave = obj.getCursoId();
				lista.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCursoLista|getMapNotas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lista;
	}
	
	public static HashMap <String, AlumnoCurso> getMapNotas(Connection conn, String codigoId ) throws SQLException{
		
		HashMap<String,AlumnoCurso> lista = new HashMap<String,AlumnoCurso>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " select * from alumno_curso " +
					" where codigo_id = '"+codigoId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumnoCurso obj = new AlumnoCurso();
				obj.mapeaReg(rs);
				llave = obj.getCursoId();
				lista.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCursoLista|getMapNotas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lista;
	}
}
