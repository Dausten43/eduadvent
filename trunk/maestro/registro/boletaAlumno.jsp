<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.util.TreeMap"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.text.*"%>

<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal" />
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista" />
<jsp:useBean id="AlumProm" scope="page" class="aca.vista.AlumnoProm" />
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxCursoAct" />
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="AlumnoCursoL" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="CatEscuela" scope="page" class="aca.catalogo.CatEscuela"/>
<jsp:useBean id="nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<%
	
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId 			= (String) session.getAttribute("cicloId");
	
	String cicloGrupoId 	= request.getParameter("CicloGrupoId");
	String codigoAlumno 	= request.getParameter("CodigoAlumno");	 
	String empleadoId	 	= request.getParameter("empleadoId");	 
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	
	AlumPersonal.setCodigoId(codigoAlumno);
	AlumPersonal.mapeaRegId(conElias, codigoAlumno);
	
	// Plan actual del alumno
	String planId 			= aca.alumno.AlumPlan.getPlanActual(conElias, codigoAlumno);
	// Escala
	int escalaEval 			= 100;// aca.ciclo.Ciclo.getEscala(conElias, cicloId );
	int evalcerradas		= 0;
	
	double promTotal 		= 0;

	java.text.DecimalFormat formato0	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0");
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00");
	formato0.setRoundingMode(java.math.RoundingMode.HALF_UP );
	formato1.setRoundingMode(java.math.RoundingMode.HALF_UP );
	formato2.setRoundingMode(java.math.RoundingMode.HALF_UP );
	DecimalFormat frmDecimal 	= new DecimalFormat("###,##0.0;(###,##0.0)");
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
	//DecimalFormat frmEntero 	= new DecimalFormat("###,##0;(###,##0)");
	java.math.MathContext mc = new java.math.MathContext(4, RoundingMode.HALF_EVEN);
	
	String msj 			= "";
	if(accion.equals("1")){
		double promedio = 0;
		AlumProm.setCodigoId(codigoAlumno);
		AlumProm.setCicloGrupoId(cicloGrupoId);
		AlumProm.setCursoId(request.getParameter("CursoId"));
		if (AlumProm.existeReg(conElias)){
			AlumProm.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, request.getParameter("CursoId"));
			promedio = Double.parseDouble(AlumProm.getPromedio().replaceAll(",","."));
			
			kardex.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, request.getParameter("CursoId"));
			kardex.setNota(frmDecimal.format(promedio));
			if(kardex.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModifico"; 
			}
		}
	}
	
	pageContext.setAttribute("resultado", msj);
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	if (Grupo.existeReg(conElias)) {
		Grupo.mapeaRegId(conElias, cicloGrupoId);
	}
	
	/* Lista de materias del alumno*/
	ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso 		= AlumnoCursoL.getListAlumCurso(conElias, codigoAlumno, cicloGrupoId, " ORDER BY TIPO_CURSO_ID(CURSO_ID), ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
	
	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
	
	// Lista de evaluaciones o bloques en el ciclo
	ArrayList<aca.ciclo.CicloBloque> lisBloque 			= CicloBloqueL.getListCiclo(conElias, cicloId, " ORDER BY BLOQUE_ID");	
	
	//Map de materias del plan seleccionado
	java.util.HashMap<String, aca.plan.PlanCurso> mapCurso		= aca.plan.PlanCursoLista.mapPlanCursos(conElias, planId);
	
	// Map de evaluaciones del alumno en Ciclo_Grupo_Eval
	java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapEvalCiclo	= aca.ciclo.CicloGrupoEvalLista.mapEvalAlumno(conElias, codigoAlumno);
	
	//Map de evaluaciones del alumno en Krdx_Alum_Eval
	java.util.HashMap<String, aca.kardex.KrdxAlumEval> mapEval	= aca.kardex.KrdxAlumEvalLista.mapEvalAlumno(conElias, codigoAlumno);	
	
	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalSumaTot			= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotasTot(conElias, codigoAlumno);
		
	//Map que cuenta las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalCuentaTot			= aca.kardex.KrdxAlumEvalLista.mapEvalCuentaNotasTot(conElias, codigoAlumno);
		
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromAlumno(conElias, codigoAlumno);
	
	// Datos de la escuela
	CatEscuela.setEscuelaId(escuelaId);
	if (CatEscuela.existeReg(conElias)){
		CatEscuela.mapeaRegId(conElias, escuelaId);
	}
	
	// Logo de la escuela	
	String logoEscuela 	= aca.catalogo.CatEscuela.getLogo(conElias, escuelaId);
	String dirLogo 		= application.getRealPath("/imagenes/logos/") + "/" + logoEscuela;	
	
	boolean tieneLogo 	= false;		
	// Verifica si existe la imagen del logo	
	java.io.File archivo = new java.io.File(dirLogo);
	if (archivo.exists()){
		tieneLogo = true;
		dirLogo = "../../imagenes/logos/"+logoEscuela;				
	}else{
		dirLogo = "../../imagenes/logos/logoIASD.png";
	}	
%>

<div id="content">	
	<table class="table" style="width:70%; margin:0 auto;">
		<tr>
			<td width="10%"> 
				<a class="btn btn-primary" href="alumnos.jsp?CicloGrupoId=<%=cicloGrupoId%>"><i class="icon-arrow-left icon-white"></i></a>
			</td>
			<td width="20%"> 
				<img width="120px" src="<%=dirLogo%>">
			</td>
			<td width="70%">
				<p style="font-size:30px; font-weight: bold;"><%=CatEscuela.getEscuelaNombre()%></p>
				<p style="font-size:15px; font-weight: bold;">
				<%=CatEscuela.getDireccion()%>,<%=CatEscuela.getColonia()%><br>
				Telefono: <%=CatEscuela.getTelefono()%><br>
				Fax: <%=CatEscuela.getFax()%>
				</p>
				<p style="font-size:20px; font-weight: bold;">
				Boleta de Calificaciones
				<p style="font-size:15px; font-weight: bold;">
			</td>
		</tr>			
	</table>
	<table class="table table-bordered table-condensed">
		<tr>
			<th width="5%">No.</th>
			<th width="25%">Nombres</th>
			<th width="30%">Apellidos</th>
			<th width="15%">Ciclo Escolar</th>
			<th width="10%">Nivel</th>
			<th width="5%">Curso</th>
			<th width="5%">Secci�n</th>
			<th width="5%">Tanda</th>
		</tr>
		<tr>
<%
		String content = aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId());
		content = content.replace("NIVEL", "");
%>
		
			<td><%=kardex.getOrden() %></td>
			<td><%=AlumPersonal.getNombre() %></td>
			<td><%=AlumPersonal.getApaterno() %> <%=AlumPersonal.getAmaterno() %></td>
			<td><%= aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId)%></td> 
			<td><%= content%></td>
			<td><%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado())) %></td>
			<td><%=Grupo.getGrupo() %></td>
			<td>MATUTINO</td>	
		</tr>
	</table>
	<form name="frmNotas" action="notasMetodo.jsp?CicloGrupoId=<%=cicloGrupoId%>&codigoAlumno=<%=codigoAlumno%>" method="post">
		<input type="hidden" name="Accion"> 
		<input type="hidden" name="CicloGrupoId" value="<%=cicloGrupoId%>"> 
		<input type="hidden" name="CodigoAlumno" value="<%=codigoAlumno%>">
						
		<table class="table table-condensed table-striped table-bordered table-condensed">
			<thead>
			<tr>
				<th width="2%">#</th>
			    <th width="20%"><fmt:message key="aca.NombreMateria"/></th>
<%
			for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
					
				for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
					if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
						// Inserta columnas de evaluaciones
						out.print("<th class='text-center' width='2%' title='"+cicloBloque.getBloqueNombre()+"'>"+cicloBloque.getCorto()+"</th>");
					}
				}			// "+cicloPromedio.getValor()+"%   // <fmt:message key='aca.Puntos'/>
				// Inserta columna del promedio de las evaluaciones
				out.print("<th class='text-center' width='2%' title='"+cicloPromedio.getNombre()+"'>"+cicloPromedio.getCorto()+"</th>");
%>				
				<th class='text-center' width='2%' title='<%= cicloPromedio.getValor() %>%'><fmt:message key='aca.Puntos'/></th>
<%				
			}
			if (lisPromedio.size() > 1){
				out.print("<th class='text-center' width='2%'><fmt:message key='aca.Nota'/></th>");
			}
			out.print("<th class='text-center' width='2%'><fmt:message key='aca.Actualizar'/></th>");
%>			
			</tr>
			</thead>

		<%
			int row = 0;
			for (aca.vista.AlumnoCurso alumCurso: lisAlumnoCurso) {
				row++;
				
				aca.plan.PlanCurso curso = new aca.plan.PlanCurso();
				// Si el alumno tiene el curso
				if (mapCurso.containsKey(alumCurso.getCursoId())){
					curso = mapCurso.get(alumCurso.getCursoId());		
				}    
%>
			<tr> 
		    	<td width="2%" title='<%=alumCurso.getCursoId()%>'><%=row %></td>
		    	<td width="20%"><%=curso.getCursoNombre()%></td>
<%
				for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
					int evalCerradas = 0;
					for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
						if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
							
							// Nota del alumno en la evaluacion
							double notaEval = 0;
							if (mapEval.containsKey(codigoAlumno+cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId())){
								notaEval = Double.parseDouble(mapEval.get(codigoAlumno+cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId()).getNota());
							}
							// Verifica si la nota de la evaluacion es temporal o definitiva(abierta o cerrada)
							String estadoEval = "A";
							String nombreEval = "-";
							if (mapEvalCiclo.containsKey(cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId())){
								estadoEval 	= mapEvalCiclo.get(cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId()).getEstado();
								nombreEval 	= mapEvalCiclo.get(cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId()).getEvaluacionNombre();
							}
							// Color de la evaluacion
							String colorEval = "color:blue;";
							if (estadoEval.equals("C")){
								evalCerradas++;
								colorEval = "color:black;";
							}
							
							// Formato de la evaluacion
							String notaFormato = formato0.format(notaEval);
							if (cicloBloque.getDecimales().equals("1")){
								notaFormato = formato1.format(notaEval);
							}
							if(cicloBloque.getRedondeo().equals("T")){
								formato0.setRoundingMode(java.math.RoundingMode.DOWN);
								formato1.setRoundingMode(java.math.RoundingMode.DOWN);
							} else{
								formato0.setRoundingMode(java.math.RoundingMode.HALF_UP);
								formato1.setRoundingMode(java.math.RoundingMode.HALF_UP);
							}
							
							// Inserta columnas de evaluaciones (Habilitado para modificar aunque este cerrado el bimestre)
							if(estadoEval.equals("A") || estadoEval.equals("C")){
%>
							<td class='text-center' width='1%' title='<%=cicloBloque.getValor()%>' style='"+colorEval+"'>						
								<%= notaFormato %>								
							</td>
<%						
							}else{
%>
							<td class='text-center' width='1%' title='<%=cicloBloque.getValor()%>' style='"+colorEval+"'><%= notaFormato %></td>
<%	
							}
						}
					}
					
					// Obtiene el promedio del alumno en las evaluaciones (tabla Krdx_Alum_Prom)
					double promEval = 0; 
					if (mapPromAlumno.containsKey(cicloGrupoId+alumCurso.getCursoId()+cicloPromedio.getPromedioId())){
						promEval = Double.parseDouble(mapPromAlumno.get(cicloGrupoId+alumCurso.getCursoId()+cicloPromedio.getPromedioId()).getNota());
					}
					
					// Puntos del promedio
					double puntosEval = (promEval * Double.parseDouble(cicloPromedio.getValor())) / escalaEval;
					
					// Formato del promedio y los puntos (decimales usados)
					String promFormato		= formato1.format(promEval);
					String puntosFormato	= formato1.format(puntosEval);
					if (cicloPromedio.getDecimales().equals("0")){
						promFormato 		= formato0.format(promEval);
						puntosFormato 		= formato0.format(puntosEval);
					}else if (cicloPromedio.getDecimales().equals("2")){
						promFormato 		= formato2.format(promEval);
						puntosFormato 		= formato2.format(puntosEval);
					}
					if(cicloPromedio.getRedondeo().equals("T")){
						formato0.setRoundingMode(java.math.RoundingMode.DOWN);
						formato1.setRoundingMode(java.math.RoundingMode.DOWN);
						formato2.setRoundingMode(java.math.RoundingMode.DOWN);
					}else{
						formato0.setRoundingMode(java.math.RoundingMode.HALF_UP);
						formato1.setRoundingMode(java.math.RoundingMode.HALF_UP);
						formato2.setRoundingMode(java.math.RoundingMode.HALF_UP);
					}
					
					// Color del promedio
					String colorProm = "color:blue;";
					if (evalCerradas>0 && evalCerradas == lisBloque.size()){
						colorProm = "color:black;";
					}
					evalcerradas = evalCerradas; 
					// Inserta columna del promedio de las evaluaciones
					out.print("<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+promFormato+"</td>");
					
					// Inserta columna de los puntos
					out.print("<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+puntosFormato+"</td>");
				}

					java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeCurso(conElias, cicloGrupoId,"");
					aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId+alumCurso.getCursoId()+codigoAlumno);
					BigDecimal prom = new BigDecimal(alumProm.getPromedio(), mc).add(new BigDecimal(alumProm.getPuntosAjuste(), mc), mc);
					out.print("<td class='text-center' width='2%'>"+prom+"</td>");
					
				if (evalcerradas>0 && evalcerradas == lisBloque.size()){
%>				
				<td>
					<a href="notasMetodo.jsp?Accion=1&CursoId=<%=alumCurso.getCursoId()%>&CicloGrupoId=<%=cicloGrupoId %>&CodigoAlumno=<%=codigoAlumno %>&EvaluacionId=0" class="btn btn-primary btn-mini">
						<i class="icon-refresh icon-black"></i>
					</a>
				</td>

		<%
				}else{
%>
				<td>
					<i class="icon-refresh icon-white"></i>					
				</td>							
<%				}
				evalcerradas = 0;
			}
			out.print("</tr>");
			out.print("<td colspan='2'>Promedio General:</td>");
			
			double promCiclo 	= 0;
			int numProm 		= 0;
			for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
				
				for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
					if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
						double sumaEval = 0;
						if (mapEvalSumaTot.containsKey(cicloGrupoId+cicloBloque.getBloqueId())){
							sumaEval = Double.parseDouble(mapEvalSumaTot.get(cicloGrupoId+cicloBloque.getBloqueId()));
						}
						double cuentaEval = 0;
						if (mapEvalCuentaTot.containsKey(cicloGrupoId+cicloBloque.getBloqueId())){
							cuentaEval = Double.parseDouble(mapEvalCuentaTot.get(cicloGrupoId+cicloBloque.getBloqueId()));
						}
						double promEval = 0;
						if (cuentaEval>0 && sumaEval>0){
							promEval = sumaEval/cuentaEval;
							numProm++;
							promCiclo += promEval;
						}
						// Inserta columnas de evaluaciones
						out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promEval)+"</td>");
					}
				}
				
				if (numProm > 0) promCiclo = promCiclo / numProm;
				// Inserta columna del promedio de las evaluaciones
				out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promCiclo)+"</td>");
			}
			// Completa las columnas del renglon de promedio  
			out.print("<td colspan='20'></td>");
%>			
		</table>
	</form>
	<br><br><br><br>
	<div class="row">
		<div class="span1"  style="align:center;"></div>
		<div class="span5 signatures"  style="align:center;">
			<center>
			<br>
			<%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE") %>
			<br>
			PROF. TITULAR</center>
		</div>

		<div class="span5 signatures" style="margin-left:20px;">
			<center>
			<br>
			<%=aca.empleado.EmpPersonal.getNombre(conElias, nivel.getDirector(conElias, escuelaId, Grupo.getNivelId()), "NOMBRE")%>
			<br>
			DIRECTOR (A)</center>
		</div>
		
		<style>
		.signatures{
			border-top: 1px solid #000000;
		}
		</style>
	</div>
	
</div>
<%@ include file="../../cierra_elias.jsp"%>
