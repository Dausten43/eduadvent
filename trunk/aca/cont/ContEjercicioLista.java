package aca.cont;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

public class ContEjercicioLista {
	public ArrayList<ContEjercicio> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContEjercicio> lisContEjercicio 	= new ArrayList<ContEjercicio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT EJERCICIO_ID,EJERCICIO_NOMBRE,ESTADO FROM CONT_EJERCICIO "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContEjercicio ejercicio = new ContEjercicio();				
				ejercicio.mapeaReg(rs);
				lisContEjercicio.add(ejercicio);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContEjercicioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContEjercicio;
	}
}
