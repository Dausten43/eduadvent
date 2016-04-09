<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>

<%
	String empleadoId 	= (String) session.getAttribute("codigoEmpleado");
	String cicloId		= (String) session.getAttribute("cicloId");
	String salto 		= "X";	
	
	if (!aca.ciclo.Ciclo.existeCiclo(conElias, cicloId)){
		// Elegir el mejor ciclo
		aca.ciclo.Ciclo.getMejorCarga(conElias, empleadoId);
		if (!cicloId.substring(0,3).equals(empleadoId.substring(0,3))){ 
			cicloId = aca.ciclo.Ciclo.getCargaActual(conElias, empleadoId.substring(0,3)); 
		}				
		session.setAttribute("cicloId", cicloId);
		
	}
	
	if(cicloGrupoCurso.existeMaestro(conElias, empleadoId)){
		salto = "cursos.jsp?Ciclo="+cicloId;
	}
	
%>
<div id="content">

	<div class="alert">	
		<fmt:message key="aca.NoEmpleadoSeleccionado" />	
	</div>
</div>
<%	if (!salto.equals("X")){%>
	<meta http-equiv='REFRESH' content='0; url=<%=salto%>'>
<%	}%>
<%@ include file= "../../cierra_elias.jsp" %>


