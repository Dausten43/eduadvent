package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CatParametroLista {

	public ArrayList<CatParametro> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatParametro> lisCatParametro = new ArrayList<CatParametro>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT ESCUELA_ID, FIRMA_BOLETA, FIRMA_PADRE, SUNPLUS, IP_SERVER, "
					+ " BASEDATOS, PUERTO, CAJA, BOLETA, BLOQUEA_PORTAL "
					+ " FROM CAT_PARAMETRO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatParametro param = new CatParametro();			
				param.mapeaReg(rs);
				lisCatParametro.add(param);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatParametroLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCatParametro;
	}
}
