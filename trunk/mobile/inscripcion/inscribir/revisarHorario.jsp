<%@ include file= "../../con_elias.jsp" %>

<jsp:useBean id="cicloGrupoHorarioL" scope="page" class="aca.ciclo.CicloGrupoHorarioLista"/>
<jsp:useBean id="GrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>

<%
	String codigoAlumno 	= (String) session.getAttribute("codigoAlumno");
	String escuelaId 		= (String) session.getAttribute("escuela");
	String planAlumno		= aca.alumno.AlumPlan.getPlanActual(conElias,codigoAlumno);
	String nivelAlumno		= String.valueOf(aca.alumno.AlumPlan.getNivelAlumno(conElias,codigoAlumno));
	String cicloId			= (String) session.getAttribute("cicloId");
	
	Alumno.mapeaRegId(conElias,codigoAlumno);
	String	cicloGrupoId 								= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias,nivelAlumno,Alumno.getGrado(),Alumno.getGrupo(),cicloId,planAlumno);

	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso 	= GrupoCursoL.getListMateriasGrupo(conElias, cicloGrupoId, " ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	
	/* LAS MATERIAS QUE SELECCIONO PARA INSCRIBIRSERLAS AL ALUMNO */
	ArrayList<String> cursosSeleccionados 				= new ArrayList<String>();
	
	for(int i=0; i<lisGrupoCurso.size(); i++){
		aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(i);
		
		String checkBox = request.getParameter("Check"+i)==null?"N":"S";
		if(checkBox.equals("S")){
			cursosSeleccionados.add(grupoCurso.getCursoId());
		}
	}
	
	/* TRAER EL HORARIO CON TODOS LOS PERIODOS DEL GRUPO */
	ArrayList<String> getListPeriodosHorariosAlumno	= cicloGrupoHorarioL.getListPeriodosHorariosAlumno(conElias, escuelaId, cicloGrupoId, "");
	
	/* FILTRAR SOLO LOS QUE SELECCIONO PARA INSCRIBIR */
	ArrayList<String> getListPeriodosHorariosAlumnoSoloLosQueSelecciono	= cicloGrupoHorarioL.getListPeriodosHorariosAlumno(conElias, escuelaId, cicloGrupoId, "");
	for(String str : getListPeriodosHorariosAlumno){
		String cursoIdActual		= str.split("@@")[0];
		
		if(cursosSeleccionados.contains(cursoIdActual)){
			getListPeriodosHorariosAlumnoSoloLosQueSelecciono.add(str);
		}
	}
	
	/* REVISAR SI CHOCAN ENTRE SI LAS MATERIAS QUE VA A INSCRIBIR */
	boolean chocaHorario = false;

	mainFor:
	for(String str : getListPeriodosHorariosAlumnoSoloLosQueSelecciono){
		String cursoIdActual		= str.split("@@")[0];
		int horaInicioActual		= Integer.parseInt( str.split("@@")[4] );
		int horaFinalActual			= Integer.parseInt( str.split("@@")[5] );
			
		for(String str2 : getListPeriodosHorariosAlumnoSoloLosQueSelecciono){
			String cursoIdOtro			= str2.split("@@")[0];
			int horaInicioOtro			= Integer.parseInt( str2.split("@@")[4] );
			int horaFinalOtro			= Integer.parseInt( str2.split("@@")[5] );
			
			if( cursoIdActual.equals(cursoIdOtro) == false ){

				if ( 
						( horaInicioActual >= horaInicioOtro && horaInicioActual < horaFinalOtro ) ||
						( horaFinalActual > horaInicioOtro && horaFinalActual <= horaFinalOtro ) ||
						( horaInicioActual <= horaInicioOtro && horaFinalActual >= horaFinalOtro )
					){	
					chocaHorario = true; break mainFor;
				}
				
			}
		}	
		
	}
	
	
	if( chocaHorario ){
		out.print("chocaHorario");
	}else{
		out.print("noChoca");
	}
%>


<%@ include file= "../../cierra_elias.jsp" %>