// Clase para la tabla de EmpPersonal
package aca.empleado;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class EmpPersonalLista{
		
	public ArrayList<EmpPersonal> getListAll(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' " +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal emp = new EmpPersonal();
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisEmpleado;
	}
	
	public ArrayList<EmpPersonal> getListAllActivos(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' AND ESTADO = 'A' " +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal emp = new EmpPersonal();
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getListAllActivos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisEmpleado;
	}
	
	public ArrayList<EmpPersonal> listEmpleados(Connection Conn, String escuelaId, String tipos, String estado, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO,"
					+ " ESTADO_CIVIL, TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND ESTADO IN ("+estado+")"
					+ " AND SUBSTRING(CODIGO_ID,4,1) IN ("+tipos+")" +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal emp = new EmpPersonal();
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|listEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisEmpleado;
	}
	
	
	public ArrayList<EmpPersonal> getArrayList(Connection conn, String escuelaId, String nombre, String paterno, String materno, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisPersonal	= new ArrayList<EmpPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE UPPER(NOMBRE) LIKE UPPER('%"+nombre+"%')"
					+ " AND UPPER(APATERNO) LIKE UPPER('%"+paterno+"%')"
					+ " AND UPPER(AMATERNO) LIKE UPPER('%"+materno+"%')"
					+ " AND CODIGO_ID LIKE '"+escuelaId+"%' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				EmpPersonal personal = new EmpPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisPersonal;
	}
	
	
	public ArrayList<EmpPersonal> getListEmp(Connection Conn, String escuela, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuela+"'"
					+ " AND SUBSTR(CODIGO_ID,4,1) = 'E' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal emp = new EmpPersonal();
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getListEmp|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisEmpleado;
	}
		
	
	// Mary
	
	public ArrayList<EmpPersonal> getListEmpActivos(Connection Conn, String escuela, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuela+"'"
					+ " AND SUBSTR(CODIGO_ID,4,1) = 'E'"
					+ " AND ESTADO = 'A' " + orden;
								
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal emp = new EmpPersonal();
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisEmpleado;
	}	
	
	public ArrayList<EmpPersonal> getListEmp(Connection conn, String escuelaId, String nombre, String paterno, String materno, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisPersonal	= new ArrayList<EmpPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE UPPER(NOMBRE) LIKE UPPER('"+nombre+"%')"
					+ " AND UPPER(APATERNO) LIKE UPPER('%"+paterno+"%')"
					+ " AND UPPER(AMATERNO) LIKE UPPER('%"+materno+"%')"
					+ " AND CODIGO_ID LIKE '"+escuelaId+"%'"
					+ " AND SUBSTR(CODIGO_ID,4,1) = 'E' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				EmpPersonal personal = new EmpPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisPersonal;
	}
	
	public ArrayList<EmpPersonal> getListEmpBusqueda(Connection conn, String escuelaId, String nombre, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisPersonal	= new ArrayList<EmpPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE UPPER(NOMBRE)||' '||UPPER(APATERNO)||' '||UPPER(AMATERNO) LIKE '%"+nombre.toUpperCase()+"%'"
					+ " AND CODIGO_ID LIKE '"+escuelaId+"%'"
					+ " AND SUBSTR(CODIGO_ID,4,1) = 'E' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				EmpPersonal personal = new EmpPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisPersonal;
	}
	
	
	public ArrayList<EmpPersonal> getListEscuela(Connection Conn, String escuela, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuela+"' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal emp = new EmpPersonal();
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisEmpleado;
	}
	
	public ArrayList<EmpPersonal> getListMaestrosCiclo(Connection conn, String escuelaId, String cicloId, String orden ) throws SQLException{
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, GENERO,"
					+ " TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO, PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND CODIGO_ID IN"
					+ "		(SELECT DISTINCT(EMPLEADO_ID) FROM CICLO_GRUPO_CURSO"
					+ "		WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"' ) "+ orden;
			rs = st.executeQuery(comando);

			while (rs.next()){				
				EmpPersonal emp = new EmpPersonal();
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getListMaestrosCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisEmpleado;
	}
	
	public ArrayList<EmpPersonal> getListMaestroxNivel(Connection conn, String escuelaId,String nivelId, String cicloId, String orden ) throws SQLException{
		ArrayList<EmpPersonal> lisEmpleado 	= new ArrayList<EmpPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, GENERO,"
					+ " TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO, PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL, TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL B WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND CODIGO_ID IN "
					+ "		( SELECT DISTINCT(EMPLEADO_ID) AS EMPLEADO_ID"
					+ "		FROM CICLO_GRUPO_CURSO A"
					+ "		WHERE EMPLEADO_ID = B.CODIGO_ID "
					+ "		AND CICLO_GRUPO_ID IN "
					+ "			(SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO "
					+ "			WHERE CICLO_GRUPO_ID =  A.CICLO_GRUPO_ID "
					+ "			AND NIVEL_ID = '"+nivelId+"' "
					+ "			AND CICLO_ID = '"+cicloId+"')) " +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				EmpPersonal emp = new EmpPersonal();				
				emp.mapeaReg(rs);
				lisEmpleado.add(emp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.emp.EmpPersonalLista|getListMaestroxNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisEmpleado;
	}
	
	
	public static ArrayList<EmpPersonal> BuscaDuplicados(Connection conn, String escuelaId, String name, String aPaterno, String aMaterno, int porc) throws SQLException{
		Statement st 		= null;
		ResultSet rs 		= null;
		ArrayList<EmpPersonal> lisTmp			= new ArrayList<EmpPersonal>();
		
		try{		
			st 		= conn.createStatement();			
			aca.empleado.EmpPersonalLista empU 	= new aca.empleado.EmpPersonalLista();
			ArrayList<EmpPersonal> lisPersonal	= new ArrayList<EmpPersonal>();	
			
			//Declaracion de Variables					
			String sNomb		= "";
			String sPat			= "";
			String sMat			= "";
			int iSuma			= 0;
			int iCont			= 0;
			int iTamanio		= 0;		
			
			//Asignacion de los parametros
			String nombre		= name.toUpperCase();
			String paterno		= aPaterno.toUpperCase();
			String materno		= aMaterno.toUpperCase();			
			int k=0, i=0/*, row= 0*/; 			
			
			if(materno.length() == 0){
				if(paterno.length() == 0){
					paterno+=" ";
				}
				lisPersonal = empU.getEmpleadoPat(conn, escuelaId, nombre, paterno, "ORDER BY NOMBRE, APATERNO, AMATERNO");
			}
				
			if(materno.length() != 0){
				lisPersonal = empU.getEmpleados(conn, escuelaId, nombre, paterno, materno, "ORDER BY NOMBRE, APATERNO, AMATERNO");
			}
			
			
			//lisPersonal = alumU.getListAll(Conn, "ORDER BY NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO");				
			//aca.alumno.AlumPersonal alumno = (aca.alumno.AlumPersonal)lisPersonal.get(row);
			
			for (k=0;k<lisPersonal.size();k++){
				
				aca.empleado.EmpPersonal alumno2 = (aca.empleado.EmpPersonal)lisPersonal.get(k);
				
				sNomb = alumno2.getNombre().toUpperCase();
				sPat = alumno2.getApaterno().toUpperCase();
				sMat = alumno2.getAmaterno().toUpperCase();
			
				iSuma = 0;						
				// Verifica la similitud del nombre
				for(i = 0; i < nombre.length() & i < sNomb.length();i++){
					if(nombre.charAt(i) == sNomb.charAt(i)){
						iSuma++;
					}
				}
				if(nombre.length() < sNomb.length())
					iTamanio = sNomb.length();
				else
					iTamanio = nombre.length();
				System.out.println("divide 1: "+iTamanio);
				if(((100*iSuma)/iTamanio)>=porc) 
					iCont++;				
				//System.out.println("Nombre:"+nombre+":"+sNomb+":"+(100*iSuma)/iTamanio);
				
				// Verifica la similitud del apellido paterno
				iSuma = 0;
				for(i = 0; i < paterno.length() & i < sPat.length();i++){
					if(paterno.charAt(i) == sPat.charAt(i)){
						iSuma++;
					}
				}
				if(paterno.length() < sPat.length())
					iTamanio = sPat.length();
				else
					iTamanio = paterno.length();
				System.out.println("divide 2: "+iTamanio);
				if(((100*iSuma)/iTamanio)>=porc)
					iCont++;				
				//System.out.println("Paterno:"+paterno+":"+sPat+":"+(100*iSuma)/iTamanio);
				
				// Verifica la similitud del apellido materno
					
				iSuma = 0;
				for(i = 0; i < materno.length() & i < sMat.length();i++){
					if(materno.charAt(i) == sMat.charAt(i)){
						iSuma++;
					}
				}
				if(materno.length() < sMat.length())
					iTamanio = sMat.length();
				else
					iTamanio = materno.length();
				System.out.println("divide 3: "+iTamanio);
				
				if(iTamanio>0 && ((100*iSuma)/iTamanio)>=porc)
					iCont++;	
				//System.out.println("Materno:"+materno+":"+sMat+":"+(100*iSuma)/iTamanio);
				
				if(iCont >= 2){
					lisTmp.add(lisPersonal.get(k));
				}
				//System.out.println(nombre+":"+paterno+":"+materno+":"+iCont);
				
				iCont = 0;
			}
			
			
			lisPersonal.remove(0);
			
			//System.out.println("Tamaño del listor:"+lisPersonal.size());				
		}catch(Exception e){
			System.out.println("Error en busca duplicados: "+e);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisTmp;
	}
	
	
	public static ArrayList<EmpPersonal> getListBusqueda(Connection conn, String escuelaId, String nombreCompleto,String orden ) throws SQLException{
		ArrayList<EmpPersonal> lisUsuarios 	= new ArrayList<EmpPersonal>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE,"
					+ " APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL, "
					+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE"
					+ " FROM EMP_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND UPPER(NOMBRE)||' '||UPPER(APATERNO)||' '||UPPER(AMATERNO) LIKE '%"+nombreCompleto.toUpperCase()+"%' "+ orden;
			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				EmpPersonal usuario = new EmpPersonal();				
				usuario.mapeaReg(rs);
				lisUsuarios.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.UsuariosLista|getListBusqueda|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisUsuarios;
	}

	
	public ArrayList<EmpPersonal> getEmpleadoPat(Connection conn, String escuelaId, String nombre, String paterno, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisPersonal	= new ArrayList<EmpPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando =	"SELECT CODIGO_ID, ESCUELA_ID, NOMBRE," +
			" APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO," +
			" PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
			+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE" +						
			" FROM EMP_PERSONAL" +
			" WHERE ESCUELA_ID = '"+escuelaId+"'"+
			" AND (UPPER(NOMBRE) LIKE '"+nombre.charAt(0)+"%'" +
			" OR UPPER(APATERNO) LIKE '"+paterno.charAt(0)+"%') "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal personal = new EmpPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getEmpleadoPat|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisPersonal;	
	}
	
	public ArrayList<EmpPersonal> getEmpleados(Connection conn, String escuelaId, String nombre, String paterno, String materno, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisPersonal	= new ArrayList<EmpPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando =	"SELECT CODIGO_ID, ESCUELA_ID, NOMBRE," +
			" APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO," +
			" PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
			+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE" +							
			" FROM EMP_PERSONAL " +
			" WHERE ESCUELA_ID = '"+escuelaId+"'" +
			" AND (UPPER(NOMBRE) LIKE '"+nombre.charAt(0)+"%'" +
			" OR UPPER(APATERNO) LIKE '"+paterno.charAt(0)+"%'" +
			" OR UPPER(AMATERNO) LIKE '"+materno.charAt(0)+"%') "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EmpPersonal personal = new EmpPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpmPersonalLista|getEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisPersonal;
	}
	
	public HashMap<String,EmpPersonal> getMap(Connection conn, String escuelaId) throws SQLException{
		
		HashMap<String,EmpPersonal> map = new HashMap<String,EmpPersonal>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		if (escuelaId.length()==1) escuelaId = "0"+escuelaId;
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE," +
			" APATERNO, AMATERNO, GENERO, TO_CHAR(F_NACIMIENTO, 'DD/MM/YYYY') AS F_NACIMIENTO," +
			" PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, ESTADO, ESTADO_CIVIL,"
			+ " TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE" +							
			" FROM EMP_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				EmpPersonal obj = new EmpPersonal();
				obj.mapeaReg(rs);
				llave = obj.getCodigoId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.EmpPersonalLista|getMap|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	 public HashMap<String,String> mapaEmpleadosPorEscuela(Connection conn, String asociacion) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT ESCUELA_ID, COUNT(CODIGO_ID) AS TOTAL" +
					" FROM EMP_PERSONAL" +
					" WHERE ESTADO = 'A' AND ASOCIACION_ESCUELA(ESCUELA_ID) = "+asociacion+ 
					" GROUP BY ESCUELA_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("ESCUELA_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|mapaEmpleadosPorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapEmpleados(Connection conn, String escuelaId, String opcion) throws SQLException{
		
		HashMap<String,String> map = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";				 
		
		if (escuelaId.length()==1) escuelaId = "0"+escuelaId;
		try{
			if (opcion.equals("NOMBRE")){
				comando = "SELECT CODIGO_ID, NOMBRE||' '||APATERNO||' '||AMATERNO AS NOMBRE FROM EMP_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"'";
			}else{
				comando = "SELECT CODIGO_ID, APATERNO||' '||AMATERNO||' '||NOMBRE AS NOMBRE FROM EMP_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"'";
			}			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put( rs.getString("CODIGO_ID"), rs.getString("NOMBRE"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|mapEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String, String> mapMaestrosCurso(Connection conn, String codigoPersonal) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";		
		
		try{
			comando = "SELECT  ASOCIACION_ESCUELA(ESCUELA_ID) AS ASOCIACION_ID, COUNT(CODIGO_ID) AS TOTAL"
					+ " FROM EMP_PERSONAL WHERE UNION_ASOCIACION(ASOCIACION_ESCUELA(ESCUELA_ID)) = "
					+ "(SELECT UNION_ASOCIACION(ASOCIACION_ESCUELA(ESCUELA_ID)) AS UNION_ID FROM EMP_PERSONAL WHERE CODIGO_ID = '"+codigoPersonal+"' "
					+ "GROUP BY UNION_ASOCIACION(ASOCIACION_ESCUELA(ESCUELA_ID))) AND ESTADO = 'A' "
					+ "AND CODIGO_ID IN (SELECT DISTINCT(EMPLEADO_ID) FROM CICLO_GRUPO_CURSO) GROUP BY ASOCIACION_ESCUELA(ESCUELA_ID)";						
					
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				map.put(rs.getString("ASOCIACION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|mapMaestrosCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return map;
	}
	
	public static HashMap<String, String> mapMaestrosCursoEscuela(Connection conn, String asociacionId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";		
		
		try{
			comando = "SELECT ESCUELA_ID, COUNT(CODIGO_ID) AS TOTAL FROM EMP_PERSONAL "
					+ "WHERE ASOCIACION_ESCUELA(ESCUELA_ID) = '"+asociacionId+"' AND ESTADO = 'A' "
					+ "AND CODIGO_ID IN (SELECT DISTINCT(EMPLEADO_ID) FROM CICLO_GRUPO_CURSO) GROUP BY ESCUELA_ID";						
					
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				map.put(rs.getString("ESCUELA_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|mapMaestrosCursoEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return map;
	}
	
	public static HashMap<String, String> mapEmpleadosPorEscuela(Connection conn, String estados, String tipos) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";		
		
		try{
			comando = " SELECT ESCUELA_ID, COUNT(CODIGO_ID) AS TOTAL FROM EMP_PERSONAL"
					+ " WHERE ESTADO IN("+estados+")"
					+ " AND SUBSTRING(CODIGO_ID,4,1) IN ("+tipos+")"
					+ " GROUP BY ESCUELA_ID";
					
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				map.put(rs.getString("ESCUELA_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|mapEmpleadosPorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return map;
	}
	
	public ArrayList<EmpPersonal> getListCumpleEmpleados(Connection conn, String escuelaId, String mes, String dia, String orden ) throws SQLException{
		
		ArrayList<EmpPersonal> lisEmpleadosPersonal		= new ArrayList<EmpPersonal>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando			= "";
		
		try{	
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, " +
					" GENERO, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, EMAIL, COLONIA, DIRECCION, TELEFONO," +
					" ESTADO, ESTADO_CIVIL, TIPO_ID, OCUPACION, RFC, SSOCIAL, PUBLICAR, IGLESIA, TIPO_SANGRE" +
					" FROM EMP_PERSONAL" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' AND ESTADO = 'A'" +
					" AND SUBSTR(TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY'),4,2)= '"+mes+"'";
			
			
			if (!dia.equals("0")){
				comando = comando + "AND SUBSTR(TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY'),1,2)= '"+dia+"' ";
			}	
			comando = comando + " "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				EmpPersonal empleado = new EmpPersonal();
				empleado.mapeaReg(rs);
				lisEmpleadosPersonal.add(empleado);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.empleado.EmpPersonalLista|getListCumpleEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisEmpleadosPersonal;
	}
	
}
