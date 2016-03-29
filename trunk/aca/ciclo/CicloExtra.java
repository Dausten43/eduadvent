package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CicloExtra {
	private String cicloId;
	private String oportunidad;
	private String valorAnterior;
	private String valorExtra;
	private String oportunidadNombre;
	
	public CicloExtra(){
		cicloId				= "";
		oportunidad			= "";
		valorAnterior		= "";
		valorExtra 			= "";
		oportunidadNombre	= "";
	}
	
	public String getCicloId() {
		return cicloId;
	}

	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}

	public String getOportunidad() {
		return oportunidad;
	}

	public void setOportunidad(String oportunidad) {
		this.oportunidad = oportunidad;
	}

	public String getValorAnterior() {
		return valorAnterior;
	}

	public void setValorAnterior(String valorAnterior) {
		this.valorAnterior = valorAnterior;
	}

	public String getValorExtra() {
		return valorExtra;
	}

	public void setValorExtra(String valorExtra) {
		this.valorExtra = valorExtra;
	}

	public String getOportunidadNombre() {
		return oportunidadNombre;
	}

	public void setOportunidadNombre(String oportunidadNombre) {
		this.oportunidadNombre = oportunidadNombre;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CICLO_EXTRA" +
					" (CICLO_ID, OPORTUNIDAD, VALOR_ANTERIOR, VALOR_EXTRA, OPORTUNIDAD_NOMBRE)" +
					" VALUES(?, TO_NUMBER(?, '99'), TO_NUMBER(?, '999.99'), TO_NUMBER(?, '999.99'), ?)");
			
			ps.setString(1, cicloId);
			ps.setString(2, oportunidad);
			ps.setString(3, valorAnterior);
			ps.setString(4, valorExtra);
			ps.setString(5, oportunidadNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_EXTRA" +
					" SET VALOR_ANTERIOR = TO_NUMBER(?, '999.99')," +
					" VALOR_EXTRA = TO_NUMBER(?, '999.99')," +
					" OPORTUNIDAD_NOMBRE = ?" +
					" WHERE CICLO_ID = ?" +
					" AND OPORTUNIDAD = TO_NUMBER(?, '99')");			
			ps.setString(1, valorAnterior);
			ps.setString(2, valorExtra);
			ps.setString(3, oportunidadNombre);
			ps.setString(4, cicloId);
			ps.setString(5, oportunidad);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = ?" +
					" AND OPORTUNIDAD = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, oportunidad);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloId				= rs.getString("CICLO_ID");
		oportunidad			= rs.getString("OPORTUNIDAD");
		valorAnterior		= rs.getString("VALOR_ANTERIOR");
		valorExtra			= rs.getString("VALOR_EXTRA");
		oportunidadNombre	= rs.getString("OPORTUNIDAD_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String cicloId, String oportunidad) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CICLO_ID, OPORTUNIDAD, VALOR_ANTERIOR," +
					" VALOR_EXTRA, " +
					" OPORTUNIDAD_NOMBRE" +
					" FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = ?" +
					" AND OPORTUNIDAD = TO_NUMBER(?, '99')");
			ps.setString(1, cicloId);
			ps.setString(2, oportunidad);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = ?" +
					" AND OPORTUNIDAD = TO_NUMBER(?, '99') ");
			ps.setString(1, cicloId);
			ps.setString(2, oportunidad);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String cicloId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(OPORTUNIDAD)+1 AS MAXIMO FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = ? ");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return maximo;
	}
	
	public String maximo(Connection conn, String cicloId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(OPORTUNIDAD) AS MAXIMO FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = ? ");
			ps.setString(1, cicloId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|maximo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return maximo;
	}
	
	public String getNombreOp(Connection conn, String cicloId, String oportunidad) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT OPORTUNIDAD_NOMBRE FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = '"+cicloId+"' AND OPORTUNIDAD = '"+oportunidad+"' ");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("OPORTUNIDAD_NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|getNombreOp|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
	public String getAnterior(Connection conn, String cicloId, String oportunidad) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT VALOR_ANTERIOR FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = '"+cicloId+"' AND OPORTUNIDAD = '"+oportunidad+"' ");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("VALOR_ANTERIOR");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|getAnterior|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
	public String getExtra(Connection conn, String cicloId, String oportunidad) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre 			= "0";
		
		try{
			ps = conn.prepareStatement("SELECT VALOR_EXTRA FROM CICLO_EXTRA" +
					" WHERE CICLO_ID = '"+cicloId+"' AND OPORTUNIDAD = '"+oportunidad+"' ");
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("VALOR_EXTRA");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloExtra|getExtra|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
	
	public ArrayList<CicloExtra> getCicloExtra(Connection con, String cicloId, String oportunidad) throws SQLException{
		ArrayList<CicloExtra> lisCicloExtra = new ArrayList<CicloExtra>();
		Statement st 		= con.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT * FROM CICLO_EXTRA" +
					" WHERE CICLO_ID ='" + cicloId +"'"+
					" AND OPORTUNIDAD ="+oportunidad;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				CicloExtra ciclo = new CicloExtra();				
				ciclo.mapeaReg(rs);
				lisCicloExtra.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloExtra|getCicloExtra:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloExtra;
	}
	
	public ArrayList<CicloExtra> getTodosLosCiclosExtras(Connection con, String cicloId) throws SQLException{
		ArrayList<CicloExtra> lisCicloExtra = new ArrayList<CicloExtra>();
		Statement st 		= con.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT * FROM CICLO_EXTRA" +
					" WHERE CICLO_ID ='" + cicloId +"'";
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				CicloExtra ciclo = new CicloExtra();				
				ciclo.mapeaReg(rs);
				lisCicloExtra.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloExtra|getCicloExtra:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCicloExtra;
	}
		
}
