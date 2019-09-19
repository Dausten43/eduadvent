<%@ include file="../../con_elias.jsp"%>
<jsp:useBean id="EstadoL" scope="page" class="aca.catalogo.CatEstadoLista"/>
<jsp:useBean id="CiudadL" scope="page" class="aca.catalogo.CatCiudadLista"/>
<jsp:useBean id="BarrioL" scope="page" class="aca.catalogo.CatBarrioLista"/>
<%
	String tipo  	= request.getParameter("tipo");
	String PaisId 	= request.getParameter("PaisId");
	String EstadoId = request.getParameter("EstadoId");
	String CiudadId = request.getParameter("CiudadId");
	String BarrioId = request.getParameter("BarrioId");
		 
	if(tipo.equals("Estado")){
		ArrayList<aca.catalogo.CatEstado> lisEstado = EstadoL.getArrayList(conElias, PaisId, "ORDER BY 1,3");
		for(aca.catalogo.CatEstado estado: lisEstado){
%>
		<option value="<%=estado.getEstadoId() %>" ><%=estado.getEstadoNombre() %></option>
<%							
		}
	}else if(tipo.equals("Ciudad")){
		ArrayList<aca.catalogo.CatCiudad> lisCiudad = CiudadL.getArrayList(conElias, PaisId, EstadoId, "ORDER BY 4");
		for(aca.catalogo.CatCiudad ciudad: lisCiudad){
%>	
		<option value="<%=ciudad.getCiudadId() %>" ><%=ciudad.getCiudadNombre() %></option>
<%						
		}
	
	}else if(tipo.equals("Barrio")){
		ArrayList<aca.catalogo.CatBarrio> lisBarrio = BarrioL.getArrayList(conElias, PaisId, EstadoId,CiudadId, "ORDER BY BARRIO_NOMBRE");
		for(aca.catalogo.CatBarrio barrio: lisBarrio){
%>	
		<option value="<%=barrio.getBarrioId() %>" ><%=barrio.getBarrioNombre() %></option>
<%						
		}
	}
%>
 <%@ include file= "../../cierra_elias.jsp" %>