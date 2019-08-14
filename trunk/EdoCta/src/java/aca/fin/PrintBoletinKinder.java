/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aca.fin;

import edoctapanama.base.EdoCtaPanama;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import kinder.boletin.base.AreasCriterios;
import kinder.boletin.base.CalificacionesCriterios;
import kinder.boletin.base.KrdxAlumObs;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

/**
 *
 * @author Daniel
 */
public class PrintBoletinKinder extends HttpServlet {

    Connection con;

    public void conectar() {
        try {
            Class.forName("org.postgresql.Driver");
            con = (DriverManager.getConnection("jdbc:postgresql://172.16.251.25:5432/elias", "postgres", ""));
            //con = (DriverManager.getConnection("jdbc:postgresql://localhost:8432/elias", "postgres", "jete17"));

        } catch (SQLException sqle) {
            System.err.println("Error al conectar postgres centauro " + sqle);
        } catch (Exception e) {
            System.err.println("Error al usar el driver de postgres en centauro " + e);
        }
    }

    public void close() {
        try {
            con.close();
        } catch (SQLException sqle) {

        }
    }

    public String calificacionTxt(Integer calificacion) {
        String salida = "";
        if (calificacion == 1) {
            salida = "LVL";
        }

        if (calificacion == 2) {
            salida = "LEL";
        }

        if (calificacion == 3) {
            salida = "LHL";
        }
        return salida;
    }
    
    public String calificacionTxtSalvador(Integer calificacion) {
        String salida = "";
        if (calificacion == 1) {
            salida = "T";
        }

        if (calificacion == 2) {
            salida = "P";
        }

        if (calificacion == 3) {
            salida = "S";
        }
        return salida;
    }

    public Map<Long, String> getPromedioPorCriterio(Connection con, String ciclo_gpo_id,
            Integer trimestre, String alumno_id) {
        Map<Long, String> salida = new HashMap<Long, String>();
        try {
            PreparedStatement pst = con
                    .prepareStatement("select kac.criterio_id, round(sum(ev.calificacion)/count(ev.id)) promedio from kinder_evaluacion ev  "
                            + "join kinder_actividades kac on kac.id=ev.actividad_id  "
                            + "where ev.ciclo_gpo_id='" + ciclo_gpo_id + "' and ev.evaluacion_id="
                            + trimestre + " and ev.alumno_id='" + alumno_id + "' group by kac.criterio_id");
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                String calificacion = "";
                if(ciclo_gpo_id.startsWith("H")){
                    calificacion = calificacionTxt(rs.getInt("promedio"));
                }else{
                    calificacion = calificacionTxtSalvador(rs.getInt("promedio"));
                }
                
                salida.put(rs.getLong("criterio_id"), calificacion);
                System.out.println(trimestre + " " + alumno_id + " " + rs.getLong("criterio_id") + " " + calificacion);
            }
            rs.close();
            pst.close();
        } catch (SQLException sqle) {
            System.out.println("Error en getPromedioPorCriterio" + sqle);
        }
        return salida;
    }

    public Map<Integer, Map<Long, String>> mapPromedio(Connection con, String ciclo_gpo_id, String alumno_id) {
        Map<Integer, Map<Long, String>> salida = new LinkedHashMap();

        List<Integer> lsTrimestres = new ArrayList<Integer>();
        lsTrimestres.add(1);
        lsTrimestres.add(2);
        lsTrimestres.add(3);

        for (Integer t : lsTrimestres) {

            Map<Long, String> mapPromediosCriterios = new HashMap<Long, String>();

            mapPromediosCriterios.putAll(getPromedioPorCriterio(con, ciclo_gpo_id, t, alumno_id));

            salida.put(t, mapPromediosCriterios);
        }

        return salida;

    }

    public Collection boletas(String imgpath, HttpServletRequest request) {
        List<AreasCriterios> salida = new ArrayList();

        String ciclo_gpo_id = request.getParameter("ciclo_gpo_id") != null ? request.getParameter("ciclo_gpo_id") : "";
        String escuela = request.getParameter("escuela_id");
        String curso_id = request.getParameter("curso_id") != null ? request.getParameter("curso_id") : "";
        String ciclo_id = request.getParameter("ciclo_id") != null ? request.getParameter("ciclo_id") : "";
        String alumnos = request.getParameter("alumnos_id") != null ? request.getParameter("alumnos_id") : "";
        try {
            conectar();

            //--- DATOS DEL CICLO 
            String ciclo_nombre = "";
            String ciclo_escolar = "";
            String nivel_eval = "";
            
            PreparedStatement pstCiclo = con.prepareStatement("SELECT * FROM ciclo where ciclo_id='" + ciclo_id + "'");
            ResultSet rsCiclo = pstCiclo.executeQuery();
            if (rsCiclo.next()) {
                ciclo_nombre = rsCiclo.getString("ciclo_nombre");
                ciclo_escolar = rsCiclo.getString("ciclo_escolar");
                nivel_eval = rsCiclo.getString("nivel_eval");
            }
            rsCiclo.close();
            pstCiclo.close();
            
            
            String comandoPromedia = "SELECT ciclo_id, promedio_id periodo, nombre, corto, "
                    + "calculo, orden, decimales, valor, redondeo  "
                    + "FROM ciclo_promedio where ciclo_id=? order by promedio_id";

            String comandoEvalua = "SELECT ciclo_id, bloque_id periodo, bloque_nombre nombre, "
                    + "f_inicio, f_final, valor, orden, promedio_id, corto, "
                    + "decimales, redondeo, calculo  "
                    + "FROM ciclo_bloque where ciclo_id=? order by bloque_id";
            
            PreparedStatement pstPeriodos = null;
            
            
            
            if(nivel_eval.equals("P") || nivel_eval.equals("A")){
                pstPeriodos = con.prepareStatement(comandoPromedia);
            }
            
            if(nivel_eval.equals("E")){
                pstPeriodos = con.prepareStatement(comandoEvalua);
            }
            System.out.println("ciclo id " + ciclo_id);
            pstPeriodos.setString(1, ciclo_id);
            ResultSet rsPeriodos = pstPeriodos.executeQuery();
            List<Integer> lsPeriodosDB = new ArrayList();
            while(rsPeriodos.next()){
                lsPeriodosDB.add(rsPeriodos.getInt("periodo"));
            }
            
            
            Map<String,String> mapAlumFaltas = new HashMap();
            String comandoFaltas = "Select codigo_id, evaluacion_id, sum(falta) f , "
                    + "sum(tardanza) t, promedio_id from krdx_alum_falta where ciclo_grupo_id = ? "
                    + "group by codigo_id, evaluacion_id, promedio_id order by codigo_id ";
            
            PreparedStatement pstFaltas = con.prepareStatement(comandoFaltas);
            pstFaltas.setString(1, ciclo_gpo_id);
            ResultSet rsFaltas = pstFaltas.executeQuery();
            while(rsFaltas.next()){
                String per = nivel_eval.equals("E") ? rsFaltas.getString("evaluacion_id") : rsFaltas.getString("promedio_id");
                mapAlumFaltas.put(rsFaltas.getString("codigo_id") 
                        + "-" + per,
                        rsFaltas.getString("f") + "-" + rsFaltas.getString("t"));
                
                System.out.println(rsFaltas.getString("codigo_id") 
                        + "-" + per + ' ' +
                        rsFaltas.getString("f") + "-" + rsFaltas.getString("t"));
            }
            
            
            //----------DATOS DE LA CONSEJERA
            String consejera = "";
            
            Map<String,KrdxAlumObs> mapObs = new HashMap(); 
            mapObs.putAll(getObservacionesComplexKey(con, 0L, request.getParameter("ciclo_gpo_id"), "", 0));
            
            PreparedStatement pstConsejera = con.prepareStatement("select cg.empleado_id, ep.nombre || ' ' || ep.apaterno || ' ' || ep.amaterno as consejera "
                    + "from ciclo_grupo cg  "
                    + "join emp_personal ep on ep.codigo_id = cg.empleado_id "
                    + "where ciclo_grupo_id='"+ ciclo_gpo_id +"'");
            ResultSet rsConsejera = pstConsejera.executeQuery();
            if(rsConsejera.next()){
                consejera = rsConsejera.getString("consejera");
            }
            rsConsejera.close();
            pstConsejera.close();

            //----DATOS PERSONALES Y GENERALES ESTUDIANTES Y ESCUELA
            
            String comando = "";
            if (request.getParameter("codigo_id") != null && !request.getParameter("codigo_id").equals("")) {
                
                

                                comando = "SELECT distinct(kca.CODIGO_ID) , ALUM_APELLIDO(kca.CODIGO_ID),ac.nivel, ac.grado, ac.grupo "
                        + ", ap.escuela_id, ap.nombre, ap.apaterno, ap.amaterno , ap.curp , "
                        + " ce.escuela_nombre, ce.direccion, ce.telefono, ce.logo, ne.nivel_nombre, ci.ciclo_escolar, ci.ciclo_nombre, emp_nombre(ne.director) as nombre_director "
                        + " FROM KRDX_CURSO_ACT kca"
                        + " join alum_personal ap on ap.codigo_id=kca.codigo_id "
                        + " join cat_escuela ce on ce.escuela_id=ap.escuela_id "
                        + " join alum_ciclo ac on ac.codigo_id=kca.codigo_id and ac.ciclo_id='"+ciclo_id+"' "
                        + " join cat_nivel_escuela ne on ne.escuela_id=ap.escuela_id and ne.nivel_id=ac.nivel "
                        + " join ciclo ci on ci.ciclo_id='"+ciclo_id+"' "
                        + " WHERE SUBSTR(kca.CODIGO_ID,1,3) = '" + escuela + "' " + " AND kca.CICLO_GRUPO_ID = '" + ciclo_gpo_id + "' ";
                        

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
                    comando += " AND kca.CODIGO_ID IN (" + alumno + ") ";
                }
                

                comando += " ORDER BY ALUM_APELLIDO(kca.CODIGO_ID)";

            } else {

                comando = "SELECT distinct(kca.CODIGO_ID) , ALUM_APELLIDO(kca.CODIGO_ID),ac.nivel, ac.grado, ac.grupo "
                        + ", ap.escuela_id, ap.nombre, ap.apaterno, ap.amaterno , ap.curp , "
                        + " ce.escuela_nombre, ce.direccion, ce.telefono, ce.logo, ne.nivel_nombre, ci.ciclo_escolar, ci.ciclo_nombre, emp_nombre(ne.director) as nombre_director "
                        + " FROM KRDX_CURSO_ACT kca"
                        + " join alum_personal ap on ap.codigo_id=kca.codigo_id "
                        + " join cat_escuela ce on ce.escuela_id=ap.escuela_id "
                        + " join alum_ciclo ac on ac.codigo_id=kca.codigo_id and ac.ciclo_id='"+ciclo_id+"'"
                        + " join cat_nivel_escuela ne on ne.escuela_id=ap.escuela_id and ne.nivel_id=ac.nivel"
                        + " join ciclo ci on ci.ciclo_id='"+ciclo_id+"' "
                        + " WHERE SUBSTR(kca.CODIGO_ID,1,3) = '" + escuela + "' " + " AND CICLO_GRUPO_ID = '" + ciclo_gpo_id + "' "
                        + " ORDER BY ALUM_APELLIDO(kca.CODIGO_ID)";
            }
            PreparedStatement psta = con.prepareStatement(comando);

            
            //------DATOS AREAS CRITERIOS POR CICLO_ID
            
            String comandoArCri = "SELECT c.id, a.id areaid , c.id criterioid, c.ciclo_id, c.area_id, a.area, c.criterio   "
                    + "FROM kinder_criterios c "
                    + "join kinder_areas a on a.id=c.area_id  and a.estado=1"
                    + "where c.ciclo_id='" + ciclo_id + "' and c.estado=1 order by a.id, c.id ";

            List<String> lsCriteriosAreas = new ArrayList();

            PreparedStatement pstb = con.prepareStatement(comandoArCri);
            ResultSet rsb = pstb.executeQuery();
            while (rsb.next()) {
                System.out.println("****Splirt "+ rsb.getString("id")+"- -" + rsb.getString("areaid") + "\t" + rsb.getString("area") + "\t" + rsb.getString("criterioid") + "\t" + rsb.getString("criterio"));
                if(rsb.getString("criterio") != null && !rsb.getString("criterio").equals("")){
                    lsCriteriosAreas.add(rsb.getString("areaid").trim() + "\t" + rsb.getString("area").trim() + "\t" + rsb.getString("criterioid").trim() + "\t" + rsb.getString("criterio").trim());
                }
            }
            rsb.close();
            pstb.close();

            
            //System.out.println(psta);
            ResultSet rs = psta.executeQuery();
            while (rs.next()) {
                //System.out.println("entro a rspsta lsCriteriosAreas" + lsCriteriosAreas.size() );

                AreasCriterios ac = new AreasCriterios();
                ac.setArea(rs.getString("codigo_id")); 
                ac.setCiclo(rs.getString("ciclo_escolar").trim());
                ac.setCodigo_estudiante(rs.getString("curp"));
                ac.setEscuela(rs.getString("escuela_nombre"));
                ac.setLogo(imgpath  + "/" +  rs.getString("logo"));
                ac.setNivel(rs.getString("nivel_nombre"));
                ac.setNombre_estudiante(rs.getString("nombre") + " " + rs.getString("apaterno") + " " + rs.getString("amaterno"));
                ac.setNombre_consejera(consejera);
                ac.setDirector(rs.getString("nombre_director"));
                ac.setCiclo_nombre(rs.getString("ciclo_nombre"));
                ac.setDireccion(rs.getString("direccion") + " " + rs.getString("telefono") + "");
                Map<Integer, Map<Long, String>> mapPromedios = new LinkedHashMap();
                mapPromedios.putAll(mapPromedio(con, ciclo_gpo_id, ac.getArea()));

                List<CalificacionesCriterios> lscc = new ArrayList();

                List<Integer> lsPeriodos = new ArrayList();
                lsPeriodos.add(new Integer("1"));
                lsPeriodos.add(new Integer("2"));
                lsPeriodos.add(new Integer("3"));
                
                System.out.println("observaciones  " +mapObs.size());
                    if(mapObs.containsKey(ac.getArea() + "-" +1)){
                        KrdxAlumObs ob = mapObs.get(ac.getArea() + "-" +1);
                        ac.setObservacionA1(ob.getObservacion_1());
                        ac.setObservacionB1(ob.getObservacion_2());
                    }
                    
                    if(mapObs.containsKey(ac.getArea() + "-" +2)){
                        KrdxAlumObs ob = mapObs.get(ac.getArea() + "-" +2);
                        ac.setObservacionA2(ob.getObservacion_1());
                        ac.setObservacionB2(ob.getObservacion_2());
                    }
                    if(mapObs.containsKey(ac.getArea() + "-" +3)){
                        KrdxAlumObs ob = mapObs.get(ac.getArea() + "-" +3);
                        ac.setObservacionA3(ob.getObservacion_1());
                        ac.setObservacionB3(ob.getObservacion_2());
                    }
                    
                    if(mapAlumFaltas.containsKey(ac.getArea() + "-" +1)){
                        String[] ftSplit = mapAlumFaltas.get(ac.getArea() + "-" +1).split("-"); 
                        ac.setFaltaA(ftSplit[0]);
                        ac.setTardanzaA(ftSplit[1]);
                    }
                    
                    if(mapAlumFaltas.containsKey(ac.getArea() + "-" +2)){
                        String[] ftSplit = mapAlumFaltas.get(ac.getArea() + "-" +2).split("-"); 
                        ac.setFaltaB(ftSplit[0]);
                        ac.setTardanzaB(ftSplit[1]);
                    }
                    if(mapAlumFaltas.containsKey(ac.getArea() + "-" +3)){
                        String[] ftSplit = mapAlumFaltas.get(ac.getArea() + "-" +3).split("-"); 
                        ac.setFaltaC(ftSplit[0]);
                        ac.setTardanzaC(ftSplit[1]);
                    }
                    
                    
                
                for (String cri : lsCriteriosAreas) {
                    CalificacionesCriterios cc = new CalificacionesCriterios();
                    //System.out.println("CRITERIO ANTES DEL SPLIT    "+cri);
                    String[] txtSplit = cri.split("\t");
                    System.out.println("***** " +  txtSplit.length + cri);
                    //System.out.println("CRITERIO ANTES DEL SPLIT    -"+ txtSplit[0] +"- -"+ txtSplit[1] +"- -"+ txtSplit[2] +"- -"+ txtSplit[3] +"- -" );
                    cc.setArea(txtSplit[1].trim());
                    cc.setArea_id(new Long(txtSplit[0].trim()));
                    cc.setCriterio(txtSplit[3].trim()!=null ? txtSplit[3] : ""); 
                    cc.setCriterio_id(new Long(txtSplit[2].trim()));

                    if (mapPromedios.containsKey(new Integer("1"))) {
                        //System.out.println("si tiene primer trimestre");
                        if (mapPromedios.get(new Integer("1")).containsKey(cc.getCriterio_id())) {
                            System.out.println("si tiene criterio con eva 1 " + mapPromedios.get(new Integer("1")).get(cc.getCriterio_id()) + " " + cc.getCriterio_id());
                            cc.setTrimestre("1");
                            cc.setNota(mapPromedios.get(new Integer("1")).get(cc.getCriterio_id()));
                        }
                    }

                    if (mapPromedios.containsKey(new Integer("2"))) {
                        if (mapPromedios.get(new Integer("2")).containsKey(cc.getCriterio_id())) {
                            System.out.println("si tiene criterio con eva 2 " + mapPromedios.get(new Integer("2")).get(cc.getCriterio_id()) + " " + cc.getCriterio_id());
                            cc.setTrimestre("2");
                            cc.setNotaB(mapPromedios.get(new Integer("2")).get(cc.getCriterio_id()));
                        }
                    }

                    if (mapPromedios.containsKey(new Integer("3"))) {
                        if (mapPromedios.get(new Integer("3")).containsKey(cc.getCriterio_id())) {
                            System.out.println("si tiene criterio con eva 3 " + mapPromedios.get(new Integer("3")).get(cc.getCriterio_id()) + " " + cc.getCriterio_id());
                            cc.setTrimestre("3");
                            cc.setNotaC(mapPromedios.get(new Integer("3")).get(cc.getCriterio_id()));
                        }
                    }

                    System.out.println("SE INGRESA A LA BOLETA " + cc.toString());
                    lscc.add(cc);
                }
                 System.out.println(ac.toString());
                ac.setLsCal(lscc);
                salida.add(ac);
            }
            rs.close();
            psta.close();
            close();
        } catch (SQLException sqle) {
            System.err.println("Error en la consulta e datos " + sqle);
        }
        //System.out.println(salida.size());
        return salida;
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //response.setContentType("text/html;charset=UTF-8");

        /* TODO output your page here. You may use following sample code. */
        //response.setContentType("text/html;charset=UTF-8");
        ServletContext context = this.getServletConfig().getServletContext();
        response.setContentType("application/pdf");
        Collection<EdoCtaPanama> dataSource = boletas(context.getRealPath("/imagenes/logos"), request);
        //CreaReporte.dsEdoctaB(context.getRealPath("/imagenes/logos"));
        Locale locale = new Locale("es", "MX");
        
        String reportPath = "";
        
        if(request.getParameter("ciclo_id").startsWith("S")){
            reportPath = "/WEB-INF/jsperFiles/boletin_salvador_encabezado.jasper";
        }else{
            reportPath = "/WEB-INF/jsperFiles/boletin_panama_encabezado.jasper";
        }

        File reportFile = new File(context.getRealPath(reportPath));
        Map parameters = new HashMap();
        parameters.put(JRParameter.REPORT_LOCALE, locale);
        JasperPrint jp = null;
        byte[] bytes = null;
        try {

            bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameters, new JRBeanCollectionDataSource(dataSource));

        } catch (JRException jreException) {
            System.err.println(jreException);
        }
        try {

            response.setHeader("Content-Disposition", "filename=\"boletin.pdf" + "\"");
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);

            response.getOutputStream().write(bytes, 0, bytes.length);
            response.getOutputStream().flush();
            response.getOutputStream().close();
            //out.close();
            //out=PageContext.pushBody();
            return;
        } catch (IOException e) {
            System.err.println("error al generar pdf" + e);
        }

    }
    
    /**
	 * @param id Long para condicion con el id o 0L
	 * @param ciclo_gpo_id String para condicion con ciclo_gpo_id o ""
	 * @param codigo_id String para condicion con codigo_id o ""
	 * @param ubicador Integer para condicion ubicador o 0
	 * @return mapa con la llave id y objeto KrdxAlumObs
	 */
	public Map<Long, KrdxAlumObs>  getObservaciones(Connection conn, Long id, String ciclo_gpo_id, String codigo_id, Integer ubicador){
		
		Map<Long, KrdxAlumObs> salida = new HashMap(); 
		
		
		String comando = "select * from krdx_alum_obs where id is not null ";
		
		if(!id.equals(0L)){
			comando+=" and id="+id;
		}
		if(!ciclo_gpo_id.equals("")){
			comando+=" and ciclo_grupo_id='"+ciclo_gpo_id+"' ";
		}
		if(!codigo_id.equals("")){
			comando+=" and codigo_id='"+codigo_id+"' ";
		}
		if(!ubicador.equals(0)){
			comando+=" and ubicador="+ubicador ;
		}
		
		try{
			System.out.println("Enrra al metodo ..."+ comando);
			PreparedStatement pst = conn.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			
			while(rs.next()){
				KrdxAlumObs ob = new KrdxAlumObs(rs.getLong("id"), 
						rs.getString("ciclo_grupo_id"), 
						rs.getString("codigo_id"), 
						rs.getInt("ubicador"), 
						rs.getString("observacion_1"), rs.getString("observacion_2"));
				
				salida.put(ob.getId(), ob);
                                System.out.println("Enrra al metodo ..."+ob.toString());
				
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilKrdxAlumObs getObservaciones " + sqle);
		}
		return salida;
	}
	
	
	public Map<String, KrdxAlumObs>  getObservacionesComplexKey(Connection conn, Long id, String ciclo_gpo_id, String codigo_id, Integer ubicador){
		Map<String, KrdxAlumObs> salida = new HashMap(); 
		
		Map<Long, KrdxAlumObs> input = new HashMap<Long, KrdxAlumObs>();
		input.putAll(getObservaciones(conn, id, ciclo_gpo_id, codigo_id, ubicador));
		
		for(Long key : input.keySet()){
			salida.put(input.get(key).getCodigo_id()+"-"+input.get(key).getUbicador(),input.get(key));
		}
		System.out.println("ENTRO Y SALIO " + salida.size());
		return salida;
	}

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
