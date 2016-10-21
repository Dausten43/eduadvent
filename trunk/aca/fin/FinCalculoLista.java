package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

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
			comando = " SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PLAN_ID,"
					+ " TIPO_PAGO, IMPORTE, INSCRITO, FOLIO, CLASFIN_ID, NUMPAGOS, PAGOINICIAL,"
					+ " TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, IMPORTE_PAGO, PAGOS"
					+ " FROM FIN_CALCULO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
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
					+ " AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "
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
			comando = " SELECT * FROM FIN_CALCULO"
					+ " WHERE CICLO_ID = '"+cicloId+"' "
					+ " AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')"
					+ " AND INSCRITO IN ("+inscrito+")"
					+ " AND CODIGO_ID IN "
					+ "		(SELECT CODIGO_ID FROM FIN_CALCULO_PAGO "
					+ "		WHERE CICLO_ID = '"+cicloId+"'"
					+ " 	AND PERIODO_ID = TO_NUMBER(?, '99')"
        			+ " 	AND PAGO_ID = TO_NUMBER(?,'99')"
        			+ " AND ESTADO = 'A'"
					+ "		AND )"+orden;
			System.out.println(comando);
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculo fc = new FinCalculo();
				fc.mapeaReg(rs);
				lisCalculo.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListAlumnos76|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	public ArrayList<FinCalculo> getListAlumnosCobro(Connection conn, String cicloId, String periodoId, String inscrito, String pagoId, String orden ) throws SQLException{
		ArrayList<FinCalculo> lisCalculo 	= new ArrayList<FinCalculo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT * FROM FIN_CALCULO"
					+ " WHERE CICLO_ID = '"+cicloId+"' "
					+ " AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')"
					+ " AND INSCRITO IN ("+inscrito+")"
					+ " AND CODIGO_ID IN "
					+ "		(SELECT CODIGO_ID FROM FIN_CALCULO_PAGO"
					+ "		WHERE CICLO_ID = '"+cicloId+"'"
					+ " 	AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')"
        			+ " 	AND PAGO_ID = TO_NUMBER('"+pagoId+"','99')"
        			+ "		AND ESTADO = 'A'"
					+ "		AND IMPORTE > 0) "
					+ " AND CODIGO_ID NOT IN ("
					+ " SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID='"+cicloId+"' AND ESTADO NOT IN ('I') AND PERIODO_ID=TO_NUMBER('"+periodoId+"','99')) " 
					+ ""+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculo fc = new FinCalculo();
				fc.mapeaReg(rs);
				lisCalculo.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListAlumnos112|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	public ArrayList<String> listAlumnosEnPago(Connection conn, String cicloId, String periodoId, String pagoId, String estado, String orden ) throws SQLException{
		ArrayList<String> lisCalculo 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "	SELECT CODIGO_ID FROM FIN_CALCULO_PAGO A"+
					  " WHERE CICLO_ID = '"+cicloId+"' "+
					  " AND PERIODO_ID =  TO_NUMBER('"+periodoId+"', '99') "+
					  " AND PAGO_ID =  '"+pagoId+"' "+
					  " AND ESTADO IN ("+estado+")"+
					  " AND IMPORTE > '0' "
					  + " AND CODIGO_ID NOT IN ("
  					+ " SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID='"+cicloId+"' AND ESTADO NOT IN ('I') AND PERIODO_ID=TO_NUMBER('"+periodoId+"','99')) "
					+  " GROUP BY CODIGO_ID "+ orden;			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				lisCalculo.add(rs.getString("CODIGO_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|listAlumnosEnPago|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	public HashMap<String,String> mapAlumnosEnPago(Connection conn, String cicloId, String periodoId, String pagoId , String estado) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "	SELECT CODIGO_ID, SUM(IMPORTE-BECA) AS TOTAL FROM FIN_CALCULO_PAGO A"+
					  " WHERE CICLO_ID = '"+cicloId+"' "+
					  " AND PERIODO_ID =  TO_NUMBER('"+periodoId+"', '99') "+
					  " AND PAGO_ID =  '"+pagoId+"' "+
					  " AND ESTADO IN ("+estado+")"+
					  " AND IMPORTE > '0'"+
					  " GROUP BY CODIGO_ID";
			
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("CODIGO_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoLista|getListAlumnosPagos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

	
}
