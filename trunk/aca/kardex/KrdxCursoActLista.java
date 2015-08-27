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
import java.util.TreeMap;
import java.util.HashMap;

/**
 * @author Elifo
 *
 */
public class KrdxCursoActLista {
	
	public ArrayList<KrdxCursoAct> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<KrdxCursoAct> lisCiclo 	= new ArrayList<KrdxCursoAct>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, ALUM_APELLIDO(CODIGO_ID)," +
                " COALESCE(NOTA,0) AS NOTA, TO_CHAR(F_NOTA, 'DD/MM/YYYY') AS F_NOTA," +
                " TIPOCAL_ID, COMENTARIO, NOTA_EXTRA," +
                " TO_CHAR(F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA,"+ 
                " NOTA_EXTRA2," +
                " TO_CHAR(F_EXTRA2, 'DD/MM/YYYY') AS F_EXTRA2, ORDEN" +
                " FROM KRDX_CURSO_ACT " +
                " WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"' " +orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				KrdxCursoAct kardex = new KrdxCursoAct();		
				kardex.mapeaReg(rs);
				lisCiclo.add(kardex);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();	
		}
		
		return lisCiclo;
	}
	
	public TreeMap<String,KrdxCursoAct> getTreeAlumnoCurso(Connection conn, String cicloGrupoId, String orden ) throws SQLException{
		TreeMap<String,KrdxCursoAct> treeCurso 	= new TreeMap<String,KrdxCursoAct>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
            " NOTA, TO_CHAR(F_NOTA, 'DD/MM/YYYY') AS F_NOTA," +
            " TIPOCAL_ID, COMENTARIO, NOTA_EXTRA," +
            " TO_CHAR(F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA," +
            " NOTA_EXTRA2," +
            " TO_CHAR(F_EXTRA2, 'DD/MM/YYYY') AS F_EXTRA2, ORDEN" +
            " FROM KRDX_CURSO_ACT " +
            " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' " +orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				KrdxCursoAct kardex = new KrdxCursoAct();				
				kardex.mapeaReg(rs);
				llave = kardex.getCicloGrupoId()+kardex.getCursoId()+kardex.getCodigoId();
				treeCurso.put(llave, kardex);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|getTreeAlumnoCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return treeCurso;
	}	
	
	public ArrayList<String> getListAlumnosGrupo(Connection conn, String cicloGrupoId ) throws SQLException{
		ArrayList<String> lisNombres 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT DISTINCT(CODIGO_ID) AS CODIGO, ALUM_APELLIDO(CODIGO_ID) " +
					" FROM KRDX_CURSO_ACT" +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" ORDER BY ALUM_APELLIDO(CODIGO_ID) ";
			rs = st.executeQuery(comando);			
			while (rs.next()){
				lisNombres.add(rs.getString("CODIGO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|getListAlumnosGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();	
		}
		
		return lisNombres;
	}
	
	public ArrayList<KrdxCursoAct> getListAlumnosGrupo(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		ArrayList<KrdxCursoAct> lista 	= new ArrayList<KrdxCursoAct>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID,"
                + " NOTA, TO_CHAR(F_NOTA, 'DD/MM/YYYY') AS F_NOTA,"
                + " TIPOCAL_ID, COMENTARIO, NOTA_EXTRA,"
                + " TO_CHAR(F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA,"
                + " NOTA_EXTRA2,"
                + " TO_CHAR(F_EXTRA2, 'DD/MM/YYYY') AS F_EXTRA2, ORDEN"
                + " FROM KRDX_CURSO_ACT" 
				+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'"
				+ " AND CURSO_ID = '"+cursoId+"' " + orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				KrdxCursoAct kardex = new KrdxCursoAct();
				kardex.mapeaReg(rs);				
				lista.add(kardex);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|getListAlumnosGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();	
		}
		
		return lista;
	}
	
	public ArrayList<KrdxCursoAct> getListAlumMat(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		ArrayList<KrdxCursoAct> lista 	= new ArrayList<KrdxCursoAct>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " NOTA, TO_CHAR(F_NOTA, 'DD/MM/YYYY') AS F_NOTA," +
                " TIPOCAL_ID, COMENTARIO, NOTA_EXTRA," +
                " TO_CHAR(F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA," +
                " NOTA_EXTRA2," +
                " TO_CHAR(F_EXTRA2, 'DD/MM/YYYY') AS F_EXTRA2, ORDEN" +
                " FROM KRDX_CURSO_ACT " +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"' " +
                " AND TIPOCAL_ID IN(1,2,3,4,5) " +orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				KrdxCursoAct kardex = new KrdxCursoAct();		
				kardex.mapeaReg(rs);
				lista.add(kardex);
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|getListAlumMat|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();	
		}
		
		return lista;
	}
	
	public ArrayList<KrdxCursoAct> getLisCursosAlumno(Connection conn, String codigoId, String cicloGrupodId, String orden ) throws SQLException{
		ArrayList<KrdxCursoAct> lista 	= new ArrayList<KrdxCursoAct>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " NOTA, TO_CHAR(F_NOTA, 'DD/MM/YYYY') AS F_NOTA," +
                " TIPOCAL_ID, COMENTARIO, NOTA_EXTRA," +
                " TO_CHAR(F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA," +
                " NOTA_EXTRA2," +
                " TO_CHAR(F_EXTRA2, 'DD/MM/YYYY') AS F_EXTRA2, ORDEN" +
                " FROM KRDX_CURSO_ACT " +
                " WHERE CODIGO_ID = '"+codigoId+"' AND CICLO_GRUPO_ID='"+cicloGrupodId+"' " +orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				KrdxCursoAct kardex = new KrdxCursoAct();
				kardex.mapeaReg(rs);
				lista.add(kardex);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|getCursosAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();	
		}
		
		return lista;
	}
	
	public TreeMap<String, String> treeCantidadAlumnos(Connection conn, String cicloId) throws SQLException{
		TreeMap<String,String> treeCurso 	= new TreeMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, CURSO_ID, COUNT(CODIGO_ID) AS ALUMNOS "
					+ " FROM KRDX_CURSO_ACT"
					+ " WHERE SUBSTRING(CICLO_GRUPO_ID,0,9) = '"+cicloId+"' "
					+ " GROUP BY CICLO_GRUPO_ID, CURSO_ID ";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				treeCurso.put(rs.getString("CICLO_GRUPO_ID")+"@@"+rs.getString("CURSO_ID"), rs.getString("ALUMNOS"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|cantidadAlumnos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return treeCurso;
	}	
	
	public static ArrayList<String> getAlumGrupos(Connection conn, String codigoId, String cicloId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs			= null;
		ArrayList<String> list	= new ArrayList<String>();
		
		try{
			cicloId = cicloId+"%";			
			ps = conn.prepareStatement("SELECT DISTINCT(CICLO_GRUPO_ID) AS GRUPO FROM KRDX_CURSO_ACT "+
				" WHERE CODIGO_ID = ?" +
				" AND CICLO_GRUPO_ID LIKE ?" +
				" AND TIPOCAL_ID IN (1,2,3,4,5,6)");
			
			ps.setString(1, codigoId);
			ps.setString(2, cicloId);
			
			rs = ps.executeQuery();
			while(rs.next()){
				list.add(rs.getString("GRUPO"));
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.krdx.KrdxCursoActLista|getAlumGrupos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return list;
	}
	
	public static ArrayList<String> getMateriasDeBaja(Connection conn, String cicloGrupoId, String codigoId, String orden) throws SQLException{
		ArrayList<String> list 		 	= new ArrayList<String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{
			comando = "SELECT CURSO_ID" +
            " FROM KRDX_CURSO_ACT " +
            " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CODIGO_ID = '"+codigoId+"' AND TIPOCAL_ID = 6 " +orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				list.add(rs.getString("CURSO_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|getMateriasDeBaja|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return list;
	}
	
	public static HashMap<String, String> mapAlumnosCicloGrupoId(Connection conn, String cicloId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, COUNT( DISTINCT(CODIGO_ID) ) AS CANTIDAD "
					+ " FROM KRDX_CURSO_ACT "
					+ " WHERE CICLO_GRUPO_ID LIKE '"+cicloId+"%'"
					+ " GROUP BY CICLO_GRUPO_ID ";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("CICLO_GRUPO_ID"), rs.getString("CANTIDAD"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|mapAlumnosCicloGrupoId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}	
	
	
	public static HashMap<String, String> mapAlumnosReprobonesCicloGrupoId(Connection conn, String cicloId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, COUNT( DISTINCT(CODIGO_ID) ) AS CANTIDAD "
					+ " FROM KRDX_CURSO_ACT "
					+ " WHERE CICLO_GRUPO_ID LIKE '"+cicloId+"%'"
					+ " AND NOTA < (SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = KRDX_CURSO_ACT.CURSO_ID)"
					+ " GROUP BY CICLO_GRUPO_ID ";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("CICLO_GRUPO_ID"), rs.getString("CANTIDAD"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|mapAlumnosReprobonesCicloGrupoId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}	
	
}
