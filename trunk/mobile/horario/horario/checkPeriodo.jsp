<%@ include file= "../../con_elias.jsp" %>

<jsp:useBean id="periodo" scope="page" class="aca.catalogo.CatHorarioPeriodo"/>

<%

	String horarioId = request.getParameter("horarioId");
	String periodoId = request.getParameter("periodoId");
	
	periodo.setHorarioId(horarioId);
	periodo.setPeriodoId(periodoId);
	if(periodo.existeReg(conElias)){
		periodo.mapeaRegId(conElias, horarioId, periodoId);
		
		out.print(periodo.getHoraInicio()+":"+periodo.getMinInicio()+":"+periodo.getHorafin()+":"+periodo.getMinfin());
	}else{
		out.print("00:00:00:00");
	}

%>

<%@ include file= "../../cierra_elias.jsp" %>