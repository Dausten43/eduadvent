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
	public ArrayList<AlumnoSaldo> getListAll(Connection conn, String escuelaId) throws SQLException{
		ArrayList<AlumnoSaldo> lisAlumno 	= new ArrayList<AlumnoSaldo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT * FROM ALUMNO_SALDO WHERE ESCUELA_ID='"+escuelaId+"' AND SALDO <> 0 ORDER BY NIVEL_ID, GRADO, GRUPO, ALUM_APELLIDO(CODIGO_ID)";
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumnoSaldo ac = new AlumnoSaldo();			
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
	
	public HashMap<String,AlumnoSaldo> mapAlumSaldo(Connection conn, String escuelaId ) throws SQLException{
		
		HashMap<String,AlumnoSaldo> mapAlumProm 	= new HashMap<String,AlumnoSaldo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT * FROM ALUMNO_SALDO WHERE ESCUELA_ID='"+escuelaId+"' AND SALDO <> 0 ORDER BY NIVEL_ID, GRADO, GRUPO, ALUM_APELLIDO(CODIGO_ID)";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 
				AlumnoSaldo ac = new AlumnoSaldo();		
				ac.mapeaReg(rs);
				llave = ac.getCodigoId()+ac.getCodigoId();
				mapAlumProm.put(llave, ac);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoSaldoLista|mapAlumSaldo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapAlumProm;
	}
	
	
	
}
