<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="Modulo" scope="page" class="aca.ciclo.CicloGpoModulo"/>
<jsp:useBean id="ModuloL" scope="page" class="aca.ciclo.CicloGpoModuloLista"/>
<jsp:useBean id="TemaL" scope="page" class="aca.ciclo.CicloGpoTemaLista"/>
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista"/>
<jsp:useBean id="ArchivoL" scope="page" class="aca.ciclo.CicloGrupoArchivoLista"/>
<%
	
	String codigoId 	= (String)session.getAttribute("codigoId");
	String cicloGrupo 	= "";
	String cursoId 		= "";	
	if (request.getParameter("cicloGrupoId")!=null){
		session.setAttribute("cicloGrupoId", request.getParameter("cicloGrupoId"));
		session.setAttribute("cursoId", request.getParameter("cursoId"));
	}	
	cicloGrupo 			= (String) session.getAttribute("cicloGrupoId");
	cursoId 			= (String) session.getAttribute("cursoId");	
	String modulo 		= request.getParameter("ModuloId")==null?"0":request.getParameter("ModuloId");
	
	String cicloIdM		= aca.ciclo.CicloGrupo.getCicloId(conElias,cicloGrupo);
	int numModulos 		= aca.ciclo.Ciclo.getModulos(conElias,cicloIdM);
	String maestro 		= aca.ciclo.CicloGrupoCurso.getMaestro(conElias, cicloGrupo, cursoId);	
	
	ArrayList lisModulo = ModuloL.getListCurso(conElias, cicloGrupo, cursoId, "ORDER BY ORDEN, MODULO_ID");
%>
<head>
</head>
<body>
	
<div id="content">	
  
  <h2><fmt:message key="maestros.Planeacion"/> <small><%= aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %></small></h2>
  
  <div class="well">
  	<a href="materias.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>	
  </div>

  
  <div class="alert"><b><fmt:message key="aca.Maestro"/>:</b>&nbsp; <%= aca.empleado.EmpPersonal.getNombre(conElias,maestro,"NOMBRE") %></div>
    
  
  <div class="well">
<%	
	for (int i=0;i<lisModulo.size();i++){
		aca.ciclo.CicloGpoModulo mod = (aca.ciclo.CicloGpoModulo) lisModulo.get(i);
		if (modulo.equals("0") && i==0) modulo = mod.getModuloId(); 
%>		
		  <a class="btn btn-info <%if(modulo.equals(mod.getModuloId()))out.print("active"); %>" href="modulo.jsp?ModuloId=<%=mod.getModuloId()%>"> <%=i+1%></a>
<%	}%>  
  </div>
<% 	
	Modulo.setCicloGrupoId(cicloGrupo);
	Modulo.setCursoId(cursoId);
	Modulo.setModuloId(modulo);
	if ( !modulo.equals("0") && Modulo.existeReg(conElias)==true ){
 		Modulo.mapeaRegId(conElias, cicloGrupo, modulo, cursoId);
 		ArrayList<aca.ciclo.CicloGpoTema> lisTema 	= TemaL.getListTemasModulo(conElias, cicloGrupo, cursoId, modulo, "ORDER BY TO_CHAR(FECHA, 'YYYYMMDD'), ORDEN, MODULO_ID");
 		
 		String descripcion = Modulo.getDescripcion();
%>
		<h3>
			<%=Modulo.getModuloNombre()%>
		</h3>
		
		<p><%=descripcion.equals("") ? "-" : descripcion%></p>
		
		<hr />


<%
		for (int j = 0; j < lisTema.size(); j++) {
			aca.ciclo.CicloGpoTema tema = lisTema.get(j);
			ArrayList<aca.ciclo.CicloGrupoArchivo> lisArchivo = ArchivoL.getListTema(conElias, cicloGrupo, cursoId, tema.getTemaId(), " ORDER BY FOLIO");				
			ArrayList<aca.ciclo.CicloGrupoTarea> lisTarea = TareaL.getListTareasTema(conElias, cicloGrupo, cursoId, tema.getTemaId(), " ORDER BY FECHA, TEMA_ID, TAREA_ID");
			
			String nomTema = tema.getTemaNombre();
			
			String desTema = tema.getDescripcion();
%>
			<div class="alert alert-info" style="">
				<h4>
					<%=nomTema.equals("") ? "-" : nomTema%> &nbsp; <%= tema.getFecha()!=null ? tema.getFecha() : "yyyy/mm/dd" %>
				</h4>
				<p style="margin:0;">
					<%=desTema.equals("") ? "-" : desTema%> <br />
				</p>
			</div>
			
			<div class="row" style="margin-left:10px;">
			  <%if(lisTarea.size()>0){ //SI TIENE TAREAS%>
			  <div class="span7">
			  			<div class="alert">
					  		<h4>
					  			<fmt:message key="portal.Tareas" /> 
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
									</td>
									<td><%=desTarea.equals("") ? "-": desTarea%></td>
									<td><%=aca.util.Fecha.getFechaCorta(tarea.getFecha())%></td>
								</tr>
							<% 
								}
							%>	
						</table>				
			  </div>
			  <%} %>
			  
			  <%if(lisArchivo.size()>0){ //SI TIENE ARCHIVOS%>
			  <div class="span4">
			  			<div class="alert">
					  		<h4>
					  			<fmt:message key="archivo.Archivos" />
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
										<a href="bajar.jsp?TemaId=<%=archivo.getTemaId()%>&Folio=<%=archivo.getFolio()%>"><i class="icon-download-alt"></i></a>
										<%=archivo.getNombre()%>
									</td>
								</tr>
							<% 
								}
							%>	
						</table>	
			  </div>
			  <%} %>
			</div>
<%		
		} // Termina for de Temas
	} %>

</div>

</body>

<script>
	jQuery('.materias').addClass('active');
</script>
<%@ include file= "../../cierra_elias.jsp" %>