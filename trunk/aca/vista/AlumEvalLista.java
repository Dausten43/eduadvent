/**
 * 
 */
package aca.vista;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import aca.ciclo.Ciclo;

/**
 * @author Elifo
 *
 */
public class AlumEvalLista {
	public ArrayList<Ciclo> getListGrupoCurso(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		ArrayList<Ciclo> lisCiclo 	= new ArrayList<Ciclo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT" +
					" A.CODIGO_ID," +
					" A.CICLO_GRUPO_ID," +
					" A.CURSO_ID," +
					" A.EVALUACION_ID," +
					" B.EVALUACION_NOMBRE," +
					" TO_CHAR(B.FECHA,'DD/MM/YYYY') AS FECHA," +
					" A.NOTA," +
					" B.VALOR," +
					" B.TIPO" +
					" FROM KRDX_ALUM_EVAL A, CICLO_GRUPO_EVAL B" +
					" WHERE A.CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND A.CURSO_ID = '"+cursoId+"'" +
					" AND B.CICLO_GRUPO_ID||B.CURSO_ID = A.CICLO_GRUPO_ID||A.CURSO_ID" +
					" AND B.EVALUACION_ID = A.EVALUACION_ID" +
					" ORDER BY FECHA "+orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Ciclo cicle = new Ciclo();				
				cicle.mapeaReg(rs);
				lisCiclo.add(cicle);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumEvalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCiclo;
	}
}
