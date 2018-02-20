<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%@page import="aca.catalogo.CatParametro"%>
<%@page import="aca.ciclo.CicloPromedio"%>
<%@page import="aca.ciclo.CicloGrupoEval"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="catParametro" scope="page" class="aca.catalogo.CatParametro" />
<jsp:useBean id="cicloPromedio" scope="page" class="aca.ciclo.CicloPromedio"/>
<jsp:useBean id="cicloPromedioU" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="BloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>

<script>
	function notas(cicloGrupoId, codigoAlumno) {
		document.location.href = "notas.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno + "&EvaluacionId=0";
	}

	function notasMetodo(cicloGrupoId, codigoAlumno) {
		document.location.href = "notasMetodo.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno + "&EvaluacionId=0";
	}

	function promedio(cicloGrupoId, codigoAlumno) {
		document.location.href = "promedio.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno;
	}
	
	function boletaAlumno(cicloGrupoId, codigoAlumno, empleadoId) {
		document.location.href = "boletaAlumno.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno+"&empleadoId" + empleadoId;
	}
	
	function boletaAlumnoPanama(cicloGrupoId, codigoAlumno, empleadoId) {
		//Se comentó esta línea para mostrar el pdf de la boleta en lugar del jsp, porque también lo quieren para imprimir con el formato del pdf
		//document.location.href = "boletaAlumnoPanama.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno+"&empleadoId" + empleadoId;
		$("#boletaForm").append('<input type="hidden" id="unAlumno" name="unAlumno" value="'+codigoAlumno+'" />');
		$("#boletaForm").submit();
	}
</script>

<%
	String codigoId 	= (String) session.getAttribute("codigoId");
	String cicloId 		= (String) session.getAttribute("cicloId");
	String escuela		= (String)session.getAttribute("escuela");
	String cicloGrupoId = (String) request.getParameter("CicloGrupoId");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	ciclo.mapeaRegId(conElias, cicloId);
	
	String metodo 		= aca.catalogo.CatNivel.getMetodo(conElias, Integer.parseInt(Grupo.getNivelId()));
	
	ArrayList<String> lisAlum 	= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);
%>

<div id="content">
	<h2><fmt:message key="aca.Alumnos" /></h2>
	
	<div class="alert alert-info">
		<h4>
			<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%> |
			<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> <%=Grupo.getGrupo()%>
		</h4> 
		<strong><fmt:message key="aca.Maestro" />:</strong> <%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE")%>
	</div>
	
	<div class="well"> 
		<a class="btn btn-primary" href="grupo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>		
<%
		String tipoBoleta		= aca.catalogo.CatParametro.getTipoBoleta(conElias, session.getAttribute("escuela").toString());
		String boleta 			= "boleta.jsp";
		String boletaActividad 	= "boletaActividades.jsp";
		if(aca.catalogo.CatEsquemaLista.getEsquemaEvaluacionNivel(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId(), Grupo.getGrado()).equals("C")){/* SI EVALUA POR COMPETENCIA */
			boleta 			= "boletaCompetencias.jsp";
			boletaActividad = "boletaActividadCompetencias.jsp";
		}
		if(tipoBoleta.equals("1")){
%>		
		<a class="btn btn-info" href="<%=boleta %>?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoleta" /></a>
		<a class="btn btn-info" href="<%=boletaActividad %>?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoletaConActividades" /></a>
<%
		}
		if(tipoBoleta.equals("2")){
%>
		<a class="btn btn-info" href="boletaDominicanaPrimSec.jsp?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoletaDominicana1" /></a>
		<a class="btn btn-info" href="boletaDominicanaSec2.jsp?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoletaDominicana2" /></a>
<%
		}
		if(tipoBoleta.equals("3")){
%>
		<table>
			<tr>
				<td valign="bottom">
					<form action="boletaPanama.jsp" method="get" id="boletaForm">
						<div style ='margin:20px 0;'>
							Selecciona los periodos a imprimir <br />
							<input type="checkbox" class="check" id="checkAll" checked>&nbsp Todos &nbsp<br /><br />
							<input type="hidden" id="cicloGrupoId" name="cicloGrupoId" value='<%=cicloGrupoId%>' />
<%
			if(ciclo.getNivelEval().equals("P")){
				ArrayList<CicloPromedio>  cicloPromedioList	= cicloPromedioU.getListCiclo(conElias, cicloId, " ORDER BY ORDEN");
				for(CicloPromedio cp: cicloPromedioList){
							out.print("<p style ='margin-right:15px;display:inline;'> <input type='checkbox' class='check' id='"+cp.getPromedioId()+"'  name='"+cp.getNombre()+"' value='"+cp.getPromedioId()+"'checked> &nbsp"+cp.getNombre()+"</p><br />");
				}
				/*for(int x = 0; x<cicloPromedioList.size();x++){
					out.print("<p style ='margin-right:15px;display:inline;'> <input type='checkbox' class='check' id='"+cicloPromedioList.get(x).getPromedioId()+"'  name='"+cicloPromedioList.get(x).getNombre()+"' value='"+cicloPromedioList.get(x).getPromedioId()+"'checked> &nbsp"+cicloPromedioList.get(x).getNombre()+"</p><br />");
				}*/
			}else if(ciclo.getNivelEval().equals("E")){
				//ArrayList <CicloGrupoEval> listaCicloGrupoEval = cicloGrupoEvalLista.getEvalGrupo(conElias, cicloGrupoId, "ORDER BY CICLO_GRUPO_ID, ORDEN");
				ArrayList<aca.ciclo.CicloBloque> lisBloque 			= BloqueLista.getListCiclo(conElias, cicloId, " ORDER BY ORDEN, BLOQUE_ID");
				for(aca.ciclo.CicloBloque cb: lisBloque){
					out.print("<p style ='margin-right:15px;display:inline;'> <input type='checkbox' class='check' id='"+cb.getBloqueId()+"'  name='"+cb.getBloqueNombre()+"' value='"+cb.getBloqueId()+"'checked> &nbsp"+cb.getBloqueNombre()+"</p><br />");
				}
			}
%>		
							<button type="submit" class="btn btn-info" ><fmt:message key="boton.ImprimirBoletaPanama" /></button>
						</div>
					</form>
					<!-- <a class="btn btn-info" href="boletaPanama.jsp?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoletaPanama" /></a> -->
				</td>
				<!--  td valign="bottom">
					<div style ='margin:20px 0;'>
						<a class="btn btn-info" href="boletaPanamaPreKinder.jsp?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoletaPanamaPreKinder" /></a>
					</div>
				</td -->
			</tr>
		</table>
<%
		}
		if(tipoBoleta.equals("4")){
%>			
			<a class="btn btn-info" href="BoletaSalvador.jsp?cicloGrupoId=<%=cicloGrupoId%>"><i class="icon-print icon-white"></i> <fmt:message key="boton.ImprimirBoleta" /></a>
			
<%			
		}
%>
	</div>
		
	<table class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%" align="center">#</th>
				<th width="15%" align="center"><fmt:message key="aca.Matricula" /></th>
				<th width="60%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
				<th width="20%" align="center"><fmt:message key="aca.Boleta" /></th>
			</tr>
		</thead>		
<%
		int cont = 0;
		for (String codigoAlumno : lisAlum) {
			cont++;				
%>
			<tr>
				<td><%=cont%></td>
				<td><%=codigoAlumno%></td>
<%				
			if (metodo.equals("N")){
%>						
				<td>
					<a href="javascript:notas('<%=cicloGrupoId%>','<%=codigoAlumno%>');"><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></a>
				</td>
<%			}else{%>
				<td>
					<a href="javascript:notasMetodo('<%=cicloGrupoId%>','<%=codigoAlumno%>');"><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></a>
				</td>				
<%			}

			if (tipoBoleta.equals("3")){
%>						
				<td>
					<a href="javascript:boletaAlumnoPanama('<%=cicloGrupoId%>','<%=codigoAlumno%>','<%=Grupo.getEmpleadoId()%>');">Boleta</a>
				</td>
<%			}else{%>
				<td>
					<a href="javascript:boletaAlumno('<%=cicloGrupoId%>','<%=codigoAlumno%>','<%=Grupo.getEmpleadoId()%>');">Boleta</a>
				</td>				
<%			}%>				
			</tr>			
<%			  	
		} //fin de for
%>
	</table>

</div>

<script>
	$("#checkAll").click(function () {
	    $(".check").prop('checked', $(this).prop('checked'));
	    
	});
	
	
	$('.check').on('change', function() {
	    $('#checkAll').not(this).prop('checked', false);  
	});
</script>

<%@ include file="../../cierra_elias.jsp"%>
