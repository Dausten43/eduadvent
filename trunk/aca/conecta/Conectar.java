// Clase para traer los privilegios del usuario
package aca.conecta;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Conectar{	
	
	// Coneccion para Oracle con el usuario Elias
	public Connection conEliasDir( ){
		Connection conn = null;
		try{		
			//System.out.println("ESC Postgres dir...");
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(getConeccion(),getUsuario(),getPassword());
				
		} catch(Exception e) {
			System.out.println("Fallo la conexion directa...");
			e.printStackTrace();
		}		
		return conn;
	}
	
	// Conexión para SqlServer Contabilidad en Sun Systems
	public Connection conSunPlus( ){
		Connection conn = null;
		try{			
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource)envContext.lookup("jdbc/conSunPlus");
			conn = ds.getConnection();
			System.out.println("Usando el pool");
		} catch(Exception ex) {			
			try{
				Class.forName("net.sourceforge.jtds.jdbc.Driver");
				conn = DriverManager.getConnection(getSunPlusUrl(),getSunPlusUser(),getSunPlusPassword());
				System.out.println("Conexion directa");
			}catch(Exception e){
				System.out.println("No es posible conectarse... Error - aca.conectar.Conectar|conSunPlus|:");
				e.printStackTrace();
			}
		}		
		return conn;
	}
	
	// Conexión para SqlServer Contabilidad en Sun Systems
	public static boolean conSunPlusPrueba(String ip, String puerto, String baseDatos, String usuario, String password){
		Connection conn = null;		
		boolean ok = false;
		try{
			usuario 	= "sa";
			password 	= "SunPlus7!";
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://"+ip+":"+puerto+"/"+baseDatos, usuario, password);
			if (conn!=null) ok = true;
			conn.close();
		}catch(Exception e){
			System.out.println("No es posible conectarse... Error - aca.conectar.Conectar|conSunPlus|:");		
		}					
		return ok;
	}
	
	// Conexión para SqlServer Contabilidad en Sun Systems
	public static Connection conSunPlusDir(String ip, String puerto, String baseDatos, String usuario, String password){
		Connection conn = null;		
		try{
			usuario 	= "sa";
			password 	= "SunPlus7!";
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://"+ip+":"+puerto+"/"+baseDatos, usuario, password);
			System.out.println("Conexion directa");
		}catch(Exception e){
			System.out.println("No es posible conectarse... Error - aca.conectar.Conectar|conSunPlus|:");
			e.printStackTrace();
		}					
		return conn;
	}
	
	// Coneccion para Postgresql
	public Connection conEliasPostgres(){
		Connection conn = null;
		try{
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource)envContext.lookup("jdbc/conElias");
			conn = ds.getConnection();
			//System.out.println("ESC Postgres pool...");						
		}catch(Exception ex){
			//System.out.println("Error - aca.conectar.Conectar|conPostgres|:"+ex);
			try{
				//System.out.println("ESC Postgres dir(fall� pool)...");
				Class.forName("org.postgresql.Driver");
				conn = DriverManager.getConnection(getConeccion(),getUsuario(),getPassword());
			}catch(Exception e){
				System.out.println("No es posible conectarse... Error - aca.conectar.Conectar|conPostgres|:");
				e.printStackTrace();
			}
		}
		return conn;
	}
	
	// Desconectar usuario Elias conexion directa
	public void desJosueDir(Connection Conn){
		try{			
			Conn.close();
		}catch(Exception ex){
			System.out.println("Error - aca.conecta.Conectar|desEliasDir|:"+ex);
		}
	}
	
	// Desconectar Postgres usuario Elias
	public void desJosuePostgres(Connection Conn){
		try{			
			Conn.close();
		}catch(Exception ex){
			System.out.println("Error - aca.conecta.Conectar|desElias|:"+ex);
		}
	}
		
	public boolean setSchema(Connection conn, String schema ) throws Exception{
		boolean ok = false;
		try{
			PreparedStatement ps = conn.prepareStatement("ALTER SESSION "+
				"SET CURRENT_SCHEMA = ?");			
			ps.setString(1, schema);			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
			
			if (ps!=null) ps.close();
			
		}catch(Exception ex){
			System.out.println("Error - aca.conectar.conectar|setSchema|:"+ex);			
		}		
		return ok;
	}
	
	//Datos de la coneccion a postgres 
	public static String getConeccion(){
		//return "jdbc:postgresql://localhost:5432/elias";
		return "jdbc:postgresql://172.16.251.25:5432/elias";
	}
	public static String getUsuario(){
		return "postgres";
	}
	public static String getPassword(){
		return "";
	}
	
	
	public static String getSunPlusUrl(){
		return "jdbc:jtds:sqlserver://172.16.7.33:1433/Sunplusadv";
	}
	
	public static String getSunPlusUser(){
		return "sa";
	}
	
	public static String getSunPlusPassword(){
		return "SunPlus7!";
	}
	
}

