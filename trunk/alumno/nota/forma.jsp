<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.alumno.AlumPlan"%>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloId 		= (String)session.getAttribute("cicloId");
	
	String codigoAlumno	= (String)session.getAttribute("codigoAlumno");
	String planId 		=  aca.alumno.AlumPlan.getPlanActual(conElias, codigoAlumno);	
%>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head> 
<h1 align="center">
  <font color="black"></font>
</h1>
<table width="50%" border="0" align="center" bordercolor="#990000">
  <tr>
    <td style="font-size:13pt; color:black" align="center">
      <strong><fmt:message key="aca.Periodo"/>: <%=cicloId%>-<%= aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId) %></strong>
    </td>
  </tr>
  <tr align="center">
	<td><strong><fmt:message key="aca.Alumno"/>:</strong> [ <%=codigoAlumno %> ] - <%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "NOMBRE") %> - &nbsp;  
	<strong><fmt:message key="aca.Plan"/>: </strong><%=aca.plan.Plan.getNombrePlan(conElias, planId) %></td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
</table>
<form action="boleta.jsp" method="post" name="frmBoleta" id="frmBoleta">
<table border="0" align="center" bordercolor="#990000" class="table table-condensed" id="checks">	
	<tr>
		<th  width="50" align="center" colspan="2"><fmt:message key="aca.Opciones"/></th>
	</tr>
	<tr align="center" >
		<td colspan="2" align="left" >
		<input type="checkbox" id="Materias" name="Materias" value="S"> <fmt:message key="aca.Materias"/></input><br>
		<input type="checkbox" id ="Bimestre1" name="Bimestre1" value="S"> <fmt:message key="aca.PrimerBim"/></input><br>
		<input type="checkbox" id ="Bimestre2" name="Bimestre2" value="S"> <fmt:message key="aca.SegundoBim"/></input><br>
	  	<input type="checkbox" id ="Bimestre3" name="Bimestre3" value="S"> <fmt:message key="aca.TercerBim"/></input><br>
		<input type="checkbox" id ="Bimestre4" name="Bimestre4" value="S"> <fmt:message key="aca.CuartoBim"/></input><br>
		<input type="checkbox" id ="Bimestre5" name="Bimestre5" value="S"> <fmt:message key="aca.QuintoBim"/></input><br>
		<input type="checkbox" id ="Promedio" name="Promedio" value="S"> <fmt:message key="aca.Promedio"/></input><br>
				
		</td>
	</tr>	   
</table>
  <div class="well"><button class="btn btn-primary" type="button" value="Formato" onclick="verificaCheckbox();"> <fmt:message key="boton.Formato"/></button></div>
  <!-- <div class="well"><input class="btn btn-primary" type="button" name="Formato" value="Comprueba" onclick="validacheckboxex();"></div> -->
</form>

<script type="text/javascript">	
function verificaCheckbox(){
	var materia = document.getElementById('Materias');
	var bim1 = document.getElementById('Bimestre1');
	var bim2 = document.getElementById('Bimestre2');
	var bim3 = document.getElementById('Bimestre3');
	var bim4 = document.getElementById('Bimestre4');
	var bim5 = document.getElementById('Bimestre5');
	var promedio = document.getElementById('Promedio');
	
	if(! materia.checked && !bim1.checked	&& !bim2.checked && !bim3.checked && !bim4.checked	&& !bim5.checked && !promedio.checked){
		alert("<fmt:message key="aca.NohaSeleccionado"/>");
	}else{
		document.frmBoleta.submit();
		
	}
}
</script>
<%@ include file="../../cierra_elias.jsp" %>