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
<jsp:useBean id="CicloLista" class="aca.ciclo.CicloLista" scope="page" />

<head>
<script>
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

	int gradoIni = 0;
	int gradoFin = 0;
	int cont = 0;

	//System.out.println("Datos:"+planId+":"+grado);
	ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, " ORDER BY CICLO_ID");
	ArrayList<aca.plan.Plan> lisPlan		= ListaPlan.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID");
	ArrayList lisReporte = ReporteL.getListGrado(conElias, cicloId, planId, grado," ORDER BY ALUM_GRUPO(CODIGO_ID), ALUM_NOMBRE(CODIGO_ID)");
%>

<body>

<div id="content">
	<h2><fmt:message key="disciplina.ListadodeReportesporGrupo" /></h2>

	<form action="reporte.jsp" name="frmReporte" method="post">
		<div class="well" style="overflow: hidden;">
		
			<fmt:message key="aca.Ciclos" />: &nbsp;
			<select name="ciclo" id="ciclo" style="width: 310px;">
				<option value="" selected><fmt:message key="aca.SeleccionaCiclo" /></option>
				<%for(aca.ciclo.Ciclo cic : lisCiclo){%>
					<option value="<%=cic.getCicloId() %>" <%if (cic.getCicloId().equals(cicloId)){ out.print("selected"); } %>><%=cic.getCicloNombre() %></option>
				<%}%>
			</select>
			
			<fmt:message key="aca.Planes" />: &nbsp; 
			<select name="PlanId" id="PlanId">
				<option value="" selected><fmt:message key="aca.SeleccionaPlan" /></option>
				<%for(aca.plan.Plan plan : lisPlan){%>
					<option value="<%=plan.getPlanId() %>" <%if (plan.getPlanId().equals(planId)){ out.print("selected"); } %>><%=plan.getPlanNombre() %></option>
				<%} %>	
			</select>
			
			<fmt:message key="aca.Grado" />:&nbsp;
			<select name="Grado" id="grado">
				<option value="" selected><fmt:message key="aca.SeleccionaGdo" /></option>
			</select>
		</div>
	</form>
	
	<div id="table"></div>
</div>
<script>
	fnRefreshPlan();
	
	$('#ciclo').change(function (){
		fnRefreshPlan();
	});
	
	$('#PlanId').change(function(){
		fnRefreshGrade();
	});
	
	$('#grado').change(function(){
		fnRefreshTable();
	});
	
	function fnRefreshPlan(){
		$('#PlanId').html('<option>Actualizando</option>');
		
		var accion = '1';
		var actualizar = 'plan';
		var ciclo = document.frmReporte.ciclo.value;
		var dataSend = 'Accion='+accion+'&Actualizar='+actualizar+'&ciclo='+ciclo;
		
		$.get('getListas.jsp?' + dataSend, function(data) {
			$("#PlanId").html(data);
			fnRefreshGrade();
		});
	}
		
	function fnRefreshGrade(){
		jQuery('#grado').html('<option>Actualizando</option>');
	
		var accion = '1';
		var actualizar = 'grado';
		var plan = document.frmReporte.PlanId.value;
		var dataSend = 'Accion='+accion+'&Actualizar='+actualizar+"&PlanId="+plan+"&escuelaId="+'<%=escuelaId%>';
		
		jQuery.get('getListas.jsp?' + dataSend, function(data) {
			jQuery("#grado").html(data);
			fnRefreshTable();
		});
	}
	
	function fnRefreshTable(){
		var ciclo = document.frmReporte.ciclo.value;
		var plan = document.frmReporte.PlanId.value;
		var grado = document.frmReporte.grado.value;
		var dataSend = "ciclo="+ciclo+"&PlanId="+plan+"&grado="+grado+"&escuelaId="+'<%=escuelaId%>';
		
		jQuery.get('getTabla.jsp?' + dataSend, function(data){
			jQuery('#table').html(data);
		});
	}
</script>
</body>
<%@ include file="../../cierra_elias.jsp"%>
