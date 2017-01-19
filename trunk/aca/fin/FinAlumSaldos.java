package aca.fin;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

public class FinAlumSaldos {

	
	public List<FinEdoCtaReporte> saldoAlumno(Connection con, HttpServletRequest request){
		List<FinEdoCtaReporte> salida = new ArrayList(); 
		Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

        String fini = request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "01-01-" + cal.get(Calendar.YEAR);
        String ffin = request.getParameter("fechaFinal") != null ? request.getParameter("fechaFinal") : sdf.format(cal.getTime());
        //String escuela = request.getParameter("escuelaid");
        String ciclo = request.getParameter("ciclo_id") != null ? request.getParameter("ciclo_id") : "";
        //String mensaje = request.getParameter("mensaje") != null ? request.getParameter("mensaje") : "";
		
        
        try {
        	
        	 String comando = "";
             if (request.getParameter("codigo_id") != null && !request.getParameter("codigo_id").equals("")) {

                 comando = "select ap.codigo_id, ap.nivel_id as nivel, "
                         + "'-' as grado , '-' as grupo, ap.escuela_id, "
                         + "ap.nombre, ap.apaterno, ap.amaterno ,ce.escuela_nombre, "
                         + "ce.logo, ne.nivel_nombre "
                         + "from alum_personal ap "
                         + "join cat_escuela ce on ce.escuela_id=ap.escuela_id "
                         + "join cat_nivel_escuela ne on ne.escuela_id=ap.escuela_id and ne.nivel_id=ap.nivel_id "
                         + "where codigo_id  is not null ";
                 
                 String alumno = "";
                 if (!Arrays.asList(request.getParameterValues("codigo_id")).isEmpty()) {
                     String[] arrAlumnos = request.getParameterValues("codigo_id");
                     String al = "";
                     for (int i = 0; i < arrAlumnos.length; i++) {
                         if (i < (arrAlumnos.length - 1)) {
                             al += "'" + arrAlumnos[i].trim() + "',";
                         }
                         if (i == (arrAlumnos.length - 1)) {
                             al += "'" + arrAlumnos[i].trim() + "'";
                         }
                     }
                     alumno = al;
                 }
                 comando += " AND ap.CODIGO_ID IN (" + alumno + ") ";

             } else {

                 comando = "SELECT "
                         + " ac.codigo_id, ac.nivel, ac.grado, ac.grupo "
                         + ", ap.escuela_id, ap.nombre, ap.apaterno, ap.amaterno , "
                         + " ce.escuela_nombre, ce.logo, ne.nivel_nombre "
                         + " from alum_ciclo ac"
                         + " join alum_personal ap on ap.codigo_id=ac.codigo_id "
                         + " join cat_escuela ce on ce.escuela_id=ap.escuela_id "
                         + " join cat_nivel_escuela ne on ne.escuela_id=ap.escuela_id and ne.nivel_id=ac.nivel"
                         + " where "
                         + " ac.codigo_id is not null ";
                 
                 comando += " and ac.ciclo_id='"+ ciclo +"' ";

                 if (request.getParameter("nivel_id") != null && !request.getParameter("nivel_id").equals("")) {

                     comando += "  AND ac.nivel=" + request.getParameter("nivel_id") + " ";

                     if (request.getParameter("grado_id") != null && !request.getParameter("grado_id").equals("")) {

                         comando += " AND ac.grado=" + request.getParameter("grado_id") + " ";

                         if (request.getParameter("grupo_id") != null && !request.getParameter("grupo_id").equals("")) {

                             comando += " AND ac.grupo='" + request.getParameter("grupo_id") + "' ";

                         }
                     }
                 }
             }
             comando += " order by nivel,grado,grupo,codigo_id ";

             System.out.println(" ======= " + comando);

             PreparedStatement psta = con.prepareStatement(comando);

             PreparedStatement pstb = con.prepareStatement("SELECT COALESCE(SUM(IMPORTE * CASE NATURALEZA WHEN 'C' THEN -1 ELSE 1 END),0) AS SALDO "
                     + "            		 FROM FIN_MOVIMIENTOS WHERE AUXILIAR = ? AND FECHA <= TO_DATE(?,'DD-MM-YYYY') and estado<>'C'");
             
             ResultSet rsa = psta.executeQuery();
             while (rsa.next()) {
                 FinEdoCtaReporte ep = new FinEdoCtaReporte();
                 ep.setCodigoid(rsa.getString("codigo_id"));
                 ep.setNivelgradogrupo(rsa.getString("nivel_nombre") + " " + rsa.getString("grado") + " " + rsa.getString("grupo"));
                 ep.setNombre(rsa.getString("nombre").trim().toUpperCase() + " " + rsa.getString("apaterno").trim().toUpperCase() + " " + rsa.getString("amaterno").trim().toUpperCase());
                 
                 pstb.setString(1, ep.getCodigoid());
                 pstb.setString(2, ffin);
                 
                 ResultSet rsb = pstb.executeQuery();
                 if(rsb.next()){
                	 ep.setSaldo(rsb.getBigDecimal("saldo")!=null ? rsb.getBigDecimal("saldo") : BigDecimal.ZERO);
                 }
                 rsb.close();
                 
                 salida.add(ep);
                 
             }
             rsa.close();
             pstb.close();
             psta.close();

        }catch(SQLException sqle){
        	System.err.println("Error en saldoAlumno " + sqle);
        }
		return salida;
	}
	
}