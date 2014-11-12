// Clase para traer los privilegios del usuario
package aca.conecta;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import oracle.jdbc.pool.OracleDataSource;


public class ConectarEliseo{	
	
	// Coneccion para Oracle con el usuario Elias
	public Connection conElias( ){
		Connection conn = null;
		try{
			// Coneccion a Oracle usando pool de Tomcat
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource)envContext.lookup("jdbc/conEliseo");
			conn = ds.getConnection();
			//System.out.println("Coneccion pool..");		
		}catch(Exception ex){
			System.out.println("Error - aca.conectar.Conectar|conection conEliseo|:"+ex);
			try {
				//System.out.println("Coneccion directa...");				
				// Conexion directa a Oracle XE mediante pool de la BD
				OracleDataSource ds;
			    ds = new OracleDataSource();
			    //ds.setURL("jdbc:oracle:thin:@172.16.254.14:1521:ora1");
			    ds.setURL("jdbc:oracle:thin:@172.16.10.242:1521:XE");
			    conn = ds.getConnection("eliseo", "manto");
				
			} catch(Exception e) {
				System.out.println("De plano no me pude conectar jajaja...");
				e.printStackTrace();
			}
		}
		return conn;
	}	
	
	// Desconectar Oracle usuario Elias
	public void desElias(Connection Conn){
		try{			
			Conn.commit();
			Conn.close();
		}catch(Exception ex){
			System.out.println("Error - aca.conecta.Conectar|desEnoc|:"+ex);
		}
	}
		
	public boolean setSchema(Connection conn, String schema ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("ALTER SESSION "+
				"SET CURRENT_SCHEMA = ?");			
			ps.setString(1, schema);			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;			
		}catch(Exception ex){
			System.out.println("Error - aca.conectar.conectar|setSchema|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}		
		return ok;
	}
}

