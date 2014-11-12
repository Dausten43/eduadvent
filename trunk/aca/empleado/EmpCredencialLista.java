// Clase para la tabla de EmpPersonal
package aca.empleado;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class EmpCredencialLista{
		
	public ArrayList<EmpCredencial> getListAll(Connection Conn, String orden ) throws SQLException{
		
		ArrayList<EmpCredencial> lisCredencial 	= new ArrayList<EmpCredencial>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESPECIALIDAD_ID, NIVEL," +
			" VIENGIA_INI, VIGENCIA_FIN, GRADO" +
			" FROM EMP_CREDENCIAL " +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpCredencial emp = new EmpCredencial();
				emp.mapeaReg(rs);
				lisCredencial.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCredencialLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCredencial;
	}
	
}
