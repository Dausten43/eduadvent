package aca.alumno;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class AlumGrupoLista {
	
	public ArrayList<AlumConstancia> getListAll(Connection Conn ) throws SQLException{
		
		ArrayList<AlumConstancia> lis 	= new ArrayList<AlumConstancia>();
		Statement st 					= Conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{
			comando = " SELECT * " +
					  " FROM ALUM_GRUPO " +
					  " ORDER BY ORDER";			
			rs = st.executeQuery(comando);
			while (rs.next()){
				AlumConstancia obj = new AlumConstancia();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumGrupoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lis;
	}
	
}
