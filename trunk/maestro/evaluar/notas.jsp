<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="Kardex" scope="page" class="aca.kardex.KrdxAlumEval"/>


<%  
	java.text.DecimalFormat frm	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String cicloId			= (String) session.getAttribute("cicloId");
	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String codigoAlumno		= (String) request.getParameter("CodigoAlumno");

	String strAccion 		= request.getParameter("Accion");
	if (strAccion==null) 	strAccion = "0"; 
	int numAccion 			= Integer.parseInt(strAccion);
	int numEval				= aca.ciclo.CicloBloque.numBloques(conElias,cicloId);
	int i=0,j=0,nota=0;
	
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso = GrupoCursoLista.getListMateriasGrupo(conElias,cicloGrupoId," ORDER BY TIPO_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	if (Grupo.existeReg(conElias)){
		Grupo.mapeaRegId(conElias,cicloGrupoId);
	}
%>

<div id="content">
	
	<h2><fmt:message key="aca.NotasAlumno" /></h2>
	
	<div class="alert alert-info">
		<%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "NOMBRE")%>
		&nbsp;&nbsp;|&nbsp;&nbsp;
		<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> "<%=Grupo.getGrupo()%>"
		&nbsp;&nbsp;|&nbsp;&nbsp;
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%>
	</div>
	
	<div class="well">
		<a href="grupo.jsp?Ciclo=<%=cicloId%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>


  
    <table class="table table-condensed">
  
  <tr>
    <th align="center">#</th>
    <th align="center"><fmt:message key="aca.Clave" /></th>
    <th align="center"><fmt:message key="aca.Materia" /></th>
<%	for (j=1;j<=numEval;j++){ %>
	<th width="5%" align="center"><%=j%></th>
<%	} %>
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
  <tr class="alert">
  	<td colspan="3">
  		<fmt:message key="aca.Promedio" />
  	</td>
<%
	for(j = 0; j < numEval; j++){
%>
  	<td><%if(sumaPorBimestre[j] > 0 && cantidadMaterias > 0){ sumaPorBimestre[j] = sumaPorBimestre[j]/cantidadMaterias; out.print(String.valueOf(sumaPorBimestre[j]).substring(0,String.valueOf(sumaPorBimestre[j]).indexOf(".")+2));}else{ out.print("-"); todasTienenCalificacion &= false;} %></td>
<%
	}
%>
	<td><%if(todasTienenCalificacion ){float total = 0;for(j = 0; j < numEval; j++){total += sumaPorBimestre[j];} out.print(frm.format(total/numEval));}else{out.print("-");} %></td>
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
    <td><strong><%=i+1%></strong></td>
    <td><%=grupoCurso.getCursoId()%></td>
    <td><%=aca.plan.PlanCurso.getCursoNombre(conElias,grupoCurso.getCursoId())%></td>
<%	
	for (j=1;j<=numEval;j++){ 
		nota = aca.kardex.KrdxAlumEval.alumNotaEval(conElias,codigoAlumno,cicloGrupoId,grupoCurso.getCursoId(),j);
		sumaPorBimestre[j-1] += nota;
%>
	<td>
		<%=nota %>
	</td>
<%	} %>    
  </tr>
<% 
	} //fin de for
	boolean todasTienenCalificacion = true;
%> 
<tr class="alert">
  	<td colspan="3"><fmt:message key="aca.Promedio" /></td>
<%
	for(j = 0; j < numEval; j++){
%>
  	<td><%if(sumaPorBimestre[j] > 0 && cantidadMaterias > 0){ sumaPorBimestre[j] = sumaPorBimestre[j]/cantidadMaterias; out.print(String.valueOf(sumaPorBimestre[j]).substring(0,String.valueOf(sumaPorBimestre[j]).indexOf(".")+2));}else{ out.print("-"); todasTienenCalificacion &= false;} %></td>
<%
	}
%>
	<td><%if(todasTienenCalificacion ){float total = 0;for(j = 0; j < numEval; j++){total += sumaPorBimestre[j];} out.print(frm.format(total/numEval));}else{out.print("-");} %></td>
  </tr>
</table>


</div>

<%@ include file= "../../cierra_elias.jsp" %> 