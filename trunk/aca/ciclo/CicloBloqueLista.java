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
	
	
	public static String getRedondeo( Connection conn, String cicloId, String bloqueId) throws SQLException, Exception {
		
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		String redondeo	= "0";
		
		try{
			comando = "SELECT REDONDEO FROM CICLO_BLOQUE WHERE CICLO_ID='"+cicloId+"' AND BLOQUE_ID= TO_NUMBER('"+bloqueId+"', '99')";
			
			rs = st.executeQuery(comando);	
			while (rs.next()){
				redondeo = rs.getString("REDONDEO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getRedondeo|:"+ex);
		}finally{		
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return redondeo;
	}
	
	
	public static String getDecimales( Connection conn, String cicloId, String bloqueId) throws SQLException, Exception {
		
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		String decimales		= "0";
		
		try{
			comando = "SELECT DECIMALES FROM CICLO_BLOQUE WHERE CICLO_ID='"+cicloId+"' AND BLOQUE_ID= TO_NUMBER('"+bloqueId+"', '99')";

			
			rs = st.executeQuery(comando);	
			while (rs.next()){
				decimales = rs.getString("DECIMALES");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueLista|getDecimales|:"+ex);
		}finally{		
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return decimales;
	}
	
}