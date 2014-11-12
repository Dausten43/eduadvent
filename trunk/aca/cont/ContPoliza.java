package aca.cont;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ContPoliza {
	private String ejercicioId;
	private String libroId;
	private String polizaId;	
	private String ccostoId;
	private String fecha;
	private String descripcion;
	private String estado;
	private String usAlta;
	private String usRevision;
	
	public ContPoliza(){
		ejercicioId		= "";
		polizaId		= "";
		libroId			= "";
		ccostoId		= "";
		fecha 			= "";
		descripcion		= "";
		estado			= "";
		usAlta			= "";
		usRevision		= 	"";
	}
	

	/**
	 * @return the ccostoId
	 */
	public String getCcostoId() {
		return ccostoId;
	}


	/**
	 * @param ccostoId the ccostoId to set
	 */
	public void setCcostoId(String ccostoId) {
		this.ccostoId = ccostoId;
	}



	/**
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}


	/**
	 * @param descripcion the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}


	/**
	 * @return the ejercicioId
	 */
	public String getEjercicioId() {
		return ejercicioId;
	}


	/**
	 * @param ejercicioId the ejercicioId to set
	 */
	public void setEjercicioId(String ejercicioId) {
		this.ejercicioId = ejercicioId;
	}


	/**
	 * @return the estado
	 */
	public String getEstado() {
		return estado;
	}


	/**
	 * @param estado the estado to set
	 */
	public void setEstado(String estado) {
		this.estado = estado;
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
	 * @return the libroId
	 */
	public String getLibroId() {
		return libroId;
	}


	/**
	 * @param libroId the libroId to set
	 */
	public void setLibroId(String libroId) {
		this.libroId = libroId;
	}


	/**
	 * @return the polizaId
	 */
	public String getPolizaId() {
		return polizaId;
	}


	/**
	 * @param polizaId the polizaId to set
	 */
	public void setPolizaId(String polizaId) {
		this.polizaId = polizaId;
	}


	/**
	 * @return the usAlta
	 */
	public String getUsAlta() {
		return usAlta;
	}


	/**
	 * @param usAlta the usAlta to set
	 */
	public void setUsAlta(String usAlta) {
		this.usAlta = usAlta;
	}


	/**
	 * @return the usRevision
	 */
	public String getUsRevision() {
		return usRevision;
	}


	/**
	 * @param usRevision the usRevision to set
	 */
	public void setUsRevision(String usRevision) {
		this.usRevision = usRevision;
	}


	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_POLIZA(EJERCICIO_ID, POLIZA_ID, LIBRO_ID, CCOSTO_ID, " +
                    " FECHA, DESCRIPCION, ESTADO, US_ALTA, US_REVISION )" +
                    " VALUES(?, ?, ?, ?, TO_DATE(?,'DD/MM/YYYY'), ?, ?, ?, ?)");   
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
            ps.setString(3, libroId);
            ps.setString(4, ccostoId);
            ps.setString(5, fecha);
            ps.setString(6, descripcion);
            ps.setString(7, estado);
            ps.setString(8, usAlta);
            ps.setString(9, usRevision);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContPoliza|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public boolean updateReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE CONT_POLIZA " +                    
                    " SET CCOSTO_ID = ?," +
                    " FECHA = TO_DATE(?,'DD/MM/YYYY')," +
                    " DESCRIPCION = ?," +
                    " ESTADO = ?," +                    
                    " US_ALTA = ?, " +
                    " US_REVISION = ? " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND LIBRO_ID = TO_NUMBER(?, '99')" +
                    " AND POLIZA_ID = ?");   
            
            ps.setString(1, ccostoId);
            ps.setString(2, fecha);
            ps.setString(3, descripcion);
            ps.setString(4, estado);            
            ps.setString(5, usAlta);
            ps.setString(6, usRevision);
            ps.setString(7, ejercicioId);
            ps.setString(8, libroId);
            ps.setString(9, polizaId);   
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContPoliza|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException{
    	PreparedStatement ps 	= null;
    	boolean ok 				= false;        

        try {
            ps = conn.prepareStatement(
                    " DELETE FROM CONT_POLIZA" +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND LIBRO_ID = ?" +
                    " AND POLIZA_ID = ?"); 
            ps.setString(1, ejercicioId);
            ps.setString(2, libroId);
            ps.setString(3, polizaId);            
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContPoliza|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		ejercicioId		= rs.getString("EJERCICIO_ID");
		polizaId		= rs.getString("POLIZA_ID");
		libroId			= rs.getString("LIBRO_ID");
		ccostoId		= rs.getString("CCOSTO_ID");
		fecha			= rs.getString("FECHA");
		descripcion		= rs.getString("DESCRIPCION");
		estado			= rs.getString("ESTADO");
		usAlta			= rs.getString("US_ALTA");
		usRevision		= rs.getString("US_REVISION");
    }

    public void mapeaRegId(Connection con, String ejercicioId, String libroId, String polizaId) throws SQLException{
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
	        ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, POLIZA_ID, LIBRO_ID, CCOSTO_ID, " +
	                " TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, DESCRIPCION, ESTADO, US_ALTA, US_REVISION "+
	                " FROM CONT_POLIZA" +
	                " WHERE EJERCICIO_ID = ?" +
	                " AND LIBRO_ID = ?" +
	                " AND POLIZA_ID = ?");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, libroId);
	        ps.setString(3, polizaId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContPoliza|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
    }

    public boolean existeReg(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
        	ps = conn.prepareStatement("SELECT LIBRO_ID FROM CONT_POLIZA" +
        			" WHERE EJERCICIO_ID = ?" +
        			" AND LIBRO_ID = ?" +
                    " AND POLIZA_ID = ?");                    	
        	ps.setString(1, ejercicioId);
        	ps.setString(2, libroId);
        	ps.setString(3, polizaId);      	
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContPoliza|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
    
    public String maxReg(Connection conn, String ejercicioId, String libroId) throws SQLException {
        String maximo			= "00001";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
        	ps = conn.prepareStatement("SELECT COALESCE(TO_NUMBER(MAX(POLIZA_ID),'99999')+1,1) AS MAXIMO FROM CONT_POLIZA"+
            		" WHERE EJERCICIO_ID = ?" +
            		" AND LIBRO_ID = ?");
            ps.setString(1, ejercicioId);
            ps.setString(2, libroId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO").trim();
                switch (maximo.length()){
                case 1: maximo = "0000"+ maximo; break;
                case 2: maximo = "000"+ maximo; break;
                case 3: maximo = "00"+ maximo; break;
                case 4: maximo = "0"+ maximo; break;
                
                }
            }         
                
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContPoliza|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }
    
    public static boolean tieneMovimientos(Connection conn, String ejercicioId, String libroId, String polizaId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
        	ps = conn.prepareStatement("SELECT POLIZA_ID FROM CONT_MOVIMIENTO" +
        			" WHERE EJERCICIO_ID = ?" +
        			" AND LIBRO_ID = ?" +
                    " AND POLIZA_ID = ?");                    	
        	ps.setString(1, ejercicioId);
        	ps.setString(2, libroId);
        	ps.setString(3, polizaId);      	
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContPoliza|tieneMovimientos|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
}
