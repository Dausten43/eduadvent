package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FinFolio {
	
	private String ejercicioId;
	private String usuario;
	private String reciboInicial;
	private String reciboFinal;
	private String reciboActual;
	private String estado;
	private String folio;
	
	public FinFolio(){
		ejercicioId		= "";
		usuario			= "";
		reciboInicial	= "";
		reciboFinal		= "";
		reciboActual	= "-1";
		estado			= "I";
		folio			= "";
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
	 * @return the usuario
	 */
	public String getUsuario() {
		return usuario;
	}

	/**
	 * @param usuario the usuario to set
	 */
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	
	/**
	 * @return the reciboInicial
	 */
	public String getReciboInicial() {
		return reciboInicial;
	}

	/**
	 * @param reciboInicial the reciboInicial to set
	 */
	public void setReciboInicial(String reciboInicial) {
		this.reciboInicial = reciboInicial;
	}

	/**
	 * @return the reciboFinal
	 */
	public String getReciboFinal() {
		return reciboFinal;
	}

	/**
	 * @param reciboFinal the reciboFinal to set
	 */
	public void setReciboFinal(String reciboFinal) {
		this.reciboFinal = reciboFinal;
	}

	/**
	 * @return the reciboActual
	 */
	public String getReciboActual() {
		return reciboActual;
	}

	/**
	 * @param reciboActual the reciboActual to set
	 */
	public void setReciboActual(String reciboActual) {
		this.reciboActual = reciboActual;
	}
	
	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_FOLIO(EJERCICIO_ID, USUARIO, RECIBO_INICIAL, RECIBO_FINAL, RECIBO_ACTUAL, ESTADO, FOLIO)" +
                    " VALUES(?, ?, TO_NUMBER(?, '9999999'), TO_NUMBER(?, '9999999'), TO_NUMBER(?, '9999999'), ?, TO_NUMBER(?, '99'))");
           
            ps.setString(1, ejercicioId);           
            ps.setString(2, usuario);
            ps.setString(3, reciboInicial);
            ps.setString(4, reciboFinal);
            ps.setString(5, reciboActual);
            ps.setString(6, estado);
            ps.setString(7, folio);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|insertReg|:" + ex);
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
            ps = conn.prepareStatement("UPDATE FIN_FOLIO SET RECIBO_INICIAL = TO_NUMBER(?, '9999999'), " +
            		"RECIBO_FINAL  = TO_NUMBER(?, '9999999'), ESTADO = ? WHERE EJERCICIO_ID = ? AND USUARIO = ? AND FOLIO = TO_NUMBER(?, '99') ");            
            ps.setString(1, reciboInicial);
            ps.setString(2, reciboFinal);
            ps.setString(3, estado);
            ps.setString(4, ejercicioId);
            ps.setString(5, usuario);
            ps.setString(6, folio);
            

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|updateReg|:" + ex);
        }finally{
        	 if(ps != null){
                 ps.close();
             }
        }

        return ok;
    }
    
    public boolean updateEstatusInactivos(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("UPDATE FIN_FOLIO SET ESTADO = 'I' WHERE EJERCICIO_ID = ? AND USUARIO = ? AND FOLIO != TO_NUMBER(?, '99') ");            
            ps.setString(1, ejercicioId);
            ps.setString(2, usuario);
            ps.setString(3, folio);
        
            if(ps.executeUpdate() >= 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|updateEstatusInactivos|:" + ex);
        }finally{
        	 if(ps != null){
                 ps.close();
             }
        }

        return ok;
    }

    public boolean updateReciboActual(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("UPDATE FIN_FOLIO "
            		+ " SET RECIBO_ACTUAL = TO_NUMBER(?, '9999999') "
            		+ " WHERE EJERCICIO_ID = ?"
            		+ " AND USUARIO = ?"
            		+ " AND FOLIO = TO_NUMBER(?,'99')");            
            
            ps.setString(1, reciboActual);
            ps.setString(2, ejercicioId);
            ps.setString(3, usuario);
            ps.setString(4, folio);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|updateReciboActual|:" + ex);
        }finally{
        	 if(ps != null){
                 ps.close();
             }
        }

        return ok;
    }
    

    public boolean deleteReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement("DELETE FROM FIN_FOLIO WHERE EJERCICIO_ID = ? AND USUARIO = ? AND FOLIO = TO_NUMBER(?,'99')");
            ps.setString(1, ejercicioId);
            ps.setString(2, usuario);
            ps.setString(3, folio);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinFolio|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        ejercicioId		= rs.getString("EJERCICIO_ID");
        usuario			= rs.getString("USUARIO");
		reciboInicial	= rs.getString("RECIBO_INICIAL");
		reciboFinal		= rs.getString("RECIBO_FINAL");
		reciboActual	= rs.getString("RECIBO_ACTUAL");
		estado			= rs.getString("ESTADO");
		folio			= rs.getString("FOLIO");
    }
        
    public void mapeaRegId(Connection conn, String ejercicioId, String usuario, String folio) throws SQLException{
    	
    	PreparedStatement ps 	= null;
        ResultSet rs 			= null;
         
        try{
	        ps = conn.prepareStatement("SELECT EJERCICIO_ID, USUARIO, RECIBO_INICIAL, RECIBO_FINAL, RECIBO_ACTUAL, ESTADO, FOLIO "
	        		+ " FROM FIN_FOLIO "
	        		+ " WHERE EJERCICIO_ID = ? "
	        		+ " AND USUARIO = ?"
	        		+ " AND FOLIO = TO_NUMBER(?,'99')");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, usuario);
	        ps.setString(3, folio);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinFolio|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
    }
    
    public void mapeaRegId(Connection conn, String ejercicioId, String usuario) throws SQLException{
    	
    	PreparedStatement ps 	= null;
        ResultSet rs 			= null;
         
        try{
	        ps = conn.prepareStatement("SELECT EJERCICIO_ID, USUARIO, RECIBO_INICIAL, RECIBO_FINAL, RECIBO_ACTUAL, ESTADO, FOLIO "
	        		+ " FROM FIN_FOLIO "
	        		+ " WHERE EJERCICIO_ID = ? "
	        		+ " AND USUARIO = ?"
	        		+ " AND ESTADO = 'A'");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, usuario);	        
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinFolio|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_FOLIO WHERE EJERCICIO_ID = ? AND USUARIO = ? AND FOLIO = TO_NUMBER(?, '99')");            
            ps.setString(1, ejercicioId);
            ps.setString(2, usuario);
            ps.setString(3, folio);
            
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinFolio|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        
        return ok;
    }
    
    public boolean tieneRecibo(Connection conn, String ejercicioId, String usuario, String folio) throws SQLException {
    	PreparedStatement ps 	= null;
    	ResultSet rs 			= null;
        boolean ok 				= false;
        
        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_FOLIO"
            		+ " WHERE EJERCICIO_ID = ? "
            		+ " AND USUARIO = ?"
            		+ " AND FOLIO = TO_NUMBER(?, '99')"
            		+ " AND VALIDA_FOLIO(EJERCICIO_ID,USUARIO,FOLIO) = 'S'");
            ps.setString(1, ejercicioId);
            ps.setString(2, usuario);
            ps.setString(3, folio);            
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinFolio|tieneRecibo|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        
        return ok;
    } 
    
    public String maxReg(Connection conn, String ejercicioId, String usuario) throws SQLException {
        String maximo			= "1";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
            ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,1) AS MAXIMO FROM FIN_FOLIO WHERE EJERCICIO_ID = ? AND USUARIO = ?");
            ps.setString(1, ejercicioId);
            ps.setString(2, usuario);
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinFolio|maxReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return maximo;
    }
    
    public boolean verificaFolio(Connection conn, String escuela, String ejercicioid, String valorini, String valorfin )throws SQLException{
    	Integer vini = new Integer(valorini);
    	Integer vfin = new Integer(valorfin);
    	boolean salida = false;
    	FinFolioLista ffl = new FinFolioLista();
    	List<FinFolio> lsFolios = new ArrayList();
    	lsFolios.addAll(ffl.getListEjercicio(conn, ejercicioid, ""));
    	Integer finalMaximo = 0;
    	if(vini.compareTo(vfin)<0){
    		for(FinFolio ff : lsFolios){
        		if(new Integer(ff.getReciboFinal()).compareTo(finalMaximo)>0){
        			finalMaximo = new Integer(ff.getReciboFinal());
        		}
        	}
    		if(vfin.compareTo(finalMaximo)>0){
    			salida=true;
    		}
    	}
    	return salida;
    	
    }
    
    public boolean verificaFolio(Connection conn, String escuela, String valor) throws SQLException {
    	PreparedStatement ps	= null;
        ResultSet rs			= null;
        boolean ok 				= false;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_FOLIO"
            		+ " WHERE SUBSTR(EJERCICIO_ID,1,3) = ?"       		
            		+ " AND TO_NUMBER(?,'9999999') BETWEEN RECIBO_INICIAL AND RECIBO_FINAL");            
            ps.setString(1, escuela);
            ps.setString(2, valor);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinFolio|verificaFolio|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
}
