<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />

<script>
	function notas(cicloGrupoId, codigoAlumno) {
		document.location.href = "notas.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno + "&EvaluacionId=0";
	}

	function notasMetodo(cicloGrupoId, codigoAlumno) {
		document.location.href = "notasMetodo.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno + "&EvaluacionId=0";
	}

	function promedio(cicloGrupoId, codigoAlumno) {
		document.location.href = "promedio.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno;
	}
	
	function boletaAlumno(cicloGrupoId, codigoAlumno, empleadoId) {
		document.location.href = "boletaAlumno.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno+"&empleadoId" + empleadoId;
	}
	
	function boletaAlumnoPanama(cicloGrupoId, codigoAlumno, empleadoId) {
		document.location.href = "boletaAlumnoPanama.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno+"&empleadoId" + empleadoId;
	}
</script>

<%
	String codigoId 	= (String) session.getAttribute("codigoId");
	String cicloId 		= (String) session.getAttribute("cicloId");
	String cicloGrupoId = (String) request.getParameter("CicloGrupoId");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	
	String metodo 		= aca.catalogo.CatNivel.getMetodo(conElias, Integer.parseInt(Grupo.getNivelId()));
	
	ArrayList<String> lisAlum 	= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);
%>

<div id="content">
	<h2><fmt:message key="aca.Alumnos" /></h2>
	
	<div class="alert alert-info">
		<h4>
			<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%> |
			<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> <%=Grupo.getGrupo()%>
		</h4> 
		<strong><fmt:message key="aca.Maestro" />:</strong> <%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE")%>
	</div>
	
	<div class="well"> 
		<a class="btn btn-primary" href="grupo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>		
<%
		String tipoBoleta		= aca.catalogo.CatParametro.getTipoBoleta(conElias, session.getAttribute("escuela").toString());
		String boleta 			= "boleta.jsp";
		String boletaActividad 	= "boletaActividades.jsp";
		if(aca.catalogo.CatEsquemaLista.getEsquemaEvaluacionNivel(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId(), Grupo.getGrado()).equals("C")){/* SI EVALUA POR COMPETENCIA */
			boleta 			= "boletaCompetencias.jsp";
			boletaActividad = "boletaActividadCompetencias.jsp";
		}
		if(tipoBoleta.equals("3")){
			boleta = "boletaPanama.jsp";
		}
%>		
		<a class="btn btn-info" href="<%=boleta %>?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoleta" /></a>
		<a class="btn btn-info" href="<%=boletaActividad %>?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoletaConActividades" /></a>		
	</div>
		
	<table class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%" align="center">#</th>
				<th width="15%" align="center"><fmt:message key="aca.Matricula" /></th>
				<th width="60%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
				<th width="20%" align="center"><fmt:message key="aca.Boleta" /></th>
			</tr>
		</thead>		
<%
		int cont = 0;
		for (String codigoAlumno : lisAlum) {
			cont++;				
%>
			<tr>
				<td><%=cont%></td>
				<td><%=codigoAlumno%></td>
<%				
			if (metodo.equals("N")){
%>						
				<td>
					<a href="javascript:notas('<%=cicloGrupoId%>','<%=codigoAlumno%>');"><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></a>
				</td>
<%			}else{%>
				<td>
					<a href="javascript:notasMetodo('<%=cicloGrupoId%>','<%=codigoAlumno%>');"><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></a>
				</td>				
<%			}

			if (tipoBoleta.equals("3")){
%>						
				<td>
					<a href="javascript:boletaAlumnoPanama('<%=cicloGrupoId%>','<%=codigoAlumno%>','<%=Grupo.getEmpleadoId()%>');">Boleta</a>
				</td>
<%			}else{%>
				<td>
					<a href="javascript:boletaAlumno('<%=cicloGrupoId%>','<%=codigoAlumno%>','<%=Grupo.getEmpleadoId()%>');">Boleta</a>
				</td>				
<%			}%>				
			</tr>			
<%			  	
		} //fin de for
%>
	</table>

</div>

<%@ include file="../../cierra_elias.jsp"%>
