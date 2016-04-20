package aca.empleado;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class EmpCurriculumLista {
	public ArrayList<EmpCurriculum> getListAll(Connection conn, String orden) throws SQLException{
		
		ArrayList<EmpCurriculum> listEmp		= new ArrayList<EmpCurriculum>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando	= "";
		
		try{
			comando = "SELECT ID_EMPLEADO, LUGAR_NAC, T_PROFESIONAL, G_POSGRADO," +
				" T_UNIVERSITARIO, RESP_ACTUAL, RESP_ANTERIOR, EXP_DOCENTE, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
				" COALESCE(NACIONALIDAD,91) AS NACIONALIDAD" +					
				" FROM EMP_CURRICULUM "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpCurriculum emp = new EmpCurriculum();
				emp.mapeaReg(rs);
				listEmp.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCurriculumLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return listEmp;
	}
	
	public ArrayList<EmpCurriculum> lisEmpleados(Connection conn, String escuelaId, String orden) throws SQLException{
		
		ArrayList<EmpCurriculum> listEmp		= new ArrayList<EmpCurriculum>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando	= "";
		
		try{
			comando = " SELECT ID_EMPLEADO, LUGAR_NAC, T_PROFESIONAL, G_POSGRADO,"
					+ " T_UNIVERSITARIO, RESP_ACTUAL, RESP_ANTERIOR, EXP_DOCENTE, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " COALESCE(NACIONALIDAD,91) AS NACIONALIDAD"
					+ " FROM EMP_CURRICULUM"
					+ " WHERE SUBSTR(ID_EMPLEADO,1,3) = '"+escuelaId+"'"+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpCurriculum emp = new EmpCurriculum();
				emp.mapeaReg(rs);
				listEmp.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpCurriculumLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return listEmp;
	}
}
