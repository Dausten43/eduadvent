<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Modulo" scope="page" class="aca.ciclo.CicloGpoModulo" />
<jsp:useBean id="ModuloL" scope="page" class="aca.ciclo.CicloGpoModuloLista" />
<jsp:useBean id="TemaL" scope="page" class="aca.ciclo.CicloGpoTemaLista" />
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista" />
<jsp:useBean id="ArchivoL" scope="page" class="aca.ciclo.CicloGrupoArchivoLista" />
<%
	String codigoId 	= (String) session.getAttribute("codigoEmpleado");
	String cicloGrupo 	= "";
	String cursoId 		= "";
	if (request.getParameter("CicloGrupoId") != null) {
		session.setAttribute("cicloGrupoId", request.getParameter("CicloGrupoId"));
		session.setAttribute("cursoId", request.getParameter("CursoId"));
	}
	cicloGrupo 			= (String) session.getAttribute("cicloGrupoId");
	cursoId 			= (String) session.getAttribute("cursoId");
	String modulo2 		= request.getParameter("ModuloId") == null ? "0":request.getParameter("ModuloId");

	String cicloId 		= aca.ciclo.CicloGrupo.getCicloId(conElias, cicloGrupo);
	int numModulos 		= aca.ciclo.Ciclo.getModulos(conElias, cicloId);

	ArrayList<aca.ciclo.CicloGpoModulo> lisModulo	= ModuloL.getListCurso(conElias, cicloGrupo, cursoId, "ORDER BY ORDEN, MODULO_ID");
%>
<div id="content">
	<h2><fmt:message key="maestros.Planeacion" /> <small><%=aca.empleado.EmpPersonal.getNombre(conElias,codigoId, "NOMBRE")%></small></h2>

	<div class="alert alert-info">
		<h4><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupo)%></h4>
		<small><%=aca.plan.Plan.getNombrePlan(conElias, aca.plan.PlanCurso.getPlanId(conElias, cursoId))%></small> 
	</div>
	
	<div class="well">
	
		<a class="btn btn-primary" href="cursos.jsp"><i class="icon icon-th-list icon-white"></i> <fmt:message key="maestros.Cursos" /></a>	
		<%
			if (lisModulo.size() > 0) {
		%>
			<a class="btn btn-success" href="moduloTraspaso.jsp"><fmt:message key="maestros.TraspasarPlaneacion" /> <i class="icon-random icon-white"></i></a>
		<%
			}
		%>
	</div>
	
	<div class="well">
	<%
	if (lisModulo.size() < numModulos) {
	%>
		<a href="altaModulo.jsp?Accion=1" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.AnadirModulo" /></a> &nbsp; &nbsp;
	<%
	}
	for (int i = 0; i < lisModulo.size(); i++) {
		aca.ciclo.CicloGpoModulo mod = (aca.ciclo.CicloGpoModulo) lisModulo.get(i);
		if (modulo2.equals("0") && i == 0)
			modulo2 = mod.getModuloId();
	%>
			<a class="btn btn-info btn-mini <%if(modulo2.equals(mod.getModuloId()))out.print("active"); %>" href="modulo.jsp?ModuloId=<%=mod.getModuloId()%>"> <%=i+1%></a> 
			<a class="icon-pencil" href="altaModulo.jsp?ModuloId=<%=mod.getModuloId()%>" > </a> &nbsp;&nbsp;
	<%
		}
	%>
				
	</div>
	
	
<%
	Modulo.setCicloGrupoId(cicloGrupo);
	Modulo.setCursoId(cursoId);
	Modulo.setModuloId(modulo2);
	if (!modulo2.equals("0") && Modulo.existeReg(conElias)) {
		Modulo.mapeaRegId(conElias, cicloGrupo, modulo2, cursoId);
		ArrayList<aca.ciclo.CicloGpoTema> lisTema = TemaL.getListTemasModulo(conElias, cicloGrupo, cursoId, modulo2, "ORDER BY TO_CHAR(FECHA, 'YYYYMMDD') DESC, ORDEN DESC, MODULO_ID");	
		
		String descripcion = Modulo.getDescripcion();
%>

	<h3>
		<%=Modulo.getModuloNombre()%>
	</h3>
	
	<p><%=descripcion.equals("") ? "-" : descripcion%></p>
	
	<hr />
	
	<p>
		<a class="btn btn-info" href="tema.jsp?Accion=1&ModuloId=<%=Modulo.getModuloId()%>"><i class="icon-book icon-white"></i> <fmt:message key="boton.AnadirTema" /></a>
	</p>
	
	
<%
	for (int j = 0; j < lisTema.size(); j++) {
		aca.ciclo.CicloGpoTema tema = lisTema.get(j);
		ArrayList<aca.ciclo.CicloGrupoArchivo> lisArchivo = ArchivoL.getListTema(conElias, cicloGrupo, cursoId, tema.getTemaId(), " ORDER BY FOLIO");				
		ArrayList<aca.ciclo.CicloGrupoTarea> lisTarea = TareaL.getListTareasTema(conElias, cicloGrupo, cursoId, tema.getTemaId(), " ORDER BY TO_CHAR(FECHA,'YYYY/MM/DD'), TEMA_ID, TAREA_ID");
		
		
		String nomTema = tema.getTemaNombre();
		
		String desTema = tema.getDescripcion();
		if (desTema.length() > 85){
			desTema = desTema.substring(0, 82) + "...";	
		}
%>
		<div class="alert alert-info" style="">
			<h4>
				<%=nomTema.equals("") ? "-" : nomTema%> &nbsp; <%= tema.getFecha()!=null ? aca.util.Fecha.getFechaCorta(tema.getFecha()) : "dd/mmm/yy" %>
				<a href="tema.jsp?Accion=0&ModuloId=<%=Modulo.getModuloId()%>&TemaId=<%=tema.getTemaId()%>"><i class="icon-pencil"></i></a>
			</h4>
			<p style="margin:0;">
				<%=desTema.equals("") ? "-" : desTema%> 
			</p>
		</div>
		
		<div class="row" style="margin-left:10px;">
		  <div class="span7">
		  			<div class="alert">
				  		<h4>
				  			<fmt:message key="portal.Tareas" />  &nbsp;
				  			<a class="btn btn-mini" href="tarea.jsp?Accion=1&ModuloId=<%=Modulo.getModuloId()%>&TemaId=<%=tema.getTemaId()%>">
				  				<i class="icon-calendar"></i>
				  				<fmt:message key="boton.AnadirTareas" />
				  			</a>
				  		</h4>
			  		</div>
			  					  		
					<table class="table table-condensed table-stripped">
						<tr>
							<th style="width:100px;"><fmt:message key="aca.Tarea" /> </th>
							<th><fmt:message key="aca.Descripcion" /></th>
							<th style="width:100px;"><fmt:message key="aca.Fecha" /></th>
						</tr>
						<%
							for (int z = 0; z < lisTarea.size(); z++) {
								aca.ciclo.CicloGrupoTarea tarea = lisTarea.get(z);
								String nomTarea = tarea.getTareaNombre();
								String desTarea = tarea.getDescripcion();
						%>
							<tr>
								<td>
									<%=nomTarea.equals("") ? "-": nomTarea%>
									&nbsp;
									<a href="tarea.jsp?Accion=0&ModuloId=<%=Modulo.getModuloId()%>&TemaId=<%=tema.getTemaId()%>&Tarea=<%=tarea.getTareaId()%>"><i class="icon-pencil"></i></a>
								</td>
								<td><%=desTarea.equals("") ? "-": desTarea%></td>
								<td><%=aca.util.Fecha.getFechaCorta(tarea.getFecha())%></td>
							</tr>
						<% 
							}
						%>	
					</table>				
		  </div>
		  <div class="span4">
		  			<div class="alert">
				  		<h4>
				  			<fmt:message key="archivo.Recursos" /> &nbsp;
				  			<a  class="btn btn-mini" href="subir.jsp?ModuloId=<%=tema.getModuloId()%>&TemaId=<%=tema.getTemaId()%>">
				  				<i class="icon-file"></i>
				  				<fmt:message key="archivo.SubirRecursos" />
				  			</a>
				  		</h4>
				  	</div>
			  		<table class="table table-condensed table-stripped">
						<tr>
							<th><fmt:message key="aca.NombreDelArchivo" /></th>
						</tr>
						<%
							for (int h = 0; h < lisArchivo.size(); h++) {
								aca.ciclo.CicloGrupoArchivo archivo = lisArchivo.get(h);
						%>
							<tr>
								<td>
									<i onclick="borrarArchivo('<%=archivo.getTemaId()%>','<%=archivo.getFolio()%>');" class="icon-remove" style="cursor:pointer;"></i> 
									<a href="bajar.jsp?TemaId=<%=archivo.getTemaId()%>&Folio=<%=archivo.getFolio()%>"><i class="icon-download-alt"></i></a>
									<%=archivo.getNombre()%>
								</td>
							</tr>
						<% 
							}
						%>	
					</table>	
		  </div>
		</div>
<%		
		} // Termina for de Temas
	}
%>
</div>

<script>
	function borrarArchivo(temaId, folio){
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			location.href="borrar.jsp?TemaId="+temaId+"&Folio="+folio;
		}
	}
</script>

<%@ include file="../../cierra_elias.jsp"%>