package aca.ciclo;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CicloGrupoAviso {
	
	private String cicloGrupoId;
	private String cursoId;
	private String folio;
	private String empleadoId;
	private String codigoId;
	private String fecha;
	private String aviso;
	
	
	public CicloGrupoAviso(){
		cicloGrupoId 	= "";
		cursoId 		= "";
		folio			= "";
		empleadoId		= "";
		codigoId		= "";		
		fecha			= "";
		aviso			= "";
	}


	/**
	 * @return the cicloGrupoId
	 */
	public String getCicloGrupoId() {
		return cicloGrupoId;
	}


	/**
	 * @param cicloGrupoId the cicloGrupoId to set
	 */
	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}


	/**
	 * @return the cursoId
	 */
	public String getCursoId() {
		return cursoId;
	}


	/**
	 * @param cursoId the cursoId to set
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}


	/**
	 * @return the empleadoId
	 */
	public String getEmpleadoId() {
		return empleadoId;
	}


	/**
	 * @param empleadoId the empleadoId to set
	 */
	public void setEmpleadoId(String empleadoId) {
		this.empleadoId = empleadoId;
	}


	/**
	 * @return the alumnoId
	 */
	public String getCodigoId() {
		return codigoId;
	}


	/**
	 * @param alumnoId the alumnoId to set
	 */
	public void setCodigoId(String alumnoId) {
		this.codigoId = alumnoId;
	}


	/**
	 * @return the folio
	 */
	public String getFolio() {
		return folio;
	}


	/**
	 * @param folio the folio to set
	 */
	public void setFolio(String folio) {
		this.folio = folio;
	}


	/**
	 * @return the fecha
	 */
	public String getFecha() {
		return fecha;
	}


	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}


	/**
	 * @return the aviso
	 */
	public String getAviso() {
		return aviso;
	}


	/**
	 * @param aviso the aviso to set
	 */
	public void setAviso(String aviso) {
		this.aviso = aviso;
	}
	
	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{			
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_AVISO" +
					"(CICLO_GRUPO_ID, CURSO_ID, FOLIO, EMPLEADO_ID, CODIGO_ID, FECHA, AVISO) " +
					"VALUES(?, ?, TO_NUMBER(?,'9999'), ?, ?, TO_DATE(?, 'DD/MM/YYYY'), ?)");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, folio);
			ps.setString(4, empleadoId);			
			ps.setString(5, codigoId);
			ps.setString(6, fecha);
			ps.setString(7, aviso);
						
			if ( ps.executeUpdate()== 1){
				ok = true;			
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoAviso.insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;

        try{
            ps = conn.prepareStatement(
                    "UPDATE CICLO_GRUPO_AVISO" +
                    " SET EMPLEADO_ID = ?," +
                    " CODIGO_ID = ?," +
                    " FECHA = TO_DATE(?, 'DD/MM/YYYY')," +
                    " AVISO = ?" +
                    " WHERE CICLO_GRUPO_ID = ?" +
                    " AND CURSO_ID = ? " +
                    " AND FOLIO = TO_NUMBER(?, '9999')");
            
            ps.setString(1, empleadoId);
            ps.setString(2, codigoId);
            ps.setString(3, fecha);
            ps.setString(4, aviso);
            ps.setString(5, cicloGrupoId);
            ps.setString(6, cursoId);
            ps.setString(7, folio);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.ciclo.CicloGrupoAviso|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }

        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException{
    	PreparedStatement ps = null;
    	boolean ok = false;

        try {
            ps = conn.prepareStatement(
                    "DELETE FROM CICLO_GRUPO_AVISO" +
                    " WHERE CICLO_GRUPO_ID = ?" +
                    " AND CURSO_ID = ?" +
                    " FOLIO = TO_NUMBER(?, '9999')");
            
            ps.setString(1, cicloGrupoId);
            ps.setString(2, cursoId);
            ps.setString(3, folio);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.ciclo.CicloGrupoAviso|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
		cursoId			= rs.getString("CURSO_ID");
		folio			= rs.getString("FOLIO");
		empleadoId		= rs.getString("EMPLEADO_ID");
		codigoId		= rs.getString("CODIGO_ID");		
		fecha			= rs.getString("FECHA");
		aviso			= rs.getString("AVISO");
    }
    
	
	public void mapeaRegId(Connection con, String cicloGrupoId, String cursoId, String folio) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
		ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, CURSO_ID," +
				" FOLIO, EMPLEADO_ID, CODIGO_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, AVISO" +
				" FROM CICLO_GRUPO_AVISO" +
				" WHERE CICLO_GRUPO_ID = ?" +
				" AND CURSO_ID = ?" +
				" FOLIO = TO_NUMBER(?, '9999')");
		
		ps.setString(1, cicloGrupoId);
		ps.setString(2, cursoId);
		ps.setString(3, folio);
	
		
		rs = ps.executeQuery();
	
		if(rs.next()){		
			mapeaReg(rs);		
		}
		
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoAviso|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_AVISO" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?" +
					" AND FOLIO = TO_NUMBER(?, '9999')");
					
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, folio);
			
			rs= ps.executeQuery();
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoAviso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		String maximo 			= "1";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1, 1) AS MAXIMO FROM CICLO_GRUPO_AVISO" +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'");
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoAviso|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
}


