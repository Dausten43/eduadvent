<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.plan.Plan"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>

<jsp:useBean id="Modulo" scope="page" class="aca.ciclo.CicloGpoModulo"/>
<jsp:useBean id="ModuloL" scope="page" class="aca.ciclo.CicloGpoModuloLista"/>
<jsp:useBean id="Tema" scope="page" class="aca.ciclo.CicloGpoTema"/>
<jsp:useBean id="TemaL" scope="page" class="aca.ciclo.CicloGpoTemaLista"/>
<jsp:useBean id="Tarea" scope="page" class="aca.ciclo.CicloGrupoTarea"/>
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista"/>
<jsp:useBean id="Archivo" scope="page" class="aca.ciclo.CicloGrupoArchivo"/>
<jsp:useBean id="ArchivoL" scope="page" class="aca.ciclo.CicloGrupoArchivoLista" />


<%
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	String codigoId 	= (String)session.getAttribute("codigoId");
	String cicloId 		= request.getParameter("Ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("Ciclo");

	empPersonal.mapeaRegId(conElias, codigoId);
	String maestro		= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();
	String materia		= "";
	String estadoMateria= "";
	
	String msj 			= "";
	
	String cicloGrupoFrom		= (String) session.getAttribute("cicloGrupoId");
	String cursoIdFrom 			= (String) session.getAttribute("cursoId");	
	String cursoTo 				= request.getParameter("cursoId")==null?"":request.getParameter("cursoId");
	String cicloGrupoTo 		= request.getParameter("cicloGrupo")==null?"":request.getParameter("cicloGrupo");
	String modulo				= request.getParameter("moduloId")==null?"0":request.getParameter("moduloId");
	
	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	if(accion.equals("1")){

		ArrayList<aca.ciclo.CicloGpoModulo> modulosTo = ModuloL.getCurso(conElias, cicloGrupoTo, cursoTo, modulo, "");
		
		if(!modulosTo.contains(modulo)){
			
			conElias.setAutoCommit(false);
			
			ArrayList<aca.ciclo.CicloGpoModulo> modulosFrom = ModuloL.getCurso(conElias, cicloGrupoFrom, cursoIdFrom, modulo, "");
			boolean grabo = true;
			
			for(aca.ciclo.CicloGpoModulo modulo2: modulosFrom){
				if(grabo==false){
					break;
				}
				
				Modulo.setCicloGrupoId(cicloGrupoTo);
				Modulo.setCursoId(cursoTo);
				Modulo.setModuloNombre(modulo2.getModuloNombre());
				Modulo.setDescripcion(modulo2.getDescripcion());
				Modulo.setModuloId(Modulo.maximoReg(conElias));
				Modulo.setOrden(modulo2.getOrden());
				
				if(Modulo.insertReg(conElias, modulo)){
					ArrayList<aca.ciclo.CicloGpoTema> temas = TemaL.getListTemasModulo(conElias, cicloGrupoFrom, cursoIdFrom, modulo2.getModuloId(), "");
					for(aca.ciclo.CicloGpoTema tema: temas){
						if(grabo==false){
							break;
						}
						
						Tema.setCicloGrupoId(cicloGrupoTo);
						Tema.setCursoId(cursoTo);
						Tema.setTemaNombre(tema.getTemaNombre());
						Tema.setDescripcion(tema.getDescripcion());
						Tema.setModuloId(modulo2.getModuloId());
						Tema.setTemaId(Tema.maximoReg(conElias));
						Tema.setOrden(tema.getOrden());
						Tema.setFecha(sdf.format(new Date()));
						
						if(Tema.insertReg(conElias, modulo)){
							
							ArrayList<aca.ciclo.CicloGrupoTarea> tareas = TareaL.getListTareasTema(conElias, cicloGrupoFrom, cursoIdFrom, tema.getTemaId(), "");
							for(aca.ciclo.CicloGrupoTarea tarea: tareas){
								if(grabo==false){
									break;
								}
								
								Tarea.setCicloGrupoId(cicloGrupoTo);
								Tarea.setCursoId(cursoTo);
								Tarea.setTareaNombre(tarea.getTareaNombre());
								Tarea.setDescripcion(tarea.getDescripcion());
								Tarea.setFecha(tarea.getFecha());
								Tarea.setTemaId(tema.getTemaId());
								Tarea.setTareaId(Tarea.maximoReg(conElias));
								
								if(Tarea.insertReg(conElias)){
									
								}else{
									grabo = false;
									msj = "ErrorAlTraspasarTareas";
									break;
								}
								
							}
							
							/* los archivos estan al mismo nivel que las tareas pero se grabarán despues de las mismas */
							ArrayList<aca.ciclo.CicloGrupoArchivo> lisArchivo = ArchivoL.getListTema(conElias, cicloGrupoFrom, cursoIdFrom, tema.getTemaId(), "");
							
							for(aca.ciclo.CicloGrupoArchivo archivo: lisArchivo){
								
								Archivo.setCicloGrupoId(cicloGrupoTo);
								Archivo.setCursoId(cursoTo);
								Archivo.setTemaId(archivo.getTemaId());
								Archivo.setFolio(archivo.getFolio());
								Archivo.setArchivo(archivo.getArchivo());
								Archivo.setDescripcion(archivo.getDescripcion());
								Archivo.setNombre(archivo.getNombre());
								
								if(Archivo.insertReg(conElias)){
									
								}else{
									grabo = false;
									msj = "ErrorAlTraspasarTareas1";
									break;
								}
							}
							
						}else{
							grabo = false;
							msj = "ErrorAlTraspasarTemas";
							break;
						}
					}
				}else{
					grabo = false;
					msj = "ErrorAlTraspasarModulos";
					break;
				}
			}
			
			if(grabo==false){
				conElias.rollback();
			}else{
				conElias.commit();
				msj = "SeTraspasoPlaneacion";
			}
				
			conElias.setAutoCommit(true);
		}else{
			msj = "YaTienePlaneacion";
		}
	}
	
	
	pageContext.setAttribute("resultado", msj);
%>

<div id="content">
	<h2><fmt:message key="aca.Traspasar" /> <small><%=aca.empleado.EmpPersonal.getNombre(conElias,codigoId, "NOMBRE")%></small></h2>
	
	<div class="alert alert-info">
		<h4><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoIdFrom)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoFrom)%></h4>
		<small><%=aca.plan.Plan.getNombrePlan(conElias, aca.plan.PlanCurso.getPlanId(conElias, cursoIdFrom))%></small> <!-- get modulo -->
	</div>
	
	<div class="alert alert-warning">
		<h3>Seleccione la materia destino</h3>
	</div>
	
	<div class="well">
		<a class="btn btn-primary" href="modulo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	
		<select id="Ciclo" onchange="location.href='moduloSingular.jsp?Ciclo='+this.options[this.selectedIndex].value?moduloId="+<%=modulo %> class="input-xxlarge"> <!-- show modulo -->
<%
			String cicloSeleccionado;
			boolean tieneCiclo = false;
			ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListCiclosEmpleadoCursos(conElias, codigoId, "ORDER BY CICLO_ID");
			for(int i = 0; i < lisCiclo.size(); i++){
				ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
				if(ciclo.getCicloId().equals(cicloId)){
					cicloSeleccionado = "Selected";
					tieneCiclo = true;
				}else{
					cicloSeleccionado = "";
				}
%>
				<option value="<%=ciclo.getCicloId() %>" <%=cicloSeleccionado %>><%=ciclo.getCicloNombre() %></option>
<%
			}
			if(!tieneCiclo){
				cicloId = ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
			}
%>
		</select>
	</div>
	
	<%if(!msj.equals("")){ %>
			<div class="alert alert-success">
				<fmt:message key="aca.${resultado}" />
			</div>	
	<%} %>
	
	<table class="table table-bordered">
		<tr>
			<th colspan="6"><fmt:message key="aca.Cursos" /></th>
		</tr>
<%
		ArrayList<aca.ciclo.CicloGrupoCurso> lisCursos = cicloGrupoCursoLista.getListAll(conElias, "WHERE EMPLEADO_ID = '"+codigoId+"' AND CICLO_GRUPO_ID LIKE '"+cicloId+"%' ORDER BY ORDEN_NGG(CICLO_GRUPO_ID), ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
		
for(int i = 0; i < lisCursos.size(); i++){
			cicloGrupoCurso = (CicloGrupoCurso)lisCursos.get(i);
			cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());		
			
			materia = PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
			System.out.println(cicloGrupoCurso.getCicloGrupoId()+" " +cicloGrupoCurso.getCursoId()+" "+modulo);
			
			
%>
			<tr>
				<% if(Modulo.existeEnGrupo(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), modulo)){ %>
						<td>
							<input type="radio" checked disabled />
						</td>
				<% }else{ %>
						<td>
					  		<input class="radioCurso" type="radio" name="curso" />
					  		<input class="curso" type="hidden" value="<%=cicloGrupoCurso.getCursoId() %>">
					  		<input class="cicloGrupo" type="hidden" value="<%=cicloGrupoCurso.getCicloGrupoId() %>">
					  		<input class="moduloId" type="hidden" value="<%=modulo%>">
						</td>
				<% } %>
				<td>
					<% if(Modulo.existeEnGrupo(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), modulo)){ %>
						<span class="label label-info"><fmt:message key="aca.MateriaConPlaneacion" /></span>
					<% } %>
				</td>
				<td>
					<%=Plan.getNombrePlan(conElias, cicloGrupo.getPlanId()) %> 
				</td>
				<td>
					<strong><%=materia%></strong>
				</td>
				<td>
					<%=cicloGrupo.getGrupoNombre() %> <%=cicloGrupo.getGrupo() %>
				</td>
				<td>
					<fmt:message key="aca.Alumnos" />: <%=KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId() ) %>
				</td>
			</tr>
				 
<%		
		} 
%>
		</table>
		      
		<div class="well">
			<a class="btn traspasar btn-success btn-large"><fmt:message key="aca.Traspasar" /> <i class="icon-random icon-white"></i></a>
		</div>
</div>

<script>
(function(){
	
	$('.traspasar').on('click', function(){
		
		var checked;
		
		$('.radioCurso').each(function(){
			if($(this).is(":checked")){
				checked = $(this);
			}
		});
		
		if(checked){
			location.href="moduloSingular.jsp?Accion=1&cursoId="+checked.siblings(".curso").val()+"&cicloGrupo="+checked.siblings(".cicloGrupo").val()+"&moduloId="+checked.siblings(".moduloId").val();
		}else{
			alert("<fmt:message key="aca.SeleccioneMateria" />");
		}
		
	});
	
})();
</script>
<%@ include file= "../../cierra_elias.jsp" %>