package aca.cont;
import java.sql.*;
import java.util.ArrayList;

public class ContAuxiliarLista {
	/**
	 * Busca todos los registros de CONT_AUXILIAR
	 * @param conn Conexión a la Base de Datos
	 * @param orden El orden en que se quieren los datos (en forma de query)
	 * @return Un ArrayList de todos los auxiliares
	 * @throws SQLException
	 */
	public ArrayList<ContAuxiliar> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContAuxiliar> lisContAuxiliar 	= new ArrayList<ContAuxiliar>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT AUXILIAR_ID, AUXILIAR_NOMBRE, DETALLE, TIPO_ID FROM CONT_AUXILIAR "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContAuxiliar auxiliar = new ContAuxiliar();				
				auxiliar.mapeaReg(rs);
				lisContAuxiliar.add(auxiliar);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContAuxiliarLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisContAuxiliar;
	}

	/**
	 * Busca los auxiliares que sean del tipo dado y de la escuela dada
	 * @param conn Conexión a la Base de Datos
	 * @param tipoId El tipo de auxiliar que se desea buscar
	 * @param escuelaId La escuela para la que se quiere buscar el auxiliar
	 * @param orden El orden en que se quieren los datos (en forma de query)
	 * @return Un ArrayList de los auxiliares que coincidan con el tipo y con la escuela deseados
	 * @throws SQLException
	 */
	public ArrayList<ContAuxiliar> getListTipo(Connection conn, String tipoId, String escuelaId, String orden ) throws SQLException{
		ArrayList<ContAuxiliar> lisContAuxiliar 	= new ArrayList<ContAuxiliar>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			if(escuelaId.length() == 1)
				escuelaId = "0" + escuelaId;
			comando = "SELECT AUXILIAR_ID, AUXILIAR_NOMBRE, DETALLE, TIPO_ID FROM CONT_AUXILIAR" +
					" WHERE TIPO_ID = " + tipoId +
					" AND AUXILIAR_ID LIKE '"+escuelaId+"%' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContAuxiliar auxiliar = new ContAuxiliar();				
				auxiliar.mapeaReg(rs);
				lisContAuxiliar.add(auxiliar);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContAuxiliarLista|getListTipo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisContAuxiliar;
	}
}
