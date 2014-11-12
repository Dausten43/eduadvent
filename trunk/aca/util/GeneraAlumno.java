// Utileria para generar datos de alumnos
package aca.util;
import java.sql.*;
import oracle.jdbc.pool.OracleDataSource;
import aca.alumno.AlumPersonal;

// Creaci{on de claves de usuarios
public class GeneraAlumno{
	
	public static void main(String[] args){
		
		try{			
			Connection conn = null;	
			OracleDataSource ds;
			ds = new OracleDataSource();
			ds.setURL("jdbc:oracle:thin:@172.16.10.239:1521:XE");
			conn = ds.getConnection("elias", "carrofuego");
			
			String codigoId = "";
			
			AlumPersonal alumno = new AlumPersonal();
			//alumno.mapeaRegId(conn, "01060001");
			for (int i=3;i<100;i++){
				
				if (String.valueOf(i).length()==1){
					codigoId = "010600"+String.valueOf(i);
				}else{
					codigoId = "01060"+String.valueOf(i);
				}
				
				alumno.setCodigoId(codigoId);
				alumno.setNombre("Nombre"+String.valueOf(i));
				alumno.setApaterno("Paterno"+String.valueOf(i));
				alumno.setAmaterno("Materno"+String.valueOf(i));
				alumno.setEscuelaId("1");
				alumno.setPaisId("135");
				alumno.setCiudadId("18");
				alumno.setEstadoId("19");
				alumno.setColonia("ZAMBRANO");
				alumno.setClasfinId("1");
				alumno.setCotejado("N");
				alumno.setCurp("x");
				alumno.setDireccion("x");
				alumno.setEmail("x");
				alumno.setEstado("A");
				alumno.setFNacimiento("01/01/2000");
				alumno.setGenero("H");
				alumno.setGrado("1");
				alumno.setGrupo("A");
				alumno.setNivelId("2");
				alumno.setTelefono("x");
								
				if (alumno.insertReg(conn))
					System.out.println("Valor:"+i+":"+codigoId);
									
			}
			
			System.out.println("Finish..");
						
			if (alumno!=null) alumno=null;
			if (conn!=null) conn.close();			
			
		}catch(Exception ex){
			System.out.println("Error:"+ex);
		}finally{
					
		}
	}
		
}
