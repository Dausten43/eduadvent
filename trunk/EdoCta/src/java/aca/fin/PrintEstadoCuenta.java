/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aca.fin;

import edoctapanama.base.EdoCtaPanama;
import edoctapanama.base.Movimientos;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

/**
 *
 * @author Daniel
 */
public class PrintEstadoCuenta extends HttpServlet {

    Connection con;

    public void conectar() {
        try {
            Class.forName("org.postgresql.Driver");
            con = (DriverManager.getConnection("jdbc:postgresql://172.16.251.25:5432/elias", "postgres", ""));

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

    public Collection datos(String imgpath, HttpServletRequest request) {
        List<EdoCtaPanama> salida = new ArrayList();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

        String fini = request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "01-01-" + cal.get(Calendar.YEAR);
        String ffin = request.getParameter("fechaFinal") != null ? request.getParameter("fechaFinal") : sdf.format(cal.getTime());
        String escuela = request.getParameter("escuela_id");
        String ciclo = request.getParameter("ciclo_id") != null ? request.getParameter("ciclo_id") : "";
        String mensaje = request.getParameter("mensaje") != null ? request.getParameter("mensaje") : "";

        try {
            conectar();

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

                if (!ciclo.equals("")) {
                    comando += " and ac.ciclo_id='" + ciclo + "'  ";
                    if (request.getParameter("nivel_id") != null && !request.getParameter("nivel_id").equals("")) {

                        comando += " AND ac.nivel=" + request.getParameter("nivel_id") + " ";

                        if (request.getParameter("grado_id") != null && !request.getParameter("grado_id").equals("")) {

                            comando += " AND ac.grado=" + request.getParameter("grado_id") + " ";

                            if (request.getParameter("grupo_id") != null && !request.getParameter("grupo_id").equals("")) {

                                comando += " AND ac.grupo='" + request.getParameter("grupo_id") + "' ";

                            }
                        }
                    }
                } else {
                    comando = "select ap.codigo_id, ap.nivel_id as nivel, "
                            + "'-' as grado , '-' as grupo, ap.escuela_id, "
                            + "ap.nombre, ap.apaterno, ap.amaterno ,ce.escuela_nombre, "
                            + "ce.logo, ne.nivel_nombre "
                            + "from alum_personal ap "
                            + "join cat_escuela ce on ce.escuela_id=ap.escuela_id "
                            + "join cat_nivel_escuela ne on ne.escuela_id=ap.escuela_id and ne.nivel_id=ap.nivel_id "
                            + "where codigo_id  is not null and ap.escuela_id='" + escuela + "' and "
                            + " ap.codigo_id in (select distinct(auxiliar) from fin_movimientos where ejercicio_id like '" + escuela + "%')";

                }
            }
            comando += " order by nivel,grado,grupo,codigo_id ";

            System.out.println(" ======= " + comando);

            PreparedStatement psta = con.prepareStatement(comando);

               PreparedStatement pstb = con.prepareStatement("SELECT COALESCE(SUM(IMPORTE * CASE NATURALEZA WHEN 'C' THEN -1 ELSE 1 END),0) AS SALDO "
                    + "            		 FROM FIN_MOVIMIENTOS WHERE AUXILIAR = ? AND FECHA < TO_DATE(?,'DD-MM-YYYY') and estado<>'C' and cuenta_id in (select cuenta_id from fin_cuenta where cuenta_aislada='N')");

            PreparedStatement pstc = con.prepareStatement(" SELECT MO.EJERCICIO_ID, "
                    + " MO.POLIZA_ID, MO.MOVIMIENTO_ID, MO.CUENTA_ID, MO.AUXILIAR, MO.DESCRIPCION,"
                    + " MO.IMPORTE, MO.NATURALEZA, MO.REFERENCIA, MO.ESTADO, "
                    + " TO_CHAR(MO.FECHA, 'DD-MM-YYYY') AS FECHA, MO.RECIBO_ID, MO.CICLO_ID, MO.PERIODO_ID, MO.TIPOMOV_ID "
                    + " ,PO.TIPO  "
                    + " FROM FIN_MOVIMIENTOS MO"
                    + " JOIN FIN_POLIZA PO ON PO.POLIZA_ID=MO.POLIZA_ID AND PO.EJERCICIO_ID=MO.EJERCICIO_ID"
                    + " WHERE MO.AUXILIAR = ? "
                    + " AND MO.FECHA <= '" + ffin + "' AND MO.FECHA >= '" + fini + "'"
                    + " AND MO.ESTADO <> 'C' and MO.cuenta_id in (select cuenta_id from fin_cuenta where cuenta_aislada='N')"
                    + " ORDER BY MO.FECHA");
            System.out.println("pstc = " + pstc);
            Calendar calb = Calendar.getInstance();
            try {
                calb.setTime(sdf.parse(fini));
            } catch (ParseException pe) {
                System.err.println(pe);
            }
            calb.add(Calendar.DAY_OF_MONTH, -1);
            ResultSet rsa = psta.executeQuery();
            while (rsa.next()) {
                EdoCtaPanama ep = new EdoCtaPanama();
                ep.setCodigoid(rsa.getString("codigo_id"));
                ep.setEscuela(rsa.getString("escuela_nombre"));
                ep.setFfinal(ffin);
                ep.setFinicial(fini);
                if (rsa.getString("logo") != null && rsa.getString("logo").indexOf(".") != -1) {
                    ep.setLogo(imgpath + "/" + rsa.getString("logo"));
                } else {
                    //logoIASD.png
                    ep.setLogo(imgpath + "/logoIASD.png");
                }
                System.out.println("**logo  " + ep.getLogo());
                ep.setNivelgradogrupo(rsa.getString("nivel_nombre") + " " + rsa.getString("grado") + " " + rsa.getString("grupo"));
                ep.setNombre(rsa.getString("nombre").trim().toUpperCase() + " " + rsa.getString("apaterno").trim().toUpperCase() + " " + rsa.getString("amaterno").trim().toUpperCase());
                ep.setNota(mensaje);

                List<Movimientos> lsM = new ArrayList();
                pstb.setString(1, ep.getCodigoid());
                pstb.setString(2, fini);

                BigDecimal saldo = BigDecimal.ZERO;

                ResultSet rsb = pstb.executeQuery();
                if (rsb.next()) {

                    Movimientos m = new Movimientos();

                    m.setDetalle("SALDO INICIAL");
                    m.setNummovto("");
                    m.setPoliza("");
                    m.setTipoPoliza("");
                    m.setFecha(sdf.format(calb.getTime()));
                    m.setDocumento("");
                    if (rsb.getBigDecimal("saldo") != null) {
                        if (rsb.getBigDecimal("saldo").compareTo(BigDecimal.ZERO) < 0) {
                            m.setAbonos(rsb.getBigDecimal("saldo").abs().toString());
                            m.setNaturaleza("C");
                            m.setSaldo(rsb.getBigDecimal("saldo").toString());
                            saldo = saldo.subtract(rsb.getBigDecimal("saldo").abs());
                        } else {
                            m.setCargos(rsb.getBigDecimal("saldo").toString());
                            m.setNaturaleza("D");
                            m.setSaldo(rsb.getBigDecimal("saldo").toString());
                            saldo = saldo.add(rsb.getBigDecimal("saldo"));
                        }
                    }
                    lsM.add(m);
                }
                rsb.close();

                pstc.setString(1, ep.getCodigoid());

                ResultSet rsc = pstc.executeQuery();
                while (rsc.next()) {

                    Movimientos m = new Movimientos();

                    m.setDetalle(rsc.getString("descripcion"));
                    m.setNummovto(rsc.getString("movimiento_id"));
                    m.setPoliza(rsc.getString("poliza_id"));
                    m.setTipoPoliza(rsc.getString("tipo"));
                    m.setFecha(rsc.getString("fecha"));
                    m.setDocumento(rsc.getString("recibo_id")!=null && !rsc.getString("recibo_id").equals("0") ? rsc.getString("recibo_id") : m.getPoliza().length() > 3 ? m.getPoliza().substring(3) : "");

                    if (rsc.getString("naturaleza").equals("C")) {
                        m.setAbonos(rsc.getBigDecimal("importe").toString());
                        m.setNaturaleza(rsc.getString("naturaleza"));
                        m.setSaldo(saldo.subtract(rsc.getBigDecimal("importe")).toString());
                        saldo = saldo.subtract(rsc.getBigDecimal("importe"));
                    } else {
                        m.setCargos(rsc.getBigDecimal("importe").toString());
                        m.setNaturaleza(rsc.getString("naturaleza"));
                        m.setSaldo(saldo.add(rsc.getBigDecimal("importe")).toString());
                        saldo = saldo.add(rsc.getBigDecimal("importe"));
                    }

                    lsM.add(m);
                }
                rsc.close();
                ep.setMovimientos(lsM);
                salida.add(ep);
            }
            rsa.close();
            pstc.close();
            pstb.close();
            psta.close();
            close();
        } catch (SQLException sqle) {
            System.err.println("error al crear el estado de cuenta " + sqle);
        }

        //
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
        ServletContext context = this.getServletConfig().getServletContext();
        response.setContentType("application/pdf");
        Collection<EdoCtaPanama> dataSource = datos(context.getRealPath("/imagenes/logos"), request);
        //Collection<EdoCtaPanama> dataSource = datos("../escuela/imagenes/logos", request);
        //CreaReporte.dsEdoctaB(context.getRealPath("/imagenes/logos"));
        Locale locale = new Locale("es", "MX");

        File reportFile = new File(context.getRealPath("/WEB-INF/jsperFiles/formEstadoCuentaCtb.jasper"));
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

            response.setHeader("Content-Disposition", "filename=\"estado_cuenta.pdf" + "\"");
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

//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet PrintEstadoCuenta</title>");            
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet PrintEstadoCuenta at " + request.getContextPath() + "</h1>");
//            out.println("Application realpath " + request.getSession().getServletContext().getRealPath("/WEB-INF/jsperFiles/formEstadoCuentaCtb.jasper"));
//            out.println("</body>");
//            out.println("</html>");
//        }
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
