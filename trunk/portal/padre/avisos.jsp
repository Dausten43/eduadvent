<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<jsp:include page="menu.jsp" />

<%@ page buffer= "none" %>
<%@page import="aca.vista.AlumEval"%>
<%@page import="aca.plan.PlanCurso"%>

<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="PadresAviso" scope="page" class="aca.ciclo.CicloGrupoAviso"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupoAvisoLista" scope="page" class="aca.ciclo.CicloGrupoAvisoLista"/>
<%
	String codigoId     	=  request.getParameter("CodigoId");

	String colorPortal 	= (String)session.getAttribute("colorPortal");
	if(colorPortal==null) colorPortal="";

	ArrayList listAlumno   	= cicloGrupoAvisoLista.getListAlumno(conElias, codigoId,"ORDER BY FECHA");
  
%>
<body>
<br>
<form name="forma" method="post">
  <table width="100%">
    <tr>
      <td align="left" colspan="4"><a href="materias.jsp" class="btn">Regresar a Materias</a></td>
    </tr>
    <tr>
      <td align="center" colspan="4"><%= aca.alumno.AlumPersonal.getNombre(conElias, codigoId, "NOMBRE") %></td>
    </tr>
    </table>
    <table width="90%" align="center" class="table table-condensed table-bordered table-striped">
	<tr>					
	  <th width="15%">Materia</th>
	  <th width="20%">Maestro</th>
	  <th width="10%">Fecha</th>
	  <th width="55%">Aviso</th>						
	</tr>
<%
	for(int i = 0; i < listAlumno.size(); i++){
		aca.ciclo.CicloGrupoAviso aviso1 = (aca.ciclo.CicloGrupoAviso)listAlumno.get(i);
%>
	<tr>
	  <td align="center"><%=aca.plan.PlanCurso.getCursoNombre(conElias, aviso1.getCursoId())%></td>
	  <td align="center"><%=aca.empleado.EmpPersonal.getNombre(conElias, aviso1.getEmpleadoId(), "NOMBRE")%></td>
	  <td align="center"><%=aviso1.getFecha()%></td>						
	  <td align="center"><%=aviso1.getAviso() %></td>
	</tr>	
<%
	}
%>				
  </table>
</form>
</body>

<script>
	jQuery('.materias').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>
