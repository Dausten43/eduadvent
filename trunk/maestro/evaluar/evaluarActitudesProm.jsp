<%@ page import="java.text.*"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="AspectosL" scope="page" class="aca.catalogo.CatAspectosLista"/>
<jsp:useBean id="AspectosCalL" scope="page" class="aca.catalogo.CatAspectosCalLista"/>
<jsp:useBean id="krdxAlumActitud" scope="page" class="aca.kardex.KrdxAlumActitud" />
<script>
	/*
	 * ABRIR INPUTS PARA EDITAR LAS NOTAS
	 */
	function muestraInput(promedioId){
		var editar = $('.editar'+promedioId);//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON
	 */
	function guardarCalificaciones(evaluacion){
		document.forma.Evaluacion.value = evaluacion;
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>
<%
	//FORMATOS ---------------------------->
	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0");
	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloId 		= (String) session.getAttribute("cicloId");
	String codigoId 	= (String) session.getAttribute("codigoEmpleado");
	
	String cicloGrupoId	= request.getParameter("CicloGrupoId");
	String cursoId 		= request.getParameter("CursoId");	
	String planId 		= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	String url 			= "evaluar.jsp";
	
	empPersonal.mapeaRegId(conElias, codigoId);		
	cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
	cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());
	
	// Lista de promedios	
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
	
	// Lista de promedios	
	ArrayList<aca.catalogo.CatAspectos> lisAspectos 	= AspectosL.getListAspectos(conElias, escuelaId, cicloGrupo.getNivelId(), " ORDER BY ORDEN");
	
	// Lista de promedios	
	ArrayList<aca.catalogo.CatAspectosCal> lisAspectosCal 	= AspectosCalL.getListPorNivel(conElias, escuelaId, cicloGrupo.getNivelId()," ORDER BY CAL_ID");
	
	// Lista de alumnos en la materia
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos	= kardexLista.getListAll(conElias,escuelaId, "AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if(accion.equals("1")){ //Guardar Conducta
		String promedio		= request.getParameter("Promedio");
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
	
		int cont = 0;
		for(aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos){
			krdxAlumActitud.setCodigoId(kardex.getCodigoId());
			krdxAlumActitud.setCicloGrupoId(cicloGrupoId);
			krdxAlumActitud.setCursoId(cursoId);
			krdxAlumActitud.setPromedioId(promedio);
			krdxAlumActitud.setEvaluacionId("0");
			
			String aspecto 		= request.getParameter("aspecto" + cont + "-" + promedio);
			if ( aspecto != null ){
				
			}
			cont++;
		}		
		
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoGuardo";
		}else{
			conElias.commit();
			msj = "Guardado";
		}
		
		conElias.setAutoCommit(true);//** END TRANSACTION **
				
	}
	
	pageContext.setAttribute("resultado", msj);

	planCurso.mapeaRegId(conElias, cursoId);
	
%>

<div id="content">
	<h2>
		<fmt:message key="maestros.RegistroConducta" />
		<small>
		( <%=empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno()%> | 
		<%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%> | 
		<%=aca.plan.Plan.getNombrePlan(conElias, planId)%>&nbsp;
		)
		</small>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>	
	<div class="well">
		<a href="<%=url %>?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i><fmt:message key="boton.Regresar" /></a>
		&nbsp;
		<select name="Promedio">
<%		
		for(aca.ciclo.CicloPromedio prom : lisPromedio){
			out.print("<option value="+prom.getPromedioId()+">"+prom.getNombre()+"</option>");
		}
%>			
		</select>
	</div>
	
	<!--  -------------------- TABLA DE EVALUACIONES -------------------- -->
	
	<table class="table table-condensed table-bordered table-striped">
		<tr>
			<th class="text-center">#</th>
			<th class="text-center"><fmt:message key="aca.Area" /></th>
			<th><fmt:message key="aca.Descripcion" /></th>		
		</tr>
		<%
			int cont = 0;
			for(aca.catalogo.CatAspectos aspecto : lisAspectos){
				cont++;
		%>				
		<tr>
			<td class="text-center"><%=cont%></td>
			<td><%=aca.catalogo.CatArea.getNombre(conElias, aspecto.getArea())%></td>
			<td>				 
				<a href="javascript:muestraInput('<%=aspecto.getAspectosId()%>');"> 
					<%=aspecto.getNombre()%>
				</a> 
			</td>		
		</tr>
		<%
			}
		%>
	</table>
	
	<!--  -------------------- TABLA DE ALUMNOS -------------------- -->
	
	<form action="evaluarConducta.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>" name="forma" method="post">
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Evaluacion" />
		
		<table class="table table-condensed table-bordered table-striped">
			
			<thead>
				<tr>
					<th class="text-center">#</th>
					<th class="text-center"><fmt:message key="aca.Codigo" /></th>
					<th><fmt:message key="aca.NombreDelAlumno" /></th>
				<%
					cont = 0;
					for(aca.catalogo.CatAspectos aspecto : lisAspectos){
						cont++;
				%>
					<th style="width:3%;" class="text-center" title="<%=aspecto.getAspectosId()%>"><%=cont%></th>
				<%
					}
				%>
					<th class="text-center"><fmt:message key="aca.Promedio" /></th>
				</tr>
			</thead>
			
			<%
			int i = 0;
			for(aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos){
			%>
				<tr>
					<td class="text-center"><%=i+1%></td>
					<td class="text-center"><%=kardex.getCodigoId()%></td>
					<td>
						<%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>
						
						<%if(kardex.getTipoCalId().equals("6")){ %>
				  			<span class="label label-important" title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />" ><fmt:message key="aca.Baja" /></span>
				  		<%} %>
					</td>
					<%
						float sumaAspectos = 0;
						int cantidadAspectos = 0;
						for(aca.catalogo.CatAspectos aspecto : lisAspectos){
									
							String nota = "-";
					%>
					<td class="text-center">
						<div><%=aspecto.getAspectosId()%></div>								
						<div class="editar<%=aspecto.getAspectosId()%>" style="display:none;">
							<select name="aspecto<%=i%>-<%=aspecto.getAspectosId()%>" id="aspecto<%=i%>-<%=aspecto.getAspectosId()%>" style="width:70px;">
					<%
							for( aca.catalogo.CatAspectosCal cal : lisAspectosCal ){
					%>		
								<option value="<%=cal.getCalId()%>"><%=cal.getCalCorto()%></option>
					<%
							}
					%>							
							</select>							
						</div>								
					</td>
					<%
						}
						
						String total = "-";
						if(sumaAspectos != 0){
							total = frmDecimal.format((double)sumaAspectos/(double)cantidadAspectos).replace(',','.');
						}
					%>
					
						<td class="text-center"><%=total %></td>
				</tr>
			<%
				i++;
			}
			%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<%for(aca.catalogo.CatAspectos aspecto : lisAspectos){%>
					<td class="text-center">
						<div class="editar<%=aspecto.getAspectosId() %>" style="display:none;">
							<a tabindex="<%=lisKardexAlumnos.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarCalificaciones( '<%=aspecto.getAspectosId()%>' );"><fmt:message key="boton.Guardar" /></a> 
						</div>
					</td>
								
				<%}%>
				<td>&nbsp;</td>
			</tr>
			
		</table>
	</form>
</div>

<%@ include file="../../cierra_elias.jsp"%>