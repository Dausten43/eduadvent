/**
 * 
 */
package aca.cont;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author Elifo
 *
 */
public class ContTipoLista {
	public ArrayList<ContTipo> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContTipo> lisTipo 	= new ArrayList<ContTipo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT TIPO_ID, TIPO_NOMBRE FROM CONT_TIPO "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContTipo tipo = new ContTipo();				
				tipo.mapeaReg(rs);
				lisTipo.add(tipo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContTipoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisTipo;
	}
}
