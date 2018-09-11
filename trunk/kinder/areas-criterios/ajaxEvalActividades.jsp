<%@page import="aca.conecta.Conectar"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file= "../../idioma.jsp" %>

<%@page import="aca.kinder.UtilAreas"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.UtilActividades"%>

<%@page import="aca.kinder.Areas"%>
<%@page import="aca.kinder.Criterios"%>
<%@page import="aca.kinder.Actividades"%>
<jsp:useBean id="krdxCursoActL" scope="page"
	class="aca.kardex.KrdxCursoActLista" />
<%

	Connection  conElias 	= new Conectar().conEliasPostgres();

	String codigoId = session.getAttribute("codigoId").toString();
	String escuelaId = session.getAttribute("escuela").toString();
	String cicloId = session.getAttribute("cicloId").toString();
	
	String cursoId = request.getParameter("CursoId");
	String estado = request.getParameter("estado") == null ? "A" : request.getParameter("estado");
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String idArea = request.getParameter("area");
	String trimestre = request.getParameter("trimestre");
	
	UtilAreas ua = new UtilAreas(conElias);
	UtilCriterios uc = new UtilCriterios(conElias);
	UtilActividades uac = new UtilActividades(conElias);
	
	Map<Long, Areas> area = ua.getMapAreas(Long.parseLong(idArea, 10), "", cicloId, 1);
	
	Map<Long, Criterios> mapCriterios = new HashMap();
	mapCriterios.putAll(uc.getMapCriterios(0L, "", cicloId, Long.parseLong(idArea, 10), 1));
	List<Long> lsIdCriterio = new ArrayList(mapCriterios.keySet());
	Collections.sort(lsIdCriterio);
	Map<Long, Actividades> mapActividades = new HashMap();
	mapActividades.putAll(
			uac.getMapActividades(0L, "", cicloGrupoId, Long.parseLong(idArea, 10), 0L, codigoId, 1, new Integer(trimestre)));
	
	SimpleDateFormat sdfA = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdfB = new SimpleDateFormat("dd-MM-yyyy");
	
	List<Long> lsActividesOrden = new ArrayList();
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos = krdxCursoActL.getListAll(conElias, escuelaId,
			" AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId
					+ "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	
	int cont = 0;
%>
<style>
	th{
		text-align:center;
	}
</style>
	<h3><%=area.get(Long.parseLong(idArea, 10)).getArea()%></h3>
	<%if(mapActividades.size()!=0){%>
	<table class="table table-condensed table-bordered" style="width: 75%;">
	    <tr style="background-color: lightgray; font-size: 16px;">
			<th>#</th>
			<th>Criterios / Indicadores</th>
	    	<th colspan="3">Actividades</th>
	    	
		</tr>
		
		<%for(Long idcriterio : lsIdCriterio){
			List<Actividades> listAct = uac.getLsActividades(0L, "", cicloGrupoId, Long.parseLong(idArea, 10), idcriterio, codigoId, 1, new Integer(trimestre));
			if(listAct.size()!=0){
			cont++;
			%>
		<tr>
		<td rowspan="<%=listAct.size()%>"><%=cont %></td>
				<th rowspan="<%=listAct.size()%>">
					<%=mapCriterios.get(idcriterio).getCriterio()%>
				</th>
				
				<%for(int i = 0; i < listAct.size(); i++){
					Actividades act = listAct.get(i);
					lsActividesOrden.add(act.getId());
				%>
					<%if(i!=0){%><tr><%}%>
					<input value="<%=act.getId()%>" name="<%=act.getId()%>" type="hidden" id="idAct">
					<td><a href="javascript:muestraInput('<%=act.getId()%>');"><%=act.getActividad() %></a></td>
					<td style="width: 10%;"><%=sdfB.format(sdfA.parse(mapActividades.get(act.getId()).getFecha()))%></td>
					<td>-</td>
					<%if(i!=0){%></tr><%}%>
				<%} %>
			</tr>
		<%}
			}%>
	</table>

	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<td colspan="20" class="text-center alert">Las actividades se evalúan de &nbsp;&nbsp;</td>
			</tr>
			<tr>
				<th class="text-center">#</th>
				<th class="text-center"><fmt:message key="aca.Codigo" /></th>
				<th><fmt:message key="aca.Nombre" /></th>
				<%
					cont = 0;
						for (Long idactividad : lsActividesOrden) {
							cont++;
				%>
				<th style="width: 4%;" class="text-center"
					title="<%=mapActividades.get(idactividad).getActividad()%>"><%= cont %></th>
				<%
					}
				%>
				<th class="text-center"
					title="<fmt:message key='aca.MensajePromedioActividades' />">
					<fmt:message key="aca.PA" />
				</th>
				<th class="text-center" title=""><fmt:message
						key="aca.Promedio" /></th>
			</tr>
		</thead>
		<%
			int i = 0;
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
		%>
		<tr>
			<td class="text-center"><%=i + 1%></td>
			<td class="text-center"><%=kardex.getCodigoId()%></td>
			<td><%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>

				<%
					if (kardex.getTipoCalId().equals("6")) {
				%> <span
				class="label label-important"
				title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />"><fmt:message
						key="aca.Baja" /></span> <%
 	}
 %></td>
			<!-- --------- RECORRE LAS ACTIVIDADES --------- -->
			<%
				for (Long idactividad : lsActividesOrden) {
							String strNota = "-";
			%>

			<td class="text-center">

				<div id="nota-<%=idactividad%>-<%=kardex.getCodigoId()%>" class="nota-<%= idactividad %>"><%=strNota%></div>

				<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) --> <%
 	if (estado.equals("A")) { /* Si el alumno no se ha dado de baja puede editar su nota */
 		if(escuelaId.startsWith("H")){
 %>
				<div class="editar<%=idactividad%> editable" style="display: none;">
					<select name="calif-<%=idactividad%>" id="calif-<%=idactividad%>"
						data-alumno="<%=kardex.getCodigoId()%>" data-alumnoactividad="<%=kardex.getCodigoId()%>-<%=idactividad%>">
						<option value="3">LHL</option>
						<option value="2">LEL</option>
						<option value="1">LVL</option>
					</select>
				</div> <%
 		}else if(escuelaId.startsWith("S")){
 			%>
			<div class="editar<%=idactividad%> editable" style="display: none;">
				<select name="calif-<%=idactividad%>" id="calif-<%=idactividad%>"
					data-alumno="<%=kardex.getCodigoId()%>" data-alumnoactividad="<%=kardex.getCodigoId()%>-<%=idactividad%>">
					<option value="3">S</option>
					<option value="2">P</option>
					<option value="1">T</option>
				</select>
			</div> <%			
 		}
 	}
 %>

			</td>
			<%
				} //End for evaluaciones
			%>
			<td class="text-center">
				<%
					
				%>
			</td>
			<%
				// obtiene el promedio de la evaluacion que esta en la BD
			%>

			<td class="text-center"><%=0%></td>
		</tr>
		<%
			i++;
				}
		%>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<%
				for (Long idactividad : lsActividesOrden) {
			%>
			<td class="text-center">
				<div class="editar<%=idactividad%> editable"
					style="display: none;">
					<a tabindex="<%=lisKardexAlumnos.size()%>"
						class="btn btn-primary btn-block" type="button"
						href="javascript:guardarCalificaciones( '<%=idactividad%>' );"><fmt:message
							key="boton.Guardar" /></a> <a
						tabindex="<%=lisKardexAlumnos.size() + 1%>"
						class="btn btn-danger btn-block" type="button"
						href="javascript:borrarCalificaciones( '<%=idactividad%>' );"><fmt:message
							key="boton.Eliminar" /></a>
				</div>
			</td>
			<%
				}
			%>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<%} else {%>
		<div class="alert alert-danger">
			Esta área no tiene actividades
		</div>	
	<%}%>
<% conElias.close(); %>
