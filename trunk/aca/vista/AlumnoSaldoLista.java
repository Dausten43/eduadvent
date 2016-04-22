/**
 * 
 */
package aca.vista;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class AlumnoSaldoLista {
	public ArrayList<AlumnoProm> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<AlumnoProm> lisAlumno 	= new ArrayList<AlumnoProm>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NIVEL_ID, GRADO, GRUPO, SALDO" +
				" FROM ALUMNO_SALDO" +
				" WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumnoProm ac = new AlumnoProm();			
				ac.mapeaReg(rs);
				lisAlumno.add(ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoSaldoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisAlumno;
	}
	
	public HashMap<String,AlumnoSaldo> mapAlumSaldo(Connection conn, String codigoId, String orden ) throws SQLException{
		
		HashMap<String,AlumnoSaldo> mapAlumProm 	= new HashMap<String,AlumnoSaldo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NIVEL_ID, GRADO, GRUPO, SALDO" +
				" FROM ALUMNO_SALDO" +
				" WHERE CODIGO_ID = '"+codigoId+"' " +orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				AlumnoSaldo ac = new AlumnoSaldo();		
				ac.mapeaReg(rs);
				llave = ac.getCodigoId()+ac.getCodigoId();
				mapAlumProm.put(llave, ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoSaldoLista|getTreeAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapAlumProm;
	}
	
	
	
}
