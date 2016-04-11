<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="tipoU" scope="page" class="aca.cond.CondTipoReporteLista"/>

<head>
	<script>
		function Borrar( TipoId ){
			if(confirm("¿Estás seguro de eliminar el registro: "+TipoId+"?")==true){
		  		document.location="accion.jsp?Accion=4&TipoId="+TipoId;
		  	}
		}
	</script>
</head>
<%
	String escuelaId			= (String) session.getAttribute("escuela");

	// Lista de tipos de reporte en la escuela
	ArrayList<aca.cond.CondTipoReporte> lisReporte				= tipoU.getListEscuela(conElias, escuelaId, " ORDER BY TIPO_NOMBRE");	
%>
<body>

<div id="content">
	
    <h2>Listado de Reportes</h2>
    
    <div class="well" style="overflow:hidden;">
    	<a class="btn btn-primary " href="accion.jsp?Accion=1"><i class="icon-plus icon-white"></i> Añadir</a>
    </div>
  
  <table width="50%" align="center" class="table table-condensed">
  <tr> 
    <th width="5%">Operación</th>
    <th width="5%">#</th>
    <th width="30%">Nombre</th>
    <th width="30%">Comentario</th>
   </tr>    
  <%
	for (int i=0; i< lisReporte.size(); i++){
		aca.cond.CondTipoReporte reporte = (aca.cond.CondTipoReporte) lisReporte.get(i);		 
%>
  <tr> 
    <td align="center">
      <a class="icon-pencil" href="accion.jsp?Accion=5&TipoId=<%=reporte.getTipoId()%>&TipoNombre=<%=reporte.getTipoNombre()%>"></a> 
      <a class="icon-remove" href="accion.jsp?Accion=4&TipoId=<%=reporte.getTipoId()%>&TipoNombre=<%=reporte.getTipoNombre()%>" onclick="javascript:alert('Esta seguro de borrar este reporte?');return true"></a>      
    </td>    
	    <td align="center"><%=i+1%></td>
	    <td>&nbsp;<%=reporte.getTipoNombre()%></td> 
	    <td>&nbsp;<%=reporte.getComentario()%></td>   
    </tr>
  <%
	}	
	lisReporte			= null;
%>
</table>

</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 