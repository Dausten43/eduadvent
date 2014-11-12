<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.TreeMap"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="AlumFalta" scope="page" class="aca.kardex.KrdxAlumFalta"/>

<% 
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String codigoAlumno		= (String) request.getParameter("CodigoAlumno");
	String cicloId			= (String) session.getAttribute("cicloId");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	if (Grupo.existeReg(conElias)){
		Grupo.mapeaRegId(conElias,cicloGrupoId);
	}	
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso	= GrupoCursoLista.getListMateriasGrupo(conElias,cicloGrupoId," ORDER BY ORDEN_CURSO_ID(CURSO_ID), TIPO_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
%>

<div id="content">
	<h2><fmt:message key="maestros.RegistrodeFaltas" /></h2>
	
	<div class="alert alert-info">
		<fmt:message key="aca.Alumno" />: <%=aca.alumno.AlumPersonal.getNombre(conElias,codigoAlumno,"NOMBRE")%>
	</div>
	
	<form name="frmNotas" action="notasMetodo.jsp?CicloGrupoId=<%=cicloGrupoId%>&codigoAlumno=<%=codigoAlumno%>" method="post">
		<input type="hidden" name="Accion">
	  	<input type="hidden" name="CicloGrupoId" value="<%=cicloGrupoId%>">
	  	<input type="hidden" name="CodigoAlumno" value="<%=codigoAlumno%>">
		
		<div class="well">
			<a class="btn btn-primary" href="alumnos.jsp?CicloGrupoId=<%=cicloGrupoId%>">
				<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
			</a>
		</div>
	  
	  	<table class="table table-condensed table-bordered table-striped">
	  		<thead>
		  		<tr>
		    		<th>#</th>
		    		<th><fmt:message key="aca.Clave" /></th>
		    		<th><fmt:message key="aca.Materia" /></th>
					<% for (int z=0; z<aca.ciclo.CicloGrupoEval.getNumEval(conElias, cicloGrupoId,((aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(0)).getCursoId()); z++){%>    
						<th class="text-center" width="3%"><%= z+1 %></th>
					<% }%>	
		  		</tr>
		  	</thead>
			<% 
				ArrayList<Integer> totales = new ArrayList<Integer>();
				for (int i=0;i<lisGrupoCurso.size();i++){
					aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(i);
					
					ArrayList<aca.ciclo.CicloGrupoEval> lisEval = GrupoEvalL.getArrayList(conElias, cicloGrupoId, grupoCurso.getCursoId(), "ORDER BY ORDEN");		
			%>
	  				<tr>
	    				<td><%=i+1%></td>
	    				<td><%=grupoCurso.getCursoId()%></td>
	    				<td><%=aca.plan.PlanCurso.getCursoNombre(conElias,grupoCurso.getCursoId())%></td>
			<% 		
			
						int falta = 0;
						for(int j=0; j < lisEval.size(); j++){
							aca.ciclo.CicloGrupoEval eval = (aca.ciclo.CicloGrupoEval) lisEval.get(j);
				
							AlumFalta.setCicloGrupoId(cicloGrupoId);
							AlumFalta.setCursoId(grupoCurso.getCursoId());
							AlumFalta.setEvaluacionId(eval.getEvaluacionId());
							AlumFalta.setCodigoId(codigoAlumno);
							if (AlumFalta.existeReg(conElias)){
								AlumFalta.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, grupoCurso.getCursoId(),eval.getEvaluacionId());
								falta = Integer.parseInt(AlumFalta.getFalta());
							}else{
								falta = 0;	
							}			
							
							if(i==0){
								totales.add(falta);
							}else{
								int tmp = totales.get(j);
								totales.set(j, tmp+falta);
							}
			%>	
							<td class="text-center"><%=falta %></td>	
			<%          					
		    			}
			%>
					</tr>
			<%
				}
			%>
	  			  
	  		<tr>
	  			<th class="alert" colspan="3"><fmt:message key="aca.Total" /></th>
				<%for(int i: totales){%>
						<th class="text-center alert"><%=i %></th>
				<%} %>
	  		</tr>  
		</table>
	</form>

</div>

<%@ include file= "../../cierra_elias.jsp" %> 