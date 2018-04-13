//Clase  para la tabla CICLO
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;

public class CicloLista {
	public ArrayList<Ciclo> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, CICLO_NOMBRE,"
                + " TO_CHAR(F_CREADA, 'DD/MM/YYYY') AS F_CREADA,"
                + " TO_CHAR(F_INICIAL, 'DD/MM/YYYY') AS F_INICIAL,"
                + " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL,"
                + " NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD,"
                + " CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
                + " FROM CICLO"
                + " WHERE CICLO_ID LIKE '"+escuelaId+"%' "+orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListAll(Connection conn, String condicion_abierta ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, CICLO_NOMBRE,"
                + " TO_CHAR(F_CREADA, 'DD/MM/YYYY') AS F_CREADA,"
                + " TO_CHAR(F_INICIAL, 'DD/MM/YYYY') AS F_INICIAL,"
                + " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL,"
                + " NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD,"
                + " CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
                + " FROM CICLO"
                + " WHERE CICLO_ID IS NOT NULL " + condicion_abierta;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListActivos(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, CICLO_NOMBRE,"
                + " TO_CHAR(F_CREADA, 'DD/MM/YYYY') AS F_CREADA,"
                + " TO_CHAR(F_INICIAL, 'DD/MM/YYYY') AS F_INICIAL,"
                + " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL,"
                + " NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD,"
                + " CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
                + " FROM CICLO"
                + " WHERE CICLO_ID LIKE '"+escuelaId+"%'"
                + " AND ESTADO = 'A'"+orden;			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListActivos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListCiclosAbiertos(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, CICLO_NOMBRE,"
					+ " TO_CHAR(F_CREADA, 'DD/MM/YYYY') AS F_CREADA,"
					+ " TO_CHAR(F_INICIAL, 'DD/MM/YYYY') AS F_INICIAL,"
					+ " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL,"
					+ " NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD,"
					+ " CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
					+ " FROM CICLO"
					+ " WHERE CICLO_ID LIKE '"+escuelaId+"%'"
					+ " AND ESTADO = 'A'" +orden;
			
			rs = st.executeQuery( comando );
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();			
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListCiclosAbiertos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListActivosHoy(Connection conn, String fecha, String escuelaId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, CICLO_NOMBRE,"
					+ " TO_CHAR(F_CREADA, 'DD/MM/YYYY') AS F_CREADA,"
					+ " TO_CHAR(F_INICIAL, 'DD/MM/YYYY') AS F_INICIAL,"
					+ " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL,"
					+ " NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD,"
					+ " CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
					+ " FROM CICLO"
					+ " WHERE CICLO_ID LIKE '"+escuelaId+"%'"
					+ " AND ESTADO = 'A'"
					+ " AND TO_DATE('"+fecha+"' , 'DD/MM/YYYY') BETWEEN F_INICIAL AND F_FINAL "+orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListActivosHoy|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListCiclosEmpleadoPlanta(Connection conn, String empleadoId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, CICLO_NOMBRE, F_CREADA, F_INICIAL, F_FINAL, NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD, CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA" +
					" FROM CICLO" +
					" WHERE CICLO_ID IN (SELECT CICLO_ID" +
										" FROM CICLO_GRUPO" +
										" WHERE EMPLEADO_ID = '"+empleadoId+"') "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListCiclosEmpleadoCursos(Connection conn, String empleadoId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, CICLO_NOMBRE, F_CREADA, F_INICIAL, F_FINAL, NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD, CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA" +
					" FROM CICLO" +
					" WHERE CICLO_ID IN (SELECT CICLO_ID" +
										" FROM CICLO_GRUPO" +
										" WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO_CURSO" +
																  " WHERE EMPLEADO_ID = '"+empleadoId+"')) "+orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListCiclosEmpleadoCursos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListCiclosAlumno(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, CICLO_NOMBRE, F_CREADA, F_INICIAL, F_FINAL, NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD, CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"+
					 " FROM CICLO"+ 
					 " WHERE CICLO_ID IN (SELECT CICLO_ID"+
										" FROM CICLO_GRUPO"+ 
										" WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID"+
										 	   				  	 " FROM KRDX_CURSO_ACT"+
																 " WHERE CODIGO_ID = '"+codigoId+"'))"+orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListCiclosAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListCiclosAlumInscrito(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, CICLO_NOMBRE, F_CREADA, F_INICIAL, F_FINAL, NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD, CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
					+ " FROM CICLO"
					+ " WHERE CICLO_ID IN "
					+"		(SELECT B.CICLO_ID FROM ALUM_CICLO B WHERE B.CODIGO_ID = '"+codigoId+"' AND B.ESTADO = 'I') "+orden;			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListCiclosAlumInscrito|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListCiclosAlumNoInscrito(Connection conn, String escuelaId, String codigoId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, CICLO_NOMBRE, F_CREADA, F_INICIAL, F_FINAL, NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD, CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
					+ " FROM CICLO"
					+ " WHERE CICLO_ID NOT IN "
					+ "		(SELECT B.CICLO_ID FROM ALUM_CICLO B WHERE B.CODIGO_ID = '"+codigoId+"' AND B.ESTADO = 'I') "
					+ " AND NOW() BETWEEN F_INICIAL AND F_FINAL "
					+ " AND SUBSTR(CICLO_ID,1,3)= '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListCiclosAlumInscrito|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
	
		return lisCiclo;
	}
	
	public ArrayList<Ciclo> getListTodo(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, CICLO_NOMBRE," 
					+ " TO_CHAR(F_CREADA, 'DD/MM/YYYY') AS F_CREADA,"
					+ " TO_CHAR(F_INICIAL, 'DD/MM/YYYY') AS F_INICIAL,"
					+ " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL,"
					+ " NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD,"
					+ " CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
					+ " FROM CICLO "
					+ " WHERE SUBSTR(CICLO_ID,1,3) = '"+escuelaId+"'"
					+ " AND ESTADO = 'A' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListTodo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCiclo;
	}	
	
	public ArrayList<String> getListCicloEscolar(Connection conn, String escuelaId, String estado, String orden ) throws SQLException{
		ArrayList<String> lista 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT DISTINCT(CICLO_ESCOLAR) AS CICLO_ESCOLAR FROM CICLO "
					+ " WHERE SUBSTR(CICLO_ID,1,3) = '"+escuelaId+"'"					
					+ " AND ESTADO IN("+estado+") "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				lista.add(rs.getString("CICLO_ESCOLAR"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloLista|getListCicloEscolar|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lista;
	}
	
}