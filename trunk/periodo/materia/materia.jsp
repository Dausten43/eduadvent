<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.TreeMap"%>
<%@page import="java.util.HashSet"%>

<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="CicloGrupoL" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="CursoL" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="GrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="BloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="BloqueActividadLista" scope="page" class="aca.ciclo.CicloBloqueActividadLista"/>
<jsp:useBean id="GrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="GrupoActividad" scope="page" class="aca.ciclo.CicloGrupoActividad"/>
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<jsp:useBean id="CatGrupoL" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="KrdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>


<script>
	function GrabaCurso(cicloGrupoId, EmpleadoId){
		document.frmGrupo.Accion.value = "1";
		document.frmGrupo.CicloGrupoId.value = cicloGrupoId;
		document.frmGrupo.EmpleadoId.value = EmpleadoId;
		document.frmGrupo.submit();
	}
	
	function CambiaGrado(grado){
		document.frmGrupo.Accion.value = "2";
		document.frmGrupo.Grado.value = grado;
		document.frmGrupo.submit();
	}
	
	function llenarEvaluaciones(cursoId, cicloGrupoId){
		if(confirm("<fmt:message key="js.ConfirmaLlenarEval" />")==true){
		  		document.location="accion.jsp?cursoId="+cursoId+"&cicloGrupoId="+cicloGrupoId;
		 }
	}
</script>

<%
	String escuelaId		= (String) session.getAttribute("escuela");

	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	String grado 			= (String) session.getAttribute("grado")==null?"0":(String) session.getAttribute("grado");
	String cicloGrupoId		= request.getParameter("CicloGrupoId")==null?cicloId:request.getParameter("CicloGrupoId");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	int numAccion 			= Integer.parseInt(accion);	
	String nivelId 			= aca.plan.Plan.getNivel(conElias,planId);

	Nivel.mapeaRegId(conElias, nivelId, escuelaId);	
	
	String titulo 			= aca.plan.Plan.getTitulo(conElias, planId);
	int gradoIni			= Integer.parseInt(Nivel.getGradoIni());
	int gradoFin			= Integer.parseInt(Nivel.getGradoFin());
	
	String maestro 			= "";
	String numAlumnos 		= "";
	
	boolean cambiaGrupo 	= false;
	boolean existeMat		= false;
	
	ArrayList<aca.ciclo.CicloGrupo> lisGrupo 			= CicloGrupoL.getListGrupos(conElias, cicloId, planId, "ORDER BY NIVEL_ID, GRADO, GRUPO");
	ArrayList<aca.catalogo.CatGrupo> lisGrupoAltaObj 	= CatGrupoL.getListGruposAlta(conElias, cicloId, planId, escuelaId, nivelId, "ORDER BY NIVEL_ID, GRADO, GRUPO");
	ArrayList<Integer> lisGrupoAltaInt 					= new ArrayList<Integer>();
	for(aca.catalogo.CatGrupo grupo: lisGrupoAltaObj){
		if(!lisGrupoAltaInt.contains(Integer.parseInt(grupo.getGrado())))
			lisGrupoAltaInt.add(Integer.parseInt(grupo.getGrado()));
	}
	ArrayList<aca.plan.PlanCurso> lisCurso 				= CursoL.getListCursoActivo(conElias, planId, "ORDER BY GRADO, ORDEN");
	TreeMap<String, aca.ciclo.CicloGrupoCurso> treeGrupoCurso 	= GrupoCursoL.getTreeMateriasPlan(conElias, cicloId, planId, " ORDER BY CURSO_ID");
	TreeMap<String, String> treeAlumnos					= KrdxCursoActL.treeCantidadAlumnos(conElias, cicloId); 
	
	switch (numAccion){
		case 1: {
			ArrayList<aca.ciclo.CicloBloque> lisBloque 						= BloqueLista.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
			ArrayList<aca.ciclo.CicloBloqueActividad> lisBloqueActividad 	= BloqueActividadLista.getListAll(conElias, cicloId, "");
			
			CicloGrupo.mapeaRegId(conElias, cicloGrupoId);
			
			conElias.setAutoCommit(false);
			boolean error = false; 
			
			for(aca.plan.PlanCurso curso : lisCurso){
				
				// Si es el mismo Grado				
				if (curso.getGrado().equals(CicloGrupo.getGrado())){
					
					// Si eligio la materia la inserta en el grupo
					if (request.getParameter(cicloGrupoId+curso.getCursoId())!= null){
						existeMat = false;
						if (treeGrupoCurso.containsKey(cicloGrupoId+curso.getCursoId())){
							existeMat 		= true;							
						}else{							
							GrupoCurso.setCicloGrupoId(cicloGrupoId);
							GrupoCurso.setCursoId(curso.getCursoId());
							GrupoCurso.setEmpleadoId(request.getParameter("EmpleadoId"));
							GrupoCurso.setHorario("--");
							GrupoCurso.setSalonId("0");
							GrupoCurso.setEstado("1");
							
							if (GrupoCurso.insertReg(conElias)){
							System.out.println("inserto grupocurso " + GrupoCurso.toString());	
								for(aca.ciclo.CicloBloque bloque : lisBloque){
									
									GrupoEval.setCicloGrupoId(cicloGrupoId);
									GrupoEval.setCursoId(curso.getCursoId());
									GrupoEval.setEvaluacionId(bloque.getBloqueId());
									GrupoEval.setEvaluacionNombre(bloque.getBloqueNombre());						
									GrupoEval.setFecha(bloque.getFFinal());
									GrupoEval.setValor(bloque.getValor());
									GrupoEval.setTipo("P");
									GrupoEval.setEstado("A");
									GrupoEval.setCalculo("V");
									GrupoEval.setOrden(bloque.getOrden());									
									
									if(!GrupoEval.existeReg(conElias)){
										if(GrupoEval.insertReg(conElias)){
											
											for(aca.ciclo.CicloBloqueActividad act : lisBloqueActividad){
												if(!act.getBloqueId().equals(bloque.getBloqueId())){
													continue;
												}
												
												GrupoActividad.setCicloGrupoId(cicloGrupoId);
												GrupoActividad.setCursoId(curso.getCursoId());
												GrupoActividad.setEvaluacionId(bloque.getBloqueId());
												GrupoActividad.setActividadId(act.getActividadId());
												GrupoActividad.setActividadNombre(act.getActividadNombre());
												GrupoActividad.setFecha(act.getFecha());
												GrupoActividad.setValor(act.getValor());
												GrupoActividad.setTipoactId(act.getTipoactId());
												GrupoActividad.setEtiquetaId(act.getEtiquetaId());
												
												if(!GrupoActividad.existeReg(conElias)){
													if(GrupoActividad.insertReg(conElias)){
														
													}else{
														error = true; break;
													}
												}												
											}
											
										}else{
											error = true; break;
										}
									}
								}
								
							}else{
								error = true; break;
							}
						}
					}else{						
						// Borra la materia del grupo
						numAlumnos = aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoId, curso.getCursoId());
						// Si no tiene alumnos
						if (Integer.parseInt(numAlumnos)==0){
							GrupoCurso.setCicloGrupoId(cicloGrupoId);
							GrupoCurso.setCursoId(curso.getCursoId());
							if (GrupoCurso.deleteReg(conElias)){
								//Elimino correctamente
							}
						}
					}
				}
			}
			
			
			if( error ){
				conElias.rollback();
			}else{
				conElias.commit();
			}
			
			cicloGrupoId = "";
			conElias.setAutoCommit(true);
			
			// Recargar el TreeMap
			treeGrupoCurso 	= GrupoCursoL.getTreeMateriasPlan(conElias, cicloId, planId, " ORDER BY CURSO_ID");
			
			break;
		}
		case 2: {			
			session.setAttribute("grado",request.getParameter("Grado"));
			grado = request.getParameter("Grado");
			break;
		}
	}
%>
<div id="content">
	<h2><%= aca.plan.Plan.getNombrePlan(conElias, planId) %></h2>
	
	<div class="alert alert-info">
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId)%> |
		<%= aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId) %>
	</div>
	
	<div class="well">
		<a class="btn btn-primary" href="seleccionaPlan.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a class="btn btn-primary" href="grupo.jsp"><i class="icon-plus icon-white"></i> <fmt:message key="boton.AnadirQuitar" /></a> 
	</div>
	
	<ul class="nav nav-tabs">
  		<li <%if(grado.equals("0")){out.print("class='active'");} %>>
  			<a href="javascript:CambiaGrado('0');"><fmt:message key="boton.Todos" /></a>
  		</li>
<% 			for(int i: lisGrupoAltaInt){
%>
	  			<li <%if(grado.equals(i+"")){out.print("class='active'");} %>>
					<a href="javascript:CambiaGrado('<%=i%>');"><%=i%>°</a>
				</li>
<% 
			} 
%>
	</ul>
	
	<form name="frmGrupo" action="materia.jsp" method="post">
		<input type="hidden" name="Accion" />
		<input type="hidden" name="CicloGrupoId" />
		<input type="hidden" name="EmpleadoId" />
		<input type="hidden" name="Grado" />	
<%	
		for(aca.ciclo.CicloGrupo grupo: lisGrupo){
			
			if (grado.equals("0") || grado.equals(grupo.getGrado())){	
				
				boolean encabezado 	= true;
				if (cicloGrupoId.equals(grupo.getCicloGrupoId())){
					cambiaGrupo = true; 
				}else{
					cambiaGrupo = false;
				}
%>
		
		  		<div class="alert" >
		    		
		    		<a href="horarioGrupo.jsp?CicloGrupoId=<%= grupo.getCicloGrupoId()%>" title="<fmt:message key="aca.HorarioGrupo" />">
		    			<i class="icon-calendar"></i>
		    		</a>
		    		
		    		<%= grupo.getGrupoNombre() %> <%= grupo.getGrupo() %>
		    		
		    		<div style="float:right;">
		      			<a href="maestro.jsp?CicloGrupoId=<%= grupo.getCicloGrupoId()%>&Parametro=<%="Grupos" %>"><i class="icon-user"></i></a>
		      			<%= aca.empleado.EmpPersonal.getNombre(conElias,grupo.getEmpleadoId(),"NOMBRE") %>
		      		</div>
		        
		 		</div> 
<%	
				for(aca.plan.PlanCurso curso: lisCurso){
					if (curso.getGrado().equals(grupo.getGrado())){
						if (encabezado){ 
							encabezado = false;
%>
				<table class="table table-striped table-bordered">
					<tr>									
						<th style="width:8%;">
							<fmt:message key="aca.Estado" />&nbsp;&nbsp;
							<a href="materia.jsp?CicloGrupoId=<%=grupo.getCicloGrupoId()%>"> <i class="icon-check"></i> </a>
							<%if (cambiaGrupo){%>
							<a onclick="jQuery('.selecciona<%=grupo.getCicloGrupoId()%>').prop('checked',true)" class="btn btn-mini">Todos</a>&nbsp;
							<%}%>
						</th>
						<th style="width:3%;">#</th>
						<th style="width:10%;"><fmt:message key="aca.Clave" /></th>
						<th style="width:25%;"><fmt:message key="aca.Materia" /></th>
						<th style="width:4%;"><fmt:message key="aca.Cred" /></th>
						<th style="width:4%;"><fmt:message key="aca.Horas" /></th>
						<th style="width:25%;"><fmt:message key="aca.Maestro" /></th> 
						<th style="width:7%;"><fmt:message key="aca.Estrategias" /></th>
						<th style="width:7%;"><fmt:message key="aca.Evaluaciones" /></th>
						<th style="width:7%;"><fmt:message key="aca.Actividades" /></th>
						<th style="width:7%;"><fmt:message key="aca.Alumnos" /></th>
						<th style="width:7%;"><fmt:message key="aca.Borrar" /></th>
					</tr>
<%					
						}
						existeMat = false; 
						numAlumnos = "0";
						if (treeGrupoCurso.containsKey(grupo.getCicloGrupoId()+curso.getCursoId())){
							aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) treeGrupoCurso.get(grupo.getCicloGrupoId()+curso.getCursoId());
							existeMat 		= true;
							maestro 		= grupoCurso.getEmpleadoId();
							
							if(treeAlumnos.containsKey(grupo.getCicloGrupoId()+"@@"+curso.getCursoId())){
								numAlumnos = treeAlumnos.get(grupo.getCicloGrupoId()+"@@"+curso.getCursoId());
							}
						}else{
							maestro = "-";
						}				
%>
		  			<tr>	  				    
		    			<td>
<%						if (cambiaGrupo){							
							if(numAlumnos.equals("0")){
%>
		      				<input class="selecciona<%=grupo.getCicloGrupoId()%>" type="checkbox" name="<%=grupo.getCicloGrupoId()+curso.getCursoId()%>" value="S" <%= existeMat?"checked":" "%> >
<%							}else{
%>
		      				<input title="<fmt:message key="aca.ErrorCambiarEstado" />" type="checkbox" value="S" <%= existeMat?"checked":" "%> onclick="return false">
<%							}
						}else{
							if (existeMat){
%>								
								<span class="label label-success"><fmt:message key="aca.Activo" /></span>
<%								
							}else{
%>								
								<span class="label"><fmt:message key="aca.Inactivo"/></span>
<%								
							}
						}	
%>
						</td>		    				
		    			<td><%= curso.getOrden() %></td>
		    			<td><%= curso.getCursoId() %></td>
		    			<td>
		    				<%= curso.getCursoNombre() %> 
		    				<a style="float:right;" href="horario.jsp?CicloGrupoId=<%= grupo.getCicloGrupoId()%>&CursoId=<%=curso.getCursoId().replace("&","$") %>" class="btn btn-mini btn-success" title="<fmt:message key="aca.Horario" />"><i class="icon-calendar icon-white"></i></a>
		    			</td>
		    			<td><%= curso.getCreditos() %></td>
		    			<td><%= curso.getHoras() %></td>
		    			<td>
<% 							
							if (existeMat){
%>    
							<a href="maestro.jsp?CicloGrupoId=<%= grupo.getCicloGrupoId()%>&CursoId=<%=curso.getCursoId().replace("&","$") %>&Parametro=<%="Materias" %>">
					    		<i class="icon-user"></i>
					    	</a>      
					      		<%= aca.empleado.EmpPersonal.getNombre(conElias,maestro,"NOMBRE") %>
<%							}else{
								out.println("-");
							}

							int numProm		= Integer.parseInt(aca.ciclo.CicloPromedio.numPromedios(conElias, cicloId));
							int numEval 	= aca.ciclo.CicloGrupoEval.getNumEval(conElias, grupo.getCicloGrupoId(), curso.getCursoId());
							int numAct  	= aca.ciclo.CicloGrupoActividad.getNumActividades(conElias, grupo.getCicloGrupoId(), curso.getCursoId());
%>      
		    			</td>
		    			<td><%=numProm%></td>
		    			<td>
<% 							if (numEval==0){ %>
		    				<a href="javascript:llenarEvaluaciones('<%=curso.getCursoId()%>','<%=grupo.getCicloGrupoId()%>')"><%=numEval%></a>
<%							}else{
								out.print(numEval);
							}	
%>
		    			</td>
		    			<td><%=numAct%></td>
						<td><%= numAlumnos %></td>
						<td>
<%	 						if(existeMat){ 
%>	
							<a href="borrar.jsp?CicloGrupoId=<%= grupo.getCicloGrupoId()%>&CursoId=<%=curso.getCursoId()%>">
				    			<i class="icon-remove"></i>
				  			</a>
<%			 				}else{
								out.println("-");
							}
%>	  
						</td>
		  			</tr>			
<%				
					}
				}
				if (cambiaGrupo){
%>			
		 			<tr>
		    			<td colspan="10">
		      				<button class="btn btn-small btn-primary btn-mini" value="Grabar" onclick="javascript:GrabaCurso('<%=grupo.getCicloGrupoId()%>','<%=grupo.getEmpleadoId()%>')"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></button>
		      				<a href="materia.jsp" class="btn btn-mini"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></a>
		    			</td>
		  			</tr>
<%				} // if (cambiaGrupo)
			} // termina filtro de grado
%>
		</table>    
<%	
	}//Fin for cicloGrupo  
%>
	</form>

</div>
<%@ include file= "../../cierra_elias.jsp" %>