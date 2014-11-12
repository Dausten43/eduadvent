<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<%@page import="java.text.*" %>
<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.vista.AlumEval"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="GrupoEval" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="GrupoAct" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="AlumEval" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="AlumAct" scope="page" class="aca.kardex.KrdxAlumActivLista"/>

<%	
	DecimalFormat frmEntero		= new DecimalFormat("##0;-##0");
	DecimalFormat frmDecimal	= new DecimalFormat("##0.0;-##0.0");
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String escuelaId 	= (String) session.getAttribute("escuela");
	String colorPortal 	= (String)session.getAttribute("colorPortal")==null?colorPortal="":(String)session.getAttribute("colorPortal");
	
	String cicloId 		= request.getParameter("ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("ciclo");
	String codigoId 	= request.getParameter("codigoId");
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String cursoId      = request.getParameter("cursoId");
	
	String notaEval		= "";
	String notaAct		= "";
	
	String plan			= aca.kardex.KrdxCursoAct.getAlumPlan(conElias,codigoId,cicloId);
	String punto		= aca.plan.PlanCurso.getPunto(conElias, cursoId);
	
	ArrayList grupoEval	= GrupoEval.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	ArrayList grupoAct	= GrupoAct.getListGrupo(conElias, cicloGrupoId, cursoId, "ORDER BY FECHA" );
	
	TreeMap alumEval	= AlumEval.getTreeAlumMat(conElias, codigoId, cicloGrupoId, cursoId, "ORDER BY EVALUACION_ID");
	TreeMap alumAct		= AlumAct.getTreeAlumAct(conElias, cicloGrupoId, cursoId, codigoId,"ORDER BY EVALUACION_ID, ACTIVIDAD_ID");	
%>
<html>
<head>	

<script>
	$('.materias').addClass('active');
</script>

</head>
<body>
<div id="content">
	<h2><fmt:message key="portal.DetalleDeEvaluacion" /> <small><%= aca.alumno.AlumPersonal.getNombre(conElias, codigoId,"NOMBRE") %> | <%= PlanCurso.getCursoNombre(conElias, cursoId) %></small> </h2>
	<form name="frmmaterias" action="materias.jsp">	
	<div class="well">
		<a href="materias.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	 
  	<table class="table table-condensed table-bordered">    
    <tr>
      <th><fmt:message key="aca.Fecha" /></th>
      <th><fmt:message key="aca.Nombre" /></th>
      <th><fmt:message key="aca.Ponderado" /></th>
      <th><fmt:message key="aca.Nota" /></th>
    </tr>
<%
	for(int i=0; i<grupoEval.size();i++){
		aca.ciclo.CicloGrupoEval gpoEval = (aca.ciclo.CicloGrupoEval)  grupoEval.get(i);
		
		notaEval = "0";
		if (alumEval.containsKey(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId())){
			aca.kardex.KrdxAlumEval kae = (aca.kardex.KrdxAlumEval) alumEval.get(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId());
			
			// Si se evalua con punto decimal
			if (punto.equals("S")){
				notaEval = frmDecimal.format(Double.valueOf(kae.getNota()));
			}else{
				notaEval = frmEntero.format(Double.valueOf(kae.getNota()));
			}			
		}
%>
	<tr>
	  <td><%= gpoEval.getFecha() %></td>
      <td><%= gpoEval.getEvaluacionNombre() %></td>
      <td><%= gpoEval.getValor() %></td>
      <td><%= notaEval %></td>
    </tr>
<%
		for(int j=0; j < grupoAct.size(); j++){
			aca.ciclo.CicloGrupoActividad gpoAct = (aca.ciclo.CicloGrupoActividad) grupoAct.get(j);
			if (gpoAct.getEvaluacionId().equals(gpoEval.getEvaluacionId())){
				notaAct = "0";
				if (alumAct.containsKey(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId()+gpoAct.getActividadId())){
					aca.kardex.KrdxAlumActiv kaa = (aca.kardex.KrdxAlumActiv) alumAct.get(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId()+gpoAct.getActividadId());
					notaAct = kaa.getNota();
				}
%>
	<tr>
      <td><%= gpoAct.getFecha() %></td>
      <td><%= gpoAct.getActividadNombre() %></td>
      <td><%= gpoAct.getValor() %></td>
      <td><%= notaAct %></td>
    </tr>
<%			
			}
		}
	}
%>    
	</table>
</body>
<%@ include file="../../cierra_elias.jsp" %>