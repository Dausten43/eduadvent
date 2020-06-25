package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinPoliza {
	
	private String ejercicioId;
	private String polizaId;
	private String fecha;
	private String descripcion;
	private String usuario;
	private String estado;
	private String tipo;
	private String descargaId;
	
	public FinPoliza(){		
		ejercicioId		= "";
		ejercicioId		= "";
		fecha			= "";
		descripcion		= "";
		usuario			= "";
		estado			= "";	
		tipo			= "";
		descargaId		= "";
	}	
	
	public String getEjercicioId() {
		return ejercicioId;
	}
	public void setEjercicioId(String ejercicioId) {
		this.ejercicioId = ejercicioId;
	}
	public String getPolizaId() {
		return polizaId;
	}
	public void setPolizaId(String polizaId) {
		this.polizaId = polizaId;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getDescargaId() {
		return descargaId;
	}
	public void setDescargaId(String descargaId) {
		this.descargaId = descargaId;
	}
	
	
	

	@Override
	public String toString() {
		return "FinPoliza [ejercicioId=" + ejercicioId + ", polizaId=" + polizaId + ", fecha=" + fecha
				+ ", descripcion=" + descripcion + ", usuario=" + usuario + ", estado=" + estado + ", tipo=" + tipo
				+ ", descargaId=" + descargaId + "]";
	}

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_POLIZA(EJERCICIO_ID, POLIZA_ID, FECHA, DESCRIPCION, USUARIO, ESTADO, TIPO)" +
                    " VALUES(?, ?," +
                    " TO_DATE(?, 'DD/MM/YYYY'), " +
                    " ?, ?, ?, ?)");
            
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
            ps.setString(3, fecha);
            ps.setString(4, descripcion);
            ps.setString(5, usuario);
            ps.setString(6, estado);
            ps.setString(7, tipo);
            System.out.println(ps);
            if(ps.executeUpdate()==1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|insertReg|:" + ex);
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
                    "UPDATE FIN_POLIZA" +
                    " SET FECHA = TO_DATE(?, 'DD/MM/YYYY')," +
                    " DESCRIPCION = ?," +
                    " USUARIO = ?," +
                    " ESTADO = ?," +
                    " TIPO = ?" +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?");
            ps.setString(1, fecha);
            ps.setString(2, descripcion);
            ps.setString(3, usuario);
            ps.setString(4, estado);
            ps.setString(5, tipo);
            ps.setString(6, ejercicioId);
            ps.setString(7, polizaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public boolean updateEstado(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE FIN_POLIZA" +
                    " SET ESTADO = ?" +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?");
            
            ps.setString(1, estado);
            ps.setString(2, ejercicioId);
            ps.setString(3, polizaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|updateEstado|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public boolean updateEstadoYDescargaId(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE FIN_POLIZA" +
                    " SET ESTADO = ?, DESCARGA_ID = TO_NUMBER(?, '9999')" +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?");
            
            ps.setString(1, estado);
            ps.setString(2, descargaId);
            ps.setString(3, ejercicioId);
            ps.setString(4, polizaId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|updateEstado|:" + ex);
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
                    " DELETE FROM FIN_POLIZA " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?");
            
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public void mapeaReg(ResultSet rs) throws SQLException {
        ejercicioId		= rs.getString("EJERCICIO_ID");
		polizaId		= rs.getString("POLIZA_ID");
		fecha			= rs.getString("FECHA");
		descripcion		= rs.getString("DESCRIPCION");
		usuario   		= rs.getString("USUARIO");
		estado			= rs.getString("ESTADO");
		tipo			= rs.getString("TIPO");
    }

    public void mapeaRegId(Connection con, String ejercicioId, String polizaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, DESCRIPCION, USUARIO, ESTADO, TIPO" +
	                " FROM FIN_POLIZA" +
	                " WHERE EJERCICIO_ID = ?" +
	                " AND POLIZA_ID = ?");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinPoliza|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_POLIZA" +
            		" WHERE EJERCICIO_ID = ?" +
            		" AND POLIZA_ID = ?");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public boolean existeDelUsuario(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_POLIZA" +
            		" WHERE EJERCICIO_ID = ?" +
            		" AND POLIZA_ID = ? AND USUARIO = ? ");
	        
            ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
	        ps.setString(3, usuario);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
     public boolean existeUsuario(Connection conn, String usuario) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_POLIZA" +
            		" WHERE USUARIO = ? ");
	        ps.setString(1, usuario);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinPoliza|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public String maximoReg(Connection conn, String ejercicioId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX( TO_NUMBER(SUBSTR(POLIZA_ID, 4, 4), '9999') ) +1, 1) AS MAXIMO FROM FIN_POLIZA WHERE EJERCICIO_ID = '"+ejercicioId+"' ");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
				
				switch(maximo.length()){
					case 1: maximo = "000"+maximo; break;
					case 2: maximo = "00"+ maximo; break;
					case 3: maximo = "0"+ maximo; break;
				}
				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPoliza|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
    
    public static String numPolizas(Connection conn, String ejercicioId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String total 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(POLIZA_ID),0) AS TOTAL FROM FIN_POLIZA WHERE EJERCICIO_ID = '"+ejercicioId+"' ");
			rs= ps.executeQuery();		
			if(rs.next()){
				total = rs.getString("TOTAL");				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPoliza|numPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return total;
	}
    
    /* Saldo de una póliza de acuerdo a una */
    public static String importePoliza(Connection conn, String ejercicioId, String polizaId, String naturaleza, String estadoMov) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String total 			= "0";
		
		try{
			ps = conn.prepareStatement(""
					+ " SELECT COALESCE(SUM(IMPORTE),0) AS TOTAL FROM FIN_MOVIMIENTOS"
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"'"
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " AND NATURALEZA = '"+naturaleza+"'"					
					+ " AND ESTADO IN("+estadoMov+")");
			rs= ps.executeQuery();		
			if(rs.next()){
				total = rs.getString("TOTAL");				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPoliza|numPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return total;
	}
    
    /* Saldo de una póliza de acuerdo a una */
    public static String importePolizaMovimientosDeCaja(Connection conn, String ejercicioId, String polizaId, String naturaleza, String estadoMov) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String total 			= "0";
		
		try{
			ps = conn.prepareStatement(""
					+ " SELECT COALESCE(SUM(IMPORTE),0) AS TOTAL FROM FIN_MOVIMIENTOS"
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"'"
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " AND NATURALEZA = '"+naturaleza+"'"					
					+ " AND ESTADO IN("+estadoMov+")"
					+ " AND RECIBO_ID != 0");
			rs= ps.executeQuery();		
			if(rs.next()){
				total = rs.getString("TOTAL");				
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPoliza|numPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return total;
	}
}