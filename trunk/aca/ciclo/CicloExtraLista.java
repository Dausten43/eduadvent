package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CicloExtraLista {
	
	public ArrayList<CicloExtra> getListCiclo(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloExtra> lis 	= new ArrayList<CicloExtra>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CICLO_ID, OPORTUNIDAD, VALOR_ANTERIOR," +
					" VALOR_EXTRA, " +
					" OPORTUNIDAD_NOMBRE" +
					" FROM CICLO_EXTRA " +
					" WHERE CICLO_ID = '"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloExtra obj = new CicloExtra();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloExtraLista|getListCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<CicloExtra> getCicloExtra(Connection conn, String cicloId, String oportunidad, String orden ) throws SQLException{
		ArrayList<CicloExtra> lis 	= new ArrayList<CicloExtra>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CICLO_ID, OPORTUNIDAD, VALOR_ANTERIOR," +
					" VALOR_EXTRA, " +
					" OPORTUNIDAD_NOMBRE" +
					" FROM CICLO_EXTRA " +
					" WHERE CICLO_ID = '"+cicloId+"' AND OPORTUNIDAD = TO_NUMBER('"+oportunidad+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloExtra obj = new CicloExtra();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloExtraLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<CicloExtra> getListAll(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloExtra> lis 	= new ArrayList<CicloExtra>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CICLO_ID, OPORTUNIDAD, VALOR_ANTERIOR," +
					" VALOR_EXTRA, " +
					" OPORTUNIDAD_NOMBRE" +
					" FROM CICLO_EXTRA " +
					" WHERE CICLO_ID = '"+cicloId+"'"+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloExtra obj = new CicloExtra();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloExtraLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	
}
