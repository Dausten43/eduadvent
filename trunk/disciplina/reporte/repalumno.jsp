<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "aca.alumno.AlumPersonal"%>
<jsp:useBean id="tipoU" scope="page" class="aca.cond.CondReporteLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<%		
	String codigoAlumno 		= (String) session.getAttribute("codigoAlumno");
	String escuelaId 			= (String) session.getAttribute("escuela");
	
	String strNombreAlumno		= "";
	String strNivel				= Alumno.getNivelId();
	String strGrado				= Alumno.getGrado();
	
	// Verifica si existe el Alumno	
	boolean existeAlumno		= false;
	Alumno.setCodigoId(codigoAlumno);
	if (Alumno.existeReg(conElias)){
		Alumno.mapeaRegId(conElias, codigoAlumno);
		strNombreAlumno 	= Alumno.getNombre()+" "+Alumno.getApaterno()+" "+Alumno.getAmaterno();
		strNivel			= Alumno.getNivelId();
		strGrado			= Alumno.getGrado();
		existeAlumno 		= true;
	}
	
	ArrayList lisReporte	= new ArrayList();
	lisReporte	 			= tipoU.getListAll(conElias,"WHERE CODIGO_ID = '"+codigoAlumno+"' ORDER BY FOLIO");
%>
<body>
<div id="content">
   <h2><fmt:message key="disciplina.ReportesdelAlumno" /></h2>
   <div class="well" style="overflow:hidden;">
		<%	if(existeAlumno){ %>
        <a href="accion.jsp?Accion=1" class="btn btn-primary"><i class="icon-plus icon-white"></i> A&ntilde;adir</a>
		<% 	}else{
			out.print("¡ Busca un alumno !");
		}%>   
   </div>
<%	if (existeAlumno){ %>  
   <td align="center"><strong>
 	  <fmt:message key="aca.Alumno" />: [ <font color='gray'><%=codigoAlumno%></font> ] [ <font color='gray'><%=strNombreAlumno%></font> ] - 
 	  <fmt:message key="aca.Nivel" />: [ <font color='gray'><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, strNivel)%></font> ] - 
 	  <fmt:message key="aca.Grado" />: [ <font color='gray'><%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(strGrado))%></font>] - 
 	  <fmt:message key="aca.Grupo" />: [ <font color='gray'><%=Alumno.getGrupo()%></font> ]
 	  </strong>
	</td>
  
  <table width="110%" class="table table-bordered" align="center">
  <tr> 
    <th width="5%"><fmt:message key="aca.Operacion" /></th>
    <th width="3%">#</th>
    <th width="8%"><fmt:message key="aca.Ciclo" /></th>    
    <th width="8%"><fmt:message key="aca.Tipo" /></th>   
    <th width="8%"><fmt:message key="aca.Fecha" /></th>
    <th width="20%"><fmt:message key="aca.Reporto" /></th>
    <th width="20%"><fmt:message key="aca.Comentario" /></th>   
    <th width="20%"><fmt:message key="aca.Compromiso" /></th>   
    <th width="5%"><fmt:message key="aca.Estado" /></th>     
   </tr>
<% 		
		if (lisReporte.size()==0){
			out.println("<tr><td colspan='8'>¡ No existen reportes !</td></tr>");
		}

		for (int i=0; i< lisReporte.size(); i++){
			aca.cond.CondReporte reporte = (aca.cond.CondReporte) lisReporte.get(i);		 
  %>
  <tr> 
    <td align="center">
      <a class="icon-pencil" href="accion.jsp?Accion=5&TipoId=<%=reporte.getTipoId()%>&Folio=<%=reporte.getFolio()%>&CodigoId=<%=reporte.getCodigoId()%>&Comentario=<%=reporte.getComentario()%>&Estado=<%=reporte.getEstado()%>&Fecha=<%=reporte.getFecha()%>&CicloId=<%=reporte.getCicloId()%>">
      </a> 
      <a class="icon-remove"  onclick="javascript:borrar('<%=reporte.getCodigoId()%>','<%=reporte.getFolio()%>','<%=reporte.getCicloId()%>');">
      </a>
    </td>    
	    <td align="center"><%=i+1%></td>
	    <td align="center">&nbsp;<%=reporte.getCicloId()%></td> 
	    <td align="center">&nbsp;<%=aca.cond.CondTipoReporte.getTipoReporteNombre(conElias, reporte.getTipoId())%></td>
	    <td align="center">&nbsp;<%=reporte.getFecha()%></td>
	    <td align="center">&nbsp;<%= aca.empleado.EmpPersonal.getNombre(conElias,reporte.getEmpleadoId(),"NOMBRE") %></td>
	    <td align="center">&nbsp;<%=reporte.getComentario()%></td>
	    <td align="center">&nbsp;<%=reporte.getCompromiso()%></td>
	    <td align="center">&nbsp;<%=reporte.getEstado()%></td>
    </tr>
  <%
		}
	} // Si existe un alumno
		lisReporte			= null;
%>
</table>
</div>

</body>
<script>
	function borrar(codigoId,folio, cicloId){
		if(confirm("<fmt:message key="js.BorrarReporte"/>")==true){
			console.log("sdf");
			document.location.href = "accion.jsp?Accion=4&CodigoId="+codigoId+"&Folio="+folio+"&CicloId="+cicloId+"";
		}
	}
</script>
<%@ include file= "../../cierra_elias.jsp" %> 
