<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="CursoAct" scope="page" class="aca.kardex.KrdxCursoAct" />

<script>
	function notas(cicloGrupoId, codigoAlumno) {
		document.location.href = "notas.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno + "&EvaluacionId=0";
	}	
</script>

<%
	String cicloId 			= (String) session.getAttribute("cicloId");
	String cicloGrupoId 	= (String) request.getParameter("CicloGrupoId");
	String cursoId 			= (String) request.getParameter("CursoId");	
	String editar 			= request.getParameter("editar")==null?"0":request.getParameter("editar");
	String Resultado 		= "";
	String accion			= request.getParameter("accion")==null?"0":request.getParameter("accion");
	ArrayList<aca.kardex.KrdxCursoAct> lisAlum 	= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId, cursoId, " ORDER BY ORDEN, ALUM_APELLIDO(CODIGO_ID)");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	
	if(accion.equals("1")){
		for (aca.kardex.KrdxCursoAct kca : lisAlum){
			CursoAct.setCicloGrupoId(cicloGrupoId);
			CursoAct.setCodigoId(kca.getCodigoId());
			CursoAct.setCursoId(cursoId);
			
			String orden = request.getParameter("Orden"+kca.getCodigoId());
			CursoAct.setOrden(orden);
			if (!orden.equals("")){
					if (CursoAct.updateOrden(conElias)){ 
						Resultado = "1";
						conElias.commit();
					}else{
						Resultado = "2";
					}
			}
			
		}
	}
	
	lisAlum 	= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId, cursoId, " ORDER BY ORDEN, ALUM_APELLIDO(CODIGO_ID)");
	
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
	<br>
	<%if(Resultado.equals("1")){ %>
	<div class="alert alert-info">Los Datos han sido Modificados Correctamente</div>
	<%}else if(Resultado.equals("2")){ %>
	<div class="alert alert-danger">No Cambió</div>
	<%} else if(Resultado.equals("3")){ %>
	<div class="alert alert-danger">Ya existe el registro</div>
	<%} %>
	<div class="well"> 
		<a class="btn btn-primary" href="cursos.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	<form action="lista.jsp?accion=1&CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>" method="post" name="forma" target="_self">
	<table class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%" align="center"><fmt:message key="aca.Orden" /></th>				
				<th width="15%" align="center"><fmt:message key="aca.Matricula" /></th>
				<th width="50%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
				<th width="10%" align="center"><fmt:message key="aca.Orden" /> <a href="lista.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>&editar=1"> <i class="icon icon-pencil"></i></a></th>
			</tr>
		</thead>
		
<%
		int cont = 0;
		for (aca.kardex.KrdxCursoAct kca : lisAlum){
			cont++;
%>
		<tr>
			<td><%=cont%></td>
			<td><%=kca.getCodigoId()%></td>					
			<td>
				<%=aca.alumno.AlumPersonal.getNombre(conElias, kca.getCodigoId(), "APELLIDO")%>
			</td>
			<td>
			<%if(editar.equals("1")){%>
			<input type="text" id="Orden<%= kca.getCodigoId()%>" name="Orden<%= kca.getCodigoId() %>" value="<%=kca.getOrden() %>" />
			<%}else{ %>
			<%=kca.getOrden()%>
			<%} %>
			</td>
		</tr>			
<%			  	
		} //fin de for
%>
	</table>
	<div class="well" ><input class="btn btn-primary" type="submit" value="Guardar" /></div>
	</form>
	
</div>
<%@ include file="../../cierra_elias.jsp"%>
