/**
 * 
 */
package aca.usuario;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class UsuarioTipoLista {
	
	public ArrayList<UsuarioTipo> getListAll(Connection Conn, String orden ) throws SQLException{
		ArrayList<UsuarioTipo> lisTipo		= new ArrayList<UsuarioTipo>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO, TIPO_ID, TIPO_NOMBRE FROM USUARIO_TIPO "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				UsuarioTipo tipo = new UsuarioTipo();
				tipo.mapeaReg(rs);
				lisTipo.add(tipo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.UsuarioTipoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisTipo;
	}
	
}
