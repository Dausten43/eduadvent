package aca.cont;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ContMovimiento {
	
	private String ejercicioId;
	private String libroId;
	private String polizaId;
	private String numMovto;
	private String fecha;
	private String descripcion;
	private String importe;		
	private String referencia;
	private String mayorId;
	private String ccostoId;
	private String auxiliarId;
	private String tipoCta;
	private String naturaleza;
	private String estado;
	
	public ContMovimiento(){
		ejercicioId	= "";
		libroId		= "";
		polizaId	= "";
		numMovto	= "";
		fecha		= "";
		descripcion	= "";
		importe		= "";
		estado		= "";
		ejercicioId	= "";
		referencia	= "";
		mayorId		= "";
		ccostoId	= "";
		auxiliarId	= "";
		tipoCta		= "";
		naturaleza	= "";
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
	 * @return the numMovto
	 */
	public String getNumMovto() {
		return numMovto;
	}

	/**
	 * @param numMovto the numMovto to set
	 */
	public void setNumMovto(String numMovto) {
		this.numMovto = numMovto;
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
	 * @return the referencia
	 */
	public String getReferencia() {
		return referencia;
	}

	/**
	 * @param referencia the referencia to set
	 */
	public void setReferencia(String referencia) {
		this.referencia = referencia;
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
	 * @return the ccostoId
	 */
	public String getCcostoId() {
		return ccostoId;
	}

	/**
	 * @param costoId the costoId to set
	 */
	public void setCcostoId(String ccostoId) {
		this.ccostoId = ccostoId;
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

	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " INSERT INTO CONT_MOVIMIENTO(EJERCICIO_ID, LIBRO_ID, POLIZA_ID, NUM_MOVTO, FECHA, DESCRIPCION," +
                    " IMPORTE, ESTADO, REFERENCIA, MAYOR_ID, CCOSTO_ID, AUXILIAR_ID, TIPO_CTA, NATURALEZA)" +
                    " VALUES(?, TO_NUMBER(?, '99'), ?, TO_NUMBER(?, '99999'), TO_DATE(?, 'DD/MM/YYYY'), ?," +
                    " TO_NUMBER(?, '9999999.99'), ?, ?, ?, ?, ?, ?, ?)");   
            ps.setString(1,  ejercicioId);
            ps.setString(2,  libroId);
            ps.setString(3,  polizaId);
            ps.setString(4,  numMovto);
            ps.setString(5,  fecha);
            ps.setString(6,  descripcion);
            ps.setString(7,  importe);
            ps.setString(8,  estado);
            ps.setString(9,  referencia);
            ps.setString(10, mayorId);
            ps.setString(11, ccostoId);
            ps.setString(12, auxiliarId);
            ps.setString(13, tipoCta);
            ps.setString(14, naturaleza);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMovimiento|insertReg|:" + ex);
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
                    "UPDATE CONT_MOVIMIENTO " + 
                    " SET FECHA = TO_DATE(?, 'DD/MM/YYYY')," +
                    " DESCRIPCION = ?," +
                    " IMPORTE = TO_NUMBER(?, '9999999.99')," +
                    " ESTADO = ?," +                    
                    " REFERENCIA = ?," +
                    " MAYOR_ID = ?," +
                    " CCOSTO_ID = ?," +
                    " AUXILIAR_ID = ?," +
                    " TIPO_CTA = ?," +
                    " NATURALEZA = ?" +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND LIBRO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND NUM_MOVTO = TO_NUMBER(?, '99999')");            
            ps.setString(1, fecha);
            ps.setString(2, descripcion);
            ps.setString(3, importe);
            ps.setString(4, estado);            
            ps.setString(5, referencia);
            ps.setString(6, mayorId);
            ps.setString(7, ccostoId);
            ps.setString(8, auxiliarId);
            ps.setString(9, tipoCta);
            ps.setString(10,naturaleza);
            ps.setString(11,ejercicioId);
            ps.setString(12,libroId);
            ps.setString(13,polizaId);
            ps.setString(14,numMovto);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMovimiento|updateReg|:" + ex);
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
                    " DELETE FROM CONT_MOVIMIENTO" +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND LIBRO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND NUM_MOVTO = TO_NUMBER(?, '99999')");
            ps.setString(1, ejercicioId);
            ps.setString(2, libroId);
            ps.setString(3, polizaId);
            ps.setString(4, numMovto);
          
            if(ps.executeUpdate() == 1){
                ok = true;
            }            
        }catch (Exception ex){
            System.out.println("Error - aca.cont.ContMovimiento|deleteReg|:" + ex);
        }finally{        	
        	if(ps != null){ ps.close(); }
        }

        return ok;
    }
    
    public void mapeaReg(ResultSet rs) throws SQLException {
    	ejercicioId	= rs.getString("EJERCICIO_ID");
    	libroId		= rs.getString("LIBRO_ID");
    	polizaId	= rs.getString("POLIZA_ID");
		numMovto	= rs.getString("NUM_MOVTO");
		fecha		= rs.getString("FECHA");
		descripcion	= rs.getString("DESCRIPCION");
		importe		= rs.getString("IMPORTE");				
		referencia	= rs.getString("REFERENCIA");
		mayorId		= rs.getString("MAYOR_ID");
		ccostoId	= rs.getString("CCOSTO_ID");
		auxiliarId	= rs.getString("AUXILIAR_ID");
		tipoCta		= rs.getString("TIPO_CTA");
		naturaleza	= rs.getString("NATURALEZA");
		estado		= rs.getString("ESTADO");
    }
    
    public void mapeaRegId(Connection con) throws SQLException{
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
	         ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, LIBRO_ID, POLIZA_ID, NUM_MOVTO, FECHA, DESCRIPCION," +
	                " TO_CHAR(IMPORTE, '9999999.00') AS IMPORTE, ESTADO, REFERENCIA, MAYOR_ID, CCOSTO_ID, AUXILIAR_ID, TIPO_CTA, NATURALEZA" +
	                " FROM CONT_MOVIMIENTO" +
	                " WHERE EJERCICIO_ID = ?" +
	                " AND LIBRO_ID = ?" +
	                " AND POLIZA_ID = ?" +
	                " AND NUM_MOVTO = TO_NUMBER(?, '99999')");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, libroId);
	        ps.setString(3, polizaId);
	        ps.setString(4, numMovto);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContMovimiento|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
    }
    
    public void mapeaRegId(Connection con, String ejercicioId, String libroId, String polizaId, String numMovto) throws SQLException{
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
	        ps = con.prepareStatement(
	                " SELECT EJERCICIO_ID, LIBRO_ID, POLIZA_ID, NUM_MOVTO, FECHA, DESCRIPCION," +
	                " TO_CHAR(IMPORTE, '9999999.00') AS IMPORTE, ESTADO, REFERENCIA, MAYOR_ID, CCOSTO_ID, AUXILIAR_ID, TIPO_CTA, NATURALEZA" +
	                " FROM CONT_MOVIMIENTO" +
	                " WHERE EJERCICIO_ID = ?" +
	                " AND LIBRO_ID = ?" +
	                " AND POLIZA_ID = ?" +
	                " AND NUM_MOVTO = TO_NUMBER(?, '99999')");
	        ps.setString(1, ejercicioId);
	        ps.setString(2, libroId);
	        ps.setString(3, polizaId);
	        ps.setString(4, numMovto);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.cont.ContMovimiento|mapeaRegId|:"+ex);
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
        	ps = conn.prepareStatement("SELECT POLIZA_ID FROM CONT_MOVIMIENTO" +
        			" WHERE EJERCICIO_ID = ?" +
                    " AND LIBRO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND NUM_MOVTO = TO_NUMBER(?, '99999')");
            ps.setString(1, ejercicioId);
            ps.setString(2, libroId);
            ps.setString(3, polizaId);
            ps.setString(4, numMovto);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContMovimiento|existeReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
    
    /**
     * @param conn La conexion a la base de datos
     * @param ccostoId El id del centro de costo
     * @param mayorId El id de la cuenta de mayor
     * @param auxiliarId El id de la cuenta auxiliar
     * @return Boolean que indica si existe esta Relacion del centro de costo, la cuenta mayor y el auxiliar
     * */
    public static boolean existeRegRelacion(Connection conn, String ccostoId, String mayorId, String auxiliarId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
        	ps = conn.prepareStatement("SELECT POLIZA_ID FROM CONT_MOVIMIENTO" +
        			" WHERE CCOSTO_ID = ?" +
        			" AND MAYOR_ID = ?" +
        			" AND AUXILIAR_ID = ?");
            ps.setString(1, ccostoId);
            ps.setString(2, mayorId);
            ps.setString(3, auxiliarId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContMovimiento|existeRegRelacion|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return ok;
    }
    
    /**
     * @param conn La conexion a la base de datos
     * @param ejercicioId El id del ejercicio
     * @param libroId El id del libro
     * @param polizaId El id de la poliza
     * @param naturaleza El tipo de naturaleza "D" o "C"
     * @return String que indica el total de la poliza
     * */
    public static String getTotal(Connection conn, String ejercicioId, String libroId, String polizaId, String naturaleza) throws SQLException {
        String total = "0";
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
        	ps = conn.prepareStatement("SELECT SUM(IMPORTE) AS TOTAL FROM CONT_MOVIMIENTO" +
        			" WHERE EJERCICIO_ID = ?" +
        			" AND LIBRO_ID = TO_NUMBER(?, '99')" +
        			" AND POLIZA_ID = ?" +
        			" AND NATURALEZA = ?");
        	
            ps.setString(1, ejercicioId);
            ps.setString(2, libroId);
            ps.setString(3, polizaId);
            ps.setString(4, naturaleza);
            
            rs = ps.executeQuery();
            if(rs.next()){
                total = rs.getString("TOTAL")==null?"0":rs.getString("TOTAL");
            }
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContMovimiento|getTotal|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return total;
    }
    
    public String maxReg(Connection conn, String ejercicioId, String libroId, String polizaId) throws SQLException {
        String maximo			= "";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
        	ps = conn.prepareStatement("SELECT COALESCE(MAX(NUM_MOVTO)+1,1) AS MAXIMO FROM CONT_MOVIMIENTO" +
        			" WHERE EJERCICIO_ID = ?" +
                    " AND LIBRO_ID = TO_NUMBER(?, '99')" +
                    " AND POLIZA_ID = ?");
            ps.setString(1, ejercicioId);
            ps.setString(2, libroId);
            ps.setString(3, polizaId);            
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }else
            	maximo = "1";
        }catch(Exception ex){
            System.out.println("Error - aca.cont.ContMovimiento|maxReg|:" +ex);
        }finally{
        	if(rs != null){ rs.close(); }
            if(ps != null){ ps.close(); }
        }
        
        return maximo;
    }
}
