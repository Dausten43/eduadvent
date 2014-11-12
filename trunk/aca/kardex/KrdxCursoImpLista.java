/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author Elifo
 *
 */
public class KrdxCursoImpLista {
	public ArrayList<KrdxAlumEval> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<KrdxAlumEval> lisEval 	= new ArrayList<KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CURSO_ID, CAL1, CAL2, CAL3, CAL4, CAL5,CAL6,CAL7,CAL8,CAL9,CAL10, NOTA," +
					"F_NOTA, TIPOCAL_ID, COMENTARIO, NOTA_EXTRA, F_EXTRA" +               
                " FROM KRDX_CURSO_IMP " +
                " WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumEval kae = new KrdxAlumEval();				
				kae.mapeaReg(rs);
				lisEval.add(kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImpLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisEval;
	}
	
	public ArrayList<KrdxCursoImp> getListPersonal(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<KrdxCursoImp> lisEval 	= new ArrayList<KrdxCursoImp>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT A.CODIGO_ID AS CODIGO_ID, " +
					" A.CURSO_ID AS CURSO_ID," +
					" A.CAL1 AS CAL1," +
					" A.CAL2 AS CAL2," +
					" A.CAL3 AS CAL3," +
					" A.CAL4 AS CAL4," +
					" A.CAL5 AS CAL5," +
					" A.CAL6 AS CAL6," +
					" A.CAL7 AS CAL7," +
					" A.CAL8 AS CAL8," +
					" A.CAL9 AS CAL9," +
					" A.CAL10 AS CAL10," +
					" A.NOTA AS NOTA," +
					" TO_CHAR(A.F_NOTA, 'DD/MM/YYYY') AS F_NOTA," +
					" A.TIPOCAL_ID AS TIPOCAL_ID," +
					" A.COMENTARIO AS COMENTARIO," +
					" A.NOTA_EXTRA AS NOTA_EXTRA," +
					" TO_CHAR(A.F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA," +
					" A.FOLIO AS FOLIO" +
					" FROM KRDX_CURSO_IMP A, PLAN_CURSO B" +
					" WHERE A.CODIGO_ID = '"+codigoId+"'" +
					" AND A.CURSO_ID = B.CURSO_ID " +orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxCursoImp kci = new KrdxCursoImp();				
				kci.mapeaReg(rs);
				lisEval.add(kci);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImpLista|getListPersonal|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisEval;
	}
}
