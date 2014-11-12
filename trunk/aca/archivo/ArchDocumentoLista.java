package aca.archivo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import aca.archivo.ArchDocumento;

public class ArchDocumentoLista {
	
	public ArrayList<ArchDocumento> getListAll(Connection conn, String escuelaId, String orden) throws SQLException{
		ArrayList<ArchDocumento> lisArchDoc	= new ArrayList<ArchDocumento>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, DOCUMENTO_ID, DOCUMENTO_NOMBRE FROM ARCH_DOCUMENTO WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchDocumento clas = new ArchDocumento();				
				clas.mapeaReg(rs);
				lisArchDoc.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumentoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisArchDoc;
	}
	
	public ArrayList<ArchDocumento> getListArchDocumento(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<ArchDocumento> lisArchDoc	= new ArrayList<ArchDocumento>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, DOCUMENTO_ID, DOCUMENTO_NOMBRE FROM ARCH_DOCUMENTO WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchDocumento clas = new ArchDocumento();				
				clas.mapeaReg(rs);
				lisArchDoc.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumentoLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisArchDoc;
	}
	
	public ArrayList<ArchDocumento> getListArchDocumentoNivel(Connection conn, String escuelaId, String nivelId, String orden ) throws SQLException{
		ArrayList<ArchDocumento> lisArchDoc	= new ArrayList<ArchDocumento>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, DOCUMENTO_ID, DOCUMENTO_NOMBRE FROM ARCH_DOCUMENTO "
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "
					+ " AND DOCUMENTO_ID IN (SELECT DOCUMENTO_ID FROM ARCH_DOCNIVEL WHERE NIVEL_ID = '"+nivelId+"' AND ESCUELA_ID = '"+escuelaId+"') "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ArchDocumento clas = new ArchDocumento();				
				clas.mapeaReg(rs);
				lisArchDoc.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumentoLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisArchDoc;
	}
}

