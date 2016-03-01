package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class FinCalculoDetLista {
	
	public ArrayList<FinCalculoDet> getListCalDet(Connection conn, String cicloId, String periodoId, String codigoId, String orden ) throws SQLException{
		ArrayList<FinCalculoDet> lisCalculoDet 	= new ArrayList<FinCalculoDet>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, CUENTA_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, IMPORTE, BECA_PORCENTAJE, BECA_CANTIDAD, IMPORTE_BECA, PAGO_INICIAL_PORCENTAJE, IMPORTE_INICIAL" +
					" FROM FIN_CALCULO_DET" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')" +
					" AND CODIGO_ID = '"+codigoId+"' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinCalculoDet fc = new FinCalculoDet();
				fc.mapeaReg(rs);
				lisCalculoDet.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListCalDet|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculoDet;
	}	
	
	public ArrayList<FinCalculoDet> getListCalDetTodosAlumnos(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<FinCalculoDet> lisCalculoDet 	= new ArrayList<FinCalculoDet>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, CUENTA_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, IMPORTE, BECA_PORCENTAJE, BECA_CANTIDAD, IMPORTE_BECA, PAGO_INICIAL_PORCENTAJE, IMPORTE_INICIAL" +
					" FROM FIN_CALCULO_DET A " +
					" WHERE CICLO_ID = '"+cicloId+"' " +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"','99')" +
					" AND ( SELECT INSCRITO FROM FIN_CALCULO WHERE CICLO_ID = A.CICLO_ID AND PERIODO_ID = A.PERIODO_ID AND CODIGO_ID = A.CODIGO_ID ) IN ('G','P') "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinCalculoDet fc = new FinCalculoDet();
				fc.mapeaReg(rs);
				lisCalculoDet.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoDetLista|getListCalDetTodosAlumnos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculoDet;
	}
	
	public HashMap<String,String> mapImporte(Connection conn, String cicloId) throws SQLException{
		
		HashMap<String,String> map 		= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			
			comando = " SELECT CICLO_ID || PERIODO_ID || CODIGO_ID || CUENTA_ID AS KEY, IMPORTE_BECA FROM FIN_CALCULO_DET"
					+ " WHERE CICLO_ID= '"+cicloId+"'";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("KEY"), rs.getString("IMPORTE_BECA"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoDetLista|mapImporte|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
}
