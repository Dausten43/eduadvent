package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinPermisoLista {
	public ArrayList<FinPermiso> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinPermiso> lisPermiso 	= new ArrayList<FinPermiso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT CODIGO_ID, FOLIO, FECHA_INI, FECHA_FIN, ESTADO, COMENTARIO FROM FIN_PERMISO "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinPermiso permiso = new FinPermiso();				
				permiso.mapeaReg(rs);
				lisPermiso.add(permiso);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinPermisoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisPermiso;
	}
}
