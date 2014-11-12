/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author ifo
 *
 */
public class CicloGrupoArchivopLista {
	public ArrayList<CicloGrupoArchivop> getListEnviados(Connection conn, String cicloGrupoId, String orden) throws SQLException{
		
		ArrayList<CicloGrupoArchivop> lisArchivos = new ArrayList<CicloGrupoArchivop>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT"+
			" CICLO_GRUPO_ID, FOLIO, COMENTARIO, ALUMNOS, NOMBRE, ARCHIVO, TO_CHAR(FECHA, 'DD/MM/YYYY HH24:MI:SS') AS FECHA"+
			" FROM CICLO_GRUPO_ARCHIVOP"+
			" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoArchivop archivo = new CicloGrupoArchivop();				
				archivo.mapeaReg(rs);
				lisArchivos.add(archivo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoEvalLista|getListEnviados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		

		return lisArchivos;
	}
}
