<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.math.MathContext"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupoActividadL" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="krdxAlumActividad" scope="page" class="aca.kardex.KrdxAlumActiv"/>
<jsp:useBean id="krdxAlumActivL" scope="page" class="aca.kardex.KrdxAlumActivLista"/>
<jsp:useBean id="kardexEval" scope="page" class="aca.kardex.KrdxAlumEval"/>
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>

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
	java.text.DecimalFormat frmDecimal1 	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	frmEntero.setRoundingMode(java.math.RoundingMode.DOWN);
	frmDecimal1.setRoundingMode(java.math.RoundingMode.DOWN);
	MathContext MATH_CTX = new MathContext(12,RoundingMode.HALF_UP);
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoId");
	String cicloId			= (String) session.getAttribute("cicloId");

	String cicloGrupoId		= request.getParameter("CicloGrupoId");
	String cursoId			= request.getParameter("CursoId");
	String evaluacionId		= request.getParameter("EvaluacionId");
	String estado			= request.getParameter("estado")==null?"":request.getParameter("estado");
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	String redondeo			= aca.ciclo.Ciclo.getRedondeo(conElias, cicloId);
	String decimales		= aca.ciclo.Ciclo.getDecimales(conElias, cicloId);
	String calculaPromedio  = aca.ciclo.CicloBloque.getCalculo(conElias, cicloId, evaluacionId);
	
	String planId			= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	String nivelId  		= aca.plan.Plan.getNivel(conElias, planId);
	
	cicloGrupo.mapeaRegId(conElias, cicloGrupoId);	
	
	//CONDICIONES DE LAS NOTAS ---------------------------->
	//String evaluaConPunto		= aca.plan.PlanCurso.getPunto(conElias, cursoId); /* Evalua con punto decimal el cursoId */
	float notaAC 				= Float.parseFloat(aca.plan.PlanCurso.getNotaAC(conElias, cursoId)); /* La nota con la que se acredita el cursoId */
	int escalaCiclo				= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	int escala 					= 0;
	
	// En Panama respetamos la configuracion del sistema, en México y Dominicana evaluacion de 0-100 pero promediamos en 10 
	if (!escuelaId.substring(0,1).equals("H")) 
		escala = 100;
	else
		escala = escalaCiclo;	
	BigDecimal notaMinima = BigDecimal.ZERO;
	notaMinima			=  notaMinima.add(new BigDecimal(aca.catalogo.CatNivelEscuela.getNotaMinima(conElias, nivelId, escuelaId ),MATH_CTX),MATH_CTX); /* La nota minima que puede sacar un alumno, depende del nivel de la escuela */	
	
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
		
		
		if(error == false){//Si no hay error entonces grabar el promedio de las actividades en las evaluaciones
			
			lisKrdxActiv = krdxAlumActivL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, "ORDER BY ALUM_APELLIDO(CODIGO_ID), ACTIVIDAD_ID");
		
			for(aca.kardex.KrdxCursoAct krdxCursoAct: lisKardexAlumnos){ 
				
				
				//double valorActividadesTotal = 0;
				BigDecimal valorActividadesTotal = BigDecimal.ZERO;
				// Valor de la actividad
				BigDecimal valorActividad = BigDecimal.ZERO;
				
				// Coloca el mismo valor a todas las actividades				
				for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
					for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
						if(krdxAlumActiv.getCodigoId().equals(krdxCursoAct.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){
							if (calculaPromedio.equals("P")){
								valorActividad = new BigDecimal("5",MATH_CTX);
								valorActividadesTotal = valorActividadesTotal.add( valorActividad ,MATH_CTX);
							}else{
								valorActividad = new BigDecimal( cicloGrupoActividad.getValor(),MATH_CTX);
								valorActividadesTotal = valorActividadesTotal.add( valorActividad ,MATH_CTX);	
							}							
						}
					}
				}
				
				
				//float promedioActividades = 0f;
				BigDecimal promedioActividades = BigDecimal.ZERO;
				for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
					for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
						if(krdxAlumActiv.getCodigoId().equals(krdxCursoAct.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){								
							
							if(valorActividadesTotal.compareTo(BigDecimal.ZERO) != 0){
								if (calculaPromedio.equals("P")){									
									promedioActividades = promedioActividades.add( new BigDecimal(krdxAlumActiv.getNota(),MATH_CTX).multiply( new BigDecimal("5",MATH_CTX),MATH_CTX ),MATH_CTX);
								}else{//Si calculaPromedio = V
									promedioActividades = promedioActividades.add( new BigDecimal(krdxAlumActiv.getNota(),MATH_CTX).multiply( new BigDecimal(cicloGrupoActividad.getValor(),MATH_CTX),MATH_CTX ),MATH_CTX);			
								}
							}
						}
					}
				}
				if(promedioActividades.floatValue() > 0){
					promedioActividades = promedioActividades.divide(valorActividadesTotal,MATH_CTX);
				}
				
				
				// Si no es Panama promediar en base a 10
				if (!escuelaId.substring(0,1).equals("H")){
					if (escalaCiclo == 10){					
						promedioActividades = promedioActividades.divide(new BigDecimal("10"),6,RoundingMode.HALF_EVEN);
					}	
				}
				
				/* Quitar decimales, por ejemplo (88.6 a 88) (80.1 a 80) */
				//promedioActividades = new BigDecimal( frmEntero.format(promedioActividades) );
				if(decimales.equals("0")){
					if(redondeo.equals("A") ){
						promedioActividades = promedioActividades.setScale(1, BigDecimal.ROUND_HALF_UP);
					}else{
						promedioActividades = new BigDecimal( frmEntero.format(promedioActividades),MATH_CTX );
					}					
				}else if(decimales.equals("1")){
					promedioActividades = new BigDecimal( frmDecimal1.format(promedioActividades),MATH_CTX );
					if(redondeo.equals("A") ){
						promedioActividades = promedioActividades.setScale(2, BigDecimal.ROUND_HALF_UP);
					}else{
						promedioActividades = new BigDecimal( frmDecimal1.format(promedioActividades),MATH_CTX );
					}
				}
				
				//--------COMPROBAR SI TIENEN PUNTO DECIMAL----------
				
				if(decimales.equals("0")){
					/* Si tiene una nota reprobatoria entonces el redondeo es hacia abajo, por ejemplo: (5.9 a 5) (5.6 a 5) (4.9 a 4)  */
					if( promedioActividades.compareTo( new BigDecimal(notaAC) ) == -1 ){// promedioActividades<notaAC
						promedioActividades = new BigDecimal( frmEntero.format( promedioActividades.setScale(0, RoundingMode.FLOOR) ),MATH_CTX );
					}
					/* Si tiene una nota aprobatoria entonces el redondeo es normal, por ejemplo: (6.4 a 6) (6.6 a 7)  */
					else{
						promedioActividades = new BigDecimal( frmEntero.format( promedioActividades.setScale(0, RoundingMode.HALF_UP) ),MATH_CTX );
					}
				}	
						
				//--------VERIFICAR LA NOTAMINIMA PARA EL NIVEL----------
				
				if( promedioActividades.compareTo( notaMinima ) == -1 ){// promedioActividades<notaMinima
					promedioActividades = notaMinima;
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
		<small>
		( <%=empPersonal.getNombre() + " " + empPersonal.getApaterno()+ " " + empPersonal.getAmaterno()%> 
		| <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> 
		| <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%> <%= cicloGrupo.getGrupo() %> 
		| <%=aca.plan.Plan.getNombrePlan(conElias, planId)%> )
		</small>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  		
	<div class="well">
		<a href="evaluar.jsp?CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>

	<table class="table table-condensed table-striped table-bordered">
		<tr>
			<th class="text-center">#</th>
			<th><fmt:message key="aca.Descripcion"/></th>
			<th><fmt:message key="aca.Fecha"/></th>
			<th><fmt:message key="aca.Valor"/></th>
			<th><fmt:message key="aca.Decimal"/></th>
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
					<td>
					<%	if (calculaPromedio.equals("V")){
							out.print(cicloGrupoActividad.getValor());
						}else{
							out.print("Promedia");
						}
					%>
					</td>
					<td>0</td>
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
						Las actividades se evalúan de <%=frmEntero.format(notaMinima)%> a <%= escala %>
						&nbsp;&nbsp;
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
							<th style="width:4%;" class="text-center" title="<%=cicloGrupoActividad.getActividadNombre() %>"><%=cont%></th>
					<%
						}						
						String txtEscala=notaMinima+" a "+escala+", "+(decimales.equals("1")?"Evaluación con punto decimal":"Evaluación con enteros");
					%>
					<th class="text-center" title="<fmt:message key='aca.MensajePromedioActividades' />">
						<fmt:message key="aca.Promedio"/>
					</th>
					<th class="text-center" title="<%=txtEscala%>"><fmt:message key="aca.PromedioEvaluacion"/></th>
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
										if (decimales.equals("0")){
											strNota = frmEntero.format(new BigDecimal(krdxAlumActiv.getNota(),MATH_CTX)).replaceAll(",", ".");
										}else{
											strNota = frmDecimal1.format(new BigDecimal(krdxAlumActiv.getNota(),MATH_CTX)).replaceAll(",", ".");
										}				
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
												data-max-num="<%=escala %>"
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
							
							// Valor de la actividad
							BigDecimal valorActividad = new BigDecimal("0",MATH_CTX);
									
							//double valorActividadesTotal = 0;
							BigDecimal valorActividadesTotal = new BigDecimal("0",MATH_CTX);							
							
							// Coloca el mismo valor a todas las actividades 
							for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
								for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
									if(krdxAlumActiv.getCodigoId().equals(kardex.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){
										if (calculaPromedio.equals("P")){
											valorActividad = new BigDecimal("5",MATH_CTX);
											valorActividadesTotal = valorActividadesTotal.add( valorActividad );									
										}else{
											valorActividad = new BigDecimal( cicloGrupoActividad.getValor(),MATH_CTX);
											valorActividadesTotal = valorActividadesTotal.add( valorActividad );											
										}										
									}
								}
							}							
							
							//float promedioActividades = 0f;
							BigDecimal promedioActividades = new BigDecimal("0",MATH_CTX);
							for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
								for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
									if(krdxAlumActiv.getCodigoId().equals(kardex.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){								
										//promedioActividades += (Float.parseFloat(krdxAlumActiv.getNota())*Float.parseFloat(cicloGrupoActividad.getValor()))/valorActividadesTotal;
										if(valorActividadesTotal.compareTo(BigDecimal.ZERO) != 0){
											if (calculaPromedio.equals("P")){
												promedioActividades = promedioActividades.add( new BigDecimal(krdxAlumActiv.getNota(),MATH_CTX).multiply( new BigDecimal("5",MATH_CTX), MATH_CTX), MATH_CTX);
											}else{																				
												promedioActividades = promedioActividades.add( new BigDecimal(krdxAlumActiv.getNota(),MATH_CTX).multiply( new BigDecimal(cicloGrupoActividad.getValor(),MATH_CTX), MATH_CTX), MATH_CTX);
											}											
										}
									}
								}
							}
							if(promedioActividades.floatValue() > 0){
								promedioActividades = promedioActividades.divide(valorActividadesTotal,MATH_CTX);
							}
						%>
							<td class="text-center">
							<%
							if(decimales.equals("0")){
								/* Si tiene una nota reprobatoria entonces el redondeo es hacia abajo, por ejemplo: (5.9 a 5) (5.6 a 5) (4.9 a 4)  */
								if( promedioActividades.compareTo( new BigDecimal(notaAC) ) == -1 ){// promedioActividades<notaAC
									out.print( frmEntero.format( promedioActividades.setScale(0, RoundingMode.FLOOR) ));
								}
								/* Si tiene una nota aprobatoria entonces el redondeo es normal, por ejemplo: (6.4 a 6) (6.6 a 7)  */
								else{
									if(escuelaId.substring(0, 1).equals("H") || escuelaId.substring(0, 1).equals("G"))
										out.print( frmEntero.format( promedioActividades.setScale(0, RoundingMode.HALF_UP) ));
									else
										out.print( frmDecimal1.format( promedioActividades.setScale(1, RoundingMode.HALF_UP) ));
								}
							}
								%>
							</td>
						<%
							// obtiene el promedio de la evaluacion que esta en la BD
							String promedio =  aca.kardex.KrdxAlumEval.getNotaEval(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, Integer.parseInt(evaluacionId));		
							
							String strProm = "-";
							if( promedio != null && !promedio.equals("-") ){
								if(decimales.equals("0")){
									strProm = frmEntero.format(new BigDecimal(promedio,MATH_CTX)).replaceAll(",", ".");
								}else{
									strProm = frmDecimal1.format(new BigDecimal(promedio,MATH_CTX)).replaceAll(",", ".");									
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