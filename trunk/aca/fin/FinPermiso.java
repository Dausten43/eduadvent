package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinPermiso {
	
	private String codigoId;
	private String folio;
	private String fecha_ini;
	private String fecha_fin;
	private String estado;
	private String comentario;
	
	public FinPermiso(){
		codigoId		= "";
		folio			= "";
		fecha_ini		= "";
		fecha_fin		= "";
		estado			= "";
		comentario		= "";
	}

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getFecha_ini() {
		return fecha_ini;
	}

	public void setFecha_ini(String fecha_ini) {
		this.fecha_ini = fecha_ini;
	}

	public String getFecha_fin() {
		return fecha_fin;
	}

	public void setFecha_fin(String fecha_fin) {
		this.fecha_fin = fecha_fin;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_PERMISO(CODIGO_ID, FOLIO, FECHA_INI, FECHA_FIN, ESTADO, COMENTARIO)" +
                    " VALUES(?, TO_NUMBER(?, '999'), TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'), ?, ?)");
           
            ps.setString(1, codigoId);           
            ps.setString(2, folio);
            ps.setString(3, fecha_ini);
            ps.setString(4, fecha_fin);
            ps.setString(5, estado);
            ps.setString(6, comentario);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPermiso|insertReg|:" + ex);
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
            ps = conn.prepareStatement("UPDATE FIN_PERMISO SET FECHA_INI = TO_DATE(?, 'DD/MM/YYYY'), " +
            		"FECHA_FIN  = TO_DATE(?, 'DD/MM/YYYY'), ESTADO = ?, COMENTARIO = ? WHERE CODIGO_ID = ? AND FOLIO = TO_NUMBER(?, '999')");            
            ps.setString(1, fecha_ini);
            ps.setString(2, fecha_fin);
            ps.setString(3, estado);
            ps.setString(4, comentario);
            ps.setString(5, codigoId);
            ps.setString(6, folio);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPermiso|updateReg|:" + ex);
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
            ps = conn.prepareStatement("DELETE FROM FIN_PERMISO WHERE CODIGO_ID = ? AND FOLIO = TO_NUMBER(?, '999')");            
            ps.setString(1, codigoId);
            ps.setString(2, folio);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPermiso|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        codigoId		= rs.getString("CODIGO_ID");
        folio			= rs.getString("FOLIO");
		fecha_ini		= rs.getString("FECHA_INI");
		fecha_fin		= rs.getString("FECHA_FIN");
		estado			= rs.getString("ESTADO");
		comentario		= rs.getString("COMENTARIO");
    }
        
    public void mapeaRegId(Connection conn) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = conn.prepareStatement("SELECT CODIGO_ID, FOLIO, TO_CHAR(FECHA_INI, 'DD/MM/YYYY') AS FECHA_INI, TO_CHAR(FECHA_FIN, 'DD/MM/YYYY') AS FECHA_FIN, ESTADO, COMENTARIO FROM FIN_PERMISO WHERE CODIGO_ID = ? AND FOLIO = TO_NUMBER(?, '999')");
	        ps.setString(1, codigoId);
	        ps.setString(2, folio);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinPermiso|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_PERMISO WHERE CODIGO_ID = ? AND FOLIO = TO_NUMBER(?, '999')");            
            ps.setString(1, codigoId);
            ps.setString(2, folio);
            
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPermiso|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        
        return ok;
    }
    
    public String maxReg(Connection conn) throws SQLException {
    	PreparedStatement ps	= null;        
        ResultSet rs			= null;
        String maximo			= "1";
        
        try {
        	ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,1) AS MAXIMO FROM FIN_PERMISO");
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPermiso|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }  
}
