<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="Plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="AlumCiclo" scope="page" class="aca.alumno.AlumCiclo"/>
<jsp:useBean id="Kardex" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="CicloL" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="GrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>

<script>		
	function cambiaCiclo( ){
		document.frmInscrito.Accion.value = "1";
		document.frmInscrito.submit();	
	}
	
	function cambiaPeriodo( ){
		document.frmInscrito.Accion.value = "1";
		document.frmInscrito.submit();
	}
	
	function Quitar(){
		if(confirm("<fmt:message key="js.ConfirmaEliminacionMaterias" />")==true){
			document.frmInscrito.Accion.value = "3";
			document.frmInscrito.submit();
		}	
	}
	
	function BorraNotas(){
		if(confirm("<fmt:message key="js.ConfirmaEliminacionNotas" />")){
			document.frmInscrito.Accion.value = "4";
			document.frmInscrito.submit();
		}
	}
	
	function BajaTotal(){
		if(confirm("<fmt:message key="js.ConfirmaBajaTotalAlumno" />")){
			document.frmInscrito.Accion.value = "5";
			document.frmInscrito.submit();
		}
	}
	
	function seleccionarTodos(checkAll){
		var checkbox = $('.checkbox');
		
		if($(checkAll).is(':checked')){
			checkbox.filter(':not([onclick])').prop('checked', true);	
		}else{
			checkbox.filter(':not([onclick])').prop('checked', false);
		}
		
		/* REFRESCAR EL HORARIO */
		checkbox.each(function(){
			var $this = $(this);
			
			if( $this.is(':checked') == false ){
				$('.materia-'+$this.data('cursoid')).fadeOut(200);
			}else{
				$('.materia-'+$this.data('cursoid')).fadeIn(200);
			}
		});
	}
	
	function Grabar(){
		if(revisa()){
			
			var validaHorario = document.frmInscrito.ValidaHorario.value;
						
			$.post('revisarHorario.jsp', $(document.frmInscrito).serialize(), function(r){
				if( $.trim(r) == 'chocaHorario' && validaHorario == 'S' ){
					alert("<fmt:message key="js.HorarioChoca" />");
				}else{
					
					if( $.trim(r) == 'chocaHorario'){
						
						if( confirm("<fmt:message key="js.ConfirmaHorarioChoca" />") ){
							document.frmInscrito.Accion.value = "2";
							document.frmInscrito.submit();	
						} 
						
					}else{
						document.frmInscrito.Accion.value = "2";
						document.frmInscrito.submit();	
					}
					
				}
			});
			
		}else {
			alert("<fmt:message key="js.NoMateriasSeleccionadas" />");
		}
	}
	
	function revisa(){
		var cont = 0;
		
		$('.checkbox').each(function(){
			if($(this).is(':checked')){
				cont++;
			}
		});
		
		if(cont>0){
			return true;
		}else{
			return false;
		}
	}	
	
</script>

<%		
	String codigoAlumno 	= (String) session.getAttribute("codigoAlumno");
	String escuelaId 		= (String) session.getAttribute("escuela");
	String planAlumno		= aca.alumno.AlumPlan.getPlanActual(conElias,codigoAlumno);
	String nivelAlumno		= String.valueOf(aca.alumno.AlumPlan.getNivelAlumno(conElias,codigoAlumno));
	
	Plan.mapeaRegId(conElias, planAlumno);
	
	// Valores de Sesion, parametros y variables	
	String cicloId			= request.getParameter("Ciclo")==null?((String) session.getAttribute("cicloId")):request.getParameter("Ciclo");
	String periodoId	    = request.getParameter("PeriodoId")==null?aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId):request.getParameter("PeriodoId");		
	
	if(periodoId.equals("0")){	periodoId="1"; }
	
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodo 	= cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY CICLO_PERIODO.F_INICIO");
	
	boolean encontroPeriodo = false;
	for(aca.ciclo.CicloPeriodo per : lisPeriodo){
		if(per.getPeriodoId().equals(periodoId)){
			encontroPeriodo = true;
		}
	}
	
	if(encontroPeriodo==false && lisPeriodo.size()>0){
		periodoId = lisPeriodo.get(0).getPeriodoId();
	}
		
	Alumno.mapeaRegId(conElias,codigoAlumno);
				
	String	cicloGrupoId 								= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias,nivelAlumno,Alumno.getGrado(),Alumno.getGrupo(),cicloId,planAlumno);		
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso 	= GrupoCursoL.getListMateriasGrupo(conElias, cicloGrupoId, " ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	String maestroBase 									= aca.ciclo.CicloGrupo.getMaestroBase(conElias,Alumno.getNivelId(),Alumno.getGrado(),Alumno.getGrupo(),cicloId);
		
/* ********************************** ACCIONES ********************************** */
	
	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj  			= "";
	
//------------- CAMBIAR CICLO ------------->
	if( accion.equals("1") ){
		cicloId 	= request.getParameter("Ciclo");
		session.setAttribute("cicloId",cicloId);
	}
//------------- GUARDA LAS MATERIAS Y CAMBIA EL ESTADO DEL ALUMNO A INSCRITO ------------->
	else if( accion.equals("2") ){
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
		
		AlumCiclo.setCodigoId(codigoAlumno);
		AlumCiclo.setCicloId(cicloId);
		AlumCiclo.setPeriodoId(periodoId);
		AlumCiclo.setEstado("I");
		AlumCiclo.setClasfinId(Alumno.getClasfinId());
		AlumCiclo.setPlanId(planAlumno);
		AlumCiclo.setNivel(Alumno.getNivelId());
		AlumCiclo.setGrado(Alumno.getGrado());
		AlumCiclo.setGrupo(Alumno.getGrupo());
		
		if(!AlumCiclo.existeReg(conElias)){
			if(!AlumCiclo.insertReg(conElias)){
				error = true;
			} 
		}else{
			if(!AlumCiclo.updateReg(conElias)){
				error = true;
			}
		}
		
		if( error == false ){
			int i = 0;
			for(aca.ciclo.CicloGrupoCurso grupoCurso : lisGrupoCurso){
				
				Kardex.setCodigoId(codigoAlumno);
				Kardex.setCicloGrupoId(grupoCurso.getCicloGrupoId());
				Kardex.setCursoId(grupoCurso.getCursoId());
				
				String checkBox = request.getParameter("Check"+i)==null?"N":"S";
				
				if(checkBox.equals("S")){
					/* Guarda materia */
					Kardex.setTipoCalId("1");
					if(!Kardex.existeReg(conElias)){
						if(!Kardex.insertRegMateria(conElias)){
							error = true; break;
						}
					}else{
						if(!Kardex.updateEstado(conElias)){
							error = true; break;
						}
					}
				}else{
					/* Elimina materia */
					if(Kardex.existeReg(conElias)){
						// Verificar si hay Notas
						if(aca.kardex.KrdxAlumEval.existeReg(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId())){
							error = true; break;
						}else{
							// Borra las materias							
							if(!Kardex.deleteRegInscripcion(conElias)){
								error = true; break;
							}
						}
					}
				}
				i++;
			}//End for
		}
			
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoLogroInscribir";
		}else{
			conElias.commit();
			msj = "AlumnoInscrito";
		}
			
		conElias.setAutoCommit(true);//** END TRANSACTION **
	}
//------------- ELIMINA TODAS LAS MATERIAS Y DESINSCRIBE AL ALUMNO ------------->	
	else if(accion.equals("3")){
				
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
		
		for(int i=0;i<lisGrupoCurso.size();i++){
			aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(i);
			
			Kardex.setCodigoId(codigoAlumno);
			Kardex.setCicloGrupoId(grupoCurso.getCicloGrupoId());
			Kardex.setCursoId(grupoCurso.getCursoId());
			
			if(Kardex.existeReg(conElias)){
				// Verificar si hay Notas
				if(aca.kardex.KrdxAlumEval.existeReg(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId())){
					error = true; break;
				}else{
					// Borra las materias							
					if(!Kardex.deleteRegInscripcion(conElias)){
						error = true; break;
					}
				}
			}
			
		}
		
		if( error == false ){
			AlumCiclo.setCodigoId(codigoAlumno);
			AlumCiclo.setCicloId(cicloId);
			AlumCiclo.setPeriodoId(periodoId);
			AlumCiclo.setEstado("M");
			AlumCiclo.setClasfinId(Alumno.getClasfinId());
			AlumCiclo.setPlanId(planAlumno);
			AlumCiclo.setNivel(Alumno.getNivelId());
			AlumCiclo.setGrado(Alumno.getGrado());
			AlumCiclo.setGrupo(Alumno.getGrupo());
			
			if(AlumCiclo.existeReg(conElias)){
				if(AlumCiclo.updateReg(conElias)){
					//Inscripcion cancelada
				}else{
					error = true;
				}
			}
		}
		
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoPosibleCompletar";
		}else{
			conElias.commit();
			msj = "InscripcionCancelada";
		}
		
		conElias.setAutoCommit(true);//** END TRANSACTION **		
	}
//------------- BORRA TODAS LAS NOTAS REGISTRADAS EN LAS MATERIAS DEL ALUMNO (ACTIVIDADES Y EVALUACIONES) ------------->
	else if(accion.equals("4")){
					
		if(aca.kardex.KrdxAlumActiv.tieneActividades(conElias,codigoAlumno,cicloGrupoId)){
			if(aca.kardex.KrdxAlumActiv.deleteRegGrupo(conElias,codigoAlumno,cicloGrupoId)){
				if(aca.kardex.KrdxAlumEval.deleteRegGrupo(conElias,codigoAlumno,cicloGrupoId) ){
					msj = "NotasBorradas";
				}else{
					msj = "NoPosibleCompletar";
				}
			}else{
				msj = "NoPosibleCompletar";						
			}					
		}else{
			if(aca.kardex.KrdxAlumEval.deleteRegGrupo(conElias,codigoAlumno,cicloGrupoId) ){
				msj = "NotasBorradas";
			}else{
				msj = "NoPosibleCompletar";
			}
		}		
		
	}
//------------- DAR DE BAJA ------------->
	else if(accion.equals("5")){
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
			
		for(aca.ciclo.CicloGrupoCurso grupoCurso : lisGrupoCurso){
			Kardex.mapeaRegId(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId());
			Kardex.setTipoCalId("6");
			if(!Kardex.updateReg(conElias)){
				error = true; break;
			}
		}
		if( error == false ){
			AlumCiclo.mapeaRegId(conElias, codigoAlumno, cicloId, periodoId);
			AlumCiclo.setEstado("B");
			if(AlumCiclo.updateReg(conElias)){
				//Alumno dado de baja
			}else{
				error = true;
			}
		}

		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "ErrorEstadoAlumno";
		}else{
			conElias.commit();
			msj = "AlumnoDadoBaja";
		}
		
		conElias.setAutoCommit(true);//** END TRANSACTION **	
	}

	
	pageContext.setAttribute("resultado", msj);

/* ********************************** END ACCIONES ********************************** */
	
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo	= CicloL.getListCiclosAbiertos(conElias, escuelaId,"ORDER BY CICLO_ID");
	
%>

<div id="content">
	
<%if(!Alumno.existeReg(conElias, codigoAlumno)){ %>
	<div class="alert">
		<fmt:message key="aca.NoAlumnoSeleccionado" />
	</div>
<%}else if(lisCiclo.size()==0){ %>
	<div class="alert">
		<fmt:message key="aca.ciclosNoDisponibles" />
	</div>
<%}else{ %>
	
	<h2><fmt:message key="inscripcion.InscripcionAlumno" /> </h2>
		
  	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado") || msj.equals("AlumnoInscrito") || msj.equals("InscripcionCancelada") || msj.equals("NotasBorradas") || msj.equals("AlumnoDadoBaja")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	  	

	<form action="inscrito.jsp" method="post" name="frmInscrito" id="frmInscrito" target="_self">
		<input type="hidden" name="Accion">
		<input type="hidden" name="ValidaHorario" value="<%=Plan.getValidaHorario() %>" />
		
		<!-- ======================= CONFIGURACION (CARGA Y PERIODO DE INSCRIPCION) ======================= -->
		
		<div class="well">
		 
			<select name="Ciclo" id="Ciclo" onchange="javascript:cambiaCiclo()" class="input-xxlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId)){out.print("selected");} %>><%=ciclo.getCicloNombre()%></option>
				<%}%>
			</select>
			  
			<select name="PeriodoId" id="PeriodoId" onchange='javascript:cambiaPeriodo()'  class="input-xlarge">
				<%for(aca.ciclo.CicloPeriodo periodo : lisPeriodo){%>
					<option value="<%=periodo.getPeriodoId() %>" <%if(periodo.getPeriodoId().equals(periodoId)){out.print("selected");} %>><%=periodo.getPeriodoNombre() %></option>
				<%}%>
			</select>
			
		</div>
		
		<!-- ======================= INFORMACION DEL ALUMNO ======================= -->
				
		<div class="well" style="background:white;"> 
			
			<div class="row">
				<div class="span2">
					<img src="../../parametros/foto/foto.jsp?mat=<%=codigoAlumno%>" width="100">
				</div>
				
				<div class="span6">
					<p>
						<strong><fmt:message key="aca.Alumno" />:</strong> <%=codigoAlumno%> | <%=Alumno.getNombre()+" "+Alumno.getApaterno()+" "+Alumno.getAmaterno() %> <br />
						<strong><fmt:message key="aca.Plan" />:</strong>  <%= aca.plan.Plan.getNombrePlan(conElias,planAlumno)%> <br />
						<strong><fmt:message key="catalogo.Nivel" />:</strong>  <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, Alumno.getNivelId())%> <br /> 
						<strong><fmt:message key="aca.Grado" />:</strong>  <%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(Alumno.getGrado()))%> <br /> 
						<strong><fmt:message key="aca.Grupo" />:</strong>  "<%=Alumno.getGrupo()%>" <br />
						<%if(aca.alumno.AlumCiclo.estaInscritoPlanNivelGradpGrupo(conElias, codigoAlumno, cicloId, periodoId, planAlumno, Alumno.getNivelId(), Alumno.getGrado(), Alumno.getGrupo() )){%>
						<%//if(aca.alumno.AlumCiclo.estaInscrito(conElias, codigoAlumno, cicloId, periodoId )){%> 
							<span class="label label-success"><fmt:message key="aca.Inscrito" /></span> 
						<%}else{ %>
							<span class="label label-inverse"><fmt:message key="aca.NoInscrito" /></span>
						<%} %>
							
							
						<%if(aca.alumno.AlumCiclo.estaInscritoPlanNivelGradpGrupo(conElias, codigoAlumno, cicloId, periodoId, planAlumno, Alumno.getNivelId(), Alumno.getGrado(), Alumno.getGrupo() )){%>
						<%//if(aca.alumno.AlumCiclo.estaInscrito(conElias, codigoAlumno, cicloId, periodoId )){%>
							<a class="btn btn-mini btn-warning" onclick="javascript:BajaTotal()" title="<fmt:message key="aca.DaDeBajaTodasLasMaterias" />" >
								<i class="icon-arrow-down icon-white"></i> <fmt:message key="boton.DarDeBaja" />
							</a>
							<%if(aca.kardex.KrdxAlumEval.tieneEvaluacionesElAlumno(conElias, codigoAlumno, cicloGrupoId)){%>
					  			<a class="btn btn-mini btn-danger" onclick="javascript:BorraNotas()" title="<fmt:message key="aca.BorraLaNota" />" ><i class="icon-remove icon-white"></i> <fmt:message key="boton.BorrarNotas" /></a>
							<%}else{%>
								<a class="btn btn-mini btn-danger" onclick="javascript:Quitar()" title="<fmt:message key="aca.CancelaLaInscripcion" />" ><i class="icon-remove icon-white"></i> <fmt:message key="boton.CancelarInscripcion" /></a>
							<%}%>
						<%}%>
					</p>
				</div>
			</div>
				
	  	</div>
	  	
	  	
			
		<%if(lisPeriodo.size()==0){ %>
			<div class="alert">
				<fmt:message key="aca.periodosNoDisponibles" />
			</div>
		<%}else if(lisGrupoCurso.size()==0){ %>
			<div class="alert">
				<fmt:message key="aca.MateriasNoDisponiblesEnEsteCiclo" />
			</div>
		<%}else{ %>
			
			<!-- ======================= HORARIO ======================= -->
			
			<%@ include file= "horario.jsp" %>
			
			<!-- ======================= ENCABEZADO MATERIAS ======================= -->
			
			<h3>
				<fmt:message key="aca.Materias" />
				
				<small>
					<fmt:message key="aca.MaestroDePlanta" />: <strong><%=aca.empleado.EmpPersonal.getNombre(conElias,maestroBase,"NOMBRE")%></strong>
				</small>
			</h3>
									
			<!-- ======================= MATERIAS ======================= -->
	
			<table class="table table-condensed table-bordered"> 
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Clave" /></th>
					<th>
						<input name="CheckAll" type="checkbox" value="S" checked onclick='javascript:seleccionarTodos(CheckAll)'>
						<fmt:message key="aca.Materia" />
					</th>
					<th><fmt:message key="aca.Estado" /></th>
					<th><fmt:message key="aca.TieneNota" /></th>
					<th><fmt:message key="aca.Maestro" /></th>
					<th><fmt:message key="aca.Tipo" /></th>
				</tr>
				
				<% 	
					int cont = 0;
					for(aca.ciclo.CicloGrupoCurso grupoCurso : lisGrupoCurso){			 
								
						String maestroMateria	= aca.empleado.EmpPersonal.getNombre(conElias, grupoCurso.getEmpleadoId(),"NOMBRE");
						String materia 			= aca.plan.PlanCurso.getCursoNombre(conElias,grupoCurso.getCursoId());
						String tipo 			= aca.plan.PlanCurso.getTipocurso(conElias, grupoCurso.getCursoId());
				%>
			  			
			  			<tr>
			    	  		<td><%=cont+1%></td>
			    	  		<td>
			    	  			<%=grupoCurso.getCursoId()%>
			    	  		</td>
			    	  		<td>
			    	  			<% 	AlumCiclo.setCodigoId(codigoAlumno);
									AlumCiclo.setCicloId(cicloId);
									AlumCiclo.setPeriodoId(periodoId);
									
									if(!AlumCiclo.existeReg(conElias)){
								%>
										<input class="checkbox" data-cursoid="<%=grupoCurso.getCursoId()%>" name="Check<%=cont%>" type="checkbox" value="S" checked>
								<%	
									}else{
						    	  		if(aca.kardex.KrdxCursoAct.existeReg(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId())){
						    	%>
											<input class="checkbox" data-cursoid="<%=grupoCurso.getCursoId()%>" name="Check<%=cont%>" type="checkbox" value="S" checked <%if(aca.kardex.KrdxAlumEval.existeReg(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId())){ %> title="<fmt:message key="aca.NoSePuedeQuitarEstaMateria" />" onclick="return false;" <%} %>>
							  	<%
							  			}else{
							  	%>
											<input class="checkbox" data-cursoid="<%=grupoCurso.getCursoId()%>" name="Check<%=cont%>" type="checkbox" value="S">
						  		<%
						  				}
						    	  	} 
						    	%>
						    	
						    	
			    	  			<%=materia%>
			    	  		</td>
			    	  		<td>
							<%	if(aca.kardex.KrdxCursoAct.existeReg(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId())){
									Kardex.mapeaRegId(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId());
									if(Kardex.getTipoCalId().equals("6")){ %>
										<span class="label label-important"><fmt:message key="aca.Baja" /></span>
									<%}else{%>
										<span class="label label-success"><fmt:message key="aca.Inscrito" /></span>
									<%}
								}else{
							%>
									<span class="label label-inverse"><fmt:message key="aca.NoInscrito" /></span>
							<%
								} 
							%>
		    	  			</td>
		    	  			<td>
		    	  				<%if(aca.kardex.KrdxAlumEval.existeReg(conElias, codigoAlumno, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId())){ %>
		    	  					<fmt:message key="aca.Si" />
		    	  				<%}else{ %>
		    	  					<fmt:message key="aca.Negacion" />
		    	  				<%} %>
		    	  			</td>
			    	  		<td><%=maestroMateria%></td>
			    	  		<td>
		    	  				<%if(tipo.equals("1")){%>
				    	  			<fmt:message key="aca.Oficial" />
				    	  		<%}else if(tipo.equals("2")){%>
				    	  			<fmt:message key="aca.NoOficial" />
				    	  		<%}else if(tipo.equals("3")){%>
				    	  			<fmt:message key="aca.Ingles" />
				    	  		<%}%>
			    	  		</td>
			  	  		</tr>
				<%	
						cont++;	
					} 
				%>        
			    
			</table>
			
			<%if( aca.ciclo.Ciclo.getCicloActivo(conElias, cicloId) == false ){%>
				<div class="alert">
					<h4><fmt:message key="aca.NoSePuedeInscribirCiclo" /></h4>
				</div>
			<%}else if( aca.alumno.AlumCiclo.estaInscritoConOtrosDatos(conElias, codigoAlumno, cicloId, periodoId, planAlumno, Alumno.getNivelId(), Alumno.getGrado(), Alumno.getGrupo() ) ){ %>
				<div class="alert">
					<h4><fmt:message key="aca.YaEstaInscritoCiclo" /></h4>
				</div>	
			<%}else{%>
				<div class="well"><a class="btn btn-primary btn-large" onclick="javascript:Grabar()"><i class="icon-ok icon-white "></i> <fmt:message key="boton.GuardarMaterias" /></a></div>
			<%} %>
			
		<%} %>
	</form>
	
<%}%>
</div>

<%@ include file= "../../cierra_elias.jsp" %>