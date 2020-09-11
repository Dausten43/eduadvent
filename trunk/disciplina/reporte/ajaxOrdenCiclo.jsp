<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "../../idioma.jsp" %>

<%@ page import= "aca.ciclo.Ciclo"%>
<jsp:useBean id="tipoU" scope="page" class="aca.cond.CondReporteLista"/>

<%
	String codigoAlumno 		= (String) session.getAttribute("codigoAlumno");
	String cicloId				= request.getParameter("cicloId");
	
	ArrayList<aca.cond.CondReporte> lisReporte	 			= tipoU.getListAll(conElias,"WHERE CODIGO_ID = '"+codigoAlumno+"' AND CICLO_ID = '"+cicloId+"'  ORDER BY FOLIO");
%>	

	<table width="110%" class="table table-condensed table-bordered" align="center" id="table">
		<thead>
		  <tr> 
		    <th width="8%"><fmt:message key="aca.Operacion" /></th>
		    <th width="3%">#</th>
		    <th width="8%"><fmt:message key="aca.Ciclo" /></th>    
		    <th width="8%"><fmt:message key="aca.Tipo" /></th>   
		    <th width="8%"><fmt:message key="aca.Fecha" /></th>
		    <th width="20%"><fmt:message key="aca.Reporto" /></th>
		    <th width="20%"><fmt:message key="aca.Comentario" /></th>   
		    <th width="19%"><fmt:message key="aca.Compromiso" /></th>   
		    <th width="6%"><fmt:message key="aca.Estado" /></th>     
		   </tr>	
		 </thead>
<%	
	if (lisReporte.size()==0){
		out.println("<tr><td colspan='8'>¡ No existen reportes !</td></tr>");
	}

	
	for (int i=0; i< lisReporte.size(); i++){
			aca.cond.CondReporte reporte = lisReporte.get(i);		 
  %>
  
	  <tr> 
	    <td align="center">
	      <a class="icon-pencil" href="accion.jsp?Accion=5&TipoId=<%=reporte.getTipoId()%>&Folio=<%=reporte.getFolio()%>&CodigoId=<%=reporte.getCodigoId()%>&Comentario=<%=reporte.getComentario()%>&Estado=<%=reporte.getEstado()%>&Fecha=<%=reporte.getFecha()%>&CicloId=<%=reporte.getCicloId()%>">
	      </a> 
	      <a class="icon-remove"  onclick="javascript:borrar('<%=reporte.getCodigoId()%>','<%=reporte.getFolio()%>','<%=reporte.getCicloId()%>');">
	      </a>
	    </td>    
		    <td align="center"><%=i+1%></td>
		    <td align="center">&nbsp;<%=Ciclo.nombreCiclo(conElias, reporte.getCicloId())%></td> 
		    <td align="center">&nbsp;<%=aca.cond.CondTipoReporte.getTipoReporteNombre(conElias, reporte.getTipoId())%></td>
		    <td align="center">&nbsp;<%=reporte.getFecha()%></td>
		    <td align="center">&nbsp;<%=aca.empleado.EmpPersonal.getNombre(conElias,reporte.getEmpleadoId(),"NOMBRE") %></td>
		    <td align="center">&nbsp;<%=reporte.getComentario()%></td>
		    <td align="center">&nbsp;<%=reporte.getCompromiso()%></td>
		    <td align="center">&nbsp;<%=reporte.getEstado()%></td>
	    </tr>
  <%
		}
  		
%>
	
</table>

<%@ include file="../../cierra_elias.jsp"%>