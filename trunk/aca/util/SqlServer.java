// Utileria para generar datos de alumnos
package aca.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

// Creaci{on de claves de usuarios
public class SqlServer{
	
	public static void main(String[] args) throws Exception{

		Connection conn = null;
		try{
			
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://172.16.7.33:1433/Sunplusadv","sa","SunPlus7!");						
			
			Statement st 	= conn.createStatement();
			ResultSet rs 	= null;
			String comando	= "";
				
			try{		
				
				comando = "SELECT ACNT_CODE, DESCR FROM ADV_ACNT";
				
				rs = st.executeQuery(comando);			
				while (rs.next()){
					System.out.println(rs.getString("ACNT_CODE")+" "+rs.getString("DESCR"));
				}				
				
			}catch(Exception ex){
				System.out.println("Error - aca.util.SqlServer|Conectar:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (st!=null) st.close();
			}			
		}catch(Exception ex){
			System.out.println("Error:"+ex);
		}finally{
			if (conn!=null) conn.close();
		}
	}
		
}
