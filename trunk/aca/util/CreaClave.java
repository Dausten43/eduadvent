// Utileria de claves
package aca.util;
import java.sql.*;
import oracle.jdbc.pool.OracleDataSource;
import sun.misc.BASE64Encoder;
import java.security.MessageDigest;

// Creaci{on de claves de usuarios
public class CreaClave{
	
	public static void main(String[] args){
		
		try{			
			Connection conn = null;	
			OracleDataSource ds;
			ds = new OracleDataSource();
			ds.setURL("jdbc:oracle:thin:@172.16.10.239:1521:XE");
			conn = ds.getConnection("elias", "carrofuego");
			
			PreparedStatement ps1 = null;
			PreparedStatement ps2 = null;
			ResultSet rs1 = null;
			
			String codigoId 	= null;
			String cuenta		= null;
			String claveDigest	= null;
			
			int update=0, error=0;
			
			ps2 = conn.prepareStatement("UPDATE USUARIO SET CLAVE = ?, CUENTA = ? " +
			"WHERE CODIGO_ID = ?");
			
			MessageDigest md5	= MessageDigest.getInstance("MD5");
			
			//ps1 = conn.prepareStatement("SELECT CODIGO_ID, CUENTA, CLAVE FROM USUARIO WHERE COALESCE(CUENTA,'X') = 'X'");
			ps1 = conn.prepareStatement("SELECT CODIGO_ID, CUENTA, CLAVE FROM USUARIO WHERE CUENTA = 'empleado'");
			rs1 = ps1.executeQuery();
			while (rs1.next()){				
				
				codigoId 	= rs1.getString("CODIGO_ID");
				cuenta		= rs1.getString("CUENTA");
				if (cuenta==null) cuenta = codigoId;
				
				md5.update(cuenta.getBytes("UTF-8"));
				byte raw[] = md5.digest();    
				claveDigest	= (new BASE64Encoder()).encode(raw);
				
				ps2.setString(1,claveDigest);
				ps2.setString(2,cuenta);
				ps2.setString(3,codigoId);
				if (ps2.executeUpdate()==1){
					System.out.println("Update:"+codigoId+":"+claveDigest);
					update++;
				}else{
					error++;
				}
			}		
			
			if (conn!=null) conn.close();
			if (ps1!=null) ps1.close();
			if (ps1!=null) ps1.close();
			if (rs1!=null) rs1.close();
			
			System.out.println("Datos:"+update+":"+error);
			
		}catch(Exception ex){
			System.out.println("Error:"+ex);
		}finally{
					
		}
	}
		
}
