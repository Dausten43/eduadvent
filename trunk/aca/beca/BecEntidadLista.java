package aca.beca;

import java.sql.*;
import java.util.ArrayList;

public class BecEntidadLista {
	public ArrayList<BecEntidad> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<BecEntidad> lisCatBeca 	= new ArrayList<BecEntidad>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *" +
					" FROM BEC_ENTIDAD" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecEntidad beca = new BecEntidad();				
				beca.mapeaReg(rs);
				lisCatBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecInstitucionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCatBeca;
	}
	
	public ArrayList<BecEntidad> getListEntidad(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<BecEntidad> lisCatBeca 	= new ArrayList<BecEntidad>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT * FROM BEC_ENTIDAD"
					+ " WHERE ENTIDAD_ID IN "
					+ "		(SELECT ENTIDAD_ID FROM BEC_ALUMNO WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND PERIODO_ID = '"+periodoId+"')"
					+ " "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecEntidad beca = new BecEntidad();				
				beca.mapeaReg(rs);
				lisCatBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecInstitucionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCatBeca;
	}
	
	public ArrayList<BecEntidad> getListEntidad(Connection conn, String escuelaId, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<BecEntidad> lisCatBeca 	= new ArrayList<BecEntidad>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT * FROM BEC_ENTIDAD"
					+ " WHERE ENTIDAD_ID IN "
					+ "		(SELECT ENTIDAD_ID FROM BEC_ALUMNO WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND PERIODO_ID = '"+periodoId+"')"
					+ " AND ESCUELA_ID = '"+escuelaId+"'"
					+ " "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				BecEntidad beca = new BecEntidad();				
				beca.mapeaReg(rs);
				lisCatBeca.add(beca);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.beca.BecInstitucionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisCatBeca;
	}
}