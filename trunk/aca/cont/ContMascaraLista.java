package aca.cont;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ContMascaraLista {
	public ArrayList<ContMascara> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContMascara> lisContMascara	= new ArrayList<ContMascara>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT MASCARA_ID,MASC_BALANCE,MASC_RESULTADO, MASC_CCOSTO,NIVEL_CONTABLE FROM CONT_MASCARA "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContMascara mascara = new ContMascara();				
				mascara.mapeaReg(rs);
				lisContMascara.add(mascara);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContMascaraLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContMascara;
	}
}
