<%@ include file= "../../con_elias.jsp" %>

<jsp:useBean id="salon" scope="page" class="aca.catalogo.CatSalon"/>

<%

	String edificioId = request.getParameter("edificioId");
	
	salon.setEdificioId(edificioId);
	if(salon.existeEdificio(conElias)){
		out.print("existe");
	}else{
		out.print("noExiste");
	}

%>

<%@ include file= "../../cierra_elias.jsp" %>