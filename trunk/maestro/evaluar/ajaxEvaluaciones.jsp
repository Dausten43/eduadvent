<%@ include file="../../con_elias.jsp"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.ciclo.CicloGrupoCursoLista"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.reflect.Type"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="java.util.List"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.ciclo.CicloGrupoActividad"%>

<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="cicloPromedioLista" scope="page" class="aca.ciclo.CicloPromedioLista" />
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="cicloGrupoActividad" scope="page" class="aca.ciclo.CicloGrupoActividad" />
<%
	

	String empleadoId 	= request.getParameter("codigoId");
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String tipo 		= request.getParameter("tipo");

	String cicloId 		= request.getParameter("cicloId");
	String cursoId 		= request.getParameter("cursoId");
	String promedioId 	= request.getParameter("promedioId");
	String evaluacionId = request.getParameter("evaluacionId");
	
	
	if(tipo.equals("curso")){
		ArrayList<CicloGrupoCurso> listCursos = cicloGrupoCursoLista.getListMateriasEmpleado(conElias, cicloId, empleadoId, "ORDER BY CURSO_ID");
		
		String materia = "";
		for (CicloGrupoCurso cicloGrupoCurso: listCursos){
			materia = PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
			cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());
	%>
			<option value="<%= cicloGrupoCurso.getCursoId()%>" data-ciclo-grupo-id="<%= cicloGrupo.getCicloGrupoId() %>" ><%=cicloGrupo.getGrupoNombre() %> <%=cicloGrupo.getGrupo() %> | <%= materia %></option>
	
	<%	
		}
	}
	
	else if(tipo.equals("promedio")){
		ArrayList<aca.ciclo.CicloPromedio> listPromedio 		= cicloPromedioLista.getListPromedioCiclo(conElias, cicloId," ORDER BY ORDEN");
		
		for (aca.ciclo.CicloPromedio cicloPromedio: listPromedio){
	%>
			<option value="<%= cicloPromedio.getPromedioId()%>" ><%= cicloPromedio.getNombre() %></option>
	
	<%
		}
	}
	
	else if(tipo.equals("evaluacion")){
		ArrayList<aca.ciclo.CicloGrupoEval> listEvaluaciones 		= cicloGrupoEvalLista.getArrayListPorPromedio(conElias, cicloGrupoId, cursoId, promedioId," ORDER BY ORDEN");

		for (aca.ciclo.CicloGrupoEval cicloEval: listEvaluaciones){
			//Si tiene actividades o esta cerrada no se le permite transferir
			if(cicloEval.getEstado().equals("C")){
	%>
				<option value="<%= cicloEval.getEvaluacionId()%>" disabled style="color:#ed837b;"><del><%= cicloEval.getEvaluacionNombre() %></del></option>
	<%
			}else {
	%>	
				<option value="<%= cicloEval.getEvaluacionId()%>" ><%= cicloEval.getEvaluacionNombre() %></option>
	<%
			}
		}
	}
	
	else if(tipo.equals("guardar")){
		boolean isOk = false;
		response.setContentType("application/json");
		response.setHeader("Content-Disposition", "inline");
		
		String listActividades = request.getParameter("listaActividades");
		String[] lista = request.getParameterValues("listaid[]");
		
		Type listType = new TypeToken<List<CicloGrupoActividad>>(){}.getType();
		List<CicloGrupoActividad> listAct = new Gson().fromJson(listActividades, listType);
		
		int i=0;
		for(CicloGrupoActividad act: listAct){
			if(act.getActividadId().equals(lista[i])){
			
				cicloGrupoActividad.setCicloGrupoId(cicloGrupoId);
				cicloGrupoActividad.setCursoId(cursoId);
				cicloGrupoActividad.setEvaluacionId(evaluacionId);
				cicloGrupoActividad.setActividadId(cicloGrupoActividad.maximoReg(conElias));
				cicloGrupoActividad.setActividadNombre(act.getActividadNombre());
				cicloGrupoActividad.setValor(act.getValor());
				cicloGrupoActividad.setTipoactId(act.getTipoactId());
				cicloGrupoActividad.setEtiquetaId(act.getEtiquetaId().equals("") ? null : act.getEtiquetaId());
				cicloGrupoActividad.setMostrar(act.getMostrar());
				cicloGrupoActividad.setFecha(act.getFecha());
				
				if(cicloGrupoActividad.insertReg(conElias))
					isOk = true;
				
				if(lista.length == i + 1) break;
				i++;
			}
		}
		
		%>
		{
			"isOk":<%=isOk%>
		}
		<%

	}
	%>

<%@ include file= "../../cierra_elias.jsp" %>
