<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%
	int nAccion			= Integer.parseInt(request.getParameter("Accion"));
	String escuelaId	= request.getParameter("EscuelaId");
	String sSalto		= "";
	sSalto				= "elegir.jsp";

	switch(nAccion){
		case 1:{
			session.setAttribute("escuela", escuelaId);
			response.sendRedirect(sSalto); 
			break;
		}
	}
%>
<%@ include file= "../../cierra_elias.jsp" %> 