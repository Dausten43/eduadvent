/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author elifo
 *
 */
public class FinCostoLista {
	public ArrayList<FinCosto> getListCicloPeriodo(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<FinCosto> lisFinCosto 	= new ArrayList<FinCosto>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT COSTO_ID, CICLO_ID, PERIODO_ID, PLAN_ID," +
					" CLASFIN_ID, CUENTA_ID, FECHA, IMPORTE " +
					" FROM FIN_COSTO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCosto fc = new FinCosto();				
				fc.mapeaReg(rs);
				lisFinCosto.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListCicloPeriodo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinCosto;
	}
	
	public ArrayList<FinCosto> getListPlanCostos(Connection conn, String cicloId, String periodoId, String planId, String orden ) throws SQLException{
		ArrayList<FinCosto> lisFinCosto 	= new ArrayList<FinCosto>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT COSTO_ID, CICLO_ID, PERIODO_ID, PLAN_ID, CLASFIN_ID, CUENTA_ID, FECHA, IMPORTE " +
					" FROM FIN_COSTO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')" +
					" AND PLAN_ID = '"+planId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCosto fc = new FinCosto();				
				fc.mapeaReg(rs);
				lisFinCosto.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListPlanCostos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinCosto;
	}
	
	public ArrayList<FinCosto> getListPlanCostosAlumno(Connection conn, String cicloId, String periodoId, String planId, String codigoId, String orden ) throws SQLException{
		ArrayList<FinCosto> lisFinCosto 	= new ArrayList<FinCosto>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT COSTO_ID, CICLO_ID, PERIODO_ID, PLAN_ID, CLASFIN_ID, CUENTA_ID, FECHA, IMPORTE " +
					" FROM FIN_COSTO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')" +
					" AND PLAN_ID = '"+planId+"' " +
					" AND CUENTA_ID NOT IN " +
					"	(SELECT CUENTA_ID FROM FIN_CALCULO_DET " +
					"	WHERE CICLO_ID = '"+cicloId+"' " +
					"	AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') " +
					"	AND CODIGO_ID = '"+codigoId+"') " + orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCosto fc = new FinCosto();				
				fc.mapeaReg(rs);
				lisFinCosto.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListPlanCostos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinCosto;
	}
	
	public ArrayList<FinCosto> getListCicloPeriodo(Connection conn, String cicloId, String periodoId, String planId, String clasFinId, String codigoId, String orden ) throws SQLException{
		ArrayList<FinCosto> lisFinCosto 	= new ArrayList<FinCosto>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT COSTO_ID, CICLO_ID, PERIODO_ID, PLAN_ID," +
					" CLASFIN_ID, CUENTA_ID, FECHA, IMPORTE " +
					" FROM FIN_COSTO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"','99')" +
					" AND PLAN_ID = '"+planId+"'" +
					" AND CLASFIN_ID = TO_NUMBER('"+clasFinId+"','99')" +
					" AND CICLO_ID||PERIODO_ID||CUENTA_ID NOT IN (SELECT CICLO_ID||PERIODO_ID||CUENTA_ID FROM FIN_CALCULO_DET WHERE CODIGO_ID = '"+codigoId+"') "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinCosto fc = new FinCosto();		
				fc.mapeaReg(rs);
				lisFinCosto.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListCicloPeriodo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinCosto;
	}
}
