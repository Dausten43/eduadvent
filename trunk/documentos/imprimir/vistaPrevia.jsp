<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>
<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="Fecha" scope="page" class="aca.util.Fecha" />

<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	String constanciaId         = request.getParameter("constanciaId");
	String codigoId      		= request.getParameter("codigoId");
	
	AlumPersonal.mapeaRegId(conElias, codigoId);
	escuela.mapeaRegId(conElias, escuelaId);
	
	if(constanciaId == null){
		response.sendRedirect("documento.jsp");
	}

	AlumConstancia.mapeaRegId(conElias, constanciaId, escuelaId);
	
	/* NOMBRE GRADO */
	String gradoNombre = AlumPersonal.getGrado();
	if(AlumPersonal.getGrado().equals("1")){
		gradoNombre = "Primer";
	}else if(AlumPersonal.getGrado().equals("2")){ 
		gradoNombre = "Segundo";
	}else if(AlumPersonal.getGrado().equals("3")){
		gradoNombre = "Tercer";
	}else if(AlumPersonal.getGrado().equals("4")){
		gradoNombre = "Cuarto";
	}else if(AlumPersonal.getGrado().equals("5")){
		gradoNombre = "Quinto";
	}else if(AlumPersonal.getGrado().equals("6")){
		gradoNombre = "Sexto";
	}else if(AlumPersonal.getGrado().equals("7")){
		gradoNombre = "Septimo";
	}
	
	/* FORMATEAR TEXTO */
	String nivelNombreCorto = aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, AlumPersonal.getNivelId());
	String grado            = gradoNombre + " " + aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, AlumPersonal.getNivelId());
	String ciudad           = aca.catalogo.CatCiudad.getCiudad(conElias, escuela.getPaisId(), escuela.getEstadoId(), escuela.getCiudadId());
	String estado 			= aca.catalogo.CatEstado.getEstado(conElias, escuela.getPaisId(), escuela.getEstadoId());
	
	String dia  			= aca.util.NumberToLetter.convertirLetras( Integer.parseInt(Fecha.getDia(aca.util.Fecha.getHoy())) );
	String mes  			= Fecha.getMesNombre( aca.util.Fecha.getHoy() );
	String year  			= aca.util.NumberToLetter.convertirLetras( Integer.parseInt(Fecha.getYear(aca.util.Fecha.getHoy())) );
	
	
	/* CALIFICACIONES */
	String calificaciones 	= 	"<table>"+
									"<tr>"+
										"<th>#</th>"+
										"<th>Materia</th>"+
										"<th>Nota</th>"+
									"</tr>";
	int count = 0;							
	for(aoidoiaias){
		count++;
		calificaciones += 	"<tr>"+
								"<td>"+count+"</td>"+
								"<td>Materia</td>"+
								"<td>Nota</td>"+
							"</tr>";
	}
	calificaciones += "</table>";
	/* END CALIFICACIONES */
	
	
	String constanciaHTML = AlumConstancia.getConstancia();
	
	constanciaHTML = constanciaHTML.replaceAll("#Escuela", aca.catalogo.CatEscuela.getNombre(conElias, escuelaId).trim());
	constanciaHTML = constanciaHTML.replaceAll("#Codigo", codigoId.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Nombre", AlumPersonal.getNombre().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Paterno", AlumPersonal.getApaterno().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Materno", AlumPersonal.getAmaterno().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Curp", AlumPersonal.getCurp().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Nivel", nivelNombreCorto.toLowerCase().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Grado", grado.toLowerCase().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Grupo", AlumPersonal.getGrupo().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Ciudad", ciudad.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Estado", estado.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Fecha", aca.util.Fecha.getHoy().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Dia", dia.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Mes", mes.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Year", year.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Foto", "<img src='imagen.jsp?mat="+codigoId.trim()+"'/>");
	constanciaHTML = constanciaHTML.replaceAll("#Calificaciones", calificaciones);
	
	
	
%>

<link rel="stylesheet" href="../../js-plugins/ckeditor/contents.css"></link>

<div id="content">
	
	<%=constanciaHTML %>
	
</div>	



<%@ include file="../../cierra_elias.jsp" %>