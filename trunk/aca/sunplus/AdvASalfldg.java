package aca.sunplus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdvASalfldg { /* Movimientos en Sun Plus */
	private String accntCode;
	
	public AdvASalfldg(){
		accntCode		= "";
	}
	
	
	public String getAccntCode() {
		return accntCode;
	}
	public void setAccntCode(String accntCode) {
		this.accntCode = accntCode;
	}



	public void mapeaReg(ResultSet rs ) throws SQLException{
		accntCode		= rs.getString("ACCNT_CODE");

	}
	
	public void mapeaRegId(Connection con, String maestroId, String folio) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null;
		try{
			ps = con.prepareStatement("SELECT ACCNT_CODE " +				
					" FROM ADV_A_SALFLDG");
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.sunplus.AdvASalfldg|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	
}