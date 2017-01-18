<%@page import="aca.vista.AlumnoSaldo"%>
<%@page import="java.util.List"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%@page import="aca.fin.FinMovimiento"%>
<jsp:useBean id="AlumnoL" scope="page"
	class="aca.alumno.AlumPersonalLista" />
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo" />
<jsp:useBean id="AlumSaldoL" scope="page"
	class="aca.vista.AlumnoSaldoLista" />


<%@page import="java.util.HashMap"%>
<%
	String escuelaId = (String) session.getAttribute("escuela");
		String ejercicioId = (String) session.getAttribute("ejercicioId");
		String ciclo = request.getParameter("ciclo") == null
				? aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId) : request.getParameter("ciclo");

		String nivel = "-";
		String grado = "-";
		String grupo = "-";
		int cont = 1;
		// Lista de Alumnos deudores
		ArrayList<aca.vista.AlumnoSaldo> listAlumSaldo = AlumSaldoL.getListAll(conElias, escuelaId);
		//HashMap<String, aca.vista.AlumnoSaldo> mapAlumSaldo = AlumSaldoL.mapAlumSaldo(conElias, escuelaId);

		List<String> lsNgg = new ArrayList();

		for (AlumnoSaldo sa : listAlumSaldo) {
			if (!lsNgg.contains(sa.getNivelId() + "-" + sa.getGrado() + "-" + sa.getGrupo())) {
				lsNgg.add(sa.getNivelId() + "-" + sa.getGrado() + "-" + sa.getGrupo());
			}

		}
%>

<div id="content">
	<h2>Alumnos con Saldo</h2>
	<form name="forma" action="reporte_deudor.jsp" method='post'
		class="hidden-print">
		<div class="well">
			<a href="menu.jsp" class="btn btn-primary"><i
				class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		</div>
	</form>


	<%
		BigDecimal stotald = BigDecimal.ZERO;
			BigDecimal stotala = BigDecimal.ZERO;

			for (String encabezado : lsNgg) {
				String[] split = encabezado.split("-");
	%>



	<table class="table  table-fontsmall " style="width: 80%; margin-left: auto; margin-right: auto;">
		<thead>
		<tr>
		<th>
			<span class="alert alert-info"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, split[0])%>
				: 
				<%=aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, split[0], split[1])%> <%=split[2] %>
				
			</span>
			</th>
			</tr>
			</thead>
			<tr>
			<td>
			<table style="width: 100%;" class="table table-striped">
		<thead>
			<tr>
				<th>#</th>
				<th>Matr&iacute;cula</th>
				<th>Nombre</th>
				<th style="width: 8%;">Deudor</th>
				<th style="width: 8%;">Acreedor</th>

			</tr>
		</thead>
		<tbody>


			<%
				BigDecimal totald = BigDecimal.ZERO;
						BigDecimal totala = BigDecimal.ZERO;

						int conta = 0;
						for (AlumnoSaldo sa : listAlumSaldo) {
							if (encabezado.equals(sa.getNivelId() + "-" + sa.getGrado() + "-" + sa.getGrupo())) {

								BigDecimal salAc = BigDecimal.ZERO;
								salAc = salAc.add(new BigDecimal(sa.getSaldo().toString()).compareTo(BigDecimal.ZERO) < 0
										? new BigDecimal(sa.getSaldo().toString()).abs() : BigDecimal.ZERO);

								conta++;
								totald = totald.add(new BigDecimal(
										new BigDecimal(sa.getSaldo().toString()).compareTo(BigDecimal.ZERO) >= 0
												? sa.getSaldo() : "0"));
								totala = totala.add(salAc);

								stotald = stotald.add(new BigDecimal(
										new BigDecimal(sa.getSaldo().toString()).compareTo(BigDecimal.ZERO) >= 0
												? sa.getSaldo() : "0"));
								stotala = stotala.add(salAc);
			%>
			<tr>
				<td><%=conta%></td>
				<td><%=sa.getCodigoId()%></td>
				<td><%=aca.alumno.AlumPersonal.getNombre(conElias, sa.getCodigoId(), "APELLIDO")%></td>
				<td style="text-align: right;"><%=new BigDecimal(sa.getSaldo()).compareTo(BigDecimal.ZERO) >= 0 ? sa.getSaldo() : ""%></td>
				<td style="text-align: right;"><%=salAc.compareTo(BigDecimal.ZERO) != 0 ? salAc : ""%></td>
			</tr>
			<%
				}
						}
			%>

			<tr>
				<td colspan="3" style="text-align: right;">Total</td>
				<td style="text-align: right;"><strong><%=totald%></strong></td>
				<td style="text-align: right;"><strong><%=totala%></strong></td>
			</tr>

			<tr>
				<td colspan="3" style="text-align: right;">Gran Total</td>
				<td style="text-align: right;"><strong><%=stotald%></strong></td>
				<td style="text-align: right;"><strong><%=stotala%></strong></td>
			</tr>
		</tbody>
	</table>
</td>
</tr>
</table>
<div style="display: block; page-break-before: always; "> </div>
			<%
				}
			%>


</div>

<%@ include file="../../cierra_elias.jsp"%>