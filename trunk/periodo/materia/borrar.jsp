<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>


<script>
	
	function BorrarNotas(){				
		if ( confirm("<fmt:message key="js.ConfirmaBorrarNotas" />") ){
			document.frmBorrar.Accion.value = "1";		
			document.frmBorrar.submit();
		}
	}
	
	function BorrarAlumnos(){				
		if ( confirm("<fmt:message key="js.ConfirmaBorrarAlumnos" />") ){
			document.frmBorrar.Accion.value = "2";		
			document.frmBorrar.submit();
		}
	}
		
</script>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String cicloGrupoId		= request.getParameter("CicloGrupoId")==null?cicloId:request.getParameter("CicloGrupoId");
	CicloGrupo.mapeaRegId(conElias, cicloGrupoId);
	String cursoId			= request.getParameter("CursoId")==null?"x":request.getParameter("CursoId");
	int numAccion 			= Integer.parseInt(accion);	
	String nivelId 			= aca.plan.Plan.getNivel(conElias,planId);
	
	String resultado 		= "";
	
	boolean tieneEval 	= aca.kardex.KrdxAlumEval.tieneEvaluaciones(conElias, cicloGrupoId, cursoId);
	boolean tieneAct	= aca.kardex.KrdxAlumActiv.tieneAct(conElias, cicloGrupoId, cursoId);
	int numAlumnos 		= Integer.parseInt(aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoId, cursoId));
	int numEval			= aca.ciclo.CicloGrupoEval.getNumEval(conElias, cicloGrupoId, cursoId);
	int numActiv		= aca.ciclo.CicloGrupoActividad.getNumActividades(conElias, cicloGrupoId, cursoId);
	
	switch (numAccion){
		case 1: {		
			conElias.setAutoCommit(false);
			// Borrar las notas
			if ( tieneAct == false || aca.kardex.KrdxAlumActiv.deleteGrupoAct(conElias, cicloGrupoId, cursoId)){
				if ( tieneEval == false || aca.kardex.KrdxAlumEval.deleteGrupoEval(conElias, cicloGrupoId, cursoId)){
					if ( numActiv==0 || aca.ciclo.CicloGrupoActividad.deleteGrupoAct(conElias, cicloGrupoId, cursoId) ){
						if ( numEval==0 || aca.ciclo.CicloGrupoEval.deleteGrupoEval(conElias, cicloGrupoId, cursoId)){
							conElias.commit();
							
							// limpiar variables
							tieneAct	= false;
							tieneEval	= false;
							numActiv	= 0;
							numEval		= 0;
							
							resultado = "¡Se eliminó el esquema y las evaluaciones !";
							
						}else{
							conElias.rollback();
							resultado = "¡Error al borrar las evaluaciones!";
						}					
					}else{
						conElias.rollback();
						resultado = "¡Error al borrar las actividades!";
					}
				}else{
					conElias.rollback();
					resultado = "¡Error al borrar las notas de evaluaciones!";
				}
			}else{
				conElias.rollback();
				resultado = "¡Error al borrar las notas de las actividades!";
			}
			conElias.setAutoCommit(true);						
			break;
		}
		
		case 2: {
			conElias.setAutoCommit(false);
			
			// Borrar los alumnos registrados en la materia
			if (aca.kardex.KrdxCursoAct.deleteAlumGrupo(conElias, cicloGrupoId, cursoId)){
				conElias.commit();
				numAlumnos = 0;
				resultado = "¡Se eliminó el registro de los alumnos enlistados en la materia!";
			}else{				
				resultado = "¡Error al borrar las notas de las actividades!";
			}
			
			conElias.setAutoCommit(true);
			break;
		}
	}
		
%>

<style>
	label{
		font-size: 14px;
		font-weight: 800;
	}
	.p{
		font-size: 16px;
		font-weight: 300;
	}
</style>


<div id="content">

	<h2><fmt:message key="aca.EliminarRegistros" /></h2>
	
	<div class="alert alert-info">
		<%= CicloGrupo.getGrupoNombre() %> |
		<%= aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %>
	</div>
	
	<%if(!resultado.equals("")){ %>
		<div class="alert alert-success">
			<%=resultado%>
		</div>
	<%} %>
	
	<div class="well">
		<a class="btn btn-primary" href="materia.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<form name="frmBorrar" action="borrar.jsp" method="post">
		<input type="hidden" name="Accion"/>
		<input type="hidden" name="CicloGrupoId" value="<%= cicloGrupoId %>" />
		<input type="hidden" name="CursoId" value="<%= cursoId %>" />
		
		<p>
			<label for=""><fmt:message key="aca.Alumnos" /></label>
			<%= numAlumnos %>
		</p>
		
		<p>
			<label for=""><fmt:message key="aca.Evaluaciones" /></label>
			<%= numEval %>
		</p>
		
		<p>
			<label for=""><fmt:message key="aca.Actividades" /></label>
			<%= numActiv %>
		</p>
		
		<p>
			<label for=""><fmt:message key="aca.HayNotasEnLasEvaluaciones" /></label>
			<%=tieneEval?"Si":"No"%>
		</p>
		
		<p>
			<label for=""><fmt:message key="aca.HayNotasEnLasActividades" /></label>
			<%=tieneAct?"Si":"No"%>
		</p>
		
		<div class="well">
			<%if( numAlumnos > 0 && numEval == 0 ){ %>
		  		<a class="btn btn-danger btn-large" href="javascript:BorrarAlumnos();">
	      			<i class="icon-remove icon-white"></i> <fmt:message key="boton.EliminarAlumnos" />
	      		</a>
			<%}%>
			<a class="btn btn-danger btn-large" href="javascript:BorrarNotas();">
	      		<i class="icon-remove icon-white"></i> <fmt:message key="boton.EliminarNotasyEval" /> 
	      	</a>
		</div>
		
	</form>

</div>
<%@ include file= "../../cierra_elias.jsp" %>