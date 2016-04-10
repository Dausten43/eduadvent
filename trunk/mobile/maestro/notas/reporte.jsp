<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.text.*"%>

<%@page import="aca.ciclo.CicloGrupoCurso"%>

<jsp:useBean id="CicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval" />
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="CicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="EmpPersonalL" scope="page" class="aca.empleado.EmpPersonalLista" />
<jsp:useBean id="CicloBloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista" />

<head>
<script type="javascript">
		function materias(empleadoId,cicloId, nivelId, numMat){
			document.location.href="repMaterias.jsp?EmpleadoId="+empleadoId+"&CicloId="+cicloId+"&NivelId="+nivelId+"&NumMateria="+numMat;
		}
	</script>
</head>
<%
	DecimalFormat frmDecimal	= new DecimalFormat("##0.0;-##0.0");

	String escuelaId	= (String) session.getAttribute("escuela");
	String cicloId		= (String) session.getAttribute("cicloId");	
	String accion 		= request.getParameter("Accion")==null ? "0" : request.getParameter("Accion");
	String nivelId 		= request.getParameter("NivelId");	
	
	int totMatCiclo		= aca.ciclo.CicloGrupoCurso.numMatPorCicloyNivel(conElias, cicloId, nivelId);
	
	
	/*Lista de Evaluaciones (Bloques-Bimestres)*/
	ArrayList<aca.ciclo.CicloBloque> listaBloques = CicloBloqueLista.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
	
	/* Lista de empleados que imparten materias en el ciclo*/
	ArrayList<aca.empleado.EmpPersonal> lisMaestro 		= EmpPersonalL.getListMaestroxNivel(conElias,escuelaId, nivelId, cicloId, "ORDER BY CODIGO_ID");
	
	
	String mensaje = "";
	String mensajeError = "";
	boolean materiaCerrada= Boolean.parseBoolean(request.getParameter("Cerradas"));
	
	if(accion.equals("1")&&request.getParameter("Cerradas")!=null&&request.getParameter("EvaluacionId")!=null){
		conElias.setAutoCommit(false);
		boolean error = false;
		boolean matCerrada = Boolean.parseBoolean(request.getParameter("Cerradas"));
		String evaluacion = request.getParameter("EvaluacionId");
		for(int i=0; i<lisMaestro.size(); i++){
			aca.empleado.EmpPersonal maestro = lisMaestro.get(i);
	
			ArrayList<aca.ciclo.CicloGrupoCurso> listaMateriasMaestro = CicloGrupoCursoLista.getListMateriasEmpleadoxNivel(conElias, cicloId, maestro.getCodigoId(), nivelId, "ORDER BY CURSO_ID");

	 		for(aca.ciclo.CicloGrupoCurso materia : listaMateriasMaestro){
	 			CicloGrupoEval.mapeaRegId(conElias, materia.getCicloGrupoId(), materia.getCursoId(), evaluacion);
	 			if(matCerrada&&CicloGrupoEval.getEstado().equals("C")) CicloGrupoEval.setEstado("A");
	 			else if(!matCerrada&&CicloGrupoEval.getEstado().equals("A")) CicloGrupoEval.setEstado("C");
	 			
 				if(!CicloGrupoEval.updateReg(conElias)){
 					error = true;
 					break;
 				}
	 		}
		 	if(error) break;
		}
		if(error){
			mensajeError = "ErrorActualizarEvaluacion";
			conElias.rollback();
		}
		else{
			mensaje = "Evaluacion";
		}
		conElias.setAutoCommit(true);
		materiaCerrada = matCerrada;
	}
	pageContext.setAttribute("mensajeError",mensajeError);
	pageContext.setAttribute("mensaje",mensaje);	
		
	
	/*HashMap del total de cursos cerrados por EvaluacionId en todo el cicloId y nivel */
	java.util.HashMap<String,String> mapCerradosPorBloque	= aca.ciclo.CicloGrupoEvalLista.mapTotMatBloque(conElias, cicloId, nivelId, "'C'");	
	
	/*HashMap de total de cursos del maestro en el ciclo*/
	java.util.HashMap<String,String> mapCursosEmp		= aca.ciclo.CicloGrupoCursoLista.mapTotMatPorMaestro(conElias, cicloId, nivelId);	
	
	/*HashMap de cursos del maestro cerrados en cada evaluación*/
	java.util.HashMap<String,String> mapTotEmpBloque	= aca.ciclo.CicloGrupoEvalLista.mapEvalPorBloque(conElias, cicloId, nivelId, "C");
	
	/*HashMap de total de cursos cerrados por el maestro en el ciclo y nivel */
	java.util.HashMap<String,String> mapTotEmp		= aca.ciclo.CicloGrupoEvalLista.mapEvalPorMaestro(conElias, cicloId, nivelId, "C");	
%>
<body>
	<div id="content">
		<h2><fmt:message key="maestros.NotasporMaestros" /> <small>Ciclo: [<%=cicloId%>] &nbsp;<%=aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId)%></small></h2>
		<div class="well" style="overflow: hidden;">
			<a href="menuNivel.jsp" class="btn btn-primary"><i
				class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>

		<h4><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId)%></h4>
		<table width="100%" align="center" class="table table-hover">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Clave" /></th>
				<th><fmt:message key="aca.Maestro" /></th>
				<th># <fmt:message key="aca.Mat" /></th>
				<%
					for(aca.ciclo.CicloBloque bloque : listaBloques){
				%>
				<th><%=bloque.getBloqueId()%>° <fmt:message key="aca.Eval" />
					<div id="btn<%=bloque.getBloqueId()%>"></div></th>
				<%
					}
				%>
				<th>%</th>
			</tr>
<%
			// Determina si hay materias abiertas en el bloque
			for(aca.ciclo.CicloBloque bloque : listaBloques){
				boolean materiasCerradas = false;
				
				/*Busca la cantidad de materias cerradas en el bloque*/
				int cerradasBloque = 0;
				if (mapCerradosPorBloque.containsKey(bloque.getBloqueId())){
					cerradasBloque = Integer.parseInt( mapCerradosPorBloque.get(bloque.getBloqueId()) );
					if ( cerradasBloque==totMatCiclo){
						materiasCerradas = true;
					}
				}				
%>
			<script>
				document.getElementById('btn<%=bloque.getBloqueId()%>').innerHTML='<input onclick=\'document.location.href=\"reporte.jsp?Accion=1&EvaluacionId=<%=bloque.getBloqueId()%>&NivelId=<%=nivelId%>&Cerradas=<%=materiasCerradas%>\"\' style=\'cursor:pointer;\' class=\'btn btn-primary\' type=\'button\' value=\'<%=materiasCerradas?"Abrir":"Cerrar"%>\'>';
			</script>
			<%
			}

			for (int i=0; i < lisMaestro.size(); i++){
				aca.empleado.EmpPersonal maestro = lisMaestro.get(i);			
				
				/* Cuenta las materias que imparte un maestro en el ciclo y nivel */
				int totMatEmp = 0;
				if (mapCursosEmp.containsKey(maestro.getCodigoId())){
					totMatEmp = Integer.parseInt( mapCursosEmp.get(maestro.getCodigoId()) );
				}
				
				/* Cuenta el total de materias cerradas del maestro en todos los bloque del ciclo */
				int totEmpCerradas = 0;
				if ( mapTotEmp.containsKey( maestro.getCodigoId() ) ){
					totEmpCerradas = Integer.parseInt( mapTotEmp.get( maestro.getCodigoId() ) );
				}
				
				// Cuenta el total de ocaciones en que el empleado debe cerrar las materias en el ciclo 
				int totMatEmpCiclo = listaBloques.size()*totMatEmp;
				
				// Avance de materias cerradas
				double avance = 0;
				if (totMatEmpCiclo>0)
					avance 	= (double)(totEmpCerradas*100)/totMatEmpCiclo;			
			%>
			<tr class="button"
				onclick="materias('<%=maestro.getCodigoId()%>','<%=cicloId%>','<%=nivelId%>');" style="cursor:pointer;">
				<td align="center"><%=i + 1%></td>
				<td align="center"><%=maestro.getCodigoId()%></td>
				<td align="left"><%=maestro.getNombre()+" "+maestro.getApaterno()+" "+maestro.getAmaterno()%></td>
				<td align="center"><%=totMatEmp%></td>
			<%
				for(aca.ciclo.CicloBloque bloque : listaBloques){
					
					int totMatEmpBloque = 0;
					if (mapTotEmpBloque.containsKey(maestro.getCodigoId()+bloque.getBloqueId()) ){
						totMatEmpBloque = Integer.parseInt( mapTotEmpBloque.get( maestro.getCodigoId()+bloque.getBloqueId() ) );
					}					
			%>
				<td align="center"><%=totMatEmpBloque%></td>
			<%
				}
			%>
				<td align="center"><%=frmDecimal.format(avance)%></td>
			</tr>
<%
			}
%>
		</table>
<%  
	if(!mensajeError.equals("")){
%>
		<div class="alert alert-danger"><fmt:message key="aca.${mensajeError}" /></div> 
<%	
	}
%>
<%  
	if(!mensaje.equals("")){
%>
		<div class="alert"><fmt:message key="aca.${mensaje}" /><%=materiaCerrada?"abierto":"cerrado" %></div> 
<%	
	}
%>
		<table>
			<td align="center"><%=mensaje%></td>
		</table>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
