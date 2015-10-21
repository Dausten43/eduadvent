package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author Jose Torres
 *
 */
public class FinCalculoLista {
	public ArrayList<FinCalculo> getListCalculos(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<FinCalculo> lisCalculo 	= new ArrayList<FinCalculo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT COSTO_ID, CICLO_ID, PERIODO_ID, PLAN_ID," +
					" CLASFIN_ID, CONCEPTO, IMPORTE, NUMPAGOS, PAGOINICIAL, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM FIN_COSTO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = '"+periodoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculo fc = new FinCalculo();				
				fc.mapeaReg(rs);
				lisCalculo.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListCalculos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	
	public ArrayList<FinCalculo> getListAlumnos(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<FinCalculo> lisCalculo 	= new ArrayList<FinCalculo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM FIN_CALCULO"
					+ " WHERE CICLO_ID = '"+cicloId+"' "
					+ " AND PERIODO_ID = '"+periodoId+"' "
					+ " AND INSCRITO IN ('G','P') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculo fc = new FinCalculo();				
				fc.mapeaReg(rs);
				lisCalculo.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListAlumnos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	public ArrayList<FinCalculo> getListAlumnos(Connection conn, String cicloId, String periodoId, String inscrito, String orden ) throws SQLException{
		ArrayList<FinCalculo> lisCalculo 	= new ArrayList<FinCalculo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM FIN_CALCULO"
					+ " WHERE CICLO_ID = '"+cicloId+"' "
					+ " AND PERIODO_ID = '"+periodoId+"' "
					+ " AND INSCRITO IN ("+inscrito+") "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculo fc = new FinCalculo();				
				fc.mapeaReg(rs);
				lisCalculo.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListAlumnos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}

	
	public ArrayList<FinCalculo> getListAlumnosPagos(Connection conn, String cicloId, String periodoId, String pagoId, String orden ) throws SQLException{
		ArrayList<FinCalculo> lisCalculo 	= new ArrayList<FinCalculo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "	SELECT CODIGO_ID, SUM(IMPORTE-BECA) AS TOTAL FROM FIN_CALCULO_PAGO A"+
					  " WHERE CICLO_ID = '"+cicloId+"' "+
					  " AND PERIODO_ID =  '"+periodoId+"' "+
					  " AND PAGO_ID =  '"+pagoId+"' "+
					  " AND ESTADO =  'P' "+
					  " AND IMPORTE > 0 "+
					  " AND ( SELECT INSCRITO FROM FIN_CALCULO WHERE CICLO_ID = A.CICLO_ID AND PERIODO_ID = A.PERIODO_ID AND CODIGO_ID = A.CODIGO_ID ) = 'P' GROUP BY CODIGO_ID"+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculo fc = new FinCalculo();				
				fc.mapeaReg(rs);
				lisCalculo.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListAlumnos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}

	
}
