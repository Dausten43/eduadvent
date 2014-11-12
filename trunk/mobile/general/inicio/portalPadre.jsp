<%@ include file="../../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="aca.alumno.AlumPadres"%>


<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<head>
<%
	String escuelaId	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoId");
	
	ArrayList<aca.alumno.AlumPadres> lisAlumPadres = alumPadresLista.getListTutor(conElias, codigoId, "ORDER BY 1");
	
%>
</head>
<body>

<div data-role="page">
	<%@ include file="../../menu.jsp"%>
	<div data-role="header">
    	<a href="#menu" class="ui-btn ui-shadow ui-corner-all ui-icon-bars ui-btn-icon-notext"></a>
    	<h1></h1>
    </div>
	<div data-role="content">
		<center>
			<h2><fmt:message key="portal.SeleccionaHijo" /></h2>
		</center>
		<br>
		<ul data-role="listview">
		<%
			for(int i = 0; i < lisAlumPadres.size(); i++){
				alumPadres = (AlumPadres) lisAlumPadres.get(i);
				alumPersonal.mapeaRegId(conElias, alumPadres.getCodigoId());
		%>
			
			<li onclick="javascript:refresca('<%=alumPersonal.getCodigoId()%>');"><a href="#"><%=alumPersonal.getNombre() %> <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %></a></li>
			
		<%
			}
		%>
    	</ul>
    </div>
	</div>
</div>
	
<script>
	function refresca(codigoId){
		document.location = "datos.jsp?Accion=1&codigo="+codigoId;
	}
</script>
	

</body>


<%@ include file="../../../cierra_elias.jsp"%>