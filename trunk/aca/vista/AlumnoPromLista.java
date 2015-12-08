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
import java.util.TreeMap;

/**
 * @author Jose Torres
 *
 */
public class AlumnoPromLista {
	public ArrayList<AlumnoProm> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<AlumnoProm> lisAlumno 	= new ArrayList<AlumnoProm>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO, PUNTOS_EVAL, PUNTOS_ALUM,PUNTOS_AJUSTE" +
				" FROM ALUMNO_PROM" +
				" WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumnoProm ac = new AlumnoProm();			
				ac.mapeaReg(rs);
				lisAlumno.add(ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoPromLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisAlumno;
	}
	
	public TreeMap<String,AlumnoProm> getTreeCurso(Connection conn, String cicloGrupoId, String orden ) throws SQLException{
		TreeMap<String,AlumnoProm> treeProm 	= new TreeMap<String,AlumnoProm>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO, PUNTOS_EVAL, PUNTOS_ALUM, PUNTOS_AJUSTE" +
				" FROM ALUMNO_PROM" +
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				AlumnoProm ac = new AlumnoProm();				
				ac.mapeaReg(rs);
				llave = ac.getCicloGrupoId()+ac.getCursoId()+ac.getCodigoId();
				treeProm.put(llave, ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoPromLista|getTreeCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return treeProm;
	}
	
	public TreeMap<String,AlumnoProm> getTreeCurso(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		TreeMap<String,AlumnoProm> treeProm 	= new TreeMap<String,AlumnoProm>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO, PUNTOS_EVAL, PUNTOS_ALUM, PUNTOS_AJUSTE" +
				" FROM ALUMNO_PROM" +
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
				" AND CURSO_ID = '"+cursoId+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				AlumnoProm ac = new AlumnoProm();		
				ac.mapeaReg(rs);
				llave = ac.getCicloGrupoId()+ac.getCursoId()+ac.getCodigoId();
				treeProm.put(llave, ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoPromLista|getTreeCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return treeProm;
	}
	
	public TreeMap<String,AlumnoProm> getTreeAlumno(Connection conn, String codigoId, String orden ) throws SQLException{
		TreeMap<String,AlumnoProm> treeProm 	= new TreeMap<String,AlumnoProm>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO, PUNTOS_EVAL, PUNTOS_ALUM, PUNTOS_AJUSTE" +
				" FROM ALUMNO_PROM" +
				" WHERE CODIGO_ID = '"+codigoId+"' " +orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				AlumnoProm ac = new AlumnoProm();		
				ac.mapeaReg(rs);
				llave = ac.getCicloGrupoId()+ac.getCursoId()+ac.getCodigoId();
				treeProm.put(llave, ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoPromLista|getTreeAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return treeProm;
	}
	
	
	public HashMap<String,AlumnoProm> mapAlumProm(Connection conn, String codigoId, String orden ) throws SQLException{
		HashMap<String,AlumnoProm> mapAlumProm 	= new HashMap<String,AlumnoProm>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO, PUNTOS_EVAL, PUNTOS_ALUM, PUNTOS_AJUSTE" +
				" FROM ALUMNO_PROM" +
				" WHERE CODIGO_ID = '"+codigoId+"' " +orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				AlumnoProm ac = new AlumnoProm();		
				ac.mapeaReg(rs);
				llave = ac.getCursoId()+ac.getCodigoId();
				mapAlumProm.put(llave, ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoPromLista|getTreeAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapAlumProm;
	}
	
	
	
}
