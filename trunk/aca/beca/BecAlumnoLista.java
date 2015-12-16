//Clase  para la tabla CAT_CIUDAD
package aca.beca;

import java.sql.*;
import java.util.ArrayList;

public class BecAlumnoLista {
	
	public ArrayList<BecAlumno> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<BecAlumno> lisBeca 	= new ArrayList<BecAlumno>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *" +
					" FROM BEC_ALUMNO" +
					" WHERE CODIGO_ID LIKE '"+escuelaId+"%' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecAlumno beca = new BecAlumno();			
				beca.mapeaReg(rs);
				lisBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.BecAlumnoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		return lisBeca;
	}
	
	public ArrayList<BecAlumno> getListAlumno(Connection conn, String cicloId, String periodoId, String codigoId, String orden ) throws SQLException{
		ArrayList<BecAlumno> lisBeca 	= new ArrayList<BecAlumno>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *" +
					" FROM BEC_ALUMNO" +
					" WHERE CODIGO_ID = '"+codigoId+"'" +
					" AND CICLO_ID = '"+cicloId+"'"+
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecAlumno beca = new BecAlumno();				
				beca.mapeaReg(rs);
				lisBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.BecAlumnoLista|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisBeca;
	}
	
	public ArrayList<BecAlumno> getListPorEntidad(Connection conn, String cicloId, String periodoId, String entidadId, String orden ) throws SQLException{
		ArrayList<BecAlumno> lisBeca 	= new ArrayList<BecAlumno>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *" +
					" FROM BEC_ALUMNO" +
					" WHERE ENTIDAD_ID = TO_NUMBER('"+entidadId+"', '99999') " +
					" AND CICLO_ID = '"+cicloId+"'"+
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecAlumno beca = new BecAlumno();				
				beca.mapeaReg(rs);
				lisBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.BecAlumnoLista|getListTodo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisBeca;
	}
	
	public static ArrayList<BecAlumno> getBecasAlumno(Connection conn, String cicloId, String periodoId, String codigoId, String cuentaId, String orden ) throws SQLException{
		ArrayList<BecAlumno> lisBeca 	= new ArrayList<BecAlumno>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM BEC_ALUMNO" +
						" WHERE CICLO_ID = '"+cicloId+"' " +
						" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') " +
						" AND CODIGO_ID = '"+codigoId+"' " +					
						" AND CUENTA_ID = '"+cuentaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				BecAlumno beca = new BecAlumno();				
				beca.mapeaReg(rs);
				lisBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.BecAlumnoLista|getBecasAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisBeca;
	}
	
	
	public ArrayList<BecAlumno> getListTodo(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<BecAlumno> lisBeca 	= new ArrayList<BecAlumno>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *" +
					" FROM BEC_ALUMNO" +
					" WHERE CICLO_ID = '"+cicloId+"'"+
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecAlumno beca = new BecAlumno();				
				beca.mapeaReg(rs);
				lisBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.BecAlumnoLista|getListTodo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisBeca;
	}
	
	public ArrayList<BecAlumno> getListEntidad(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<BecAlumno> lisBeca 	= new ArrayList<BecAlumno>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ENTIDAD_ID FROM BEC_ALUMNO" +
					" WHERE CICLO_ID = '"+cicloId+"'"+
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecAlumno beca = new BecAlumno();				
				beca.mapeaReg(rs);
				lisBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.BecAlumnoLista|getListTodo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisBeca;
	}
	
}