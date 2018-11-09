<%@page import="java.util.LinkedHashMap"%>
<%@page import="aca.fin.FinSaldoAlumno"%>
<%@page import="java.util.Map"%>
<%@page import="aca.fin.FinMovimientosLista"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../../con_elias.jsp"%>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza" />
<jsp:useBean id="FinMovC" scope="page" class="aca.fin.FinMovimientos" />
<jsp:useBean id="FinMovA" scope="page" class="aca.fin.FinMovimientos" />
<%
	Map<String, FinSaldoAlumno> pasados = new LinkedHashMap();
 	String poliza = "";

		if (request.getParameter("traspaso") != null) {
			FinMovimientosLista fml = new FinMovimientosLista();
			String escuelaId = (String) session.getAttribute("escuela");
			String ejercicioId = (String) session.getAttribute("ejercicioId");
			String usuario = (String) session.getAttribute("codigoId");
			String cuentaOrigen = request.getParameter("ctaO") == null ? "00000"
					: request.getParameter("ctaO");
			String cuentaDestino = request.getParameter("ctaD") == null ? "00000"
					: request.getParameter("ctaD");
			String polizaId = request.getParameter("polizaId") == null ? "" : request.getParameter("polizaId");
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			polizaId = escuelaId + FinPoliza.maximoReg(conElias, ejercicioId);
			
			Map<String, FinSaldoAlumno> mapSaldos = fml.getMapSaldosCtaAbono(conElias, cuentaOrigen, escuelaId);
			
			BigDecimal salTotal = BigDecimal.ZERO;
			
			for(String al : mapSaldos.keySet()){
				salTotal = salTotal.add(mapSaldos.get(al).getSaldo());
			}
			
			
			if (!cuentaOrigen.equals("00000") && !cuentaDestino.equals("00000") && salTotal.compareTo(BigDecimal.ZERO)!=0) {
				
				System.out.println(escuelaId + " " + ejercicioId + " " + usuario + " " + cuentaOrigen + " " + cuentaDestino + " " + polizaId);
				
				FinPoliza.setEjercicioId(ejercicioId);
				FinPoliza.setPolizaId(polizaId);
				FinPoliza.setFecha(sdf.format(new Date()));
				FinPoliza.setDescripcion("Traspaso de abonos a cta corriente");
				FinPoliza.setUsuario(usuario);
				FinPoliza.setEstado("A");//Abierta
				FinPoliza.setTipo("G"); //General
				if (FinPoliza.insertReg(conElias)) {
				poliza=polizaId;
					int cont = 1;
					for (String al : mapSaldos.keySet()) {
						FinSaldoAlumno fsa = mapSaldos.get(al);

						if (fsa.getSaldo().compareTo(BigDecimal.ZERO) != 0) {

							FinMovC.setEjercicioId(ejercicioId);
							FinMovC.setPolizaId(polizaId);
							FinMovC.setMovimientoId(cont + "");
							FinMovC.setCuentaId(cuentaOrigen);
							FinMovC.setAuxiliar(fsa.getAuxiliar());
							FinMovC.setDescripcion("Traspaso de saldo de cuenta de abono");
							FinMovC.setImporte(fsa.getSaldo().toString());
							FinMovC.setNaturaleza("D"); /* Cargo o Debito */
							FinMovC.setReferencia("-");
							FinMovC.setEstado("R"); /* Recibo */
							FinMovC.setFecha(aca.util.Fecha.getDateTime());
							FinMovC.setReciboId("0");
							FinMovC.setCicloId("00000000");
							FinMovC.setPeriodoId("0");
							FinMovC.setTipoMovId("0");

							cont++;

							FinMovA.setEjercicioId(ejercicioId);
							FinMovA.setPolizaId(polizaId);
							FinMovA.setMovimientoId(cont + "");
							FinMovA.setCuentaId(cuentaDestino);
							FinMovA.setAuxiliar(fsa.getAuxiliar());
							FinMovA.setDescripcion("Traspaso de saldo de cuenta de abono");
							FinMovA.setImporte(fsa.getSaldo().toString());
							FinMovA.setNaturaleza("C"); /* Cargo o Debito */
							FinMovA.setReferencia("-");
							FinMovA.setEstado("R"); /* Recibo */
							FinMovA.setFecha(aca.util.Fecha.getDateTime());
							FinMovA.setReciboId("0");
							FinMovA.setCicloId("00000000");
							FinMovA.setPeriodoId("0");
							FinMovA.setTipoMovId("0");

							cont++;

							if (FinMovC.insertReg(conElias)) {
								if (FinMovA.insertReg(conElias)) {
									pasados.put(fsa.getAuxiliar(), fsa);
								}
							}
						}
					}
				}
			}
		}
%>
<%
if(pasados.size()!=0){
%>
<h2>Resultado del traspaso a la poliza <%= poliza %></h2>


<table class="table table-bordered " style="width: 80%">
	<tr>
		<th>Codigo</th>
		<th>Nombre</th>
		<th>Saldo</th>
	</tr>
	<%
	BigDecimal total =  BigDecimal.ZERO;
	for(String al : pasados.keySet()){
		total = total.add(pasados.get(al).getSaldo());
	%>
	<tr>
		<td><%= pasados.get(al).getAuxiliar() %></td>
		<td><%= pasados.get(al).getNombre() %> <%= pasados.get(al).getApaterno() %> <%= pasados.get(al).getApaterno() %></td>
		<td style="text-align: right;"><%= pasados.get(al).getSaldo().setScale(2) %></td>
	</tr>
	<%	
	}
	%>
	<tr>
	<td></td>
	<td></td>
	<td style="text-align: right; font-weight: bold;"><%= total.setScale(2) %></td>
	</tr>
</table>
<%
}else{
%>
<h2 style="color: red;">Ningun elemento fue traspasado</h2>
<%} %>

<%@ include file="../../cierra_elias.jsp"%>