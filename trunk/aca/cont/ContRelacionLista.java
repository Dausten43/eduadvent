package aca.cont;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ContRelacionLista {
	public ArrayList<ContRelacion> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContRelacion> lisContRelacion 	= new ArrayList<ContRelacion>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT MAYOR_ID,CCOSTO_ID,AUXILIAR_ID,NOMBRE,ESTADO,NATURALEZA,TIPO_CTA " +
					"FROM CONT_RELACION "+orden;	
			//System.out.println(comando);
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContRelacion rel = new ContRelacion();				
				rel.mapeaReg(rs);
				lisContRelacion.add(rel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContRelacionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContRelacion;
	}
	
	public ArrayList<ContRelacion> getListCcosto(Connection conn, String ccostoId, String mayorId, String orden ) throws SQLException{
		ArrayList<ContRelacion> lisContRelacion 	= new ArrayList<ContRelacion>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT MAYOR_ID,CCOSTO_ID,AUXILIAR_ID,NOMBRE,ESTADO,NATURALEZA,TIPO_CTA " +
					"FROM CONT_RELACION" +
					" WHERE CCOSTO_ID = '"+ccostoId+"'" +
					" AND MAYOR_ID LIKE '"+mayorId+"%' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContRelacion rel = new ContRelacion();				
				rel.mapeaReg(rs);
				lisContRelacion.add(rel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContRelacionLista|getListCcosto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisContRelacion;
	}
	
	public ArrayList<ContRelacion> getListTipo(Connection conn, String ccostoId, String mayorId, String tipo, String orden ) throws SQLException{
		ArrayList<ContRelacion> lisContRelacion 	= new ArrayList<ContRelacion>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT MAYOR_ID,CCOSTO_ID,AUXILIAR_ID,NOMBRE,ESTADO,NATURALEZA,TIPO_CTA " +
					"FROM CONT_RELACION" +
					" WHERE CCOSTO_ID LIKE '"+ccostoId.substring(0, 3)+"%'" +
					" AND MAYOR_ID LIKE '"+mayorId+"%'" +
					" AND TIPO_CTA = '"+tipo+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContRelacion rel = new ContRelacion();				
				rel.mapeaReg(rs);
				lisContRelacion.add(rel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContRelacionLista|getListTipo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContRelacion;
	}
}
