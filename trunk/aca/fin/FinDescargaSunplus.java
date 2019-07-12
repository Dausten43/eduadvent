/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinDescargaSunplus {	
	private String descargaId;
	private String codigoId;
	private String fecha; 
	private String tipoPoliza;
	private long archivo;
	
	public FinDescargaSunplus(){
		descargaId	= "";
		codigoId	= "";
		fecha		= "";
		tipoPoliza	= "";
		archivo		= 0;
	}

	
	public String getDescargaId() {
		return descargaId;
	}

	public void setDescargaId(String descargaId) {
		this.descargaId = descargaId;
	}

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getTipoPoliza() {
		return tipoPoliza;
	}

	public void setTipoPoliza(String tipoPoliza) {
		this.tipoPoliza = tipoPoliza;
	}
	
	public long getArchivo() {
		return archivo;
	}

	public void setArchivo(long archivo) {
		this.archivo = archivo;
	}


	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_DESCARGA_SUNPLUS(DESCARGA_ID, CODIGO_ID, FECHA, TIPO_POLIZA, ARCHIVO)" +
                    " VALUES(TO_NUMBER(?, '9999999999')," +
                    " ?," +
                    " TO_TIMESTAMP(?,'DD/MM/YYYY HH24:MI:SS'), ?, ? )");
            
            ps.setString(1, descargaId);
            ps.setString(2, codigoId);
            ps.setString(3, fecha);
            ps.setString(4, tipoPoliza);
            ps.setLong(5, archivo);

            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinDescargaSunplus|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	 public boolean deleteSoloReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        
        
			        
        try {
            ps = conn.prepareStatement("DELETE FROM FIN_DESCARGA_SUNPLUS WHERE DESCARGA_ID = TO_NUMBER(?, '999999999')");            
            ps.setString(1, descargaId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinDescargaSunplus|deleteReg|:" + ex);
        }finally{
            if(ps != null) ps.close();
        }
		
        
        return ok;
    }
	
    public boolean deleteReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        
        try{
			ResultSet rs = null;
			ps = conn.prepareStatement("SELECT LO_UNLINK(ARCHIVO) AS RESULTADO FROM FIN_DESCARGA_SUNPLUS WHERE DESCARGA_ID  = TO_NUMBER(?, '999999999')" );
			ps.setString(1, descargaId);		
			
			rs = ps.executeQuery();
			if(rs.next()){
			    ok = rs.getInt("RESULTADO")==1 ? true : false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinDescargaSunplus|deleteArchivoReg|:"+ex);
			ok = false;
		}finally{
			if (ps!=null) ps.close();
		}
		        
		if(ok){
			ok = false;
			ps = null;
        
	        try {
	            ps = conn.prepareStatement("DELETE FROM FIN_DESCARGA_SUNPLUS WHERE DESCARGA_ID = TO_NUMBER(?, '999999999')");            
	            ps.setString(1, descargaId);
	          
	            if(ps.executeUpdate() == 1){
	                ok = true;
	            }
	            
	        }catch (Exception ex){
	            System.out.println("Error - aca.fin.FinDescargaSunplus|deleteReg|:" + ex);
	        }finally{
	            if(ps != null) ps.close();
	        }
		}
        
        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {        
		descargaId	= rs.getString("DESCARGA_ID");
		codigoId	= rs.getString("CODIGO_ID");
		fecha		= rs.getString("FECHA");
		tipoPoliza	= rs.getString("TIPO_POLIZA");
		archivo 	= rs.getInt("ARCHIVO");
    }

    public void mapeaRegId(Connection con, String descargaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                "SELECT DESCARGA_ID, CODIGO_ID, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, TIPO_POLIZA, ARCHIVO" +
	                " FROM FIN_DESCARGA_SUNPLUS" +
	                " WHERE DESCARGA_ID = TO_NUMBER(?, '999999999') ");
	        
	        ps.setString(1, descargaId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinDescargaSunplus|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
        
    }
    
    public String maxReg(Connection conn) throws SQLException {
        String maximo			= "1";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
            ps = conn.prepareStatement("SELECT COALESCE(MAX(DESCARGA_ID)+1,1) AS MAXIMO FROM FIN_DESCARGA_SUNPLUS");
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }
            
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinDescargaSunplus|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return maximo;
    }
   
}
