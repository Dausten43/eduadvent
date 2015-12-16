// Bean del Catáogo Cursos
package  aca.plan;
import java.sql.*;

public class PlanGrado{
	
	private String planId;
	private String grado;	
	private String nombre;
	
	public PlanGrado(){
		planId			= "";
		grado			= "";
		nombre			= "";
	}
	
public String getPlanId() {
		return planId;
	}

	public void setPlanId(String planId) {
		this.planId = planId;
	}

	public String getGrado() {
		return grado;
	}

	public void setGrado(String grado) {
		this.grado = grado;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

public boolean insertReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{			
			ps = conn.prepareStatement("INSERT INTO PLAN_GRADO"+
				" (PLAN_ID, GRADO, NOMBRE)" +
				" VALUES( ?, TO_NUMBER(?,'99'), ?)");	
					
			ps.setString(1, planId);
			ps.setString(2, grado);
			ps.setString(3, nombre);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanGrupo|insertReg|:"+ex);	
		}finally{
			if (ps!=null) ps.close();
		}		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE PLAN_GRADO" + 
				" SET NOMBRE = ?" +
				" WHERE PLAN_ID = ? AND GRADO = TO_NUMBER(?, '99')");
			
			ps.setString(1, nombre);
			ps.setString(2, planId);			
			ps.setString(3, grado);
			
			if (ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanGrupo|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM PLAN_GRADO WHERE PLAN_ID = ? AND GRUPO = ? ");
			ps.setString(1,planId);
			ps.setString(2,grado);
			
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;			
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanGrupo|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		planId 			= rs.getString("PLAN_ID");
		grado	 		= rs.getString("GRADO");
		nombre			= rs.getString("NOMBRE");
	}
	
	public void mapeaRegId( Connection conn, String cursoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT PLAN_ID, GRADO, NOMBRE FROM PLAN_GRADO" +
					" WHERE PLAN_ID = ? AND GRUPO = ?");
			
			ps.setString(1,planId);
			ps.setString(2,grado);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanGrupo|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 		ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM PLAN_GRADO WHERE PLAN_ID = ? AND GRUPO = ?");
			
			ps.setString(1,planId);
			ps.setString(2,grado);
			
			rs = ps.executeQuery();
			
			if (rs.next()){
				ok = true;
			}else{
				ok = false;
			}

		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanGrupo|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	
	
}