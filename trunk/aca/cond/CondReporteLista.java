// Clase para la tabla de AlumPersonal
package aca.cond;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CondReporteLista {
	public ArrayList<CondReporte> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CondReporte> lisReporte 	= new ArrayList<CondReporte>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID,TIPO_ID,TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA," +
					 " COMENTARIO,ESTADO,FOLIO,CICLO_ID, EMPLEADO_ID, COMPROMISO FROM COND_REPORTE "+orden;		
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CondReporte repor = new CondReporte();		
				repor.mapeaReg(rs);
				lisReporte.add(repor);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condReporteLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisReporte;
	}
	
	public ArrayList<CondReporte> getListGrado(Connection conn, String cicloId, String planId, String grado, String orden ) throws SQLException{
		ArrayList<CondReporte> lisReporte 	= new ArrayList<CondReporte>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID,TIPO_ID,TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA,COMENTARIO,ESTADO,FOLIO, CICLO_ID, EMPLEADO_ID, COMPROMISO " +
					" FROM COND_REPORTE" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND ALUM_PLAN_ID(CODIGO_ID) = '"+planId+"'" +
					" AND ALUM_GRADO(CODIGO_ID) = "+grado+" "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CondReporte repor = new CondReporte();		
				repor.mapeaReg(rs);
				lisReporte.add(repor);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condReporteLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisReporte;
	}
	
	public ArrayList<CondReporte> getListReporte(Connection conn, String cicloId, String planId, String grado, String orden ) throws SQLException{
		ArrayList<CondReporte> lisReporte 	= new ArrayList<CondReporte>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID,TIPO_ID,TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA,COMENTARIO, ESTADO, FOLIO, CICLO_ID, EMPLEADO_ID, COMPROMISO " +
					" FROM COND_REPORTE" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND ALUM_PLAN_ID(CODIGO_ID) = '"+planId+"'"+
					" AND ALUM_GRADO(CODIGO_ID) = '"+grado+"'"+orden;
			
					
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CondReporte repor = new CondReporte();		
				repor.mapeaReg(rs);
				lisReporte.add(repor);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condReporteLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisReporte;
	}
}
/*
 SELECT * FROM COND_REPORTE 
WHERE CICLO_ID = '011011A' 
AND ALUM_PLAN_ID(CODIGO_ID) = '01-03'
ORDER BY ALUM_GRADO(CODIGO_ID), ALUM_GRUPO(CODIGO_ID), ALUM_APELLIDO(CODIGO_ID);
 * */

