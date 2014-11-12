package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FinCoordenada {
	private String usuario;
	private String tipo;
	private String cliente;
	private String domicilio;
	private String rfc;
	private String observaciones;
	private String letra;
	private String total;
	private String codigo;
	private String nombre;
	private String concepto;
	private String importe;
	private String fecha;
	
	public FinCoordenada(){
		usuario			= "";
		tipo			= "";
		cliente			= "";
		domicilio		= "";
		rfc				= "";
		observaciones	= "";
		letra			= "";
		total			= "";
		codigo			= "";
		nombre			= "";
		concepto 		= "";
		importe			= "";
		fecha 			= "";
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
	 * @return the tipo
	 */
	public String getTipo() {
		return tipo;
	}

	/**
	 * @param tipo the tipo to set
	 */
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	/**
	 * @return the cliente
	 */
	public String getCliente() {
		return cliente;
	}

	/**
	 * @param cliente the cliente to set
	 */
	public void setCliente(String cliente) {
		this.cliente = cliente;
	}

	/**
	 * @return the domicilio
	 */
	public String getDomicilio() {
		return domicilio;
	}

	/**
	 * @param domicilio the domicilio to set
	 */
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}

	/**
	 * @return the rfc
	 */
	public String getRfc() {
		return rfc;
	}

	/**
	 * @param rfc the rfc to set
	 */
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}

	/**
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return observaciones;
	}

	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	/**
	 * @return the letra
	 */
	public String getLetra() {
		return letra;
	}

	/**
	 * @param letra the letra to set
	 */
	public void setLetra(String letra) {
		this.letra = letra;
	}

	/**
	 * @return the total
	 */
	public String getTotal() {
		return total;
	}

	/**
	 * @param total the total to set
	 */
	public void setTotal(String total) {
		this.total = total;
	}

	/**
	 * @return the codigo
	 */
	public String getCodigo() {
		return codigo;
	}

	/**
	 * @param codigo the codigo to set
	 */
	public void setCodigo(String codigo) {
		this.codigo = codigo;
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
	 * @return the concepto
	 */
	public String getConcepto() {
		return concepto;
	}

	/**
	 * @param concepto the concepto to set
	 */
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	/**
	 * @return the importe
	 */
	public String getImporte() {
		return importe;
	}

	/**
	 * @param importe the importe to set
	 */
	public void setImporte(String importe) {
		this.importe = importe;
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

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "INSERT INTO FIN_COORDENADA(USUARIO, TIPO, CLIENTE, DOMICILIO," +
                    " RFC, OBSERVACIONES, LETRA, TOTAL, CODIGO, NOMBRE, CONCEPTO, IMPORTE, FECHA)" +
                    " VALUES(?," +
                    " ?," +
                    " ?," +
                    " ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )");
            
            ps.setString(1, usuario);
            ps.setString(2, tipo);
            ps.setString(3, cliente);
            ps.setString(4, domicilio);
            ps.setString(5, rfc);
            ps.setString(6, observaciones);
            ps.setString(7, letra);
            ps.setString(8, total);
            ps.setString(9, codigo);
            ps.setString(10, nombre);
            ps.setString(11, concepto);
            ps.setString(12, importe);
            ps.setString(13, fecha);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCoordenada|insertReg|:" + ex);
        }finally{
        	if(ps!=null) ps.close();
        }

        return ok;
    }

    public boolean updateReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    "UPDATE FIN_COORDENADA" +
                    " SET CLIENTE = ?," +
                    " DOMICILIO = ?," +
                    " RFC = ?," +
                    " OBSERVACIONES = ?," +
                    " LETRA = ?," +
                    " TOTAL = ?," +
                    " CODIGO = ?," +
                    " NOMBRE = ?," +
                    " CONCEPTO = ?," +
                    " IMPORTE = ?," +
                    " FECHA = ?" +
                    " WHERE USUARIO = ? AND TIPO = ?");
            
            ps.setString(1, cliente);
            ps.setString(2, domicilio);
            ps.setString(3, rfc);
            ps.setString(4, observaciones);
            ps.setString(5, letra);
            ps.setString(6, total);
            ps.setString(7, codigo);
            ps.setString(8, nombre);
            ps.setString(9, concepto);
            ps.setString(10, importe);
            ps.setString(11, fecha);
            ps.setString(12, usuario);
            ps.setString(13, tipo);
            
            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCoordenada|updateReg|:" + ex);
        }finally{
        	if(ps!=null)ps.close();
        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(
                    "DELETE FROM FIN_COORDENADA" +
                    " WHERE USUARIO = ? AND TIPO = ?");
            
            ps.setString(1, usuario);
            ps.setString(2, tipo);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinCoordenada|deleteReg|:" + ex);
        }finally{
        	if(ps!=null)ps.close();
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        usuario			= rs.getString("USUARIO");
		tipo			= rs.getString("TIPO");
		cliente			= rs.getString("CLIENTE");
		domicilio		= rs.getString("DOMICILIO");
		rfc				= rs.getString("RFC");
		observaciones	= rs.getString("OBSERVACIONES");
		letra			= rs.getString("LETRA");
		total			= rs.getString("TOTAL");
		codigo			= rs.getString("CODIGO");
		nombre			= rs.getString("NOMBRE");
		concepto		= rs.getString("CONCEPTO");
		importe			= rs.getString("IMPORTE");
		fecha			= rs.getString("FECHA");
    }

    public void mapeaRegId(Connection con, String usuario, String tipo) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(
	                "SELECT USUARIO, TIPO, CLIENTE, DOMICILIO," +
	                " RFC, OBSERVACIONES, LETRA, TOTAL, CODIGO, NOMBRE, CONCEPTO, IMPORTE, FECHA" +
	                " FROM FIN_COORDENADA" +
	                " WHERE USUARIO = ? AND TIPO = ?");        
	        ps.setString(1, usuario);
	        ps.setString(2, tipo);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinCoordenada|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM FIN_COORDENADA" +
                    " WHERE USUARIO = ? AND TIPO = ? ");
            
            ps.setString(1, usuario);
            ps.setString(2, tipo);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCoordenada|existeReg|:" +ex);
        }finally{
	        if(rs!=null)rs.close();	
	        if(ps!=null)ps.close();
        }

        return ok;
    }
}
