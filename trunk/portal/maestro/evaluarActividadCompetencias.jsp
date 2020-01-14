<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupoActividadL" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="krdxAlumActividad" scope="page" class="aca.kardex.KrdxAlumActiv"/>
<jsp:useBean id="krdxAlumActivL" scope="page" class="aca.kardex.KrdxAlumActivLista"/>
<jsp:useBean id="kardexEval" scope="page" class="aca.kardex.KrdxAlumEval"/>
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>

<script>

	/*
	 * ABRIR INPUTS PARA EDITAR LAS NOTAS
	 */
	function muestraInput(actividadId){
		var editar = $('.editar'+actividadId);//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON
	 */
	function guardarCalificaciones(actividad){
		document.forma.Actividad.value = actividad;
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
	
	/*
	 * BORRA TODAS LAS NOTAS DE UNA ACTIVIDAD
	 */
	function borrarCalificaciones(actividad){	
		if ( confirm("<fmt:message key="js.EsteProcesoEliminaTodasLasNotasActiv" />")==true ){
			var editar = $('.editar'+actividad).find('input');//Busca los inputs
			editar.val("");
			guardarCalificaciones(actividad);
		}		
	}	
	
</script>

<%
	//FORMATOS ---------------------------->
	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoId");
	String cicloId			= (String) session.getAttribute("cicloId");

	String cicloGrupoId		= request.getParameter("CicloGrupoId");
	String cursoId			= request.getParameter("CursoId");
	String evaluacionId		= request.getParameter("EvaluacionId");
	String estado			= request.getParameter("estado")==null?"":request.getParameter("estado");
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	String planId			= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	String nivelId  		= aca.plan.Plan.getNivel(conElias, planId);
	
	//INFORMACION DEL MAESTRO
	empPersonal.mapeaRegId(conElias, codigoId);
	

	ArrayList<aca.ciclo.CicloGrupoActividad> lisActividad 	= cicloGrupoActividadL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ACTIVIDAD_ID, ACTIVIDAD_NOMBRE");
	ArrayList<aca.kardex.KrdxAlumActiv> lisKrdxActiv 		= krdxAlumActivL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ALUM_APELLIDO(CODIGO_ID), ACTIVIDAD_ID");

	//LISTA DE ALUMNOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos		= krdxCursoActL.getListAll(conElias, escuelaId," AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID = '"+cursoId+"' ORDER BY ORDEN, ALUM_APELLIDO(CODIGO_ID)");
	
/* ********************************** ACCIONES ********************************** */
	String msj = "";	

//------------- GUARDA CALIFICACIONES DE UNA ACTIVIDAD Y PROMEDIA LA NOTA DE LA EVALUACION ------------->

	if(accion.equals("1")){
		String actividadId	= request.getParameter("Actividad");
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
		
		int i = 0;
		for(aca.kardex.KrdxCursoAct krdxCursoAct : lisKardexAlumnos ){
		
			String nota 	= request.getParameter("nota"+i+"-"+actividadId);
			
			if(nota != null){
				
				krdxAlumActividad.setCodigoId(krdxCursoAct.getCodigoId());
				krdxAlumActividad.setCicloGrupoId(cicloGrupoId);
				krdxAlumActividad.setCursoId(cursoId);
				krdxAlumActividad.setEvaluacionId(evaluacionId);
				krdxAlumActividad.setActividadId(actividadId);
				krdxAlumActividad.setNota(nota);
				
				if (nota.equals("")){//Si no tiene nota entonces eliminala si es que existe, si no pues ignora esa nota 
					
					if(krdxAlumActividad.existeReg(conElias)){
						krdxAlumActividad.deleteReg(conElias);	
					}
					
				}else{//Si tiene nota entonces guardarla
					if(krdxAlumActividad.existeReg(conElias)){
						if(krdxAlumActividad.updateReg(conElias)){
							//Actualizado correctamente
						}else{
							error = true; break;
						}
					}else{
						if(krdxAlumActividad.insertReg(conElias)){
							//Insertado correctamente
						}else{
							error = true; break;
						}
					}
				}
				
			}
			
			i++;
		}
				
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoGuardo";
			
			lisKrdxActiv = krdxAlumActivL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ALUM_APELLIDO(CODIGO_ID), ACTIVIDAD_ID");
		}else{
			conElias.commit();
			msj = "Guardado";
			
			lisKrdxActiv = krdxAlumActivL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ALUM_APELLIDO(CODIGO_ID), ACTIVIDAD_ID");
		}
		
		conElias.setAutoCommit(true);//** END TRANSACTION **
	}

	pageContext.setAttribute("resultado", msj);
	
	/* ********************************** END ACCIONES ********************************** */
	
%>

<div id="content">
	
	<h2>
		<fmt:message key="aca.Actividades" /> 
		<small><%=empPersonal.getNombre() + " " + empPersonal.getApaterno()+ " " + empPersonal.getAmaterno()%></small>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
		<h4><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%></h4>
		<small><%=aca.plan.Plan.getNombrePlan(conElias, planId)%></small> 
	</div>
	
	<div class="well">
		<a href="evaluarCompetencias.jsp?CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>

	<table class="table table-condensed table-striped table-bordered">
		<tr>
			<th class="text-center">#</th>
			<th><fmt:message key="aca.Descripcion"/></th>
			<th><fmt:message key="aca.Fecha"/></th>
			<th><fmt:message key="aca.Valor"/></th>
		</tr>
		<%
			int cont = 0;
			for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
				cont++;
		%>
				<tr>
					<td  class="text-center"><%=cont %></td>
					<td>
						<%if(estado.equals("A")){ %>
							<a href="javascript:muestraInput('<%=cicloGrupoActividad.getActividadId()%>');">
								<%=cicloGrupoActividad.getActividadNombre()%>
							</a> 
						<%}else{%> 
							<%=cicloGrupoActividad.getActividadNombre() %>
						<%} %>
					</td>
					<td><%=cicloGrupoActividad.getFecha() %></td>
					<td><%=cicloGrupoActividad.getValor() %></td>
				</tr>
		<%
			}
		%>
			
	</table>
		
	<form action="evaluarActividadCompetencias.jsp?estado=<%=estado %>&CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>&EvaluacionId=<%=evaluacionId %>" name="forma" method="post">
	
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Actividad" />
		
		<table class="table table-condensed table-bordered table-striped"">
			<thead>
				
				<tr>
					<th class="text-center">#</th>
					<th class="text-center"><fmt:message key="aca.Codigo"/></th>
					<th><fmt:message key="aca.Nombre"/></th>
					<%
						cont = 0;
						for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
							cont++;
					%>
							<th style="width:4%;" class="text-center" title="<%=cicloGrupoActividad.getActividadNombre() %>"><%=cont %></th>
					<%
						}
					%>
				</tr>
			</thead>
			
			<%
				int i = 0;
				for(aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos){
			%>
					<tr>
						<td class="text-center"><%=i+1 %></td>
						<td class="text-center"><%= kardex.getCodigoId() %></td>
						<td>
							<%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>
							
							<%if(kardex.getTipoCalId().equals("6")){ %>
					  			<span class="label label-important" title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />" ><fmt:message key="aca.Baja" /></span>
					  		<%} %>
						</td>
						<!-- --------- RECORRE LAS ACTIVIDADES --------- -->
						<%
							for (aca.ciclo.CicloGrupoActividad activ: lisActividad) {
								String strNota = "-";
								
								for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
									if(krdxAlumActiv.getCodigoId().equals(kardex.getCodigoId()) && krdxAlumActiv.getActividadId().equals(activ.getActividadId())){					
										strNota = frmEntero.format(Double.parseDouble(krdxAlumActiv.getNota())).replaceAll(",", ".");
									}
								}

						%>
						
								<td class="text-center">
									
									<div>
										<%=aca.catalogo.CatEsquema.getCaracter(strNota) %>
									</div>
									
									<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) -->
									<%if (!kardex.getTipoCalId().equals("6") && estado.equals("A") ) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
										<div class="editar<%=activ.getActividadId() %>" style="display:none;">
											<select tabindex="<%=i+1%>" name="nota<%=i%>-<%=activ.getActividadId() %>" id="nota<%=i%>-<%=activ.getActividadId() %>"  class="input-mini" style="margin:0;">
												<option value="10" <%if(strNota.equals("10")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("10") %></option>
												<option value="5" <%if(strNota.equals("5")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("5") %></option>
												<option value="0" <%if(strNota.equals("0")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("0") %></option>
											</select>
										</div>
									<%}%>
									
								</td>
						<%
							}//End for evaluaciones
						%>	
					</tr>
			<%	
					i++;
				}
			%>
			
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
						for(aca.ciclo.CicloGrupoActividad activ : lisActividad){
					%>
							<td class="text-center">
								<div class="editar<%=activ.getActividadId() %>" style="display:none;">
									<a tabindex="<%=lisKardexAlumnos.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarCalificaciones( '<%=activ.getActividadId()%>' );"><fmt:message key="boton.Guardar" /></a> 
									<a tabindex="<%=lisKardexAlumnos.size()+1 %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarCalificaciones( '<%=activ.getActividadId()%>' );"><fmt:message key="boton.Eliminar" /></a>
								</div>
							</td>
					<%
						}
					%>
				</tr>
		</table>
	</form>
	
</div>
<script>
$('body').on('keydown', 'input, select, textarea', function(e) {
    var self = $(this)
      , form = self.parents('form:eq(0)')
      , focusable
      , next
      ;
    if (e.keyCode == 13) {
        focusable = form.find('input,a,select,button,textarea').filter(':visible');
        next = focusable.eq(focusable.index(this)+1);
        if (next.length) {
            next.focus();
        } else {
            form.submit();
        }
        return false;
    }
});
</script>
<%@ include file= "../../cierra_elias.jsp" %>