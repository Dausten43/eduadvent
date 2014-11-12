package aca.cont;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

public class ContCcostoLista {
	public ArrayList<ContCcosto> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContCcosto> lisContCcosto 	= new ArrayList<ContCcosto>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CCOSTO_ID,NOMBRE,DETALLE FROM CONT_CCOSTO "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContCcosto costo = new ContCcosto();				
				costo.mapeaReg(rs);
				lisContCcosto.add(costo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContCcostoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisContCcosto;
	}
	
	public ArrayList<ContCcosto> getListCentros(Connection conn, String orden ) throws SQLException{
		ArrayList<ContCcosto> lisContCcosto 	= new ArrayList<ContCcosto>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CCOSTO_ID, NOMBRE, DETALLE" +
					" FROM CONT_CCOSTO" +
					" WHERE CCOSTO_ID NOT LIKE '%000' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContCcosto costo = new ContCcosto();				
				costo.mapeaReg(rs);
				lisContCcosto.add(costo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContCcostoLista|getListContabilidades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisContCcosto;
	}
	
	/**
	 * Busca todos los centros contables del nivel contable(En un caso normal, buscaria todas las escuelas) especificado
	 * @param conn Conexión a la Base de Datos
	 * @param orden Orden en que se desean los datos (En formato SQL)
	 * @return	Un <b>ArrayList</b> con los centros de costo del nivel contable predefinido
	 * @throws SQLException
	 */
	public ArrayList<ContCcosto> getListNivelContable(Connection conn, String orden ) throws SQLException{
		aca.cont.ContMascara contMascara	= new aca.cont.ContMascara();
		ArrayList<ContCcosto> lisContCcosto 	= new ArrayList<ContCcosto>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		String ceros						= "";
		String cerosAsociacion				= "";
		int escuelaInicio					= 0;
        int escuelaSize						= 0;
        int centroInicio					= 0;
        int centroSize						= 0;
        int noAsociacionSize				= 0;//La parte que no es de la asociacion
		
		contMascara.mapeaRegId(conn, "1");
        for(int i = 1; i <= Integer.parseInt(contMascara.getNivelContable()); i++){
        	if((i == Integer.parseInt(contMascara.getNivelContable()))){
        		escuelaInicio++;
        		escuelaSize = Integer.parseInt(String.valueOf(contMascara.getMascCcosto().charAt(i-1)));
        	}else{
        		escuelaInicio += Integer.parseInt(String.valueOf(contMascara.getMascCcosto().charAt(i-1)));
        	}
        }
        centroInicio = escuelaInicio+escuelaSize;
        for(int i = 0; i < contMascara.getMascCcosto().length(); i++){
        	centroSize += Integer.parseInt(String.valueOf(contMascara.getMascCcosto().charAt(i)));
        }
        
        noAsociacionSize = centroSize - (escuelaInicio-1);
        for(int i = escuelaInicio-1; i < centroSize; i++){//Para sacar los ceros que lleva la asociacion
        	cerosAsociacion += "0";
        }
        
        centroSize = (centroSize+1)-centroInicio;
        for(int i = 0; i < centroSize; i++){
        	ceros += "0";
        }
		
		try{
			comando = "SELECT CCOSTO_ID, NOMBRE, DETALLE" +
					" FROM CONT_CCOSTO" +
					" WHERE SUBSTR(CCOSTO_ID, "+escuelaInicio+", "+noAsociacionSize+") <> '"+cerosAsociacion+"'" +
					" AND SUBSTR(CCOSTO_ID, "+centroInicio+", "+centroSize+") = '"+ceros+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContCcosto costo = new ContCcosto();				
				costo.mapeaReg(rs);
				lisContCcosto.add(costo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContCcostoLista|getListNivelContable|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}

		return lisContCcosto;
	}
}
