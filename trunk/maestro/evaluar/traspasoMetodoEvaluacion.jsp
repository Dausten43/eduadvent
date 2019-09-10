
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.text.*"%>
<%@page import="java.util.Collections"%>
<%@page import="aca.ciclo.CicloGrupoActividadLista"%>
<%@page import="aca.ciclo.CicloGrupoActividad"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>

<jsp:useBean id="cicloGrupoActividadLista" scope="page" class="aca.ciclo.CicloGrupoActividadLista" />
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista" />
<%
	String codigoId				= (String) session.getAttribute("codigoEmpleado");
	String escuelaId 			= (String) session.getAttribute("escuela");

	String cursoId 				= request.getParameter("CursoId")==null?"":request.getParameter("CursoId");
	String cicloGrupoId 		= request.getParameter("CicloGrupoId")==null?"":request.getParameter("CicloGrupoId");
	String evaluacionId			= request.getParameter("EvaluacionId")==null?"":request.getParameter("EvaluacionId");
	String cicloId 				= request.getParameter("CicloId")== null?aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId):request.getParameter("CicloId");									
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID"); //Lista de ciclos activos
	ArrayList<CicloGrupoActividad> lisActEvaluacion	= cicloGrupoActividadLista.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, " ORDER BY ACTIVIDAD_ID");//Actividades de la evaluacion]
	//System.out.println(lisActEvaluacion.size());
%>
<div id="content">
	<h2>Traspasar método de evaluación</h2>		 
	<table class="table table-condensed table-bordered">
		<tr>
			<th><fmt:message key="aca.Actividad" /></th>
			<th><fmt:message key="aca.FechaEntrega" /></th>
			<th><fmt:message key="aca.Valor" /> </th> 
			<th><fmt:message key="aca.Mostrar" /> </th>						
		</tr>
		<% 
	for (int i=0; i < lisActEvaluacion.size(); i++){
		aca.ciclo.CicloGrupoActividad act = (aca.ciclo.CicloGrupoActividad) lisActEvaluacion.get(i);		
%>	
		<tr>
			<td> <%=act.getActividadNombre()%> </td> 
			<td> <%=act.getFecha()%> </td>
			<td> <%=act.getValor()%>%</td>
			<td> <%= act.getMostrar().equals("S")?"SI":"NO" %></td>			
		</tr>			 		
<% 	
	}
%>				
	</table>
	<div id="cicloSelect">
		<label for="cicloid">Ciclo:</label>
		<select name="ciclo_id" id="cicloid">
			<option value="">Seleccione un ciclo</option>
			<%
				Collections.reverse(lisCiclo);
					for (aca.ciclo.Ciclo c : lisCiclo) {
						int x = CicloGrupoCurso.numCursosMaestro(conElias, c.getCicloId() , codigoId);
						System.out.println(x);
						if (x>0){
			%>
			<option value="<%=c.getCicloId()%>"
				<%=c.getCicloId().equals(cicloId) ? " Selected" : ""%>><%=c.getCicloNombre()%></option>
			<%
						}
					}
			%>
		</select>
		<button onclick="javascript:prueba();">Click me</button>		
	</div>
	<div id="cursoSelect">
	<label for="cursoid">Curso:</label>
		<select name="curso_id" id="cursoid">
			<option value="">Seleccione un curso</option>
		</select>
	</div>
</div>
<script>
	function prueba(){
			
			let data = {
				cursoId 		: $('#CursoId').val(),
				escuela 		: $('#escuela').val()
			};
			
			
				$.ajax({
					url : 'ajaxEvaluaciones.jsp',
					type : 'post',
					data : data,
					success : function (output){
						alert(output);
					},
					error : function (xhr, ajaxOptions, thrownError) {
						console.log("error ");
						alert(xhr.status + " " + thrownError);
					}
				});
		}
</script>
<%@ include file="../../cierra_elias.jsp"%>