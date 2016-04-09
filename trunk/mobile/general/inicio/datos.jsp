<%@ include file="../../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>


<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>


<%

	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	if(accion.equals("1")){
		session.setAttribute("codigoAlumno",request.getParameter("codigo"));	
	}
	
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	String colorPortal 		= (String)session.getAttribute("colorPortal");	
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	String cicloId 			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	String periodoId		= aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId);
	
	alumPersonal.mapeaRegId(conElias, codigoId);
	
	
%>

<div data-role="page">
	<%@ include file="../../menu.jsp"%>
	
	<div data-role="header" style="border:0;">
   		<a href="#menu" data-role="none" class="ui-btn ui-icon-bars ui-btn-icon-notext" style="background:transparent !important;"></a>
    </div>
    
    <div data-role="content">
        	
		<center>
    		<div class="inicio-header">
	    		<img style="border:3px solid white;" src='foto.jsp?id=<%=new java.util.Date().getTime()%>&mat=<%=codigoId%>' width="130">
	    		<div class="nombreAlumno">
	    			<div><%=alumPersonal.getNombre()%> </div>
	    			<div class="apellido"><%=alumPersonal.getApaterno()%></div>
	    		</div>

	    	</div>
    	</center>
    	
		<div class="informacionPersonal">
	    	<ul>
	    		<li><fmt:message key="aca.Matricula" />: <strong><%= codigoId %></strong></li>
	    		<li><fmt:message key="aca.FechadeNacimiento"/>: <strong><%=alumPersonal.getFNacimiento() %></strong></li>
	    		<li><fmt:message key="aca.Nivel"/>: <strong><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, alumPersonal.getNivelId()) %></strong></li>
	    		<li><fmt:message key="aca.Grado"/>: <strong><%=alumPersonal.getGrado() %>°</strong></li>
	    		<li><fmt:message key="aca.Grupo"/>: <strong><%=alumPersonal.getGrupo() %></strong></li>
	    	</ul>
    	</div>
    	    	
    </div>
</div>

<script>
	$('.menuPrincipal').find('a[href="datos.jsp"]').addClass('selected');
</script>	
<%@ include file="../../../cierra_elias.jsp"%>