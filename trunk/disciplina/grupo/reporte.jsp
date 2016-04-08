<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="aca.plan.PlanLista"%>
<%@page import="aca.plan.Plan"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.plan.PlanCursoLista"%>
<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.catalogo.CatNivelLista"%>
<%@page import="aca.cond.CondReporteLista"%>
<%@page import="aca.cond.CondReporte"%>
<%@page import="aca.alumno.AlumPlan"%>
<%@page import="aca.alumno.AlumPersonal"%>

<jsp:useBean id="ReporteL" scope="page"	class="aca.cond.CondReporteLista" />
<jsp:useBean id="ListaPlan" scope="page" class="aca.plan.PlanLista" />
<jsp:useBean id="NivelU" scope="page" class="aca.catalogo.CatNivelLista" />

<head>
<script type="javascript">
	function MostrarDatos() {
		document.frmReporte.submit();
	}
</script>
</head>
<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloId 		= (String) session.getAttribute("cicloId");

	String planId 		= request.getParameter("PlanId") == null ? "00-00": request.getParameter("PlanId");
	String grado 		= request.getParameter("Grado") == null ? "1": request.getParameter("Grado");
	String nivelId 		= "0";
	String grupo 		= "-";
	String alumGrupo 	= "";
	String alumCod 		= "X";
	String codigoId		 = "";
	String color 		= "";
	String colorA 		= "bgcolor='#CCFFFF'";
	String colorB 		= "bgcolor='#E6E6E6'";

	int gradoIni = 0;
	int gradoFin = 0;
	int cont = 0;

	//System.out.println("Datos:"+planId+":"+grado);
	ArrayList listaPlanes = ListaPlan.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID, PLAN_ID");
	ArrayList lisReporte = ReporteL.getListGrado(conElias, cicloId, planId, grado," ORDER BY ALUM_GRUPO(CODIGO_ID), ALUM_NOMBRE(CODIGO_ID)");
%>

<body>

<div id="content">
	<h2><fmt:message key="disciplina.ListadodeReportesporGrupo" /></h2>

	<form action="reporte.jsp" name="frmReporte" method="post">
		<div class="well" style="overflow: hidden;">
			<td align="center"><fmt:message key="aca.Planes" />: &nbsp; 
				<select id="PlanId" name="PlanId">
<%
	for (int j = 0; j < listaPlanes.size(); j++) {
		Plan planes = (Plan) listaPlanes.get(j);
		if (!nivelId.equals(planes.getNivelId())) {
			nivelId = planes.getNivelId();
%>
					<optgroup style="font-size: 8pt; font-weight: bold;" label="<%="-"+ aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId)%>">
<%
		}
%>
					<option style="font-size: 7pt;" value="<%=planes.getPlanId()%>" <%=planId.equals(planes.getPlanId()) ? "selected":""%>>
						<%=planes.getPlanNombre()%>
					</option>
<%
	}
%>
				</select> &nbsp;
			</td>	
			<td align="center"><fmt:message key="aca.Grado" />:&nbsp;
				<input class="input-small" type="text" id="Grado" name="Grado" maxlength="2" value="<%=grado%>" /> &nbsp; &nbsp; 
				<a class="btn btn-primary " href="javascript:MostrarDatos()">
					<i class="icon-chevron-down icon-white"></i> <fmt:message key="boton.Mostrar" />
				</a>
			</td>	
		</div>
	</form>

	<table align="center" width="77%" class="table table-condensed">
		<tr>
			<th width="5%">#</th>
			<th width="5%"><fmt:message key="aca.Fecha" /></th>
			<th width="5%"><fmt:message key="aca.Tipo" /></th>
			<th width="20%"><fmt:message key="aca.Reporto" /></th>
			<th width="5%"><fmt:message key="aca.Matricula" /></th>
			<th width="30%"><fmt:message key="aca.Nombre" /></th>
			<th width="30%"><fmt:message key="aca.Comentario" /></th>
		</tr>
<%
	for (int i = 0; i < lisReporte.size(); i++) {
		CondReporte reporte = (CondReporte) lisReporte.get(i);
		alumGrupo = AlumPersonal.getGrupo(conElias, reporte.getCodigoId());
		codigoId = reporte.getCodigoId();

		if (!grupo.equals(alumGrupo)) {
			grupo = alumGrupo;
%>
		<tr>
			<td align="center" colspan="7" bgcolor="#C8D4A3"><b><fmt:message key="aca.Grupo" /> <%=alumGrupo%></b></td>
		</tr>
<%
		}
		if (!alumCod.equals(codigoId)) {
			alumCod = codigoId;
			if (color == colorB) {color = colorA;} else	color = colorB;	}
%>
		<tr <%=color%>>
			<td>&nbsp;<%=i + 1%></td>
			<td align="center"><%=reporte.getFecha()%></td>
			<td align="center"><%=aca.cond.CondTipoReporte.getTipoReporteNombre(conElias, reporte.getTipoId())%></td>
			<td align="left">&nbsp;<%=aca.empleado.EmpPersonal.getNombre(conElias, reporte.getEmpleadoId(), "NOMBRE")%></td>
			<td>&nbsp;<%=reporte.getCodigoId()%></td>
			<td>&nbsp;<%=AlumPersonal.getNombre(conElias, reporte.getCodigoId(), " ORDER APATERNO")%></td>
			<td>&nbsp;<%=reporte.getComentario()%></td>
		</tr>
<%
		}
		lisReporte = null;
%>
	</table>
</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
