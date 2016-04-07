<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Empleado" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="EmpleadoL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="Plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="CicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>

<script>
	
	function Modificar( CodigoPersonal ){
		document.frmmaestro.Accion.value="2";
		document.frmmaestro.CodigoPersonal.value = CodigoPersonal;
		document.frmmaestro.submit();
	}	
	
</script>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String cursoId			= (String) request.getParameter("CursoId")==null?"":request.getParameter("CursoId").replace("$", "&");
	String parametro		= (String) request.getParameter("Parametro")==null?"":request.getParameter("Parametro");
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	String nivelId 			= aca.plan.Plan.getNivel(conElias, planId);
	
	Plan.mapeaRegId(conElias, planId);
	
	CicloGrupo.mapeaRegId(conElias, cicloGrupoId);
	CicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
	
	String Maestro  		= "";	
	String grupo 			= CicloGrupo.getGrupoNombre();
	String Nombre  			= "";
	String Resultado 		= "";
	String salto			= "X";
	
	ArrayList<aca.empleado.EmpPersonal> lisEmpleado	 	= new ArrayList<aca.empleado.EmpPersonal>();
	
	if(accion.equals("1")){
		Nombre		= request.getParameter("Nombre");
		if (Nombre == null) Nombre = "";
		
		lisEmpleado = EmpleadoL.getListEmpBusqueda(conElias, escuelaId, Nombre.trim().replaceAll(" ", "%"), " AND ESTADO = 'A' ORDER BY 3,4,5");
		
	}
	if(accion.equals("2")){
		if(parametro.equals("Grupos")){
			CicloGrupo.mapeaRegId( conElias, cicloGrupoId );
			CicloGrupo.setEmpleadoId(request.getParameter("CodigoPersonal"));
			if (CicloGrupo.existeReg(conElias) == true){
				if (CicloGrupo.updateReg(conElias)==true){
					Resultado = "Modificado";					
					salto = "materia.jsp";
				}else{
					Resultado = "NoModifico";
				}
			}else{
				Resultado = "Noexiste";
			}		
		}
		if(parametro.equals("Materias")){			
			CicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);			
			CicloGrupoCurso.setEmpleadoId(request.getParameter("CodigoPersonal"));
			if (CicloGrupoCurso.existeReg(conElias) == true){
				if (CicloGrupoCurso.updateReg(conElias)==true){					
					Resultado = "Modificado";					
					salto = "materia.jsp";
				}else{
					Resultado = "NoModifico";
				}
			}else{
				Resultado = "NoExiste";
			}	
		}
		pageContext.setAttribute("resultado", Resultado);
	}
	
	
	if(parametro.equals("Grupos")){
		Maestro = aca.empleado.EmpPersonal.getNombre(conElias, CicloGrupo.getEmpleadoId(),"NOMBRE");
	}
	if(parametro.equals("Materias")){
		Maestro = aca.empleado.EmpPersonal.getNombre(conElias, CicloGrupoCurso.getEmpleadoId(), "NOMBRE");
	} 
%>

<div id="content">
	<h2>
		<fmt:message key="aca.AsignarMaestro" />		
		<small>(&nbsp;<%=Maestro.equals("-")?"¡Sin Maestro!":Maestro%>
		<%if(parametro.equals("Materias")){ %> 
		| <%=CicloGrupo.getGrado()%>-<%=grupo%> | <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %>
		<%}%>
		&nbsp;)
		</small>
	</h2>
	
	<% if (Resultado.equals("Eliminado") || Resultado.equals("Modificado") || Resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!Resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<form name="frmmaestro" action="maestro.jsp?CicloGrupoId=<%=cicloGrupoId %>&Parametro=<%=parametro %>&CursoId=<%=cursoId.replace("&","$")%>" method="post">
		<input type="hidden" name="Accion" />
		<input type="hidden" name="CodigoPersonal">
		
		<div class="well">
			<a href="materia.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
			<input type="Text" name="Nombre" size="3" maxlength="15" placeholder="<fmt:message key="boton.Buscar" />" class="input-xlarge" style="margin:0;">
			<button class="btn btn-primary" onclick="document.frmmaestro.Accion.value='1';">
				<i class="icon-search icon-white"></i>
			</button>
		</div>
			
		<table class="table table-condensed table-bordered">	
			<tr> 
				<th><fmt:message key="aca.Maestro" /></th>
			</tr>
		<%
			for (aca.empleado.EmpPersonal maestro: lisEmpleado){
		%>	  
				<tr>
					<td>
						<a href="javascript:Modificar('<%=maestro.getCodigoId()%>')">
							<%=maestro.getApaterno()+" "+maestro.getAmaterno()+" "+maestro.getNombre()%>
						</a>
					</td>
				</tr>
		<%	}
			if(lisEmpleado.size() == 0){
		%>
			<tr>
				<td class="alert"><fmt:message key="aca.RealizarBusqueda" /></td>
			</tr>
		<%
			}
		%>
		</table>	
		
	</form>

</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>