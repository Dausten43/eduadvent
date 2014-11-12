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
public class ContMayorLista {
	/**
	 * Busca todos los registros de CONT_MAYOR
	 * @param conn Conexión a la Base de Datos
	 * @param orden El orden en que se quieren los datos (en forma de query)
	 * @return Un <b>ArrayList</b> con todos los registros de CONT_MAYOR
	 * @throws SQLException
	 */
	public ArrayList<ContMayor> getListAll(Connection conn, String orden) throws SQLException{
		ArrayList<ContMayor> lisMayor	= new ArrayList<ContMayor>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT MAYOR_ID, TIPO_CTA, MAYOR_NOMBRE, DETALLE, NATURALEZA" +
					" FROM CONT_MAYOR "+orden;		
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ContMayor mayor = new ContMayor();		
				mayor.mapeaReg(rs);
				lisMayor.add(mayor);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContMayorLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisMayor;
	}
	
	/**
	 * Busca los registros de CONT_MAYOR con el tipoCta dado
	 * @param conn Conexión a la Base de Datos
	 * @param tipoCta El tipo de cuenta a buscar
	 * @param orden El orden en que se quieren los datos (en forma de query)
	 * @return Un <b>ArrayList</b> con los registros de CONT_MAYOR que sean del tipo de cuenta dado
	 * @throws SQLException
	 */
	public ArrayList<ContMayor> getListTipo(Connection conn, String tipoCta, String orden) throws SQLException{
		ArrayList<ContMayor> lisMayor	= new ArrayList<ContMayor>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT MAYOR_ID, TIPO_CTA, MAYOR_NOMBRE, DETALLE, NATURALEZA" +
					" FROM CONT_MAYOR" +
					" WHERE TIPO_CTA = '"+tipoCta+"' "+orden;		
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ContMayor mayor = new ContMayor();		
				mayor.mapeaReg(rs);
				lisMayor.add(mayor);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContMayorLista|getListTipo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisMayor;
	}
	
	public ArrayList<ContMayor> getListBalance(Connection conn, String ejercicioId, String mascaraLength, String wildcard, String orden) throws SQLException{
		ArrayList<ContMayor> lisMayor	= new ArrayList<ContMayor>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT MAYOR_ID, TIPO_CTA, MAYOR_NOMBRE," +
					" TO_CHAR(SALDO_CTA_MAYOR('"+ejercicioId+"', SUBSTR(MAYOR_ID, 0, "+mascaraLength+"), 'B'), '99999990.00') AS DETALLE, NATURALEZA" +
					" FROM CONT_MAYOR" +
					" WHERE TIPO_CTA = 'B'" +
					" AND MAYOR_ID LIKE '%"+wildcard+"' "+orden;
			//System.out.println(comando);
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ContMayor mayor = new ContMayor();
				mayor.mapeaReg(rs);
				lisMayor.add(mayor);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContMayorLista|getListBalance|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisMayor;
	}
	
	public ArrayList<ContMayor> getListResultado(Connection conn, String ejercicioId, String mascaraLength, String wildcard, String orden) throws SQLException{
		ArrayList<ContMayor> lisMayor	= new ArrayList<ContMayor>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT MAYOR_ID, TIPO_CTA, MAYOR_NOMBRE," +
					" TO_CHAR(SALDO_CTA_MAYOR('"+ejercicioId+"', SUBSTR(MAYOR_ID, 0, "+mascaraLength+"), 'R'), '99999990.00') AS DETALLE, NATURALEZA" +
					" FROM CONT_MAYOR" +
					" WHERE TIPO_CTA = 'R'" +
					" AND MAYOR_ID LIKE '%"+wildcard+"' "+orden;		
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ContMayor mayor = new ContMayor();		
				mayor.mapeaReg(rs);
				lisMayor.add(mayor);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContMayorLista|getListResultado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}

		return lisMayor;
	}
}
