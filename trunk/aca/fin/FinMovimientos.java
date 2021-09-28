package aca.fin;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class FinMovimientos {
	
	private String ejercicioId;
	private String polizaId;
	private String movimientoId;
	private String cuentaId;
	private String auxiliar;
	private String descripcion;
	private String importe;
	private String naturaleza;
	private String referencia;
	private String estado;
	private String fecha;
	private String reciboId;
	private String cicloId;
	private String periodoId;
	private String tipoMovId;
	
	public FinMovimientos(){
		ejercicioId 	= "";
		polizaId 		= "";
		movimientoId	= "";
		cuentaId 		= "";
		auxiliar 		= "";
		descripcion 	= "";
		importe 		= "";
		naturaleza 		= "";
		referencia 		= "";
		estado 			= "";
		fecha 			= "";
		reciboId		= "";
		cicloId			= "00000000";
		periodoId		= "0";
		tipoMovId		= "0";
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
	public String getMovimientoId() {
		return movimientoId;
	}
	public void setMovimientoId(String movimientoId) {
		this.movimientoId = movimientoId;
	}
	public String getCuentaId() {
		return cuentaId;
	}
	public void setCuentaId(String cuentaId) {
		this.cuentaId = cuentaId;
	}
	public String getAuxiliar() {
		return auxiliar;
	}
	public void setAuxiliar(String auxiliar) {
		this.auxiliar = auxiliar;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getImporte() {
		return importe;
	}
	public void setImporte(String importe) {
		this.importe = importe;
	}
	public String getNaturaleza() {
		return naturaleza;
	}
	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getReciboId() {
		return reciboId;
	}
	public void setReciboId(String reciboId) {
		this.reciboId = reciboId;
	}	
	public String getCicloId() {
		return cicloId;
	}
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}
	public String getPeriodoId() {
		return periodoId;
	}
	public void setPeriodoId(String periodoId) {
		this.periodoId = periodoId;
	}

	public String getTipoMovId() {
		return tipoMovId;
	}

	public void setTipoMovId(String tipoMovId) {
		this.tipoMovId = tipoMovId;
	}
	
	
	

	@Override
	public String toString() {
		return "FinMovimientos [ejercicioId=" + ejercicioId + ", polizaId=" + polizaId + ", movimientoId="
				+ movimientoId + ", cuentaId=" + cuentaId + ", auxiliar=" + auxiliar + ", descripcion=" + descripcion
				+ ", importe=" + importe + ", naturaleza=" + naturaleza + ", referencia=" + referencia + ", estado="
				+ estado + ", fecha=" + fecha + ", reciboId=" + reciboId + ", cicloId=" + cicloId + ", periodoId="
				+ periodoId + ", tipoMovId=" + tipoMovId + "]";
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO FIN_MOVIMIENTOS"
					+ " (EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION,"
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID )"
					+ " VALUES(?, ?, TO_NUMBER(?, '99999'), ?, ?, ?,"
					+ " TO_NUMBER(?, '999999.99'), ?, ?, ?,"
					+ " TO_TIMESTAMP(?,'DD/MM/YYYY HH24:MI:SS'), TO_NUMBER(?, '9999999'), ?, TO_NUMBER(?,'99'), TO_NUMBER(?,'99') )");

			ps.setString(1, ejercicioId);
			ps.setString(2, polizaId);
			ps.setString(3, movimientoId);
			ps.setString(4, cuentaId);
			ps.setString(5, auxiliar);
			ps.setString(6, descripcion);
			ps.setString(7, importe);
			ps.setString(8, naturaleza);
			ps.setString(9, referencia);
			ps.setString(10, estado);
			ps.setString(11, fecha);
			ps.setString(12, reciboId);
			ps.setString(13, cicloId);
			ps.setString(14, periodoId);
			ps.setString(15, tipoMovId);
			System.out.println(ps);
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientos|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("UPDATE FIN_MOVIMIENTOS"
                    + " SET CUENTA_ID = ?,"
                    + " AUXILIAR = ?,"
                    + " DESCRIPCION = ?,"
                    + " IMPORTE = TO_NUMBER(?, '999999.99'),"
                    + " NATURALEZA = ?,"
                    + " REFERENCIA = ?,"
                    + " ESTADO = ?,"
                    + " FECHA = TO_TIMESTAMP(?,'DD/MM/YYYY HH24:MI:SS'),"
                    + " RECIBO_ID = TO_NUMBER(?, '9999999'),"
                    + " CICLO_ID = ?,"
                    + " PERIODO_ID = TO_NUMBER(?,'99'),"
                    + " TIPOMOV_ID = TO_NUMBER(?,'99')"
                    + " WHERE EJERCICIO_ID = ?"
                    + " AND POLIZA_ID = ?"
                    + " AND MOVIMIENTO_ID = TO_NUMBER(?, '99999')");
            
            ps.setString(1, cuentaId);
            ps.setString(2, auxiliar);
            ps.setString(3, descripcion);
            ps.setString(4, importe);
            ps.setString(5, naturaleza);
            ps.setString(6, referencia);
            ps.setString(7, estado);
            ps.setString(8, fecha);
            ps.setString(9, reciboId);
            ps.setString(10, cicloId);
            ps.setString(11, periodoId);
            ps.setString(12, tipoMovId);
            ps.setString(13, ejercicioId);
            ps.setString(14, polizaId);
            ps.setString(15, movimientoId);            

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|updateReg|:" + ex);
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
                    " UPDATE FIN_MOVIMIENTOS" +
                    " SET ESTADO = ? " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND MOVIMIENTO_ID = TO_NUMBER(?, '99999')");
            
            ps.setString(1, estado);
            ps.setString(2, ejercicioId);
            ps.setString(3, polizaId);
            ps.setString(4, movimientoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|updateReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public boolean updateCicloPeriodo(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement(
                    " UPDATE FIN_MOVIMIENTOS" +
                    " SET CICLO_ID = ?, PERIODO_ID = ? " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND MOVIMIENTO_ID = TO_NUMBER(?, '99999')");
            
            ps.setString(1, cicloId);
            ps.setString(2, periodoId);
            ps.setString(3, ejercicioId);
            ps.setString(4, polizaId);
            ps.setString(5, movimientoId);

            if(ps.executeUpdate() == 1){
                ok = true;
            }
            
        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|updateCicloPeriodo|:" + ex);
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
                    " DELETE FROM FIN_MOVIMIENTOS " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND MOVIMIENTO_ID = TO_NUMBER(?, '99999')");
            
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
            ps.setString(3, movimientoId);
          
            if(ps.executeUpdate() > 0){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|deleteReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public boolean deleteMovimientosParaCuadrarPolizaCaja(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(
                    " DELETE FROM FIN_MOVIMIENTOS " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND NATURALEZA = 'D' ");
            
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
          
            if(ps.executeUpdate() > 0){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|deleteMovimientosParaCuadrarPolizaCaja|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public boolean deleteMovimientosParaCuadrarPolizaIngreso(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(
                    " DELETE FROM FIN_MOVIMIENTOS " +
                    " WHERE EJERCICIO_ID = ?" +
                    " AND POLIZA_ID = ?" +
                    " AND NATURALEZA = 'C' AND AUXILIAR='-'");
            
            ps.setString(1, ejercicioId);
            ps.setString(2, polizaId);
            
            if(ps.executeUpdate() > 0){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|deleteMovimientosParaCuadrarPolizaIngreso|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public void mapeaReg(ResultSet rs) throws SQLException {
		ejercicioId 	= rs.getString("EJERCICIO_ID");
        polizaId 		= rs.getString("POLIZA_ID");
        movimientoId 	= rs.getString("MOVIMIENTO_ID");
        cuentaId 		= rs.getString("CUENTA_ID");
        auxiliar 		= rs.getString("AUXILIAR");
        descripcion 	= rs.getString("DESCRIPCION");
        importe 		= rs.getString("IMPORTE");
        naturaleza 		= rs.getString("NATURALEZA");
        referencia 		= rs.getString("REFERENCIA");
        estado 			= rs.getString("ESTADO");
        fecha 			= rs.getString("FECHA");
        reciboId		= rs.getString("RECIBO_ID");
        cicloId			= rs.getString("CICLO_ID");
        periodoId		= rs.getString("PERIODO_ID");
        tipoMovId		= rs.getString("TIPOMOV_ID");
    }

    public void mapeaRegId(Connection con, String ejercicioId, String polizaId, String movimientoId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement(""
	        		+ " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
	                + " FROM FIN_MOVIMIENTOS"
	                + " WHERE EJERCICIO_ID = ?"
	                + " AND POLIZA_ID = ?"
	                + " AND MOVIMIENTO_ID = TO_NUMBER(?, '99999')");
	        
	        ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
	        ps.setString(3, movimientoId);
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientos|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
    }

    public static boolean existeAlumno(Connection conn, String auxiliar) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;
 
        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_MOVIMIENTOS" 
            		+ " WHERE auxiliar = ? ");
            
	        ps.setString(1, auxiliar);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|existeCuentaId|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public static boolean existeCuentaId(Connection conn, String cuentaId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_MOVIMIENTOS" +
            		" WHERE CUENTA_ID = ? ");
            
	        ps.setString(1, cuentaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|existeCuentaId|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
	
    public boolean existeReg(Connection conn) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_MOVIMIENTOS" +
            		" WHERE EJERCICIO_ID = ?" +
            		" AND POLIZA_ID = ?" +
	                " AND MOVIMIENTO_ID = TO_NUMBER(?, '99999')");
            
	        ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
	        ps.setString(3, movimientoId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
    
    public static boolean existePoliza(Connection conn, String ejercicioId, String polizaId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM FIN_MOVIMIENTOS WHERE EJERCICIO_ID = '"+ejercicioId+"' AND POLIZA_ID = '"+polizaId+"' ");
            
            rs = ps.executeQuery();
            if(rs.next()){
                ok = true;
            }
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinMovimientos|existeReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return ok;
    }
      
    public static String getCPoliza(Connection conn, String ejercicioId, String polizaId) throws SQLException {       
        
        PreparedStatement ps	= null;
        ResultSet rs			= null;
        String importe			= "0";

        try {
            ps = conn.prepareStatement("SELECT COALESCE(SUM(IMPORTE),0) AS IMPORTE FROM FIN_MOVIMIENTOS"
            		+ " WHERE NATURALEZA = 'C'"
            		+ " AND EJERCICIO_ID = '"+ejercicioId+"'"
            		+ " AND POLIZA_ID = '"+polizaId+"'");
            
            
            rs = ps.executeQuery();
            if(rs.next()){
                importe = rs.getString("IMPORTE");
            }            
           
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|getCPoliza|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return importe;
    }
    
    public static String getDPoliza(Connection conn, String ejercicioId, String polizaId) throws SQLException {     
        
        PreparedStatement ps	= null;
        ResultSet rs			= null;
        String importe			= "0";

        try {
            ps = conn.prepareStatement("SELECT COALESCE(SUM(IMPORTE),0) AS IMPORTE FROM FIN_MOVIMIENTOS"
            		+ " WHERE NATURALEZA = 'D'"
            		+ " AND EJERCICIO_ID = '"+ejercicioId+"'"
            		+ " AND POLIZA_ID = '"+polizaId+"'");
            
            
            rs = ps.executeQuery();
            if(rs.next()){
                importe = rs.getString("IMPORTE");
            }            
           
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|getCPoliza|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return importe;
    }
    
    public String maxReg(Connection conn, String ejercicioId, String polizaId) throws SQLException {    	
        String maximo			= "1";
        ResultSet rs			= null;
        PreparedStatement ps	= null;

        try {
            ps = conn.prepareStatement("SELECT COALESCE( MAX(MOVIMIENTO_ID)+1 , 1) AS MAXIMO" +
            		" FROM FIN_MOVIMIENTOS WHERE EJERCICIO_ID = ? AND POLIZA_ID = ?");
            
            ps.setString(1, ejercicioId);
	        ps.setString(2, polizaId);
            
            rs = ps.executeQuery();
            if(rs.next()){
                maximo = rs.getString("MAXIMO");
            }            
           
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|maxReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return maximo;
    }
    
    public static String getSaldoAnterior(Connection conn, String auxiliar, String fecha) throws SQLException {    	
       
        PreparedStatement ps	= null;
        ResultSet rs			= null;
        String saldo 			= "0";

        try {
            ps = conn.prepareStatement("SELECT COALESCE(SUM(IMPORTE * CASE NATURALEZA WHEN 'C' THEN -1 ELSE 1 END),0) AS SALDO" +
            		" FROM FIN_MOVIMIENTOS WHERE AUXILIAR = ? AND FECHA < TO_TIMESTAMP(?,'DD/MM/YYYY HH24:MI:SS') and estado<>'C' "
            		+ "and cuenta_id in (select cuenta_id from fin_cuenta where cuenta_aislada='N' )  ");  
            
            ps.setString(1, auxiliar);
	        ps.setString(2, fecha);
            System.out.println("saldo anterior " + ps);
            rs = ps.executeQuery();
            if(rs.next()){
                saldo = rs.getString("SALDO");
            }            
           
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|maxReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return saldo;
    }
    
    public static String getPolizaId(Connection conn, String ejercicio, String recibo) throws SQLException {
        
        PreparedStatement ps	= null;
        ResultSet rs			= null;
        String saldo 			= "0";

        try {
            ps = conn.prepareStatement("SELECT POLIZA_ID FROM FIN_MOVIMIENTOS WHERE EJERCICIO_ID = ? AND RECIBO = TO_NUMBER(?, '9999999')");
            
            ps.setString(1, ejercicio);
	        ps.setString(2, recibo);
            
            rs = ps.executeQuery();
            if(rs.next()){
                saldo = rs.getString("SALDO");
            }            
           
        }catch(Exception ex){
            System.out.println("Error - aca.fin.FinCuenta|maxReg|:" +ex);
        }finally{
	        if(rs != null) rs.close();
	        if(ps != null) ps.close();
        }
        return saldo;
    }
    
    public static double saldoPolizas( Connection conn, String escuela, String estadoPoliza, String tipoPoliza, String fechaIni, String fechaFin, String naturaleza ) throws SQLException{
    	Statement st		= conn.createStatement();
		ResultSet rs 		= null;
		String comando 		= "";		
		double saldo			= 0;
		
		try{
			comando = " SELECT COALESCE(SUM(IMPORTE),0) AS SALDO FROM FIN_MOVIMIENTOS"
					+ " WHERE POLIZA_ID IN "
					+ " 	(SELECT POLIZA_ID FROM FIN_POLIZA WHERE SUBSTR(POLIZA_ID,1,3) = '"+escuela+"' AND ESTADO IN ("+estadoPoliza+") AND TIPO IN ("+tipoPoliza+") "
					+ "		AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY'))"
					+ " AND NATURALEZA = '"+naturaleza+"' and and estado<>'C'";				
			System.out.println("a " + comando);
			rs = st.executeQuery(comando);					
			if(rs.next()){
				saldo = rs.getDouble("SALDO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|saldoPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return saldo;
	}
    
    
    public static BigDecimal saldoPolizas( Connection conn, String cuenta, String fecha) throws SQLException{
    	Statement st		= conn.createStatement();
		ResultSet rs 		= null;
		String comando 		= "";		
		BigDecimal saldo			= BigDecimal.ZERO;
		
		try{
			comando = " SELECT COALESCE(SUM(IMPORTE * CASE NATURALEZA WHEN 'D' THEN 1 ELSE -1 END),0) AS SALDO FROM FIN_MOVIMIENTOS"
					+ " WHERE to_date(to_char(fecha,'dd/mm/yyyy'),'dd/mm/yyyy')< to_date('"+fecha+"','dd/mm/yyyy') and cuenta_id='"+cuenta+"' and estado<>'C'"
							+ " and auxiliar<>'-' "
							+ "";				
			System.out.println("b " + comando);
			rs = st.executeQuery(comando);					
			if(rs.next()){
				saldo = rs.getBigDecimal("SALDO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|saldoPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return saldo;
	}
    
    
    public static double saldoPolizas( Connection conn, String escuela, String estadoPoliza, String tipoPoliza, String fechaIni, String fechaFin, String naturaleza, String estadoMov ) throws SQLException{
    	Statement st		= conn.createStatement();
		ResultSet rs 		= null;
		String comando 		= "";		
		double saldo			= 0;
		
		try{
			comando = "SELECT COALESCE(SUM(IMPORTE),0) AS SALDO FROM FIN_MOVIMIENTOS"
					+ " WHERE EJERCICIO_ID || '-' ||POLIZA_ID  IN "
					+ " 	(SELECT EJERCICIO_ID || '-' ||POLIZA_ID  FROM FIN_POLIZA WHERE SUBSTR(POLIZA_ID,1,3) = '"+escuela+"' AND ESTADO IN ("+estadoPoliza+") AND TIPO IN ("+tipoPoliza+") "
					+ "		AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY'))"
					+ " AND NATURALEZA = '"+naturaleza+"'"
					+ " AND ESTADO IN("+estadoMov+")";
			System.out.println("c " + comando);
			rs = st.executeQuery(comando);					
			if(rs.next()){
				saldo = rs.getDouble("SALDO");
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|saldoPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return saldo;
	}
    
    public static double saldoCaja( Connection conn, String escuela, String estadoPoliza, String tipoPoliza, String fechaIni, String fechaFin, String naturaleza, String estadoMov ) throws SQLException{
    	Statement st		= conn.createStatement();
		ResultSet rs 		= null;
		String comando 		= "";		
		double saldo			= 0;
		
		try{
			comando = "SELECT COALESCE(SUM(IMPORTE),0) AS SALDO FROM FIN_MOVIMIENTOS"
					+ " WHERE POLIZA_ID IN "
					+ " 	(SELECT POLIZA_ID FROM FIN_POLIZA WHERE SUBSTR(POLIZA_ID,1,3) = '"+escuela+"' AND ESTADO IN ("+estadoPoliza+") AND TIPO IN ("+tipoPoliza+")"
					+ "		AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY'))"
					+ " AND NATURALEZA = '"+naturaleza+"'"
					+ " AND ESTADO IN("+estadoMov+")"
					+ " AND RECIBO_ID != 0";
			
			rs = st.executeQuery(comando);					
			if(rs.next()){
				saldo = rs.getDouble("SALDO");
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|saldoCaja|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return saldo;
	}
    
    public static double saldoAlumno( Connection conn, String auxiliar, String fecha) throws SQLException{
    	Statement st		= conn.createStatement();
		ResultSet rs 		= null;
		String comando 		= "";		
		double saldo			= 0;
		
		try{
			comando = " SELECT COALESCE(SUM(IMPORTE * CASE NATURALEZA WHEN 'D' THEN -1 ELSE 1 END),0) AS SALDO"
					+ " FROM FIN_MOVIMIENTOS"
					+ " WHERE AUXILIAR = '"+auxiliar+"'"
					+ " AND  TO_DATE(TO_CHAR(FECHA,'DD/MM/YYYY'),'DD/MM/YYYY') <= TO_DATE('"+fecha+"','DD/MM/YYYY') and estado<>'C' and cuenta_id in (select cuenta_id from fin_cuenta where cuenta_aislada='N')";
								
			rs = st.executeQuery(comando);					
			if(rs.next()){
				saldo = rs.getDouble("SALDO");
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimiento|saldoAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return saldo;
	}
    
}