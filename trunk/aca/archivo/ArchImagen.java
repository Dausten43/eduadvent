package aca.archivo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ArchImagen {
	
	private String codigoId;
	private String escuelaId;
	private String documentoId;
	private String hoja;
	private long imagen;
	private String nombre;
	
	public ArchImagen(){
		codigoId 		= "";
		escuelaId 		= "";
		documentoId		= "";
		hoja			= "";
		imagen			= 0;
		nombre			= "";
	}
		
	
	/**
	 * @return the codigoId
	 */
	public String getCodigoId() {
		return codigoId;
	}

	/**
	 * @param codigoId the codigoId to set
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}


	/**
	 * @return the escuelaId
	 */
	public String getEscuelaId() {
		return escuelaId;
	}

	/**
	 * @param escuelaId the escuelaId to set
	 */
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}


	/**
	 * @return the documentoId
	 */
	public String getDocumentoId() {
		return documentoId;
	}

	/**
	 * @param documentoId the documentoId to set
	 */
	public void setDocumentoId(String documentoId) {
		this.documentoId = documentoId;
	}


	/**
	 * @return the hoja
	 */
	public String getHoja() {
		return hoja;
	}

	/**
	 * @param hoja the hoja to set
	 */
	public void setHoja(String hoja) {
		this.hoja = hoja;
	}


	/**
	 * @return the imagen
	 */
	public long getImagen() {
		return imagen;
	}

	/**
	 * @param imagen the imagen to set
	 */
	public void setImagen(long imagen) {
		this.imagen = imagen;
	}
	

	/**
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}


	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("INSERT INTO ARCH_IMAGEN" +
					"(CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, HOJA, IMAGEN, NOMBRE) " +
					"VALUES(?, ?, TO_NUMBER(?,'99'), TO_NUMBER(?,'99'), ?, ?)");
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			ps.setString(4, hoja);
			ps.setLong(5, imagen);
			ps.setString(6, nombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagen.insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteSoloRegistro(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		
		try{
			ps = conn.prepareStatement("DELETE FROM ARCH_IMAGEN"+
					" WHERE CODIGO_ID  = ?" +
					" AND ESCUELA_ID = ?" +
					" AND DOCUMENTO_ID = TO_NUMBER(?,'99')" +
					" AND HOJA = TO_NUMBER(?,'99')");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			ps.setString(4, hoja);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagen|deleteSoloRegistro|:"+ex);
			ok = false;
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ResultSet rs = null;
			ps = conn.prepareStatement("SELECT LO_UNLINK(IMAGEN) AS RESULTADO FROM ARCH_IMAGEN"+
				" WHERE CODIGO_ID  = ?" +
				" AND ESCUELA_ID = ?" +
				" AND DOCUMENTO_ID = TO_NUMBER(?,'99')" +
				" AND HOJA = TO_NUMBER(?,'99')" );
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			ps.setString(4, hoja);		
			
			rs = ps.executeQuery();
			if(rs.next()){
			    ok=rs.getInt("RESULTADO")==1?true:false;
			}
		}catch(Exception ex){
			System.out.println("Error - adm.archivo.ArchImagen|unlink - deleteReg|:"+ex);
			ok = false;
		}finally{
			if (ps!=null) ps.close();
		}
		ps = null;
		if(ok){
			ok = false;
			try{
				ps = conn.prepareStatement("DELETE FROM ARCH_IMAGEN"+
						" WHERE CODIGO_ID  = ?" +
						" AND ESCUELA_ID = ?" +
						" AND DOCUMENTO_ID = TO_NUMBER(?,'99')" +
						" AND HOJA = TO_NUMBER(?,'99')");
				
				ps.setString(1, codigoId);
				ps.setString(2, escuelaId);
				ps.setString(3, documentoId);
				ps.setString(4, hoja);
				
				if (ps.executeUpdate()== 1)
					ok = true;
				else
					ok = false;
			}catch(Exception ex){
				System.out.println("Error - aca.archivo.ArchImagen|borrar - deleteReg|:"+ex);
				ok = false;
			}finally{
				if (ps!=null) ps.close();
			}
		}else{
			System.out.println("No se pudo desligar la imagen... - aca.archivo.ArchImagen|deleteReg");
		}
		
		return ok;
	}	
		
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		escuelaId  		= rs.getString("ESCUELA_ID");
		documentoId		= rs.getString("DOCUMENTO_ID");
		hoja			= rs.getString("HOJA");
		imagen			= rs.getInt("IMAGEN");
		nombre			= rs.getString("NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String escuelaId, String documentoId, String hoja) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, HOJA, IMAGEN, NOMBRE" +
					" FROM ARCH_IMAGEN" +
					" WHERE CODIGO_ID = ?" +
					" AND ESCUELA_ID = ?" +
					" AND DOCUMENTO_ID = TO_NUMBER(?,'99')" +
					" AND HOJA = TO_NUMBER(?,'99')");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			ps.setString(4, hoja);			
				
			rs = ps.executeQuery();
		
			if(rs.next()){		
				mapeaReg(rs);		
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagen|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM ARCH_IMAGEN" +
					" WHERE CODIGO_ID = ?" +
					" AND ESCUELA_ID = ?" +
					" AND DOCUMENTO_ID = TO_NUMBER(?,'99')" +
					" AND HOJA = TO_NUMBER(?,'99')");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			ps.setString(4, hoja);
			
			rs= ps.executeQuery();
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagen|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String codigoId, String escuelaId, String documentoId) throws SQLException{
		String maximo 			= "1";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(HOJA)+1, 1) AS MAXIMO FROM ARCH_IMAGEN" +
					" WHERE CODIGO_ID = '"+codigoId+"'" +
					" AND ESCUELA_ID = '"+escuelaId+"'" +
					" AND DOCUMENTO_ID = TO_NUMBER('"+documentoId+"','99')");
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagen|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	public int getCantidadOID(Connection conn, int oid) throws SQLException{
		int cantidad 			= 0;
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS CANTIDAD FROM ARCH_IMAGEN WHERE IMAGEN = "+oid+" ");
			rs = ps.executeQuery();
			if (rs.next())
				cantidad = rs.getInt("CANTIDAD");
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagen|getCantidadOID|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return cantidad;
	}
	
	public static int numArchivos(Connection conn, String codigoId, String escuelaId, String documentoId) throws SQLException{
		
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		int numTareas			= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(*),0) AS NUMARCHIVOS FROM ARCH_IMAGEN " +
					" WHERE CODIGO_ID = ?" +
					" AND ESCUELA_ID = ?" +
					" AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				numTareas = rs.getInt("NUMARCHIVOS");
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchImagen|numArchivos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return numTareas;
	}
		
	
}