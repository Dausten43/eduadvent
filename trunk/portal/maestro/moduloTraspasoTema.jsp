<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.plan.Plan"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>

<jsp:useBean id="ModuloFrom" scope="page" class="aca.ciclo.CicloGpoModulo"/>
<jsp:useBean id="ModuloL" scope="page" class="aca.ciclo.CicloGpoModuloLista"/>
<jsp:useBean id="Tema" scope="page" class="aca.ciclo.CicloGpoTema"/>
<jsp:useBean id="TemaFrom" scope="page" class="aca.ciclo.CicloGpoTema"/>
<jsp:useBean id="TemaL" scope="page" class="aca.ciclo.CicloGpoTemaLista"/>
<jsp:useBean id="Tarea" scope="page" class="aca.ciclo.CicloGrupoTarea"/>
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista"/>
<jsp:useBean id="Archivo" scope="page" class="aca.ciclo.CicloGrupoArchivo"/>
<jsp:useBean id="ArchivoL" scope="page" class="aca.ciclo.CicloGrupoArchivoLista" />


<%

	String codigoId 	= (String)session.getAttribute("codigoId");
	String cicloId 		= request.getParameter("Ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("Ciclo");

	empPersonal.mapeaRegId(conElias, codigoId);
	String maestro		= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();
	String materia		= "";
	String estadoMateria= "";
	
	String msj 			= request.getParameter("msj")==null?"":(String)request.getParameter("msj");
	String cambiarOrden = request.getParameter("cambiarOrden")==null?"0":(String)request.getParameter("cambiarOrden");//****
	
	String cicloGrupoFrom		= (String) session.getAttribute("cicloGrupoId");
	String cursoIdFrom 			= (String) session.getAttribute("cursoId");	
	String cursoTo 				= request.getParameter("cursoId")==null?"":request.getParameter("cursoId");
	String cicloGrupoTo 		= request.getParameter("cicloGrupoTo")==null?"":request.getParameter("cicloGrupoTo");
	String moduloIdFrom			= request.getParameter("moduloId")==null?"0":request.getParameter("moduloId");
	String temaIdFrom			= request.getParameter("temaId")==null?"0":request.getParameter("temaId");
	//Variable temaIdToFocus usada para hacer scroll hacia el tema añadido
	String cursoIdToFocus		= request.getParameter("cursoIdToFocus")==null?"":request.getParameter("cursoIdToFocus");
	String moduloIdTo			= request.getParameter("moduloIdTo")==null?"":request.getParameter("moduloIdTo");
	
	ModuloFrom.mapeaRegId(conElias, cicloGrupoFrom, moduloIdFrom, cursoIdFrom);
	TemaFrom.mapeaRegId(conElias, cicloGrupoFrom, temaIdFrom, cursoIdFrom);
	
	pageContext.setAttribute("resultado", msj);//usada para pasar el mensaje a la libreria de idioma
%>

<div id="content">
	<h2>
		<fmt:message key="aca.TraspasarTema" /><br />
		<small>
			<%=ModuloFrom.getModuloNombre() %><br />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<%=TemaFrom.getTemaNombre() %>
		</small><br/>
	</h2>
	
	<div class="alert alert-warning">
		<h3>Seleccione el m&oacute;dulo destino o tema a reemplazar</h3>
	</div>
	
	<div class="alert alert-info">
		<h4><%=aca.empleado.EmpPersonal.getNombre(conElias,codigoId, "NOMBRE")%> | <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoIdFrom)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoFrom)%></h4>
		<small><%=aca.plan.Plan.getNombrePlan(conElias, aca.plan.PlanCurso.getPlanId(conElias, cursoIdFrom))%></small> <!-- get modulo -->
	</div>
	
	<div class="well">
		<a class="btn btn-primary" href="modulo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	
		<select id="Ciclo" onchange="location.href='moduloSingular.jsp?Ciclo='+this.options[this.selectedIndex].value?moduloId="+<%=moduloIdFrom %> class="input-xxlarge"> <!-- show modulo -->
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
			<div class="alert alert-success" style="position: fixed; width: 500px; left: 50%; margin-left: -250px; top: 40px;">
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
			//System.out.println(cicloGrupoCurso.getCicloGrupoId()+" " +cicloGrupoCurso.getCursoId()+" "+moduloIdFrom);
			
			
%>
			<tr<%=cursoIdToFocus.equals(cicloGrupoCurso.getCursoId())?" class=\"focus\"":"" %>>
				<td>
					<% if(ModuloFrom.existeEnGrupo(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), moduloIdFrom)){ %>
						<span class="label label-info"><fmt:message key="aca.MateriaConPlaneacion" /></span>
					<% } %>
				</td>
				<td>
					<strong><%=Plan.getNombrePlan(conElias, cicloGrupo.getPlanId()) %></strong>
				</td>
				<td>
					<strong><%=materia%></strong>
				</td>
				<td>
					<strong><%=cicloGrupo.getGrupoNombre() %> <%=cicloGrupo.getGrupo() %></strong>
				</td>
				<td>
					<fmt:message key="aca.Alumnos" />: <%=KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId() ) %>
				</td>
				<td>&nbsp;</td>
			</tr>
<%		
			ArrayList<aca.ciclo.CicloGpoModulo> listModulo	= ModuloL.getListCurso(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), "ORDER BY ORDEN, MODULO_ID");
			for(int j = 0; j < listModulo.size(); j++){
				aca.ciclo.CicloGpoModulo cgm = (aca.ciclo.CicloGpoModulo) listModulo.get(j);
%>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<%=cgm.getModuloNombre() %>
				</td>
				<td>
					<a 
					  class="btn btn-success" 
					  href="moduloTraspasoTemaAccion.jsp?Accion=1&cicloGrupoIdFrom=<%=cicloGrupoFrom %>&cursoIdFrom=<%=cursoIdFrom %>&moduloIdFrom=<%=moduloIdFrom %>&temaIdFrom=<%=temaIdFrom %>&cicloGrupoIdTo=<%=cicloGrupoCurso.getCicloGrupoId() %>&cursoIdTo=<%=cicloGrupoCurso.getCursoId() %>&moduloIdTo=<%=cgm.getModuloId() %>"
					  onclick="clickAndDisable(this);">
						<i class="icon-random icon-white"></i> 
						<fmt:message key="maestros.AgregarTema" />
					</a>
				</td>
				<td>
				<%if(cursoIdToFocus.equals(cicloGrupoCurso.getCursoId()) && moduloIdTo.equals(cgm.getModuloId())){%>
					<strong><center>Ordenar:</center></strong>
				<%}else{ %>
					&nbsp;
				<%} %>
				</td>
				<td>&nbsp;</td>
			</tr>
<%
				ArrayList<aca.ciclo.CicloGpoTema> listTema = TemaL.getListTemasModulo(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), cgm.getModuloId(), "ORDER BY ORDEN, MODULO_ID");
				for(int k = 0; k < listTema.size(); k++){
					aca.ciclo.CicloGpoTema cgt = listTema.get(k);
					aca.ciclo.CicloGpoTema cgtTmpUp = cgt, cgtTmpDown = cgt;
					if(k+1 < listTema.size()){
						cgtTmpUp   = listTema.get(k+1);
					}
					if(k-1 >= 0){
						cgtTmpDown = listTema.get(k-1);
					}
%>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<%=cgt.getTemaNombre() %>
					
				</td>
				<td>
					<a 
					  class="btn btn-primary" 
					  href="moduloTraspasoTemaAccion.jsp?Accion=2&cicloGrupoIdFrom=<%=cicloGrupoFrom %>&cursoIdFrom=<%=cursoIdFrom %>&moduloIdFrom=<%=moduloIdFrom %>&temaIdFrom=<%=temaIdFrom %>&cicloGrupoIdTo=<%=cicloGrupoCurso.getCicloGrupoId() %>&cursoIdTo=<%=cicloGrupoCurso.getCursoId() %>&moduloIdTo=<%=cgm.getModuloId() %>&temaIdTo=<%=cgt.getTemaId() %>">
						<i class="icon-random icon-white"></i>
						<fmt:message key="maestros.ReemplazarTema" />
					</a>
				</td>
				<td>
					<%if(cursoIdToFocus.equals(cicloGrupoCurso.getCursoId()) && moduloIdTo.equals(cgm.getModuloId())){
						String up = "1", down = "-1"; 
						%>
						<center>
						<a 	id="btnUp"
							class="btn btn-primary"
						  	href="moduloTraspasoTemaAccion.jsp?Accion=3&cicloGrupoIdFrom=<%=cicloGrupoFrom %>&cursoIdFrom=<%=cursoIdFrom %>&moduloIdFrom=<%=moduloIdFrom %>&temaIdFrom=<%=temaIdFrom %>&cicloGrupoIdTo=<%=cicloGrupoCurso.getCicloGrupoId() %>&cursoIdTo=<%=cicloGrupoCurso.getCursoId() %>&moduloIdTo=<%=cgm.getModuloId() %>&temaIdTo=<%=cgt.getTemaId() %>&temaIdToMove=<%=cgtTmpUp.getTemaId()%>&move=<%=up%>">
							<i class="icon-chevron-down icon-white"></i>
						</a>
						<a  id="btnDown"
							class="btn btn-primary" 
						  	href="moduloTraspasoTemaAccion.jsp?Accion=3&cicloGrupoIdFrom=<%=cicloGrupoFrom %>&cursoIdFrom=<%=cursoIdFrom %>&moduloIdFrom=<%=moduloIdFrom %>&temaIdFrom=<%=temaIdFrom %>&cicloGrupoIdTo=<%=cicloGrupoCurso.getCicloGrupoId() %>&cursoIdTo=<%=cicloGrupoCurso.getCursoId() %>&moduloIdTo=<%=cgm.getModuloId() %>&temaIdTo=<%=cgt.getTemaId() %>&temaIdToMove=<%=cgtTmpDown.getTemaId()%>&move=<%=down%>">
							<i class="icon-chevron-up icon-white"></i>
						</a>
						</center>
					<%}else{ %>
					&nbsp;
					<%} %>
				</td>
				<td>&nbsp;</td>
			</tr>
<%					
				}
			}
		} 
%>
		</table>
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
if($('.focus').length){
	$('html,body').animate({scrollTop: $('.focus').offset().top-70});
}

function clickAndDisable(link){
	$(link).click(function(event){
		event.preventDefault();
	});
	$(link).attr("disabled",true);
}
</script>
<%@ include file= "../../cierra_elias.jsp" %>