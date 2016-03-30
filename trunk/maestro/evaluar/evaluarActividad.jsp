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
		
		//Busca los inputs
		var editar = $('.editar'+actividadId);
		
		editar.each(function(){
			var $this = $(this);
			
			//Esconde la calificación
			$this.siblings('div').hide();
			
			//Muestra el input con la calificación
			$this.fadeIn(300);
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
	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0");
	
	frmEntero.setRoundingMode(java.math.RoundingMode.DOWN);
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoEmpleado");
	String cicloId			= (String) session.getAttribute("cicloId");

	String cicloGrupoId		= request.getParameter("CicloGrupoId");
	String cursoId			= request.getParameter("CursoId");
	String evaluacionId		= request.getParameter("EvaluacionId");
	String estado			= request.getParameter("estado")==null?"":request.getParameter("estado");
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	String redondeo			= aca.ciclo.Ciclo.getRedondeo(conElias, cicloId);
	String decimales		= aca.ciclo.Ciclo.getDecimales(conElias, cicloId);
	
	String planId			= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	String nivelId  		= aca.plan.Plan.getNivel(conElias, planId);
	
	//CONDICIONES DE LAS NOTAS ---------------------------->
	String evaluaConPunto		= aca.plan.PlanCurso.getPunto(conElias, cursoId); /* Evalua con punto decimal el cursoId */
	float notaAC 				= Float.parseFloat(aca.plan.PlanCurso.getNotaAC(conElias, cursoId)); /* La nota con la que se acredita el cursoId */	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	float notaMinima			= Float.parseFloat(aca.catalogo.CatNivelEscuela.getNotaMinima(conElias, nivelId, escuelaId )); /* La nota minima que puede sacar un alumno, depende del nivel de la escuela */
// 	if (escala == 100){ //Si la escala es 100, entonces la nota minima debe multiplicarse por 10, por ejemplo en vez de 5 que sea 50
// 		notaMinima = notaMinima * 10;	
// 	}
	
	//INFORMACION DEL MAESTRO
	empPersonal.mapeaRegId(conElias, codigoId);	

	ArrayList<aca.ciclo.CicloGrupoActividad> lisActividad 	= cicloGrupoActividadL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ACTIVIDAD_ID, ACTIVIDAD_NOMBRE");
	ArrayList<aca.kardex.KrdxAlumActiv> lisKrdxActiv 		= krdxAlumActivL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ALUM_APELLIDO(CODIGO_ID), ACTIVIDAD_ID");

	//LISTA DE ALUMNOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos		= krdxCursoActL.getListAll(conElias, escuelaId," AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID = '"+cursoId+"' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	
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
		
		if(error == false){//Si no hay error entonces grabar el promedio de las actividades en las evaluaciones
			
			lisKrdxActiv = krdxAlumActivL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ALUM_APELLIDO(CODIGO_ID), ACTIVIDAD_ID");
		
			for(aca.kardex.KrdxCursoAct krdxCursoAct: lisKardexAlumnos){ 
				
				//double valorActividadesTotal = 0;
				BigDecimal valorActividadesTotal = new BigDecimal("0");
				for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
					for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
						if(krdxAlumActiv.getCodigoId().equals(krdxCursoAct.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){
							//valorActividadesTotal += Double.parseDouble( cicloGrupoActividad.getValor() );
							valorActividadesTotal = valorActividadesTotal.add( new BigDecimal(cicloGrupoActividad.getValor()) );
						}
					}
				}
				
				//float promedioActividades = 0f;
				BigDecimal promedioActividades = new BigDecimal("0");
				for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
					for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
						if(krdxAlumActiv.getCodigoId().equals(krdxCursoAct.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){				
							//promedioActividades += (Float.parseFloat(krdxAlumActiv.getNota())*Float.parseFloat(cicloGrupoActividad.getValor()))/valorActividadesTotal;
							if(valorActividadesTotal.compareTo(BigDecimal.ZERO) != 0){
								promedioActividades = promedioActividades.add( new BigDecimal(krdxAlumActiv.getNota()).multiply(new BigDecimal(cicloGrupoActividad.getValor())).divide(valorActividadesTotal, 2, RoundingMode.DOWN) );
							}
						}
					}
				}
				
				/* Quitar decimales, por ejemplo (88.6 a 88) (80.1 a 80) */
// 				promedioActividades = new BigDecimal( frmEntero.format(promedioActividades) );
				if(decimales.equals("0")){
					promedioActividades = new BigDecimal( frmEntero.format(promedioActividades) );
				}else if(decimales.equals("1")){
					promedioActividades = new BigDecimal( frmDecimal.format(promedioActividades) );
					if(redondeo.equals("A") ){
						promedioActividades = promedioActividades.setScale(2, BigDecimal.ROUND_HALF_UP);
					}else{
						promedioActividades = new BigDecimal( frmEntero.format(promedioActividades) );
					}
				}
				
				
				//--------COMPROBAR SI LA ESCALA ES 5----------				
// 				if( escala == 5 ){
// 					/* Convirtiendo la escala de 100 a 5 (ya que las actividades se evaluan de 0 a 100) */
// 					promedioActividades = promedioActividades.multiply(new BigDecimal("5")).divide(new BigDecimal("100"), 2, RoundingMode.DOWN);
// 				}
				
// 				//--------COMPROBAR SI LA ESCALA ES 10----------
				
// 				if( escala == 10 ){
// 					/* Convirtiendo la escala de 100 a 10 (ya que las actividades se evaluan de 0 a 100) */
// 					promedioActividades = promedioActividades.divide(new BigDecimal("10"), 2, RoundingMode.DOWN);
// 				}
				
				//--------COMPROBAR SI TIENEN PUNTO DECIMAL----------
				
				if(evaluaConPunto.equals("N")){
					/* Si tiene una nota reprobatoria entonces el redondeo es hacia abajo, por ejemplo: (5.9 a 5) (5.6 a 5) (4.9 a 4)  */
					if( promedioActividades.compareTo( new BigDecimal(notaAC) ) == -1 ){// promedioActividades<notaAC
						promedioActividades = new BigDecimal( frmEntero.format( promedioActividades.setScale(0, RoundingMode.FLOOR) ) );
					}
					/* Si tiene una nota aprobatoria entonces el redondeo es normal, por ejemplo: (6.4 a 6) (6.6 a 7)  */
					else{
						promedioActividades = new BigDecimal( frmEntero.format( promedioActividades.setScale(0, RoundingMode.HALF_UP) ) );
					}
				}	
						
				//--------VERIFICAR LA NOTAMINIMA PARA EL NIVEL----------
				
				if( promedioActividades.compareTo( new BigDecimal(notaMinima) ) == -1 ){// promedioActividades<notaMinima
					promedioActividades = new BigDecimal(notaMinima);
				}
				
				//--------GUARDAR PROMEDIO DE LAS ACTIVIDADES EN LA EVALUACION----------
				
				kardexEval.setCodigoId(krdxCursoAct.getCodigoId());
				kardexEval.setCicloGrupoId(cicloGrupoId);
				kardexEval.setCursoId(cursoId);
				kardexEval.setEvaluacionId(evaluacionId);
				
				int numActiv		= aca.kardex.KrdxAlumActiv.getNumActividades(conElias, cicloGrupoId, cursoId, evaluacionId, krdxCursoAct.getCodigoId());
				
				if(numActiv<=0){//Si no tiene evaluada alguna actividad entonces eliminala si es que existe, si no pues ignora ese promedio
					
					if(kardexEval.existeReg(conElias)){
						if(kardexEval.deleteReg(conElias)){
							//Eliminado correctamente
						}else{
							error = true; break;
						}
					}
					
				}else{//Si tiene evaluada alguna actividad entonces guarda el promedio
					
					if(kardexEval.existeReg(conElias)){
						kardexEval.mapeaRegId(conElias, krdxCursoAct.getCodigoId(), cicloGrupoId, cursoId, evaluacionId);
						kardexEval.setNota(promedioActividades +"");
						if(kardexEval.updateReg(conElias)){
							//Actualizo correctamente
						}else{
							error = true; break;
						}
					}else{
						kardexEval.setNota( promedioActividades +"");
						if(kardexEval.insertReg(conElias)){
							//Inserto correctamente
						}else{
							error = true; break;
						}
					}
					
				}
					
					
			}//End for alumnos
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
		<a href="evaluar.jsp?CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
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
		
	<form action="evaluarActividad.jsp?estado=<%=estado %>&CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>&EvaluacionId=<%=evaluacionId %>" name="forma" method="post">
	
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Actividad" />
		
		<table class="table table-condensed table-bordered table-striped"">
			<thead>
				<tr>
					<td colspan="20" class="text-center alert">
<%-- 						<fmt:message key="aca.ActivdadesDeCeroACien"/> --%>
						  
						 Las actividades se evalúan de 0 a <%= escala %>
						&nbsp;&nbsp;
<!-- 						| -->
						&nbsp;&nbsp;
						
<%-- 						<fmt:message key="aca.EvaluacionConEnteros" /> --%>
					</td>
				</tr>
				
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
						
						
						String txtEscala=notaMinima+" a "+escala+", "+(evaluaConPunto.equals("S")?"Evaluación con punto decimal":"Evaluación con enteros");
					%>
					<th class="text-center" title="<fmt:message key='aca.MensajePromedioActividades' />">
						<fmt:message key="aca.PA"/>
					</th>
					<th class="text-center" title="<%=txtEscala%>"><fmt:message key="aca.Promedio"/></th>
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
										strNota = frmDecimal.format(Double.parseDouble(krdxAlumActiv.getNota())).replaceAll(",", ".");
									}
								}

						%>
						
								<td class="text-center">
									
									<div>
										<%=strNota%>
									</div>
									
									<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) -->
									<%if (!kardex.getTipoCalId().equals("6") && estado.equals("A") ) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
										<div class="editar<%=activ.getActividadId() %>" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers" 
												data-allow-decimal="si"
												data-max-num="<%= escala %>"
												type="text" 
												tabindex="<%=i+1%>" 
												name="nota<%=i%>-<%=activ.getActividadId() %>"
												id="nota<%=i%>-<%=activ.getActividadId() %>" 
												value="<%=strNota.equals("-")?"":strNota %>" 
											/>
										</div>
									<%}%>
									
								</td>
						<%
							}//End for evaluaciones
							
							
							//Calcula el promedio de la evaluacion de 0 a 100
							//double valorActividadesTotal = 0;
							BigDecimal valorActividadesTotal = new BigDecimal("0");
							for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
								for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
									if(krdxAlumActiv.getCodigoId().equals(kardex.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){
										//valorActividadesTotal += Double.parseDouble( cicloGrupoActividad.getValor() );
										valorActividadesTotal = valorActividadesTotal.add( new BigDecimal(cicloGrupoActividad.getValor()) );
									}
								}
							}
							
							//float promedioActividades = 0f;
							BigDecimal promedioActividades = new BigDecimal("0");
							for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
								for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
									if(krdxAlumActiv.getCodigoId().equals(kardex.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){								
										//promedioActividades += (Float.parseFloat(krdxAlumActiv.getNota())*Float.parseFloat(cicloGrupoActividad.getValor()))/valorActividadesTotal;
										if(valorActividadesTotal.compareTo(BigDecimal.ZERO) != 0){
											promedioActividades = promedioActividades.add( new BigDecimal(krdxAlumActiv.getNota()).multiply(new BigDecimal(cicloGrupoActividad.getValor())).divide(valorActividadesTotal, 2, RoundingMode.DOWN) );
										}
									}
								}
							}
						%>

							<td class="text-center"><%= frmEntero.format(promedioActividades) %></td>

						<%
							// obtiene el promedio de la evaluacion que esta en la BD
							String promedio =  aca.kardex.KrdxAlumEval.getNotaEval(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, Integer.parseInt(evaluacionId));		
						
							String strProm = "-";
							if( promedio != null && !promedio.equals("-") ){
								if(evaluaConPunto.equals("S")){
									strProm = frmDecimal.format(Double.parseDouble(promedio)).replaceAll(",", ".");
								}else{
									strProm = frmEntero.format(Double.parseDouble(promedio)).replaceAll(",", ".");
								}
							}
						%>
						
							<td class="text-center"><%=strProm%></td>
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
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
		</table>
	</form>
	
</div>

<%@ include file= "../../cierra_elias.jsp" %>