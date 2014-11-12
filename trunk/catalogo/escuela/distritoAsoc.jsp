<%@ include file= "../../con_elias.jsp" %>

<jsp:useBean id="distrito" scope="page" class="aca.catalogo.CatDistrito"/>
<jsp:useBean id="distritoL" scope="page" class="aca.catalogo.CatDistritoLista"/>

<%

	String asocId = request.getParameter("asocId");
	ArrayList<aca.catalogo.CatDistrito> listDistritos = distritoL.getListAsociacion(conElias, asocId, "ORDER BY DISTRITO_ID");
	
%>
	<option value="">No aplica</option>
	<%for(aca.catalogo.CatDistrito distritos : listDistritos){%>
		<option value="<%=distritos.getDistritoId()%>"><%=distritos.getDistritoNombre() %></option>	
	<%} %>
	
<%@ include file= "../../cierra_elias.jsp" %>