// Clase para la tabla de AlumPersonal
package aca.alumno;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class AlumPersonalLista{
		
	public ArrayList<AlumPersonal> getListAll(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lista 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, "
					+ " GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO,"
					+ " NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"
					+ " CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"
					+ " TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"
					+ " FROM ALUM_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lista.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lista;
	}
	
	public ArrayList<AlumPersonal> getListAllNombres(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, NOMBRE, AMATERNO, APATERNO FROM ALUM_PERSONAL"
					+ " WHERE SUBSTR(CODIGO_ID, 0, 4) = '"+escuelaId+"' "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaRegNombres(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAllNombres|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	
	public Map<String,AlumPersonal> getLsAlumEscuela(Connection Conn, String escuelaId)throws SQLException{
		Map<String,AlumPersonal> salida = new HashMap<String, AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO," +
					" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID, NIVEL_ID, GRADO, GRUPO,  " +
					" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
					" ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, CELULAR, TUTOR, MATRICULA,"+
					" DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA, TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO" +
					" FROM ALUM_PERSONAL " +
					" WHERE ESCUELA_ID = '"+escuelaId+"'";
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				salida.put(alumno.getCodigoId(),alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		return salida;
	}
	
	public ArrayList<AlumPersonal> getListAlumnosInscritos(Connection Conn, String escuelaId, String cicloId,String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO," +
					" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
					" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
					" ALUM_NIVEL_HISTORICO(CODIGO_ID, '"+cicloId+"', 1 ) AS NIVEL_ID, " +
					" ALUM_GRADO_HISTORICO( CODIGO_ID, '"+cicloId+"', 1 ) AS GRADO, " +
					" ALUM_GRUPO_HISTORICO( CODIGO_ID, '"+cicloId+"', 1 ) AS GRUPO, " +
					" ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, CELULAR, TUTOR, MATRICULA,"+
					" DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA, TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO" +
					" FROM ALUM_PERSONAL " +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +			
					" AND CODIGO_ID IN " +
					"	(SELECT CODIGO_ID FROM ALUM_CICLO" +
						" WHERE CICLO_ID = '"+cicloId+"' " +													
						" AND ESTADO = 'I') " +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<String> getListAlumnosInscritosReligion(Connection Conn, String escuelaId, String cicloId) throws SQLException{
		
		ArrayList<String> lisModulo 	= new ArrayList<String>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT COUNT(RELIGION) AS TOTAL, RELIGION "+
					" FROM ALUM_PERSONAL  WHERE ESCUELA_ID = '"+escuelaId+"'" +			
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID = '"+cicloId+"' AND ESTADO = 'I')"+
					" GROUP BY RELIGION ORDER BY RELIGION";
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				lisModulo.add(rs.getString("TOTAL")+"@@"+rs.getString("RELIGION"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosInscritosReligion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<String> getListInscritosReligionDivision(Connection Conn,String escuelas) throws SQLException{
		
		ArrayList<String> lisModulo 	= new ArrayList<String>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT COUNT(RELIGION) AS TOTAL, RELIGION "+
					" FROM ALUM_PERSONAL WHERE ESCUELA_ID IN ("+escuelas+") AND CODIGO_ID IN(SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL))"+
					" GROUP BY RELIGION ORDER BY RELIGION";
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				lisModulo.add(rs.getString("TOTAL")+"@@"+rs.getString("RELIGION"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListInscritosReligionDivision|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getListAlumnosInscritosNivel(Connection Conn, String escuelaId, String cicloId, String nivelId, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO," +
					" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
					" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
					" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"+
					" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA," +
					" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"+
					" FROM ALUM_PERSONAL " +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +			
					" AND CODIGO_ID IN " +
					"	(SELECT CODIGO_ID FROM ALUM_CICLO" +
						" WHERE CICLO_ID = '"+cicloId+"'" +													
						" AND ESTADO = 'I') AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99')" +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosInscritosNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getListTotalAlumnosInscritosNivel(Connection Conn, String escuelaId, String cicloId, String nivelId, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO," +
					" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
					" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
					" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, "+
					" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA," +
					" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO "+
					" FROM ALUM_PERSONAL " +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +			
					" AND CODIGO_ID IN " +
					"	(SELECT CODIGO_ID FROM ALUM_CICLO" +
						" WHERE CICLO_ID IN ("+cicloId+") " +
						" AND ESTADO = 'I') AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99')" +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListTotalAlumnosInscritosNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getListAlumnosInscritosNivelAll(Connection Conn, String fecha, String escuelas, String nivelId, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT * " +
					" FROM ALUM_PERSONAL " +
					" WHERE " +
						" ESCUELA_ID IN ("+escuelas+") " +
						" AND CODIGO_ID IN " +
							" (SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' " +
							" AND CICLO_ID IN " +
								"(SELECT CICLO_ID FROM CICLO WHERE TO_DATE('"+fecha+"' , 'DD/MM/YYYY') BETWEEN F_INICIAL AND F_FINAL)" +
							" ) " +
						"AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99')" +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosInscritosNivelAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getListAlumnosInscritosNivelGrado(Connection Conn, String escuelaId, String cicloId, String nivelId, String grado, String genero, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO," +
					" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
					" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
					" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"+
					" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA," +
					" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"+
					" FROM ALUM_PERSONAL " +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +			
					" AND CODIGO_ID IN " +
					"	(SELECT CODIGO_ID FROM ALUM_CICLO" +
						" WHERE CICLO_ID = '"+cicloId+"'" +													
						" AND ESTADO = 'I') AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') AND GENERO IN ("+genero+") " +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getArrayList(Connection conn, String escuelaId, String nombre, String paterno, String materno, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisPersonal	= new ArrayList<AlumPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, " +
			" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO, " +
			" PAIS_ID, ESTADO_ID, CIUDAD_ID, " +
			" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO, " +
			" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, "+
			" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA," +
			" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"+
			" FROM ALUM_PERSONAL "+
			" WHERE UPPER(NOMBRE) LIKE UPPER('%"+nombre+"%') "+
			" AND UPPER(APATERNO) LIKE UPPER('%"+paterno+"%') "+
			" AND UPPER(AMATERNO) LIKE UPPER('%"+materno+"%')" +
			" AND CODIGO_ID LIKE '"+escuelaId+"%' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				AlumPersonal personal = new AlumPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);				
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisPersonal;
	}
	
	public ArrayList<AlumPersonal> getListEscuela(Connection Conn, int escuela, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, "
					+ " GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO,"
					+ " NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"
					+ " CELULAR, TUTOR, MATRICULA,DISCAPACIDAD,ENFERMEDAD, CORREO, IGLESIA,"
					+ " TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"
					+ " FROM ALUM_PERSONAL "
					+ " WHERE ESCUELA_ID = "+escuela+" "+orden;		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getListNivel(Connection Conn, int escuela, int nivel, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,"
					+ " GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO,"
					+ " NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, "
					+ " CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"
					+ " TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"
					+ " FROM ALUM_PERSONAL"
					+ " WHERE ESCUELA_ID = "+escuela+" "
					+ " NIVEL_ID = TO_NUMBER('"+nivel+"', '99') "+orden;		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getListGrupo(Connection Conn, int escuela, int nivel, String grupo, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,"
					+ " GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, "
					+ " CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO,"
					+ " NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"
					+ " CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"
					+ " TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"
					+ " FROM ALUM_PERSONAL "
					+ " WHERE ESCUELA_ID = "+escuela
					+ " AND NIVEL_ID = TO_NUMBER('"+nivel+"', '99')"
					+ " AND GRUPO = TO_NUMBER('"+grupo+"', '99') "+orden;		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<AlumPersonal> getListCumple(Connection conn, int escuelaId, String cicloId, String mes, String dia, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisAlumPersonal		= new ArrayList<AlumPersonal>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando			= "";
		
		try{
			
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,"
					+ " GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO,"
					+ " NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"
					+ " CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"
					+ " TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"
					+ " FROM ALUM_PERSONAL"
					+ " WHERE ESCUELA_ID = "+escuelaId
					+ " AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND ESTADO = 'I')"
					+ " AND SUBSTR(TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY'),4,2)= '"+mes+"'";				
			if (!dia.equals("0")){
				comando = comando + "AND SUBSTR(TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY'),1,2)= '"+dia+"' ";
			}	
			comando = comando + " "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisAlumPersonal.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListCumple|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisAlumPersonal;
	}
	
	public ArrayList<AlumPersonal> getListCumpleTodosInscritos(Connection conn, String escuelaId, String mes, String dia, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisAlumPersonal		= new ArrayList<AlumPersonal>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando			= "";
		
		try{
			
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, " +
				" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
				" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
				" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
				" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, "+
				" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA," +
				" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"+
				" FROM ALUM_PERSONAL" +
				" WHERE ESCUELA_ID = '"+escuelaId+"'"+
				" AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
					" WHERE CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE 'now'::text::date >= ciclo.f_inicial AND 'now'::text::date <= ciclo.f_final)" +
					" AND ESTADO = 'I')"+
				"AND SUBSTR(TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY'),4,2)= '"+mes+"' ";
			if (!dia.equals("0")){
				comando = comando + "AND SUBSTR(TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY'),1,2)= '"+dia+"' ";
			}	
			comando = comando + " "+orden;
			//System.out.println(comando);
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisAlumPersonal.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListCumple|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisAlumPersonal;
	}
	
	public ArrayList<AlumPersonal> getListAlumnosGrado(Connection Conn, String escuelaId, String cicloId, String periodoId, String nivelId, String grado, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT P.CODIGO_ID, P.ESCUELA_ID, P.NOMBRE, P.APATERNO, P.AMATERNO, P.GENERO, P.CURP,"+
					" TO_CHAR(P.F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO, P.NIVEL_ID,"+
					" P.PAIS_ID, P.ESTADO_ID, P.CIUDAD_ID, P.EMAIL, P.COLONIA, P.DIRECCION, P.TELEFONO, P.COTEJADO,"+
					" P.ACTA, P.CRIP, P.RELIGION, P.TRANSPORTE, P.CELULAR, P.TUTOR, P.MATRICULA, P.DISCAPACIDAD,"+
					" P.ENFERMEDAD, P.CORREO, P.IGLESIA, P.TIPO_SANGRE, P.TUTOR_CEDULA, P.BARRIO_ID, P.URL_PAGO,"+
					" P.ESTADO AS ESTADO, C.CLASFIN_ID AS CLASFIN_ID, C.NIVEL, C.GRADO AS GRADO, C.GRUPO AS GRUPO"+
					" FROM ALUM_PERSONAL AS P JOIN ALUM_CICLO AS C ON P.CODIGO_ID = C.CODIGO_ID"+
					" WHERE P.ESCUELA_ID = '"+escuelaId+"' AND C.CICLO_ID = '"+cicloId+"'"+	
					" AND C.NIVEL = TO_NUMBER('"+nivelId+"', '99') AND C.GRADO = TO_NUMBER('"+grado+"', '99')"+	
					" AND C.ESTADO = 'I' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
		
	public ArrayList<AlumPersonal> getListAlumnosGradoTodos(Connection Conn, String escuelaId, String nivelId, String grado, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO," +
					" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
					" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
					" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
					" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"+
					" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA, " +
					" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"+
					" FROM ALUM_PERSONAL " +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAlumnosGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public ArrayList<String> getListGrupos(Connection conn, String nivelId, String grado) throws SQLException{
		
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		ArrayList<String> lisGrupos	= new ArrayList<String>();
		
		try{
			comando = "SELECT DISTINCT(GRUPO) FROM ALUM_PERSONAL " +
					"WHERE NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') AND GRADO = TO_NUMBER('"+grado+"', '99') ORDER BY GRUPO";
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				lisGrupos.add(rs.getString("GRUPO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListGrupos|:"+ex);
		}finally{		
			if (rs!=null) rs.close();
			if (st!=null) st.close();		
		}
		return lisGrupos;
	}
	
	public ArrayList<AlumPersonal> getListPromover(Connection Conn, String escuela, String ciclo, String planId, String grado, String grupo,String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisPro 	= new ArrayList<AlumPersonal>();
		Statement st 					= Conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{
			comando = "SELECT * FROM ALUM_PERSONAL "+ 
					"WHERE GRADO = TO_NUMBER('"+grado+"', '99') AND GRUPO = '"+grupo+"' AND ESCUELA_ID = '"+escuela+"' "+
					"AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_PLAN WHERE PLAN_ID = '"+planId+"' AND ESTADO = '1') "+
					"AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID = '"+ciclo+"' AND ESTADO = 'I')"+orden;		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisPro.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListPromover|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisPro;
	}
	
	public ArrayList<String> getListEdades(Connection conn, String cicloId) throws SQLException{
		
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		ArrayList<String> list	= new ArrayList<String>();
		
		try{
			comando = "SELECT TO_NUMBER(ALUM_EDAD(CODIGO_ID), '999999') AS EDAD FROM ALUM_PERSONAL " +
					"WHERE CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO" +
															" WHERE CICLO_ID = '"+cicloId+"'" +
															" AND ESTADO = 'I') ORDER BY EDAD ASC" ;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				list.add(rs.getString("EDAD"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListEdades|:"+ex);
		}finally{		
			if (rs!=null) rs.close();
			if (st!=null) st.close();		
		}
		return list;
	}
	
	public ArrayList<String> getListEdadesEscuela(Connection conn, String escuelas) throws SQLException{
		
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		ArrayList<String> list	= new ArrayList<String>();
		
		try{
			comando = "SELECT TO_NUMBER(ALUM_EDAD(CODIGO_ID), '9999') AS EDAD FROM ALUM_PERSONAL " +
					"WHERE ESCUELA_ID IN ("+escuelas+") AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO WHERE ESTADO='I' AND CICLO_ID IN (SELECT CICLO_ID FROM CICLO WHERE NOW() BETWEEN F_INICIAL AND F_FINAL)) ORDER BY EDAD ASC" ;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				list.add(rs.getString("EDAD"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListEdades|:"+ex);
		}finally{		
			if (rs!=null) rs.close();
			if (st!=null) st.close();		
		}
		return list;
	}
	
	public ArrayList<AlumPersonal> getAlumnosPat(Connection conn, String escuelaId, String nombre, String paterno, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisPersonal	= new ArrayList<AlumPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando =	"SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, TIPO_SANGRE, TUTOR_CEDULA, " +
			" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
			" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
			" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
			" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"+
			" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"+
			" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"+
			" FROM ALUM_PERSONAL " +
			" WHERE ESCUELA_ID = '"+escuelaId+"' AND ( UPPER(NOMBRE) LIKE '"+nombre.charAt(0)+"%' OR UPPER(APATERNO) LIKE '"+paterno.charAt(0)+"%') "+orden;	
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal personal = new AlumPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getAlumnosPat|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisPersonal;	
	}
	
	
	public ArrayList<AlumPersonal> getAlumnos(Connection conn, String escuelaId, String nombre, String paterno, String materno, String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisPersonal	= new ArrayList<AlumPersonal>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";

		try{
			comando =	"SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO," +
			" GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO," +
			" PAIS_ID, ESTADO_ID, CIUDAD_ID," +
			" CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO," +
			" NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"+
			" CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"+
			" TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"+
			" FROM ALUM_PERSONAL " +
			" WHERE ESCUELA_ID = '"+escuelaId+"' AND (UPPER(NOMBRE) LIKE '"+nombre.charAt(0)+"%' OR UPPER(APATERNO) LIKE '"+paterno.charAt(0)+"%' OR UPPER(AMATERNO) LIKE '"+materno.charAt(0)+"%') "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal personal = new AlumPersonal();
				personal.mapeaReg(rs);
				lisPersonal.add(personal);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getAlumnos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisPersonal;
	}
		
	
	public static ArrayList<AlumPersonal> BuscaDuplicados(Connection conn, String escuelaId, String name, String aPaterno, String aMaterno, int porc) throws SQLException{
		Statement st 		= null;
		ResultSet rs 		= null;
		ArrayList<AlumPersonal> lisTmp			= new ArrayList<AlumPersonal>();
		
		try{		
			st 		= conn.createStatement();			
			aca.alumno.AlumPersonalLista alumU 	= new aca.alumno.AlumPersonalLista();
			ArrayList<AlumPersonal> lisPersonal	= new ArrayList<AlumPersonal>();	
			
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
				lisPersonal = alumU.getAlumnosPat(conn, escuelaId, nombre, paterno, "ORDER BY NOMBRE, APATERNO, AMATERNO");
			}
				
			if(materno.length() != 0){
				lisPersonal = alumU.getAlumnos(conn, escuelaId, nombre, paterno, materno, "ORDER BY NOMBRE, APATERNO, AMATERNO");				
			}
										
			for (k=1;k<lisPersonal.size();k++){
				aca.alumno.AlumPersonal alumno2 = (aca.alumno.AlumPersonal)lisPersonal.get(k);
				
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
				if(((100*iSuma)/iTamanio)>=porc)
					iCont++;
					
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
				if(((100*iSuma)/iTamanio)>=porc)
					iCont++;
				
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
				if(((100*iSuma)/iTamanio)>=porc)
					iCont++;	
				
				if(iCont >= 2){
					lisTmp.add(lisPersonal.get(k));
				}
				
				iCont = 0;
			}
			
			if (lisPersonal.size()>0){
				lisPersonal.remove(0);
			}			
			//System.out.println("Tamaño del listor:"+lisPersonal.size());				
		}catch(Exception e){
			System.out.println("Error en busca duplicados: "+e);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisTmp;
	}
	
	public ArrayList<AlumPersonal> getListNombre(Connection Conn, String escuelaId, String nombreCompleto,String orden ) throws SQLException{
		
		ArrayList<AlumPersonal> lisModulo 	= new ArrayList<AlumPersonal>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,"
					+ " GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO,"
					+ " NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, CELULAR,"
					+ " TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"
					+ " FROM ALUM_PERSONAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND UPPER(NOMBRE)||' '||UPPER(APATERNO)||' '||UPPER(AMATERNO) LIKE '%"+nombreCompleto.toUpperCase()+"%' "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				lisModulo.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	public HashMap<String,String> mapaAlumnosPorEscuela(Connection conn, String asociacion) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT ESCUELA_ID, COUNT(CODIGO_ID) AS TOTAL" +
					" FROM ALUM_PERSONAL" +
					" WHERE ASOCIACION_ESCUELA(ESCUELA_ID) = "+asociacion+
					" GROUP BY ESCUELA_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("ESCUELA_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|mapaAlumnosPorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapNombreCorto(Connection conn,  String escuelaId, String cicloId,String Opcion) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			if ( Opcion.equals("NOMBRE")){
				comando = "SELECT CODIGO_ID, SPLIT_PART(NOMBRE, ' ', 1)||' '|| APATERNO AS NOMBRE "+
					"FROM ALUM_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"' "+
					" AND CODIGO_ID IN (SELECT CODIGO_ID FROM FIN_CALCULO WHERE CICLO_ID = '"+cicloId+"')";
			}else{
				comando = "SELECT CODIGO_ID, APATERNO||' '||SPLIT_PART(NOMBRE, ' ', 1) AS NOMBRE "+
					"FROM ALUM_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"' "+
					"AND CODIGO_ID IN (SELECT CODIGO_ID FROM FIN_CALCULO WHERE CICLO_ID = '"+cicloId+"')";
			}	
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("CODIGO_ID"), rs.getString("NOMBRE"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonal|mapaAlumnosPorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String, AlumPersonal> mapAlumnosAsociacion(Connection conn, String asociaciones) throws SQLException{
		HashMap<String, AlumPersonal> map 	= new HashMap<String, AlumPersonal>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{			
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO,"
					+ " GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID,"
					+ " CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO,"
					+ " NIVEL_ID, GRADO, GRUPO, ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE,"
					+ " CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA,"
					+ " TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID, URL_PAGO"
					+ " FROM ALUM_PERSONAL"
					+ " WHERE CODIGO_ID IN"
					+ " (SELECT AUXILIAR FROM FIN_MOVIMIENTOS"
					+ "  WHERE ESTADO IN ('R')"
					+ "  AND (SELECT ESTADO FROM FIN_POLIZA WHERE POLIZA_ID = FIN_MOVIMIENTOS.POLIZA_ID"
					+ " 	AND EJERCICIO_ID = FIN_MOVIMIENTOS.EJERCICIO_ID) = 'T'"
					+ "  AND ASOCIACION_ESCUELA(SUBSTR(POLIZA_ID, 1, 3)) IN ("+asociaciones+") "
					+ " )";
			
			rs = st.executeQuery(comando);
			
			while (rs.next()){
				AlumPersonal obj = new AlumPersonal();
				obj.mapeaReg(rs);
				map.put(obj.getCodigoId(), obj);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|mapAlumnosAsociacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return map;
	}
	
	public static HashMap<String, AlumPersonal> getMapHistoria(Connection conn, String ciclo ) throws SQLException{
		
		HashMap<String, AlumPersonal> map = new HashMap<String,AlumPersonal>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT * FROM ALUM_PERSONAL" +
					" WHERE CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO WHERE CICLO_ID = '"+ciclo+"')";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumPersonal personal = new AlumPersonal();
				personal.mapeaReg(rs);
				llave = personal.getCodigoId();
				map.put(llave, personal);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapNombreLargo(Connection conn,String escuelaId, String Opcion) throws SQLException{
			
			HashMap<String,String> map 	= new HashMap<String,String>();
			Statement st 					= conn.createStatement();
			ResultSet rs 					= null;
			String comando					= "";
			
			try{
				if ( Opcion.equals("NOMBRE")){
					comando = "SELECT NOMBRE||' '||APATERNO||' '||AMATERNO AS NOMBRE, CODIGO_ID "+
						"FROM ALUM_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"'";
				}else{
					comando = "SELECT APATERNO||' '||AMATERNO||' '||NOMBRE AS NOMBRE, CODIGO_ID "+
						"FROM ALUM_PERSONAL WHERE ESCUELA_ID = '"+escuelaId+"'";
				}	
				rs = st.executeQuery(comando);
				
				while (rs.next()){				
					map.put(rs.getString("CODIGO_ID"), rs.getString("NOMBRE"));
				}
				
			}catch(Exception ex){
				System.out.println("Error - aca.alumno.AlumPersonalLista|mapaNombreLargo|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (st!=null) st.close();
			}
			
			return map;
		}
	
}

