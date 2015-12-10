package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinDeposito {
	private String escuelaId;
	private String folio;
	private String fecha;
	private String fechaDeposito;
	private String importe;
	private String responsable;
	
	
	public FinDeposito(){
		escuelaId		= "";
		folio			= "";
		fecha			= "";
		fechaDeposito	= "";
		importe 		= "";
		responsable		= "";
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
	

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}
	
	public String getFecha() {
		return fecha;
	}


	public void setFecha(String fecha) {
		this.fecha = fecha;
	}


	public String getFechaDeposito() {
		return fechaDeposito;
	}


	public void setFechaDeposito(String fechaDeposito) {
		this.fechaDeposito = fechaDeposito;
	}


	public String getImporte() {
		return importe;
	}


	public void setImporte(String importe) {
		this.importe = importe;
	}


	public String getResponsable() {
		return responsable;
	}


	public void setResponsable(String responsable) {
		this.responsable = responsable;
	}


	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_DEPOSITO( ESCUELA_ID, FOLIO, FECHA, FECHA_DEPOSITO, IMPORTE, RESPONSABLE )" +
                    " VALUES(?, TO_NUMBER(?, '99999'),TO_DATE(?,'DD/MM/YYYY'), TO_DATE(?,'DD/MM/YYYY')," +
                    " TO_NUMBER(?, '99999.99'),?)");
            
            ps.setString(1, escuelaId);
            ps.setString(2, folio);
            ps.setString(3, fecha);
            ps.setString(4, fechaDeposito);
            ps.setString(5, importe);
            ps.setString(6, responsable);
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinDeposito|insertReg|:" + ex);
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
                    "UPDATE FIN_DEPOSITO" +
                    " SET FECHA = TO_DATE(?,'DD/MM/YYYY')," +
                    " FECHA_DEPOSITO = TO_DATE(?,'DD/MM/YYYY')," +
                    " IMPORTE = TO_NUMBER(?, '99999.99')," +
                    " RESPONSABLE = ?" +
                    " WHERE ESCUELA_ID = ?" +
                    " AND FOLIO = TO_NUMBER(?, '999999')");
            ps.setString(1, fecha);
            ps.setString(2, fechaDeposito);
            ps.setString(3, importe);
            ps.setString(4, responsable);
            ps.setString(5, escuelaId);
            ps.setString(6, folio);   
            

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinDeposito|updateReg|:" + ex);
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
            ps = conn.prepareStatement(
                    "DELETE FROM FIN_DEPOSITO " +
                    " WHERE ESCUELA_ID = ?" +
                    " AND FOLIO = TO_NUMBER(?, '99999')");
            
            ps.setString(1, escuelaId);
            ps.setString(2, folio);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinDeposito|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        escuelaId		= rs.getString("ESCUELA_ID");
		folio			= rs.getString("FOLIO");
		fecha			= rs.getString("FECHA");
		fechaDeposito	= rs.getString("FECHA_DEPOSITO");
		importe   		= rs.getString("IMPORTE");
		responsable		= rs.getString("RESPONSABLE");
    }

    public void mapeaRegId(Connection con, String escuelaId, String folio) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT ESCUELA_ID, FOLIO, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, TO_CHAR(FECHA_DEPOSITO,'DD/MM/YYYY') AS FECHA_DEPOSITO, IMPORTE, RESPONSABLE" +
	                " FROM FIN_DEPOSITO" +
	                " WHERE ESCUELA_ID = ?" +
	                " AND FOLIO = TO_NUMBER(?, '99999')");
	        ps.setString(1, escuelaId);
	        ps.setString(2, folio);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinDeposito|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_DEPOSITO" +
            		" WHERE ESCUELA_ID = ?" +
            		" AND FOLIO = TO_NUMBER(?, '99999')");
            ps.setString(1, escuelaId);
            ps.setString(2, folio);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinDeposito|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public String maxReg(Connection conn, String escuelaId) throws SQLException {
        
        ResultSet rs = null;
        PreparedStatement ps = null;
        String maximo = "1";
        try {
            ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO+1),1) AS MAXIMO FROM FIN_DEPOSITO" +
            		" WHERE ESCUELA_ID = ?");
            ps.setString(1, escuelaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinDeposito|maxReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return maximo;
    }    
}