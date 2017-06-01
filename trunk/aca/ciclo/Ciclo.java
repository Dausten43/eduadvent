//Beans para la tabla CICLO
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class Ciclo {
    private String cicloId;
    private String cicloNombre;
    private String fCreada;
    private String fInicial;
    private String fFinal;
    private String numCursos;
    private String estado;
    private String escala;
    private String modulos;
    private String editarActividad;
    private String cicloEscolar;
    private String decimales;
    private String redondeo;
    private String nivelEval;
    private String nivelAcademicoSistema;



	public Ciclo() {
        cicloId 		= "";
        cicloNombre 	= "";
        fCreada 		= "";
        fFinal 			= "";
        numCursos 		= "0";
        estado 			= "";
        escala			= "10";
        modulos			= "0";
        editarActividad = "SI";
        cicloEscolar	= "0000";
        decimales 		= "1";
        redondeo 		= "A";
        nivelEval		= "E";
    }
    
    
    /**
	 * @return the nivelAcademicoSistema
	 */
	public String getNivelAcademicoSistema() {
		return nivelAcademicoSistema;
	}


	/**
	 * @param nivelAcademicoSistema the nivelAcademicoSistema to set
	 */
	public void setNivelAcademicoSistema(String nivelAcademicoSistema) {
		this.nivelAcademicoSistema = nivelAcademicoSistema;
	}

	
    public String getCicloId() {
		return cicloId;
	}

	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}

	public String getCicloNombre() {
		return cicloNombre;
	}

	public void setCicloNombre(String cicloNombre) {
		this.cicloNombre = cicloNombre;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}	

	public String getFCreada() {
		return fCreada;
	}

	public void setFCreada(String creada) {
		fCreada = creada;
	}	

	public String getFFinal() {
		return fFinal;
	}
	
	public void setFFinal(String final1) {
		fFinal = final1;
	}

	public String getFInicial() {
		return fInicial;
	}
	
	public void setFInicial(String inicial) {
		fInicial = inicial;
	}
	
	public String getNumCursos() {
		return numCursos;
	}
	
	public void setNumCursos(String numCursos) {
		this.numCursos = numCursos;
	}
	
	public String getEscala() {
		return escala;
	}
	
	public void setEscala(String escala) {
		this.escala = escala;
	}	

	public String getModulos() {
		return modulos;
	}

	public void setModulos(String modulos) {
		this.modulos = modulos;
	}
	
	public String getEditarActividad() {
		return editarActividad;
	}
	
	public void setEditarActividad(String editarActividad) {
		this.editarActividad = editarActividad;
	}	

	public String getCicloEscolar() {
		return cicloEscolar;
	}
	
	public void setCicloEscolar(String cicloEscolar) {
		this.cicloEscolar = cicloEscolar;
	}
	
	public String getDecimales() {
		return decimales;
	}
	
	public void setDecimales(String decimales) {
		this.decimales = decimales;
	}

	public String getRedondeo() {
		return redondeo;
	}
	
	public void setRedondeo(String redondeo) {
		this.redondeo = redondeo;
	}
	
	
	
	public String getNivelEval() {
		return nivelEval;
	}


	public void setNivelEval(String nivelEval) {
		this.nivelEval = nivelEval;
	}
	
	
	public String nivelAcademicoSistemaTxt(String idnas){
		Map<String,String> lsNAS  = new HashMap();
		lsNAS.put("0","MATERNAL");
		lsNAS.put("1","PRE-KINDER");
		lsNAS.put("2","KINDER");
		lsNAS.put("3","PRIMARIA");
		lsNAS.put("4","SECUNDARIA PRE-MEDIA");
		lsNAS.put("5","BACHILLERATO");
		lsNAS.put("-1","NO DEFINIDO");
		
		return lsNAS.get(idnas);
	}


	// Insert del ciclo
	public boolean insertReg(Connection conn) throws SQLException {
		PreparedStatement ps = null;
		boolean ok = false;

        try {
            ps = conn.prepareStatement("INSERT INTO CICLO(CICLO_ID,"
                    + " CICLO_NOMBRE, F_CREADA, F_INICIAL, F_FINAL, NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD, CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA)"
                    + " VALUES(?, ?, TO_DATE(?,'DD/MM/YYYY'),"
                    + " TO_DATE(?,'DD/MM/YYYY'),"
                    + " TO_DATE(?,'DD/MM/YYYY'),"
                    + " TO_NUMBER(?,'999'), ?,"
                    + " TO_NUMBER(?,'999'),"
                    + " TO_NUMBER(?,'99'), ?, ?,"
                    + " TO_NUMBER(?,'9'),?,?,?)");
            ps.setString(1, cicloId);
            ps.setString(2, cicloNombre);
            ps.setString(3, fCreada);
            ps.setString(4, fInicial);
            ps.setString(5, fFinal);
            ps.setString(6, numCursos);
            ps.setString(7, estado);
            ps.setString(8, escala);
            ps.setString(9, modulos);
            ps.setString(10, editarActividad);
            ps.setString(11, cicloEscolar);
            ps.setString(12, decimales);
            ps.setString(13, redondeo);
            ps.setString(14, nivelEval);
            ps.setString(15, nivelAcademicoSistema);

            if (ps.executeUpdate() == 1) {
                ok = true;
            } else {
                ok = false;
            }

        } catch (Exception ex) {
            System.out.println("Error - aca.ciclo.ciclo|insertReg|:" +
                ex);
        }finally{
        	if (ps != null) {
                ps.close();
            }
        }

        return ok;
    }

    public boolean updateReg(Connection conn) throws SQLException {
    	PreparedStatement ps = null;
    	boolean ok = false;

        try {
           ps = conn.prepareStatement(
                    " UPDATE CICLO SET CICLO_NOMBRE = ?,"
                    + " F_CREADA = TO_DATE(?,'DD/MM/YYYY'),"
                    + " F_INICIAL = TO_DATE(?,'DD/MM/YYYY'),"
                    + " F_FINAL = TO_DATE(?,'DD/MM/YYYY'),"
                    + " NUM_CURSOS = TO_NUMBER(?,'999'),"
                    + " ESTADO = ?,"
                    + " ESCALA = TO_NUMBER(?,'999'),"
                    + " MODULOS = TO_NUMBER(?,'99'),"
                    + " EDITAR_ACTIVIDAD = ?,"
                    + " CICLO_ESCOLAR = ?,"
                    + " DECIMALES = TO_NUMBER(?,'9'),"
                    + " REDONDEO = ?,"
                    + " NIVEL_EVAL = ?,"
                    + " NIVEL_ACADEMICO_SISTEMA = ?"
                    + " WHERE CICLO_ID = ?");
            
            ps.setString(1, cicloNombre);
            ps.setString(2, fCreada);
            ps.setString(3, fInicial);
            ps.setString(4, fFinal);
            ps.setString(5, numCursos);            
            ps.setString(6, estado);
            ps.setString(7, escala);
            ps.setString(8, modulos);
            ps.setString(9, editarActividad);
            ps.setString(10, cicloEscolar);            
            ps.setString(11, decimales);
            ps.setString(12, redondeo);
            ps.setString(13, nivelEval);
            ps.setString(14, nivelAcademicoSistema);
            ps.setString(15, cicloId);
            

            if (ps.executeUpdate() == 1) {
                ok = true;
            } else {
                ok = false;
            }
            
        } catch (Exception ex) {
            System.out.println("Error - aca.ciclo.ciclo|updateReg|:" +
                ex);
        }finally{
        	if (ps != null) {
                ps.close();
            }
        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException {
    	PreparedStatement ps = null;
    	boolean ok = false;

        try {
            ps = conn.prepareStatement(
                    "DELETE FROM CICLO WHERE CICLO_ID = ?");
            ps.setString(1, cicloId);
          
            if (ps.executeUpdate() == 1) {
                ok = true;
            } else {
                ok = false;
            }

            
        } catch (Exception ex) {
            System.out.println("Error - aca.ciclo.ciclo|deleteReg|:" +
                ex);
        }finally{
        	if (ps != null) {
                ps.close();
            }
        }

        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
        cicloId 		= rs.getString("CICLO_ID");
        cicloNombre		= rs.getString("CICLO_NOMBRE");
        fCreada 		= rs.getString("F_CREADA");
        fInicial 		= rs.getString("F_INICIAL");
        fFinal 			= rs.getString("F_FINAL");
        numCursos 		= rs.getString("NUM_CURSOS");
        estado 			= rs.getString("ESTADO");
        escala			= rs.getString("ESCALA");
        modulos			= rs.getString("MODULOS");
        editarActividad = rs.getString("EDITAR_ACTIVIDAD");
        cicloEscolar	= rs.getString("CICLO_ESCOLAR");
        decimales		= rs.getString("DECIMALES");
        redondeo		= rs.getString("REDONDEO");
        nivelEval		= rs.getString("NIVEL_EVAL");
        nivelAcademicoSistema = rs.getString("NIVEL_ACADEMICO_SISTEMA");
    }

    public void mapeaRegId(Connection con, String cicloId) throws SQLException {
    	PreparedStatement ps = null;
    	ResultSet rs = null;
        
    	try{
	        ps = con.prepareStatement("SELECT CICLO_ID, CICLO_NOMBRE,"
	                + " TO_CHAR(F_CREADA, 'DD/MM/YYYY') AS F_CREADA,"
	                + " TO_CHAR(F_INICIAL, 'DD/MM/YYYY') AS F_INICIAL,"
	                + " TO_CHAR(F_FINAL, 'DD/MM/YYYY') AS F_FINAL,"
	                + " NUM_CURSOS, ESTADO, ESCALA, MODULOS, EDITAR_ACTIVIDAD,"
	                + " CICLO_ESCOLAR, DECIMALES, REDONDEO, NIVEL_EVAL, NIVEL_ACADEMICO_SISTEMA"
	                + " FROM CICLO WHERE CICLO_ID = ?");
	        ps.setString(1, cicloId);
	        rs = ps.executeQuery();
	
	        if (rs.next()) {
	            mapeaReg(rs);
	        }

    	}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|mapeaRegId|:"+ex);
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
            ps = conn.prepareStatement("SELECT * FROM CICLO " +
                    "WHERE CICLO_ID = ?");
            ps.setString(1, cicloId);
            rs = ps.executeQuery();

            if (rs.next()) {
                ok = true;
            } else {
                ok = false;
            }
        } catch (Exception ex) {
            System.out.println("Error - aca.ciclo.ciclo|existeReg|:" +ex);
        }finally{

	        if (rs != null) {
	            rs.close();
	        }
	
	        if (ps != null) {
	            ps.close();
	        }
        }    
        return ok;
    }
    
    public static boolean existeCiclo(Connection conn, String cicloId) throws SQLException {
        boolean ok = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement("SELECT * FROM CICLO " +
                    "WHERE CICLO_ID = ?");
            ps.setString(1, cicloId);
            rs = ps.executeQuery();

            if (rs.next()) {
                ok = true;
            } else {
                ok = false;
            }
        } catch (Exception ex) {
            System.out.println("Error - aca.ciclo.ciclo|existeReg|:" +ex);
        }finally{
	        if (rs != null) rs.close();	
	        if (ps != null) ps.close();
        }
        return ok;
    }

    public String maximoReg(Connection conn) throws SQLException {
        String maximo = "1";
        ResultSet rs = null;
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement(
                    "SELECT MAX(CICLO_ID)+1 MAXIMO FROM CICLO");
            rs = ps.executeQuery();

            if (rs.next()) {
                maximo = rs.getString("MAXIMO");
            }
        } catch (Exception ex) {
            System.out.println("Error - aca.ciclo.ciclo|maximoReg|:" +
                ex);
        }finally{

	        if (rs != null) {
	            rs.close();
	        }
	
	        if (ps != null) {
	            ps.close();
	        }
        }    
        return maximo;
    }
	
	public static String nombreCiclo(Connection conn, String cicloId) throws SQLException {
	        
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String nombre			= "X";

	    try {
			ps = conn.prepareStatement("SELECT CICLO_NOMBRE FROM CICLO " +
	                   "WHERE CICLO_ID = ?");
	        ps.setString(1, cicloId);
	        rs = ps.executeQuery();

	        if (rs.next()) {
	                nombre = rs.getString("CICLO_NOMBRE");
	        }
				
				
	    } catch (Exception ex) {
	            System.out.println("Error - aca.ciclo.ciclo|nombreCiclo|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
		}        

	    return nombre;
	}

	public static String nomCiclo(Connection conn, String cicloId) throws SQLException {
        
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String nombre			= "X";

	    try {
			ps = conn.prepareStatement("SELECT CICLO_NOMBRE FROM CICLO " +
	                   "WHERE CICLO_ID = '"+cicloId+"'");
	        rs = ps.executeQuery();

	        if (rs.next()) {
	                nombre = rs.getString("CICLO_NOMBRE");
	        }
				
				
	    } catch (Exception ex) {
	            System.out.println("Error - aca.ciclo.ciclo|nombreCiclo|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
		}        

	    return nombre;
	}
	
	public static String getMejorCarga(Connection conn, String codigoId) throws SQLException {
        
		PreparedStatement ps 	= null;
		PreparedStatement ps2 	= null;
		ResultSet rs 			= null;
		ResultSet rs2 			= null;
		String cicloId			= "XXXXXXX";

	    try{
	    	ps = conn.prepareStatement("SELECT COALESCE(MAX(SUBSTR(CICLO_GRUPO_ID,1,8)),'0') AS CICLO_ID FROM CICLO_GRUPO_CURSO WHERE EMPLEADO_ID = ?");
			ps.setString(1, codigoId);
			rs = ps.executeQuery();
	        if (rs.next() && !rs.getString("CICLO_ID").equals("0")) {
	        	cicloId = rs.getString("CICLO_ID");
	        	
	        }else{
	        	ps2 = conn.prepareStatement("SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL");
		        rs2 = ps2.executeQuery();
		        if (rs2.next()) {
					cicloId = rs2.getString("CICLO_ID");
		        }		        
	        }      
				
		} catch (Exception ex) {
			System.out.println("Error - aca.ciclo.ciclo|getMejorCarga|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
			if (rs2 != null) rs2.close();
			if (ps2 != null) ps2.close();
		}        

	    return cicloId;
	}
	
	public static String getMejorCargaEscuela(Connection conn, String escuelaId) throws SQLException {
        
		PreparedStatement ps 	= null;
		PreparedStatement ps2 	= null;
		ResultSet rs 			= null;
		ResultSet rs2 			= null;
		String cicloId			= "XXXXXXX";

	    try{
	    	ps = conn.prepareStatement("SELECT CICLO_ID FROM CICLO WHERE SUBSTR(CICLO_ID,1,3) = ? AND ( NOW() BETWEEN F_INICIAL AND F_FINAL)");
			ps.setString(1, escuelaId);
			rs = ps.executeQuery();
	        if (rs.next() && !rs.getString("CICLO_ID").equals("0")) {
	        	cicloId = rs.getString("CICLO_ID");      	
	        }else{
	        	ps2 = conn.prepareStatement("SELECT COALESCE(MAX(CICLO_ID),'XXXXXXX') AS CICLO FROM CICLO WHERE SUBSTR(CICLO_ID,1,3) = '"+escuelaId+"'");
		        rs2 = ps2.executeQuery();
		        if (rs2.next()) {
					cicloId = rs2.getString("CICLO");
		        }
	        }				
				
		} catch (Exception ex) {
			System.out.println("Error - aca.ciclo.ciclo|getMejorCargaEscuela|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
			if (rs2 != null) rs2.close();
			if (ps2 != null) ps2.close();
		}        

	    return cicloId;
	}
	
	public static String getCargaActual(Connection conn, String escuelaId) throws SQLException {
        
		PreparedStatement ps 	= null;
		PreparedStatement ps2 	= null;
		ResultSet rs 			= null;
		ResultSet rs2 			= null;
		String cicloId			= "XXXXXXX";

	    try{
			ps = conn.prepareStatement("SELECT CICLO_ID AS CICLO FROM CICLO" +
					" WHERE SUBSTR(CICLO_ID,1,3) = '"+escuelaId+"' " +
					" AND NOW() BETWEEN F_INICIAL AND F_FINAL");
			
	        rs = ps.executeQuery();
	        if(rs.next()){
				cicloId = rs.getString("CICLO");
	        }else{
	        	ps2 = conn.prepareStatement("SELECT MAX(CICLO_ID) AS CICLO FROM CICLO" +
						" WHERE SUBSTR(CICLO_ID,1,3) = '"+escuelaId+"'");				
		        rs2 = ps2.executeQuery();
		        if(rs2.next()){
					cicloId = rs2.getString("CICLO");
		        }	        	
	        }			
				
		}catch (Exception ex){
			System.out.println("Error - aca.ciclo.ciclo|getCargaActual|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
			if (rs2 != null) rs2.close();
			if (ps2 != null) ps2.close();
		}        

	    return cicloId;
	}
	
	public static String getEstado( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String estado		= "";
		
		try{
			ps = conn.prepareStatement("SELECT ESTADO FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			rs = ps.executeQuery();
			if (rs.next()){
				estado = rs.getString("ESTADO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getEstado|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		return estado;
	} 
	
	public static int getEscala( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		int escala				= 0;
		
		try{
			ps = conn.prepareStatement("SELECT ESCALA FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			rs = ps.executeQuery();
			if (rs.next()){
				escala = rs.getInt("ESCALA");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getEscala|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return escala;
	}
	
	public static int getModulos( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		int escala				= 0;
		
		try{
			ps = conn.prepareStatement("SELECT MODULOS FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			rs = ps.executeQuery();
			if (rs.next()){
				escala = rs.getInt("MODULOS");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getModulos|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		return escala;
	}
	
	public static int getNumModulos( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		int escala				= 0;
		
		try{
			ps = conn.prepareStatement("SELECT MODULOS FROM CICLO WHERE CICLO_ID = '"+cicloId+"'");
			rs = ps.executeQuery();
			if (rs.next()){
				escala = rs.getInt("MODULOS");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getModulos|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		return escala;
	}
	
	public static String getCicloNombre( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT CICLO_NOMBRE FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			rs = ps.executeQuery();
			if (rs.next()){
				nombre = rs.getString("CICLO_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getModulos|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nombre;
	}
	
	public static String getCicloEscolar( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String cicloEscolar		= "0000";
		
		try{
			ps = conn.prepareStatement("SELECT CICLO_ESCOLAR FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			rs = ps.executeQuery();
			if (rs.next()){
				cicloEscolar = rs.getString("CICLO_ESCOLAR");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getCicloEscolar|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return cicloEscolar;
	}
	
	public static String getCicloEscolarMateria( Connection conn, String cicloGrupoId) throws SQLException, Exception {

		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String cicloEscolar		= "0000";
		
		try{
			ps = conn.prepareStatement("SELECT CICLO_ESCOLAR FROM CICLO WHERE CICLO_ID IN (SELECT CICLO_ID FROM CICLO_GRUPO WHERE CICLO_GRUPO_ID = ?)");
			ps.setString(1, cicloGrupoId);
			rs = ps.executeQuery();
			if (rs.next()){
				cicloEscolar = rs.getString("CICLO_ESCOLAR");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getCicloEscolarMateria|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return cicloEscolar;
	}
	
	public static String getEditarActividad( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(EDITAR_ACTIVIDAD,'SI') AS EDITAR FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			rs = ps.executeQuery();
			if (rs.next()){
				nombre = rs.getString("EDITAR");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getEditarActividad|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nombre;
	}
	
	public static boolean getCicloActivo( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		boolean activo			= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO WHERE CICLO_ID = ? AND 'now'::text::date >= ciclo.f_inicial AND 'now'::text::date <= ciclo.f_final ");
			ps.setString(1, cicloId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				activo = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getModulos|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return activo;
	}
	
	public static String getDecimales( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String decimales		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT DECIMALES FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				decimales = rs.getString("DECIMALES");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getDecimales|:"+ex);
		}finally{
		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return decimales;
	}
	
	public static String getRedondeo( Connection conn, String cicloId) throws SQLException, Exception {
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String redondeo		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT REDONDEO FROM CICLO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				redondeo = rs.getString("REDONDEO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.Ciclo|getRedondeo|:"+ex);
		}finally{		
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return redondeo;
	}
	
	// Redondeo de números
	public static String numRedondeo(Connection conn, String numero, int decimales, String tipo) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String num 				= "0";
		try{
			if (tipo.equals("A")){
				ps = conn.prepareStatement("SELECT ROUND(TO_NUMBER(?,'999999.9999'),?) AS NUMERO");
			}else{
				ps = conn.prepareStatement("SELECT TRUNC(TO_NUMBER(?,'999999.9999'),?) AS NUMERO");
			}			
			ps.setString(1, numero);
			ps.setInt(2, decimales);
			
			rs = ps.executeQuery();
			if (rs.next()){
				num = rs.getString("NUMERO");
			}	
			
		}catch(Exception ex){
			 System.out.println("Error - aca.ciclo.ciclo|numRedondeo|:" + ex);
		}finally{
			if (ps!=null) ps.close();		
			if (rs!=null) rs.close();
			
		}
		return num;
	}
	
	// Consulta el nivel de evaluación
	public static String getNivelEval(Connection conn, String ciclo) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nivel			= "-";
		try{	
			ps = conn.prepareStatement("SELECT NIVEL_EVAL FROM CICLO WHERE CICLO_ID = ?");
			
			ps.setString(1, ciclo);
			
			rs = ps.executeQuery();
			if (rs.next()){
				nivel = rs.getString("NIVEL_EVAL");
			}
			
		}catch(Exception ex){
			 System.out.println("Error - aca.ciclo.ciclo|getNivelEval|:" + ex);
		}finally{
			if (ps!=null) ps.close();
			if (rs!=null) rs.close();
			
		}
		return nivel;
	}
	
}