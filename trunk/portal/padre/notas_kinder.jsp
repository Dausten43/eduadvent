<%@page import="aca.kinder.UtilEvaluacion"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@page import="aca.kinder.Criterios"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.List"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumPlanL" scope="page" class="aca.alumno.AlumPlanLista"/>
<jsp:useBean id="AlumCicloL" scope="page" class="aca.alumno.AlumCicloLista"/>
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="AlumnoCursoL" scope="page" class="aca.vista.AlumnoCursoLista"/>

<%@ include file= "menuPortal.jsp" %>

<%
String escuelaId 		= (String) session.getAttribute("escuela");
String codigoId 		= (String) session.getAttribute("codigoAlumno");

String planId			= request.getParameter("plan")==null?aca.alumno.AlumPlan.getPlanActual(conElias, codigoId):request.getParameter("plan");
String nivel			= aca.plan.Plan.getNivel(conElias, planId);
String nivelNombre		= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivel);
String nivelTitulo		= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivel).toUpperCase();
boolean existeAlumno 	= false;	

/* Planes de estudio del alumno */
ArrayList<aca.alumno.AlumPlan> lisPlan						= AlumPlanL.getArrayList(conElias, codigoId, "ORDER BY F_INICIO");

/* Ciclos en los que el alumno ha estudiado */
ArrayList<aca.alumno.AlumCiclo> lisCiclos					= AlumCicloL.listCiclosConMaterias(conElias, codigoId, planId, "1,2,3,4,5", " ORDER BY CICLO_ID");

//Map de materias del plan seleccionado
java.util.HashMap<String, aca.plan.PlanCurso> mapCurso		= aca.plan.PlanCursoLista.mapPlanCursos(conElias, planId);

/* Array de Esquema o calculo de promedio */
ArrayList<aca.ciclo.CicloPromedio> lisPromedio				= new ArrayList<aca.ciclo.CicloPromedio>();

/* Array de Bloques de la materia */
ArrayList<aca.ciclo.CicloBloque> lisBloque					= new ArrayList<aca.ciclo.CicloBloque>();

/* Notas el alumno en las materias */
//ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso 			= new ArrayList<aca.vista.AlumnoCurso>();


%>
<div id="content">
	
	
	<h2><fmt:message key="aca.Calificaciones"/> <small><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoId, "NOMBRE") %> </small></h2>
	
	<div class="well">	
		<select name="plan" id="plan" onchange="location.href='<%= urlNotas %>?plan='+this.options[this.selectedIndex].value;" class="input-xxlarge">
			<%for(aca.alumno.AlumPlan alPlan : lisPlan){%>
				<option value="<%=alPlan.getPlanId() %>" <%if(planId.equals(alPlan.getPlanId())){out.print("selected");} %>><%=aca.plan.Plan.getNombrePlan(conElias, alPlan.getPlanId())%></option>
			<%}%>
		</select>
	</div>
	

<%	
		for(aca.alumno.AlumCiclo ciclo : lisCiclos){
			
			//Nombre del ciclo escolar 
			String cicloNombre 	= aca.ciclo.Ciclo.getCicloNombre(conElias, ciclo.getCicloId());
			
			// Nombre del grado
			String gradoNombre	= aca.catalogo.CatNivel.getGradoNombre( Integer.parseInt(ciclo.getGrado()) )+" "+nivelTitulo;
			
			// Escala
			int escalaEval = aca.ciclo.Ciclo.getEscala(conElias, ciclo.getCicloId());
			
			// Clave del grupo donde se inscribio el alumno
			String cicloGrupoId	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias, ciclo.getNivel(), ciclo.getGrado(), ciclo.getGrupo(), ciclo.getCicloId(), planId);
			
			List<Areas> lsAreas = new ArrayList();
			List<Criterios> lsCriterios = new ArrayList();
			
			UtilAreas ua = new UtilAreas(conElias);
			lsAreas.addAll(ua.getLsAreas(0L, "", ciclo.getCicloId(), 1)); 
			
			UtilCriterios uc = new UtilCriterios(conElias);
			lsCriterios.addAll(uc.getLsCriterios(0L, "", ciclo.getCicloId(), 0L, 1));
			
			Map<Integer, Map<Long, String>> mapProm = new HashMap();
			
			UtilEvaluacion uev = new UtilEvaluacion(conElias);
			
			mapProm.putAll(uev.mapPromedio(cicloGrupoId, codigoId));
			
			
			
			//System.out.println("areas " + lsAreas.size() + " criterios " +lsCriterios.size()+ "\t" + ciclo.getCicloId() );
			
%>			
	<div class="alert alert-info"><%= cicloNombre %> - <%= nivelNombre %> - <%= gradoNombre %> "<%= ciclo.getGrupo() %>"</div>
	<div style="width: 60%; float: left;">			
	<table class="table table-condensed table-bordered">
		<thead>
		<% 
		int cont = 0;
		for(Areas a : lsAreas){ %>
			<tr style="background-color:gray;">
				<th colspan="5"><%= a.getArea() %></th>
				
			</tr>
			<tr style="background-color: silver;">
				<th style="text-align: center;">#</th>
				<th style="text-align: left;">Criterio</th>
				<th style="text-align: center;">1</th>
				<th style="text-align: center;">2</th>
				<th style="text-align: center;">3</th>
				
				
			</tr>
			</thead>
			<tbody>
			
			<%
			
			for(Criterios c : lsCriterios){ 
					if(c.getArea_id().equals(a.getId())){
						cont++;
						String trA = mapProm.containsKey(1) ? mapProm.get(1).containsKey(c.getId()) ? mapProm.get(1).get(c.getId()) : "-" : "-";
						String trB = mapProm.containsKey(2) ? mapProm.get(2).containsKey(c.getId()) ? mapProm.get(2).get(c.getId()) : "-" : "-";
						String trC = mapProm.containsKey(3) ? mapProm.get(3).containsKey(c.getId()) ? mapProm.get(3).get(c.getId()) : "-" : "-";
						
			%>
			<tr id="row-<%= c.getId() %>" class="rowcriterio">
				<td style="text-align: right;"><%= cont %></td>
				<td><%= c.getCriterio() %></td>
				<td style="text-align: center;"><a onclick="cargaTabla('alumnoid=<%= codigoId %>&criterioid=<%= c.getId() %>&evaluacion=1',<%= c.getId() %>)" href="javascript:void(0);"><%= trA %></a></td>
				<td style="text-align: center;"><a onclick="cargaTabla('alumnoid=<%= codigoId %>&criterioid=<%= c.getId() %>&evaluacion=2',<%= c.getId() %>)" href="javascript:void(0);"><%= trB %></a></td>
				<td style="text-align: center;"><a onclick="cargaTabla('alumnoid=<%= codigoId %>&criterioid=<%= c.getId() %>&evaluacion=3',<%= c.getId() %>)" href="javascript:void(0);"><%= trC %></a></td>
			</tr>
			<% } 
			}
			%>
		<% } %>
		</tbody>
		
		</table>
		</div>
		<div style="width: 40%; float: left;">
			<div id="detalle"></div>
		</div>
<% 
		}		
%>
</div>
<script>
	jQuery('.notas').addClass('active');
	
	function cargaTabla(datadata, criterio){
		
		$.ajax({
			url : 'ajaxDetalleNota.jsp',
			type : 'post',
			data : datadata,
			success : function(output) {
				console.log("INFO ENVIADA " + datadata);
				$('.rowcriterio').css('background-color','transparent');
				$('#detalle').html(output);
				$('#row-'+criterio).css('background-color','#FFFACD');
				$('#detalle').css('background-color','#FFFACD');
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	}
	
</script>
<%@ include file="../../cierra_elias.jsp" %>