<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<%@page import="java.text.*" %>
<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.vista.AlumEval"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="GrupoEval" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="GrupoAct" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="AlumEval" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="AlumAct" scope="page" class="aca.kardex.KrdxAlumActivLista"/>
<jsp:useBean id="promedioL" scope="page" class="aca.ciclo.CicloPromedioLista" />

<%	
	DecimalFormat frmEntero		= new DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	DecimalFormat frmDecimal	= new DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String escuelaId 	= (String) session.getAttribute("escuela");
	String colorPortal 	= (String)session.getAttribute("colorPortal")==null?colorPortal="":(String)session.getAttribute("colorPortal");
	
	cicloId 			= request.getParameter("ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("ciclo");
	String codigoId 	= request.getParameter("codigoId");
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String cursoId      = request.getParameter("cursoId");
	
	String notaEval		= "";
	String notaAct		= "";
	
	String plan			= aca.kardex.KrdxCursoAct.getAlumPlan(conElias,codigoId,cicloId);
	String punto		= aca.plan.PlanCurso.getPunto(conElias, cursoId);
	
	ArrayList<aca.ciclo.CicloGrupoEval> grupoEval	= new ArrayList();	
	ArrayList<aca.ciclo.CicloPromedio> listPromedio 		= promedioL.getListPromedioCiclo(conElias, cicloId," ORDER BY ORDEN");
	ArrayList<aca.ciclo.CicloGrupoActividad> grupoAct	= GrupoAct.getListGrupo(conElias, cicloGrupoId, cursoId, "ORDER BY FECHA" );
	
	TreeMap<String, aca.kardex.KrdxAlumEval> alumEval	= AlumEval.getTreeAlumMat(conElias, codigoId, cicloGrupoId, cursoId, "ORDER BY EVALUACION_ID");
	TreeMap<String, aca.kardex.KrdxAlumActiv> alumAct		= AlumAct.getTreeAlumAct(conElias, cicloGrupoId, cursoId, codigoId,"ORDER BY EVALUACION_ID, ACTIVIDAD_ID");	
%>
<div id="content">
	<h2>
		<fmt:message key="portal.DetalleDeEvaluacion" />
		<small>
			<%= aca.alumno.AlumPersonal.getNombre(conElias, codigoId,"NOMBRE") %> | <%= PlanCurso.getCursoNombre(conElias, cursoId) %>
		</small>
	</h2>
	<div class="well">
		<a href="materias.jsp" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i>
			<fmt:message key="boton.Regresar" />
		</a>
	</div>
<%
	for(aca.ciclo.CicloPromedio promedios : listPromedio) {
%>
		<div class="alert alert-success">
			<h4>
				N1. <%=promedios.getNombre() %> (Valor: <%=promedios.getValor() %>)
			</h4>
		</div>
<%
		grupoEval	= GrupoEval.getArrayListPorPromedio(conElias, cicloGrupoId, cursoId, promedios.getPromedioId(), "ORDER BY ORDEN");
%>   
    
<%
		for(aca.ciclo.CicloGrupoEval gpoEval: grupoEval) {
			
			notaEval = "0";
			if (alumEval.containsKey(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId())){
				aca.kardex.KrdxAlumEval kae = alumEval.get(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId());
				
				// Si se evalua con punto decimal
				if (punto.equals("S")){
					notaEval = frmDecimal.format(Double.valueOf(kae.getNota()));
				}else{
					notaEval = frmEntero.format(Double.valueOf(kae.getNota()));
				}			
			}
		
%>
			<div class="alert alert-info">
		    	<h5> N2. 
		    		<%=gpoEval.getEvaluacionNombre() %>
		    		<span class="pull-right">
						<fmt:message key="aca.Valor" />: <%= gpoEval.getValor() %>% &nbsp; &nbsp;
						( <span style="font-size:12px;"><fmt:message key="aca.Promedio" />: <%= notaEval %></span> )
					</span>
					<small>( <%= gpoEval.getFecha() %> )</small>
		    		
		    	</h5>
		    </div>
			<table class="table table-condensed table-bordered">
<%
			boolean ponerTitulo = true;
			for(aca.ciclo.CicloGrupoActividad actividad: grupoAct) {
				
				if (actividad.getEvaluacionId().equals(gpoEval.getEvaluacionId())){
					if(ponerTitulo){
%>
							<tr style="background-color: #FFF1CF">
								<th><fmt:message key="aca.FechaEntrega"/></th>
								<th><fmt:message key="aca.Actividad"/></th>
								<th><fmt:message key="aca.Valor"/></th>
								<th><fmt:message key="aca.Nota"/></th>
							 </tr>
<%
					}
					
					notaAct = "0";
					if (alumAct.containsKey(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId()+actividad.getActividadId())){
						aca.kardex.KrdxAlumActiv kaa = alumAct.get(codigoId+cicloGrupoId+cursoId+gpoEval.getEvaluacionId()+actividad.getActividadId());
						notaAct = kaa.getNota();
					}
%>
					<tr>
				      <td>&nbsp;&nbsp;&nbsp;<%= actividad.getFecha().substring(0, 10) %></td>
				      <td>&nbsp;&nbsp;&nbsp;<%= actividad.getActividadNombre() %></td>
				      <td>&nbsp;&nbsp;&nbsp;<%= actividad.getValor() %></td>
				      <td>&nbsp;&nbsp;&nbsp;<%= notaAct %></td>
				    </tr>
<%			
					ponerTitulo = false;
				}
			}
%>
			</table>
<%
		}
	}
%>    
</div>
<%@ include file="../../cierra_elias.jsp" %>