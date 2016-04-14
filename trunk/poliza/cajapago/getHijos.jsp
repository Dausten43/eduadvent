<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../idioma.jsp" %>

<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="AlumPersonalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>

<%
	String codigoId 	= request.getParameter("padre");
	String alumno 		= request.getParameter("alumno");
	String escuelaId 	= (String) session.getAttribute("escuela");

	ArrayList<aca.alumno.AlumPadres> lisAlumPadres = alumPadresLista.getListTutor(conElias, codigoId, "ORDER BY 1");	
%>
		<option value="0">Elegir</option>
<%	
	for(aca.alumno.AlumPadres alum : lisAlumPadres){
%>
		<option value="<%=alum.getCodigoId()%>">
			<%=alum.getCodigoId()%> | <%=aca.alumno.AlumPersonal.getNombre(conElias, alum.getCodigoId(), "NOMBRE") %>
		</option>
<%		
	}
	
	
	if(codigoId.equals("0")){
		ArrayList<aca.alumno.AlumPersonal> alumnos = AlumPersonalLista.getListAllNombres(conElias, escuelaId, "");
		for(aca.alumno.AlumPersonal alum : alumnos){
%>
			<option value="<%=alum.getCodigoId()%>">
				<%=alum.getCodigoId()%> | <%=aca.alumno.AlumPersonal.getNombre(conElias, alum.getCodigoId(), "NOMBRE") %>
			</option>
<%		
		}	
	}
	
%>

<%@ include file= "../../cierra_elias.jsp" %>