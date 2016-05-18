/**
 * 
 */
package aca.empleado;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class EmpTipoLista {
	
	public ArrayList<EmpTipo> getListAll(Connection Conn, String orden ) throws SQLException{
		
		ArrayList<EmpTipo> lisTipo	 	= new ArrayList<EmpTipo>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT TIPO_ID, TIPO_NOMBRE FROM EMP_TIPO "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpTipo tipo = new EmpTipo();
				tipo.mapeaReg(rs);
				lisTipo.add(tipo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpTipoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisTipo;
	}
	
	public ArrayList<EmpTipo> getListSinEsteTipo(Connection Conn, String tipoId, String orden ) throws SQLException{
		
		ArrayList<EmpTipo> lisTipo	 	= new ArrayList<EmpTipo>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT TIPO_ID, TIPO_NOMBRE FROM EMP_TIPO WHERE TIPO_ID NOT IN ("+tipoId+") "+orden;
			//System.out.println(comando);
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpTipo tipo = new EmpTipo();
				tipo.mapeaReg(rs);
				lisTipo.add(tipo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpTipoLista|getListSinEsteTipo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisTipo;
	}
	
	public static HashMap<String, String> mapTipoEmpleados(Connection conn, String orden) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";		
		
		try{
			comando = " SELECT TIPO_ID, TIPO_NOMBRE FROM EMP_TIPO "+orden;
					
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				map.put(rs.getString("TIPO_ID"), rs.getString("TIPO_NOMBRE"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|mapTipoEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return map;
	}
	
}
