// Bean del Cat�logo de Materias de los grupos
package  aca.ciclo;

import java.sql.*;

public class CicloPermiso{
	private String cicloId;
	private String nivelId;	
	
	
	
	@Override
	public String toString() {
		return "CicloPermiso [cicloId=" + cicloId + ", nivelId=" + nivelId + "]";
	}

	public CicloPermiso(){
		cicloId		= "";
		nivelId		= "";					
	}
	
	public String getCicloId(){
		return cicloId;
	}
	
	public void setCicloId( String cicloId){
		this.cicloId = cicloId;
	}	
	
	public String getNivelId(){
		return nivelId;
	}
	
	public void setNivelId( String nivelId){
		this.nivelId = nivelId;
	}	
	
	public boolean insertReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
		    ps = conn.prepareStatement("INSERT INTO CICLO_PERMISO"+
				"(CICLO_ID, NIVEL_ID ) VALUES( ?, TO_NUMBER(?,'99') )");
			ps.setString(1, cicloId);
			ps.setString(2, nivelId);								
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.carga.CicloPermiso|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_PERMISO "+
				"WHERE CICLO_ID = ? AND NIVEL_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloId);
			ps.setString(2, nivelId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
					
		}catch(Exception ex){
			System.out.println("Error - aca.carga.CicloPermiso|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloId 		= rs.getString("CICLO_ID");
		nivelId 		= rs.getString("NIVEL_ID");	
	}
	
	public void mapeaRegId( Connection conn, String cicloId, String nivelId ) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = conn.prepareStatement("SELECT "+
				"CICLO_ID, NIVEL_ID "+
				"FROM CICLO_PERMISO "+
				"WHERE CICLO_ID = ? "+
				"AND NIVEL_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloId);
			ps.setString(2, nivelId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloPermiso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 			rs		= null;
		PreparedStatement 	ps		= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_PERMISO "+
				"WHERE CICLO_ID = ? "+
				"AND NIVEL_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloId);
			ps.setString(2, nivelId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.carga.CicloPermiso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}	
	
	public static boolean existeCiclo(Connection conn, String cicloId) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 			rs		= null;
		PreparedStatement 	ps		= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_PERMISO "+
				"WHERE CICLO_ID = ? ");
			ps.setString(1, cicloId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.carga.CicloPermiso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	public static String getNiveles(Connection conn, String cicloId) throws SQLException{
		
		PreparedStatement 	ps		= null;
		ResultSet 			rs		= null;
		String niveles				= "-";
		
		try{
			ps = conn.prepareStatement("SELECT NIVEL_ID FROM CICLO_PERMISO WHERE CICLO_ID = ?");
			ps.setString(1, cicloId);		
			
			rs = ps.executeQuery();
			while(rs.next()){
				niveles += rs.getString("NIVEL_ID")+"-";
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.carga.CicloPermiso|getNiveles|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return niveles;
	}
	
}
