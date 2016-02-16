package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatActividadEtiqueta {
	
	private String unionId;
	private String etiquetaId;
	private String etiquetaNombre;
	
	public CatActividadEtiqueta(){
		unionId				= "";
		etiquetaId			= "";
		etiquetaNombre		= "";
	}
	
		
	public String getUnionId() {
		return unionId;
	}

	public void setUnionId(String unionId) {
		this.unionId = unionId;
	}

	public String getEtiquetaId() {
		return etiquetaId;
	}

	public void setEtiquetaId(String etiquetaId) {
		this.etiquetaId = etiquetaId;
	}

	public String getEtiquetaNombre() {
		return etiquetaNombre;
	}

	public void setEtiquetaNombre(String etiquetaNombre) {
		this.etiquetaNombre = etiquetaNombre;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ACTIVIDAD_ETIQUETA" +
					" (UNION_ID, ETIQUETA_ID, ETIQUETA_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '99'), TO_NUMBER(?, '999'), ?)");
							
			ps.setString(1, unionId);
			ps.setString(2, etiquetaId);
			ps.setString(3, etiquetaNombre);			
						
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiqueta|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_ACTIVIDAD_ETIQUETA" +
					" SET ETIQUETA_NOMBRE = ? " +
					" WHERE UNION_ID = TO_NUMBER(?, '99') AND  ETIQUETA_ID = TO_NUMBER(?, '999')");
			
			ps.setString(1, unionId);
			ps.setString(2, etiquetaNombre);					
			ps.setString(3, etiquetaId);
				
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiqueta|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ACTIVIDAD_ETIQUETA" +
					" WHERE UNION_ID = TO_NUMBER(?, '99') AND ETIQUETA_ID = TO_NUMBER(?, '999')");
			
			ps.setString(1, unionId);
			ps.setString(2, etiquetaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiqueta|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		unionId				= rs.getString("UNION_ID");
		etiquetaId			= rs.getString("ETIQUETA_ID");
		etiquetaNombre		= rs.getString("ETIQUETA_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String etiquetaId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT * " +
					" FROM CAT_ACTIVIDAD_ETIQUETA WHERE ETIQUETA_ID = TO_NUMBER(?, '999') ");
			ps.setString(1, etiquetaId);
			
			rs = ps.executeQuery();			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiqueta|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_ACTIVIDAD_ETIQUETA WHERE ETIQUETA_ID = TO_NUMBER(?, '999') ");
			ps.setString(1, etiquetaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiqueta|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ETIQUETA_ID)+1,'1') AS MAXIMO FROM CAT_ACTIVIDAD_ETIQUETA WHERE UNION_ID = TO_NUMBER(?, '99' ");
			ps.setString(1, unionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiqueta|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getNombreEtiqueta(Connection conn, String unionId, String etiquetaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre 			= "";
		
		try{
			ps = conn.prepareStatement("SELECT ETIQUETA_NOMBRE FROM CAT_ACTIVIDAD_ETIQUETA "
					+ " WHERE UNION_ID = TO_NUMBER(?, '99') AND ETIQUETA_ID = TO_NUMBER(?, '999') ");
			ps.setString(1, unionId);
			ps.setString(2, etiquetaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("ETIQUETA_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatActividadEtiqueta|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nombre;
	}
	
	
}
