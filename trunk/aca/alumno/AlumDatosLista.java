package aca.alumno;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class AlumDatosLista {
	public ArrayList<AlumDatos> getListAll(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<AlumDatos> lisModulo 	= new ArrayList<AlumDatos>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, ESCUELA_ID, NOMBRE_TUTOR, PARENTESCO, DIRECCION, " +
					  " TELEFONO, EMAIL, ESTUDIO, ESCUELA_ANT, FAX, NOMBRE_PADRE, VIVE_PADRE, RELIGION_PADRE,  " +
					  " DIR_PADRE, TEL_PADRE, TELTRABAJO_PADRE,CEL_PADRE, NOMBRE_MADRE, VIVE_MADRE, RELIGION_MADRE, " +
					  " DIR_MADRE, TEL_MADRE, TELTRABAJO_MADRE, CEL_MADRE, ESTADO_CIVIL, HERMANOS,PREESCOLAR, PRIMARIA, SECUNDARIA " +
					  " FROM ALUM_DATOS " +
					  " WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumDatos alumno = new AlumDatos();
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
}
