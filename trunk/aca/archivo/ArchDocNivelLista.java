package aca.archivo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ArchDocNivelLista {
	
	public ArrayList<ArchDocNivel> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<ArchDocNivel> lisArchDocNivel	= new ArrayList<ArchDocNivel>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, NIVEL_ID, DOCUMENTO_ID FROM ARCH_DOCNIVEL ESCUELA_ID = '"+escuelaId+"'"+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchDocNivel clas = new ArchDocNivel();				
				clas.mapeaReg(rs);
				lisArchDocNivel.add(clas);
				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumentoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchDocNivel;
	}
	
	public ArrayList<ArchDocNivel> getListDocNivel(Connection conn, String escuelaId, String nivelId, String orden ) throws SQLException{
		ArrayList<ArchDocNivel> lisArchDocNivel	= new ArrayList<ArchDocNivel>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, NIVEL_ID, DOCUMENTO_ID FROM ARCH_DOCNIVEL WHERE NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') and ESCUELA_ID='"+escuelaId+"'"+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchDocNivel clas = new ArchDocNivel();				
				clas.mapeaReg(rs);
				lisArchDocNivel.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocNivelLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchDocNivel;
	}
}