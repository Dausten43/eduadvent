<%@ include file="../../con_elias.jsp"%>
<%@ include file= "../../idioma.jsp" %>
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela" />
<jsp:useBean id="CatGrupoL" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="ReporteL" scope="page"	class="aca.cond.CondReporteLista" />

<%@page import="aca.cond.CondReporte"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%
	String color 		= "";
	String colorA 		= "bgcolor='#CCFFFF'";
	String colorB 		= "bgcolor='#E6E6E6'";
	String alumGrupo 	= "";
	String alumCod 		= "X";
	String codigoId		 = "";
	String grupo 		= "-";
	
	String cicloId = request.getParameter("ciclo") == null ? "" : request.getParameter("ciclo");
	String planId = request.getParameter("PlanId") == null ? "" : request.getParameter("PlanId");
	String grado = request.getParameter("grado") == null ? "" : request.getParameter("grado");
	
	ArrayList lisReporte = ReporteL.getListGrado(conElias, cicloId, planId, grado," ORDER BY ALUM_GRUPO(CODIGO_ID), ALUM_NOMBRE(CODIGO_ID)");
%>
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
<%@ include file="../../cierra_elias.jsp"%>