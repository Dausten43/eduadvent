<%@page import="aca.fin.FinProrrogas"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="java.util.Map"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="finProrroga" scope="page" class="aca.fin.FinProrrogas"/>
	

	
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String usuario 			= (String) session.getAttribute("codigoId");
	String alumno			= (String) session.getAttribute("codigoAlumno");
	
	
	if(request.getParameter("guardar")!=null){
		
		if(!request.getParameter("fechaVence").isEmpty() && !request.getParameter("observacion").isEmpty()){
			finProrroga.setFechaVence(request.getParameter("fechaVence"));
			finProrroga.setIdAlumno(request.getParameter("idAlumno"));
			finProrroga.setIdEscuela(request.getParameter("idEscuela"));
			finProrroga.setIdPadre(request.getParameter("idPadre"));
			finProrroga.setObservacion(request.getParameter("observacion"));
			finProrroga.setUsuarioCrea(request.getParameter("usuarioCrea"));
			finProrroga.setStatus("I");
			
			
			finProrroga.insertReg(conElias);
			//response.sendRedirect("porrogas.jsp");
		}
		
	}
	
	if(request.getParameter("accion")!=null && request.getParameter("accion").equals("r")){
		finProrroga.updateReg(conElias, "", "", "I", new Integer(request.getParameter("id")));
	}
	
	
	/* ACCIONES */
	
	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 				= "";
	ArrayList<aca.alumno.AlumPersonal> alumnos = alumPersonalL.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID, GRADO, GRUPO, APATERNO, AMATERNO, NOMBRE");
	Map<String,aca.alumno.AlumPersonal> mapAlumnos = new HashMap();
	for(aca.alumno.AlumPersonal al : alumnos){
		if(!mapAlumnos.containsKey(al.getCodigoId())){
			mapAlumnos.put(al.getCodigoId(), al);
		}
	}
	
	
%>
	
<div id="content">
<div class="well">
	<h3>Pr&oacute;rrogas o convenios para permitir acceso al sistema</h3>
</div>
<%
	if(mapAlumnos.containsKey(alumno)){
		
		alumPadres.mapeaRegId(conElias, alumno);
		
		String padre = "-";
		if(!alumPadres.getCodigoTutor().isEmpty()){
			padre=alumPadres.getCodigoTutor();
		}
		if(!alumPadres.getCodigoMadre().isEmpty()){
			padre=alumPadres.getCodigoMadre();
		}
		if(!alumPadres.getCodigoPadre().isEmpty()){
			padre = alumPadres.getCodigoPadre();
		}
%>
Acreditar pr&oacute;rroga al alumno: <strong> [<%= alumno %>] <%= mapAlumnos.get(alumno).getNombre() +" " + mapAlumnos.get(alumno).getApaterno() +" " + mapAlumnos.get(alumno).getAmaterno() %></strong>
<br><br><br>

<form id="frmRecibo" name="frmRecibo" action="" method="post">
<input type="hidden" name="idEscuela" value="<%= escuelaId %>">
<input type="hidden" name="idAlumno" value="<%= alumno %>">
<input type="hidden" name="idPadre" value="<%=padre %>">
<input type="hidden" name="usuarioCrea" value="<%= usuario %>">
<div>
<label><strong>Fecha vencimiento de la pr&oacute;rroga</strong></label>
<input type="text" name="fechaVence" id="fechaVence">
</div>
<div>
<label><strong>Observaciones</strong></label>
<textarea rows="5" cols="" name="observacion"></textarea>
</div>
<div>
<input type="submit" name="guardar" value="Guardar">
</div>
</form>
<h3>Solicitudes activas </h3>
<table class="table table-bordered">
<tr>
<th></th>
<th>Fecha Creada</th>
<th>Fecha Vence</th>
<th>Observaciones</th>
<th>Creado Por</th>
<th>Status</th>
</tr>
<% 
	List<FinProrrogas> pro = finProrroga.getListFinProrrogas(conElias, escuelaId, alumno, "", "");
	for(FinProrrogas p : pro){
		if(p.getStatus().equals("A")){
%>
<tr>
		<td><a href="prorrogas.jsp?id=<%= p.getId() %>&accion=r" class="btn btn-danger">X</</a></td>
		<td><%= p.getFechaCreado() %></td>
		<td><%= p.getFechaVence() %></td>
		<td><%= p.getObservacion() %></td>
		<td><%=aca.vista.Usuarios.getNombreUsuario(conElias, p.getUsuarioCrea()) %></td>
		<td><%= p.getStatus() %></td>
</tr>
<%
		}		
	}
	%>
	<tr>
	<td colspan="6">Inactivas Hist&oacute;rico </td>
	</tr>
	<%
	for(FinProrrogas p : pro){
		if(p.getStatus().equals("I")){
%>
<tr>
		<td></td>
		<td><%= p.getFechaCreado() %></td>
		<td><%= p.getFechaVence() %></td>
		<td><%= p.getObservacion() %></td>
		<td><%=aca.vista.Usuarios.getNombreUsuario(conElias, p.getUsuarioCrea()) %></td>
		<td><%= p.getStatus() %></td>
</tr>
<%
		}		
	}
%>

</table>

<%
	}else{
%>
	<h2>Tiene que elegir un alumno para acreditar una pr&oacute;rroga</h2>
<%
	}
%>
</div>
	<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fechaVence').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>