//Clase  para la tabla CICLO
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;

public class CicloBloqueLista {
	public ArrayList<CicloBloque> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CicloBloque> lisCicloBloque 	= new ArrayList<CicloBloque>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, BLOQUE_ID, BLOQUE_NOMBRE," +
					" TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO," +
					" TO_CHAR(F_FINAL,'DD/MM/YYYY') AS F_FINAL, VALOR, ORDEN, PROMEDIO_ID, CORTO, DECIMALES, REDONDEO, CALCULO" +
					" FROM CICLO_BLOQUE " +
					" WHERE SUBSTR(CICLO_ID,1,3)='"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloBloque ciclo = new CicloBloque();				
				ciclo.mapeaReg(rs);
				lisCicloBloque.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCicloBloque;
	}
	
	public ArrayList<CicloBloque> getListCiclo(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloBloque> lisCicloBloque 	= new ArrayList<CicloBloque>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, BLOQUE_ID, BLOQUE_NOMBRE," +
					" TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO," +
					" TO_CHAR(F_FINAL,'DD/MM/YYYY') AS F_FINAL, VALOR, ORDEN, PROMEDIO_ID, CORTO, DECIMALES, REDONDEO, CALCULO" +
					" FROM CICLO_BLOQUE " +
					" WHERE CICLO_ID = '"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloBloque ciclo = new CicloBloque();				
				ciclo.mapeaReg(rs);
				lisCicloBloque.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getListCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	

		return lisCicloBloque;
	}
	
	public ArrayList<CicloBloque> getListCiclo(Connection conn, String cicloId, String promedioId, String orden ) throws SQLException{
		ArrayList<CicloBloque> lisCicloBloque 	= new ArrayList<CicloBloque>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, BLOQUE_ID, BLOQUE_NOMBRE,"
					+ " TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO,"
					+ " TO_CHAR(F_FINAL,'DD/MM/YYYY') AS F_FINAL, VALOR, ORDEN, PROMEDIO_ID, CORTO, DECIMALES, REDONDEO, CALCULO"
					+ " FROM CICLO_BLOQUE"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND PROMEDIO_ID = TO_NUMBER('"+promedioId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloBloque ciclo = new CicloBloque();				
				ciclo.mapeaReg(rs);
				lisCicloBloque.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getListCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	

		return lisCicloBloque;
	}
	
	public ArrayList<CicloBloque> getBloquePromedioCiclo(Connection conn, String promedioId, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloBloque> lisCicloBloque 	= new ArrayList<CicloBloque>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, BLOQUE_ID, BLOQUE_NOMBRE," +
					" TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO," +
					" TO_CHAR(F_FINAL,'DD/MM/YYYY') AS F_FINAL, VALOR, ORDEN, PROMEDIO_ID, CORTO, DECIMALES, REDONDEO, CALCULO" +
					" FROM CICLO_BLOQUE " +
					" WHERE PROMEDIO_ID = TO_NUMBER('"+promedioId+"', '99') AND CICLO_ID='"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloBloque ciclo = new CicloBloque();	
				ciclo.mapeaReg(rs);
				lisCicloBloque.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getBloquePromedioCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	

		return lisCicloBloque;
	}
	
}