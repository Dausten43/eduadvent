package aca.cont;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ContRelacion {
	private String mayorId;
	private String ccostoId;
	private String auxiliarId;
	private String nombre;	
	private String estado;
	private String naturaleza;
	private String tipoCta;	
	
	public ContRelacion(){
		mayorId			= "";
		ccostoId		= "";
		auxiliarId		= "";
		nombre			= "";
		estado 			= "";
		naturaleza		= "";
		tipoCta			= "";		
	}

	
	/**
	 * @return the auxiliarId
	 */
	public String getAuxiliarId() {
		return auxiliarId;
	}

	/**
	 * @param auxiliarId the auxiliarId to set
	 */
	public void setAuxiliarId(String auxiliarId) {
		this.auxiliarId = auxiliarId;
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
	 * @return the mayorId
	 */
	public String getMayorId() {
		return mayorId;
	}


	/**
	 * @param mayorId the mayorId to set
	 */
	public void setMayorId(String mayorId) {
		this.mayorId = mayorId;
	}


	/**
	 * @return the naturaleza
	 */
	public String getNaturaleza() {
		return naturaleza;
	}


	/**
	 * @param naturaleza the naturaleza to set
	 */
	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
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


	/**
	 * @return the tipoCta
	 */
	public String getTipoCta() {
		return tipoCta;
	}


	/**
	 * @param tipoCta the tipoCta to set
	 */
	public void setTipoCta(String tipoCta) {
		this.tipoCta = tipoCta;
	}


	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_RELACION(MAYOR_ID, CCOSTO_ID, AUXILIAR_ID, NOMBRE, " +
                    " ESTADO, NATURALEZA, TIPO_CTA )" +
                    " VALUES(?, ?, ?, ?, ?, ?, ?)");   
            ps.setString(1, mayorId);
            ps.setString(2, ccostoId);
            ps.setString(3, auxiliarId);
            ps.setString(4, nombre);
            ps.setString(5, estado);
            ps.setString(6, naturaleza);
            ps.setString(7, tipoCta);           

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContRelacion|insertReg|:" + ex);
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
                    "UPDATE CONT_RELACION " + 
                    " SET NOMBRE = ?," +
                    " ESTADO = ?," +
                    " NATURALEZA = ?," +
                    " TIPO_CTA = ? " +                                        
                    " WHERE MAYOR_ID = ?" +
                    " AND CCOSTO_ID = ?" +
                    " AND AUXILIAR_ID = ?");   
            
            ps.setString(1, nombre);
            ps.setString(2, estado);
            ps.setString(3, naturaleza);
            ps.setString(4, tipoCta);
            ps.setString(5, mayorId);
            ps.setString(6, ccostoId);
            ps.setString(7, auxiliarId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContRelacion|updateReg|:" + ex);
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
                    " DELETE FROM CONT_RELACION" +
                    " WHERE MAYOR_ID = ?" +
                    " AND CCOSTO_ID = ?" +
                    " AND AUXILIAR_ID = ?"); 
            ps.setString(1, mayorId);
            ps.setString(2, ccostoId);
            ps.setString(3, auxiliarId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContRelacion|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
		mayorId			= rs.getString("MAYOR_ID");
		ccostoId		= rs.getString("CCOSTO_ID");
		auxiliarId		= rs.getString("AUXILIAR_ID");
		nombre			= rs.getString("NOMBRE");
		estado			= rs.getString("ESTADO");
		naturaleza		= rs.getString("NATURALEZA");
		tipoCta			= rs.getString("TIPO_CTA");
    }

    public void mapeaRegId(Connection con, String mayorId, String ccostoId, String auxiliarId) throws SQLException{
        PreparedStatement ps = null;
    	ResultSet rs = null;
        try{
	    	ps = con.prepareStatement(
	                " SELECT MAYOR_ID, CCOSTO_ID, AUXILIAR_ID, NOMBRE, " +
	                " ESTADO, NATURALEZA, TIPO_CTA"+
	                " FROM CONT_RELACION" +
	                " WHERE MAYOR_ID = ?" +
	                " AND CCOSTO_ID = ?" +
	                " AND AUXILIAR_ID = ?");
	        ps.setString(1, mayorId);
	        ps.setString(2, ccostoId);
	        ps.setString(3, auxiliarId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContRelacion|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
    }
    
    public void mapeaRegMayorId(Connection con, String mayorId, String ccostoId, String auxiliarId) throws SQLException{
        PreparedStatement ps = null;
    	ResultSet rs = null;
        try{
	    	ps = con.prepareStatement(
	                " SELECT MAYOR_ID, CCOSTO_ID, AUXILIAR_ID, NOMBRE, " +
	                " ESTADO, NATURALEZA, TIPO_CTA"+
	                " FROM CONT_RELACION" +
	                " WHERE MAYOR_ID = ?" +
	                " AND CCOSTO_ID LIKE ?||'%'" +
	                " AND AUXILIAR_ID = ?");
	        ps.setString(1, mayorId);
	        ps.setString(2, ccostoId.substring(0, 3));
	        ps.setString(3, auxiliarId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContRelacion|mapeaRegMayorId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT AUXILIAR_ID FROM CONT_RELACION" +
        			" WHERE MAYOR_ID = ?" +
                    " AND CCOSTO_ID = ?" +
                    " AND AUXILIAR_ID = ?");	
        	ps.setString(1, mayorId);
        	ps.setString(2, ccostoId);
        	ps.setString(3, auxiliarId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContRelacion|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }    
    
    public static String getNombre(Connection con, String mayorId, String ccostoId, String auxiliarId) throws SQLException{
        PreparedStatement ps = null;
    	ResultSet rs = null;
        String nombre = "";
        try{
	        ps = con.prepareStatement(
	                " SELECT MAYOR_ID, CCOSTO_ID, AUXILIAR_ID, NOMBRE, " +
	                " ESTADO, NATURALEZA, TIPO_CTA"+
	                " FROM CONT_RELACION" +
	                " WHERE MAYOR_ID = ?" +
	                " AND CCOSTO_ID = ?" +
	                " AND AUXILIAR_ID = ?");
	        ps.setString(1, mayorId);
	        ps.setString(2, ccostoId);
	        ps.setString(3, auxiliarId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            nombre = rs.getString("NOMBRE");
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContRelacion|getNombre|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
        
        return nombre;
    }
}
