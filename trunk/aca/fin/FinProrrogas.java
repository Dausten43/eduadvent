package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class FinProrrogas {

	private Integer id;
	private String idEscuela;
	private String idAlumno;
	private String idPadre;
	private String fechaVence;
	private String observacion;
	private String usuarioCrea;
	private String fechaCreado;
	private String status;
	
	public FinProrrogas(){
		id=0;
		idAlumno="";
		idPadre="";
		fechaVence="";
		observacion="";
		usuarioCrea="";
		fechaCreado="";
		status="A";
	}


	
	/**
	 * @return the id
	 */
	public Integer getId() {
		return id;
	}



	/**
	 * @param id the id to set
	 */
	public void setId(Integer id) {
		this.id = id;
	}



	/**
	 * @return the idEscuela
	 */
	public String getIdEscuela() {
		return idEscuela;
	}



	/**
	 * @param idEscuela the idEscuela to set
	 */
	public void setIdEscuela(String idEscuela) {
		this.idEscuela = idEscuela;
	}



	/**
	 * @return the idAlumno
	 */
	public String getIdAlumno() {
		return idAlumno;
	}



	/**
	 * @param idAlumno the idAlumno to set
	 */
	public void setIdAlumno(String idAlumno) {
		this.idAlumno = idAlumno;
	}



	/**
	 * @return the idPadre
	 */
	public String getIdPadre() {
		return idPadre;
	}



	/**
	 * @param idPadre the idPadre to set
	 */
	public void setIdPadre(String idPadre) {
		this.idPadre = idPadre;
	}



	/**
	 * @return the fechaVence
	 */
	public String getFechaVence() {
		return fechaVence;
	}



	/**
	 * @param fechaVence the fechaVence to set
	 */
	public void setFechaVence(String fechaVence) {
		this.fechaVence = fechaVence;
	}



	/**
	 * @return the observacion
	 */
	public String getObservacion() {
		return observacion;
	}



	/**
	 * @param observacion the observacion to set
	 */
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}



	/**
	 * @return the usuarioCrea
	 */
	public String getUsuarioCrea() {
		return usuarioCrea;
	}



	/**
	 * @param usuarioCrea the usuarioCrea to set
	 */
	public void setUsuarioCrea(String usuarioCrea) {
		this.usuarioCrea = usuarioCrea;
	}



	/**
	 * @return the fechaCreado
	 */
	public String getFechaCreado() {
		return fechaCreado;
	}



	/**
	 * @param fechaCreado the fechaCreado to set
	 */
	public void setFechaCreado(String fechaCreado) {
		this.fechaCreado = fechaCreado;
	}



	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}



	/**
	 * @param status the status to set
	 */
	public void setStatus(String status) {
		this.status = status;
	}



	public boolean insertReg(Connection conn) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
        	updateReg(conn,idAlumno, idEscuela, status, 0);
        	
            ps = conn.prepareStatement(
                    "INSERT INTO fin_prorrogas("
                    + "            id_escuela, id_alumno, id_padre, fecha_vence, observacion,"
                    + "            usuario_crea)"
                    + "    VALUES (?, ?, ?, to_date(?,'DD/MM/YYYY'), ?, ?)");
            
            ps.setString(1, idEscuela);
            ps.setString(2, idAlumno);
            ps.setString(3, idPadre);
            ps.setString(4, fechaVence);
            ps.setString(5, observacion);
            ps.setString(6, usuarioCrea);

            
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.out.println("Error - aca.fin.FinProrrogas|insertReg|:" + ex);
        }finally{
        	if(ps != null){
                ps.close();
            }
        }

        return ok;
    }
	
	public boolean updateReg(Connection conn, String idalumno, String idescuela, String status, Integer id) throws SQLException{
        boolean ok = false;
        PreparedStatement ps = null;
        try{
        	String sql = "UPDATE fin_prorrogas    "
            		+ "SET  status=? , fecha_creado=current_timestamp "
            		+ "WHERE id is not null";
        	
        	if(!idalumno.isEmpty()){
        		sql+= " and id_alumno='"+ idalumno +"' ";
        	}
        	
        	if(!idescuela.isEmpty()){
        		sql+= " and id_escuela='"+ idescuela +"' ";
        	}
        	
        	if(id!=0){
        		sql+= " and id="+ id +" ";
        	}
        	
        	
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            
            
           
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.err.println("Error - aca.fin.FinProrrogas|updateReg|:" + ex);
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
            ps = conn.prepareStatement(" UPDATE fin_prorrogas    "
            		+ "SET  status=? , fecha_creado=current_timestamp "
            		+ "WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, id);
            
           
            if(ps.executeUpdate() == 1){
                ok = true;
            }

        }catch (Exception ex){
            System.err.println("Error - aca.fin.FinProrrogas|updateReg|:" + ex);
        }finally{
        	 if(ps != null){
                 ps.close();
             }
        }

        return ok;
    }

    public boolean deleteReg(Connection conn) throws SQLException{
        boolean ok = false;
        
        return ok;
    }

    public void mapeaReg(ResultSet rs) throws SQLException {
    	id				= rs.getInt("id");
        idEscuela		= rs.getString("id_escuela");
		idAlumno		= rs.getString("id_alumno");
		idPadre			= rs.getString("id_padre");
		fechaVence		= rs.getString("fecha_vence");
		observacion		= rs.getString("observacion");
		usuarioCrea		= rs.getString("usuario_crea");
		fechaCreado		= rs.getString("fecha_creado");
		status		 	= rs.getString("status");
    }
        
    public void mapeaRegId(Connection con, String cuentaId) throws SQLException{
        ResultSet rs = null;
        PreparedStatement ps = null; 
        try{
	        ps = con.prepareStatement("SELECT id, id_escuela, id_alumno, id_padre, to_char(fecha_vence,'DD/MM/YYYY') fecha_vence, observacion,"
	        		+ "        usuario_crea, to_char(fecha_creado,'DD/MM/YYYY') fecha_creado , status  FROM fin_prorrogas where id=?");
	        ps.setInt(1, id); 
	        
	        rs = ps.executeQuery();
	        if(rs.next()){
	            mapeaReg(rs);
	        }
        }catch(Exception ex){
			System.out.println("Error - aca.fin.FinProrrogas|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
    }
    
    public List<FinProrrogas> getListFinProrrogas(Connection conn, String idEscuela, String idAlumno, String idPadre, String status)throws SQLException{
    	List<FinProrrogas> salida = new ArrayList<FinProrrogas>();
    	Statement st 	= conn.createStatement(); 
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT id, id_escuela, id_alumno, id_padre, to_char(fecha_vence,'DD/MM/YYYY') fecha_vence, observacion,        "
					+ "usuario_crea, to_char(fecha_creado,'DD/MM/YYYY') fecha_creado, status  FROM fin_prorrogas where id is not null ";
			if(!idEscuela.isEmpty()){
				comando+= " and id_escuela='"+idEscuela+"' ";
			}
			if(!idAlumno.isEmpty()){
				comando+= " and id_alumno='"+idAlumno+"' ";
			}
			if(!idPadre.isEmpty()){
				comando+= " and id_padre='"+idPadre+"' ";
			}
			if(!idPadre.isEmpty()){
				comando+= " and status='"+status+"' ";
			}
			
			comando += " order by status,fecha_vence ";
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinProrrogas fp = new FinProrrogas();				
				fp.mapeaReg(rs);
				salida.add(fp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinProrrogas|getListFinProrrogas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		return salida;
    }

    public boolean existeReg(Connection conn, String idEscuela, String idAlumno, String idPadre, String status) throws SQLException {
        boolean ok = false;
        Statement st 	= conn.createStatement(); 
		ResultSet rs 	= null;
		String comando	= "";
		try{
			comando = "SELECT id, id_escuela, id_alumno, id_padre, to_char(fecha_vence,'DD-MM-YYYY') fecha_vence, observacion,        "
					+ "usuario_crea,  to_char(fecha_creado,'DD-MM-YYYY') fecha_creado , status  FROM fin_prorrogas where id is not null "
					+ " and fecha_vence>=current_date and status='A' ";
			
			if(!idEscuela.isEmpty()){
				comando+= " and id_escuela='"+idEscuela+"' ";
			}
			if(!idAlumno.isEmpty()){
				comando+= " and id_alumno='"+idAlumno+"' ";
			}
			if(!idPadre.isEmpty()){
				comando+= " and id_padre='"+idPadre+"' ";
			}
			
			rs = st.executeQuery(comando);			
			if (rs.next()){
				ok=true;
			}
			//System.out.println(comando);
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinProrrogas|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
        return ok;
    }
    
    public boolean existeReg(Connection conn, String cuentaId) throws SQLException {
        boolean ok = false;
        
        return ok;
    }    
    
}
