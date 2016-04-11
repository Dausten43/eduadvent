<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.alumno.AlumCiclo"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.alumno.AlumCicloLista"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.ciclo.*"%>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigo_personal 	= (String) session.getAttribute("codigoAlumno");
	String orden			= "";
	String cicloId			= null;
	String estado			= null;
	
	ArrayList lisAlumnos 			= new ArrayList();
	AlumCicloLista alumnoLista		= new AlumCicloLista();
	lisAlumnos 						= alumnoLista.getArrayList(conElias, codigo_personal, "ORDER BY 1");	
	
%>
	
<head>
	<script type="text/javascript">
		function modificar(codigoId, cicloId, periodoId, estado){
			document.location.href = "accion.jsp?Accion=1&codigoId="+codigoId+"&cicloId="+cicloId+"&periodoId="+periodoId+"&estado="+estado+"&valor=1";
		}
	</script>
</head>
<body>
<div id="content">
<h2><fmt:message key="alumnos.EstadodelAlumno"/></h2> 
<div class="alert alert-info">
	<h4><fmt:message key="aca.Alumno"/>: &nbsp;&nbsp;</h4> <%=codigo_personal%> - <%=AlumPersonal.getNombre(conElias, codigo_personal, "ORDER BY 1") %>
</div>
<div  class="well">       
      <a class="btn btn-primary" href="elige_ciclo.jsp"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir"/></a>
</div>
   <br>
    
<table width="70%" border="0" align="center" class="table table-condensed" > 
   <tr> 
	<th width="3%"><fmt:message key="aca.Operacion"/></th>
    <th width="10%" height="20"><b><fmt:message key="aca.Ciclo"/></b></th>
	<th width="30%" height="20"><b><fmt:message key="aca.Nombre"/></b></th>
	<th width="5%" height="20"><b><fmt:message key="aca.Periodo"/></b></th>
	<th width="30%" height="20"><b><fmt:message key="aca.Nombre"/></b></th>
    <th width="13%" height="20"><b><fmt:message key="aca.Estado"/></b></th>    
  </tr>
<%	
	if(lisAlumnos.size()!=0){
		for(int i=0;i<lisAlumnos.size();i++){
			AlumCiclo alum = (AlumCiclo) lisAlumnos.get(i);
%>
  <tr>
  	<td align="center">  		
  		<img src="../../imagenes/edit.gif" onclick="modificar('<%=alum.getCodigoId()%>','<%=alum.getCicloId()%>','<%=alum.getPeriodoId()%>','<%=alum.getEstado() %>');" style="cursor:pointer;" width="15px" />&nbsp;&nbsp;
  	</td> 
    <td width="10%" align="center"><%=alum.getCicloId() %></td>
	<td width="30%"><%=Ciclo.nombreCiclo(conElias, alum.getCicloId()) %></td>
	<td width="5%" align="center"><%= alum.getPeriodoId()%></td>
	<td width="30%"><%= aca.ciclo.CicloPeriodo.periodoNombre(conElias,alum.getCicloId(),alum.getPeriodoId())%></td>
    <td width="13%" align="center"><%=alum.getEstado()%></td>    
  </tr>
<%		}
	}else if(lisAlumnos.size()==0){
%>
	<script>
		alert("¡<fmt:message key="aca.AlumnonoInscrito"/>!")
	</script>
<%		
	}
		alumnoLista		 		= null;
		lisAlumnos				= null;
%>

</table>	
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 