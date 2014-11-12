<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>

<%
	String empleadoId 	= (String) session.getAttribute("codigoId");
	String cicloId		= (String) session.getAttribute("cicloId");	
	
	
	if (!aca.ciclo.Ciclo.existeCiclo(conElias, cicloId)){
		// Elegir el mejor ciclo
		aca.ciclo.Ciclo.getMejorCarga(conElias, empleadoId);
		if (!cicloId.substring(0,3).equals(empleadoId.substring(0,3))){ 
			cicloId = aca.ciclo.Ciclo.getCargaActual(conElias, empleadoId.substring(0,3)); 
		}				
		session.setAttribute("cicloId", cicloId);
		
	}
	
	if(cicloGrupoCurso.existeMaestro(conElias, empleadoId)){
			response.sendRedirect("cursos.jsp?Ciclo="+cicloId);
	}
	
%>
<%@ include file= "../../cierra_elias.jsp" %>