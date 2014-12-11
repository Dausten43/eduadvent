<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>
<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="Fecha" scope="page" class="aca.util.Fecha" />
<jsp:useBean id="alumPlanLista" scope="page" class="aca.alumno.AlumPlanLista"/>
<jsp:useBean id="CursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="AlumnoCursoLista" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>

<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	String constanciaId         = request.getParameter("constanciaId");
	String codigoId      		= request.getParameter("codigoId");
	
	String planId				= request.getParameter("plan")==null?aca.alumno.AlumPlan.getPlanActual(conElias, codigoId):request.getParameter("plan");
	
	
	AlumPersonal.mapeaRegId(conElias, codigoId);
	escuela.mapeaRegId(conElias, escuelaId);
	
	/* Planes de estudio del alumno */
	ArrayList<aca.alumno.AlumPlan> lisPlan			= alumPlanLista.getArrayList(conElias, codigoId, "ORDER BY F_INICIO");
	
	/* Array de Bloques de la materia */
	ArrayList<aca.ciclo.CicloBloque> lisBloque		= new ArrayList<aca.ciclo.CicloBloque>();
	
	/* Materias o cursos del plan de estudio del alumno */
	ArrayList<aca.plan.PlanCurso> lisCurso 			= CursoLista.getListCurso(conElias, planId," AND (CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_IMP WHERE CODIGO_ID = '"+codigoId+"') OR CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"')) ORDER BY GRADO, TIPOCURSO_ID, ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE");
	
	/* Notas de alumno en las materias */
	ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso = AlumnoCursoLista.getListAll(conElias, escuelaId, "AND CODIGO_ID = '"+codigoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
	
	//TreeMap de los promedios del alumno en la materia
	java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm 	= AlumPromLista.getTreeAlumno(conElias, codigoId,"");	
	
	
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
	
	int block 					= 0;
	int gradoTemp				= 0;
	
	
	/* CALIFICACIONES */
	String calificaciones 	= 	"<table width='50%'>"+
									"<tr>"+
										"<th width='1%' align='left'>#</th>"+
										"<th width='5%' align='left'>Clave</th>"+
										"<th width='10%' align='left'>Materia</th>"+
										"<th width='1%' align='left' colspan='2'>Calificacion</th>"+
										"<th width='5%'>Ciclo Escolar</th>"+
									"</tr>"
									
									;
	int count = 0;			
	
	float [] sumaPorBimestre 	= {0,0,0,0,0,0,0,0,0,0};
	int [] materiasSinNota 		= {0,0,0,0,0,0,0,0,0,0};
	int cantidadMaterias	 	= 0;
	
	System.out.println(lisBloque.size()+" "+"Subjects: "+lisCurso.size());
	
	for(aca.plan.PlanCurso curso : lisCurso){
		
		for(aca.vista.AlumnoCurso alumnoCurso : lisAlumnoCurso){
		
		if(curso.getGrado() != null && curso.getGrado() != ""){
			block = Integer.parseInt(curso.getGrado());			
		}
		
 
		
		
		
	
		}
		
		
		
		for(int l = 0; l < lisBloque.size(); l++){ 
			if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
				int cantidadMateriasTmp = cantidadMaterias;
				cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];

				sumaPorBimestre[l] = sumaPorBimestre[l]/(cantidadMateriasTmp);
			}

		}
		
		
		count++;
		calificaciones += 	"<tr>"+
								"<td>"+count+"</td>"+
								"<td>"+curso.getCursoId()+"</td>"+
								"<td>"+curso.getCursoNombre()+"</td>"+
								
								"<td align='left'>"+block+"</td>"+
							    "<td> siete </td>"+
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