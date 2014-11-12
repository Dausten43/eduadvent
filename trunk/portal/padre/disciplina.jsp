<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<%@ page import= "aca.alumno.AlumPersonal"%>
<jsp:useBean id="tipoU" scope="page" class="aca.cond.CondReporteLista"/>
<%
	
	AlumPersonal alumno					= new AlumPersonal();

	String colorPortal					= (String)session.getAttribute("colorPortal");
	String strCodigoAlumno 				= (String) session.getAttribute("codigoAlumno");
	String strNombreAlumno				= aca.alumno.AlumPersonal.getNombre(conElias, strCodigoAlumno,"NOMBRE");
	ArrayList lisReporte				= new ArrayList();
	lisReporte	 						= tipoU.getListAll(conElias,"WHERE CODIGO_ID = '"+strCodigoAlumno+"' ORDER BY FOLIO");
	
	alumno.mapeaRegId(conElias, strCodigoAlumno);
	String strNivel						= alumno.getNivelId();
	String strGrado						= alumno.getGrado();	
%>
<head>

<script>
	jQuery('.disciplina').addClass('active');
</script>

</head>
<body >
<div id="content">

	<h2><fmt:message key="aca.Reportes" /> <small><%=strNombreAlumno%></small></h2>
	
	<div class="alert alert-info">
		<strong><fmt:message key="aca.Nivel"/>:</strong> <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), strNivel)%> |
 	  	<strong><fmt:message key="aca.Grado"/>:</strong> <%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(strGrado))%> |
 	  	<strong><fmt:message key="aca.Grupo"/>:</strong> <%=alumno.getGrupo()%> 
	</div>
	

  <table class="table table-condensed" >
  <tr> 
    <th width="3%">#</th>
    <th width="8%"><fmt:message key="aca.Ciclo" /></th>    
    <th width="8%"><fmt:message key="aca.Tipo" /></th>
    <th width="20%"><fmt:message key="aca.Reporto" /></th>   
    <th width="8%"><fmt:message key="aca.Fecha" /></th>      
    <th width="30%"><fmt:message key="aca.Comentario" /></th>   
    <th width="5%"><fmt:message key="aca.Estado" /></th>     
   </tr>    
  <%
 
	for (int i=0; i< lisReporte.size(); i++){
		
		aca.cond.CondReporte reporte = (aca.cond.CondReporte) lisReporte.get(i);		 
%>
  <tr>  
	    <td align="center"><%=reporte.getFolio()%></td>	    
	    <td align="center">&nbsp;<%=reporte.getCicloId()%></td> 
	    <td align="center">&nbsp;<%=aca.cond.CondTipoReporte.getTipoReporteNombre(conElias, reporte.getTipoId())%></td>   
	    <td align="left">&nbsp;<%= aca.empleado.EmpPersonal.getNombre(conElias, reporte.getEmpleadoId(),"NOMBRE")%></td>
	    <td align="center">&nbsp;<%=reporte.getFecha()%></td>   
	    <td align="left">&nbsp;<%=reporte.getComentario()%></td>   
	    <td align="center">&nbsp;<%=reporte.getEstado()%></td>
	    
    </tr>
  <%
	}	
	lisReporte			= null;
%>
</table>

</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 