<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.ciclo.CicloGrupoEval"%>
<%@ page import="java.text.*" %>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
<%@page import="aca.ciclo.CicloBloque"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="Kardex" scope="page" class="aca.kardex.KrdxAlumEval"/>
<jsp:useBean id="kardexCA" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="kardexEval" scope="page" class="aca.kardex.KrdxAlumEval"/>
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<head>
	<script type="text/javascript" src="../../js/prototype.js"></script>
	<script type="text/javascript">

	function evaluacion(cicloGrupoId,codigoAlumno,evaluacionId){
		document.location.href="notas.jsp?CicloGrupoId="+cicloGrupoId+"&CodigoAlumno="+codigoAlumno+"&EvaluacionId="+evaluacionId;
	}
		
	function grabar(){
		document.frmNotas.Accion.value="1";
		document.frmNotas.submit();
	}
	
	function ocultaOMuestraNombres(){
		var objs = document.getElementsByClassName("oculto", document);
		for(var i = 0; i < objs.length; i++){
			objs[i].remove();
		}
		$("boton").value = "Mostrar";
		if(objs.length == 0)
			document.location.reload();
	}
	</script>
</head>
<%  
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String codigoAlumno		= (String) request.getParameter("CodigoAlumno");
	String evaluacionId		= (String) request.getParameter("EvaluacionId")==null?"":(String) request.getParameter("EvaluacionId");
	//System.out.println("Evaluacion ="+evaluacionId);

	String strAccion 		= request.getParameter("Accion");
	if (strAccion==null) 	strAccion = "0"; 
	int numAccion 			= Integer.parseInt(strAccion);
	int numEval				= aca.ciclo.CicloBloque.numBloques(conElias,cicloId);
	//ArrayList listEstrategias 	= cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	int i=0,j=0,nota=0;
	int escala 				= aca.ciclo.Ciclo.getEscala(conElias,aca.ciclo.CicloGrupo.getCicloId(conElias,cicloGrupoId));
	
	ArrayList lisGrupoCurso	= null;
	lisGrupoCurso			= GrupoCursoLista.getListMateriasGrupo(conElias,cicloGrupoId," ORDER BY ORDEN_CURSO_ID(CURSO_ID), TIPO_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
	ArrayList<CicloBloque> lisBloque	= null;
	
	switch (numAccion){
		case 1: {
			for(i=0;i<lisGrupoCurso.size();i++){
				aca.ciclo.CicloGrupoCurso cg = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(i);
				Kardex.setCodigoId(codigoAlumno);
				Kardex.setCicloGrupoId(cicloGrupoId);
				Kardex.setCursoId(cg.getCursoId());
				Kardex.setEvaluacionId(evaluacionId);
				String notaFinal = request.getParameter(cg.getCursoId());
				//System.out.println("Datos:"+cg.getCursoId()+":"+request.getParameter(cg.getCursoId()));
				if(notaFinal != null){
					Kardex.setNota(notaFinal);
					
					if (Kardex.existeReg(conElias)){
						if (Kardex.updateReg(conElias)); conElias.commit();	
					}else{
						if (Kardex.insertReg(conElias)); conElias.commit();
					}
					if(CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cg.getCursoId())){
						ArrayList lisKardex = kardexLista.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID = '"+cg.getCursoId()+"' AND CODIGO_ID = '"+codigoAlumno+"'");
						ArrayList lisEvaluacion = cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cg.getCursoId(), "ORDER BY ORDEN");
						ArrayList lisKardexEval = kardexEvalLista.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID = '"+cg.getCursoId()+"' AND CODIGO_ID = '"+codigoAlumno+"' ORDER BY EVALUACION_ID");
						boolean todosEstanCalificados = true;
						float promedios[] = new float[lisKardex.size()];
						for(int l = 0; l < lisKardex.size(); l++){
							kardexCA = (KrdxCursoAct) lisKardex.get(l);
							float sumaNotas = 0;
							float sumaTotales = 0;
							for(j = 0; j < lisEvaluacion.size(); j++){
								cicloGrupoEval = (aca.ciclo.CicloGrupoEval) lisEvaluacion.get(j);
								boolean encontroCalificacion = false;
								for(int k = 0; k < lisKardexEval.size(); k++){
									kardexEval = (KrdxAlumEval) lisKardexEval.get(k);
									if( kardexEval.getCodigoId().equals(kardexCA.getCodigoId()) && 
										cicloGrupoEval.getEvaluacionId().equals(kardexEval.getEvaluacionId()) &&
										!kardexEval.getNota().equals("0")){
										encontroCalificacion = true;
										sumaTotales += Float.parseFloat(cicloGrupoEval.getValor());
										
										sumaNotas += (Float.parseFloat(kardexEval.getNota()) * Float.parseFloat(cicloGrupoEval.getValor()) / Float.parseFloat(String.valueOf(escala)));
										
										k = lisKardexEval.size();
									}
								}
								if(encontroCalificacion){
									todosEstanCalificados &= true;
								}else{
									todosEstanCalificados &= false;
								}
							}
							if(sumaNotas != 0){
								promedios[l] = ((sumaNotas*escala)/sumaTotales);
							}else
								promedios[l] = -1;
						}
						DecimalFormat getformato= new DecimalFormat("##0.0#;-##0.0#", new java.text.DecimalFormatSymbols(java.util.Locale.US));
						for(int l = 0; l < lisKardex.size(); l++){
							kardexCA = (KrdxCursoAct) lisKardex.get(l);
							kardexCA.setNota(String.valueOf(getformato.format(((String.valueOf(promedios[l]).indexOf(".") != -1)?Double.parseDouble(String.valueOf(promedios[l]).substring(0, String.valueOf(promedios[l]).indexOf(".")+2)):promedios[l])).replace(',', '.')));
							kardexCA.setFNota(aca.util.Fecha.getHoy());
							if(Float.parseFloat(kardexCA.getNota()) >= 6)
								kardexCA.setTipoCalId("2");
							else
								kardexCA.setTipoCalId("3");
							kardexCA.updateReg(conElias);
						}
					}
				}
			}
			evaluacionId = "-1";
		}break;
	}	
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	if (Grupo.existeReg(conElias)){
		Grupo.mapeaRegId(conElias,cicloGrupoId);
	}
%>
<body>
<table width="70%" border="0" align="center">

<form name="frmNotas" action="notas.jsp?CicloGrupoId=<%=cicloGrupoId%>&codigoAlumno=<%=codigoAlumno%>" method="post">
  <input type="hidden" name="Accion">
  <input type="hidden" name="EvaluacionId" value="<%=evaluacionId%>">
  <input type="hidden" name="CicloGrupoId" value="<%=cicloGrupoId%>">
  <input type="hidden" name="CodigoAlumno" value="<%=codigoAlumno%>">
  
  <tr><td align="center" colspan="8"><font size="3"><strong><%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></strong></font></td></tr>
  <tr><td align="center" colspan="8"><font size="2"><strong><%=aca.ciclo.Ciclo.nombreCiclo(conElias,cicloId)%></strong></font></td></tr>
  <tr><td align="center" colspan="8"><strong>
  	<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%> - 
  	<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> "<%=Grupo.getGrupo()%>" - 
  	<fmt:message key="aca.Consejero" />: <%=aca.empleado.EmpPersonal.getNombre(conElias,Grupo.getEmpleadoId(),"NOMBRE")%> 
	</strong></td></tr>
  <tr><td align="center" colspan="8"><a href="alumnos.jsp?CicloGrupoId=<%=cicloGrupoId%>"><fmt:message key="boton.ElegirAlumno" /></a></td></tr>
  <tr>
    <td align="left" colspan="8">      
      <strong><fmt:message key="aca.Alumno" />: <%=AlumPersonal.getNombre(conElias,codigoAlumno,"NOMBRE")%></strong>
    </td>
  </tr>
  <tr bgcolor="#C8D4A3">
    <th align="center" class="oculto">#</th>
    <th align="center" class="oculto"><fmt:message key="aca.Clave" /></th>
    <th align="center" class="oculto"><fmt:message key="aca.Materia" /></th>
 
<%	for (j=1;j<=numEval;j++){%>
	<th width="5%" align="center" style="cursor:pointer;padding:2px" onclick="evaluacion('<%=cicloGrupoId%>','<%=codigoAlumno%>','<%=j%>');" style="cursor:pointer;" onmouseover="border=this.style.border;this.style.border='outset';this.style.padding='0px';" onmouseout="this.style.border=border;this.style.padding='2px';">
	  <%=j%>
	</th>
<%	}%>       
  </tr>
<%
	float[] sumaPorBimestre = new float[numEval];
	int cantidadMaterias = 0;
	String oficial = "1";
	cantidadMaterias = 0;
	for(i = 0; i < numEval; i++){
		sumaPorBimestre[i] = 0;
	}
	for (i=0;i<lisGrupoCurso.size();i++){
		aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(i);
		aca.plan.PlanCurso curso = new aca.plan.PlanCurso();
		curso.mapeaRegId(conElias, grupoCurso.getCursoId());
		if(!oficial.equals(curso.getTipocursoId())){
			boolean todasTienenCalificacion = true;
%>
  <tr>
  	<td class="oculto"><b>-</b></td>
  	<td class="oculto"><b>---</b></td>
  	<td class="oculto"><b><em><font color="#000000"><fmt:message key="aca.PromedioSeparado" /></font></em></b></td>
<%
	for(j = 0; j < numEval; j++){
%>
  	<td align="center"><font color="#000000"><b><%if(sumaPorBimestre[j] > 0 && cantidadMaterias > 0){ sumaPorBimestre[j] = sumaPorBimestre[j]/cantidadMaterias; out.print(String.valueOf(sumaPorBimestre[j]).substring(0,String.valueOf(sumaPorBimestre[j]).indexOf(".")+2));}else{ out.print("---"); todasTienenCalificacion &= false;} %></b></font></td>
<%
	}
%>
	<td align="center"><b><%if(todasTienenCalificacion ){float total = 0;for(j = 0; j < numEval; j++){total += sumaPorBimestre[j];} String result = String.valueOf(total/numEval); result = (result.indexOf(".") != -1)?result.substring(0, result.indexOf(".")+2):result; out.print(result);}else{out.print("---");} %></b></td>
  </tr>
<%
			cantidadMaterias = 0;
			for(j = 0; j < numEval; j++){
				sumaPorBimestre[j] = 0;
			}
		}
		oficial = curso.getTipocursoId();
		cantidadMaterias++;
%>    
  <tr>
    <td align="left" class="oculto"><strong><%=i+1%></strong></td>
    <td align="left" class="oculto">&nbsp;<%=grupoCurso.getCursoId()%></td>
    <td align="left" class="oculto"><strong><%=aca.plan.PlanCurso.getCursoNombre(conElias,grupoCurso.getCursoId())%></strong></td>
<%	
	for (j=1;j<=numEval;j++){ 
		nota = aca.kardex.KrdxAlumEval.alumNotaEval(conElias,codigoAlumno,cicloGrupoId,grupoCurso.getCursoId(),j);
		kardexCA.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, grupoCurso.getCursoId());
		sumaPorBimestre[j-1] += nota;
%>
	<td align="center">
<%
		if (evaluacionId.equals(String.valueOf(j)) && !kardexCA.getTipoCalId().equals("6")){ %>	
	  <input name="<%=grupoCurso.getCursoId()%>" type="text" size="1" maxlength="3" value="<%=nota%>">
<%		}else{
			out.println(nota);
		}%>
	  
	</td>
<%	} %>    
  </tr>
<% 
	} //fin de for
	boolean todasTienenCalificacion = true;
%> 
<tr>
  	<td class="oculto"><b>-</b></td>
  	<td class="oculto"><b>---</b></td>
  	<td class="oculto"><b><em><font color="#000000"><fmt:message key="aca.PromedioSeparado" /></font></em></b></td>
<%
	for(j = 0; j < numEval; j++){
%>
  	<td align="center"><font color="#000000"><b><%if(sumaPorBimestre[j] > 0 && cantidadMaterias > 0){ sumaPorBimestre[j] = sumaPorBimestre[j]/cantidadMaterias; out.print(String.valueOf(sumaPorBimestre[j]).substring(0,String.valueOf(sumaPorBimestre[j]).indexOf(".")+2));}else{ out.print("---"); todasTienenCalificacion &= false;} %></b></font></td>
<%
	}
%>
	<td align="center"><b><%if(todasTienenCalificacion ){float total = 0;for(j = 0; j < numEval; j++){total += sumaPorBimestre[j];} String result = String.valueOf(total/numEval); result = (result.indexOf(".") != -1)?result.substring(0, result.indexOf(".")+2):result; out.print(result);}else{out.print("---");} %></b></td>
  </tr>
<tr>
<td align="center" colspan="5">
<%	if (!evaluacionId.equals("0")){ %>
  <a href="javascript:grabar()"><font size="3"><strong><fmt:message key="boton.GrabarNotas" /></strong></font></a>
<% 	}else{%>  
	&nbsp;
<% 	}%>  
</td>

</tr>    
<form>
	<tr>
		<td align="center" colspan="8"><input id="boton" type="button" value="<fmt:message key="boton.Ocultar" />" onclick="ocultaOMuestraNombres();" /></td>
	</tr>
</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 