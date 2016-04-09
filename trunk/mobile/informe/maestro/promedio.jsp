<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.HashMap"%>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="MaestroL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="EvalL" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>

<% 
		String escuelaId		= (String) session.getAttribute("escuela");
		String cicloId			= request.getParameter("Ciclo");
		String bloqueId			= request.getParameter("Bloque");
		
		if(cicloId == null) cicloId = (String) session.getAttribute("cicloId");
		
		ArrayList<aca.empleado.EmpPersonal> lisMaestros 	= MaestroL.getListMaestrosCiclo(conElias, escuelaId, cicloId, "ORDER BY 1");
		
		java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)");	
%>

<script src="../../js/jquery-1.7.1.min.js"></script>
<style>
	body{
		background: white;
	}
	.materias{
		display: none;
	}
</style>

<div id="content">

<h2><fmt:message key="informes.RendimientoMaestros" /> <small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%> )</small></h2>

<form name="forma" action="promedio.jsp" method='post'>

<div class="well">
	<select id="Ciclo" name="Ciclo" onchange="document.forma.submit();" style="width:310px;">
		<%
		ArrayList<aca.ciclo.Ciclo> lisCiclo = CicloLista.getListActivos(conElias, escuelaId, "ORDER BY 1");
		for(int i = 0; i < lisCiclo.size(); i++){
			aca.ciclo.Ciclo ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
		%>
		<option value="<%=ciclo.getCicloId() %>"<%=ciclo.getCicloId().equals(cicloId)?" Selected":"" %>><%=ciclo.getCicloNombre() %></option>
		<%
		}
		%>
	</select>
	<select id="Bloque" name="Bloque" onchange="document.forma.submit();" >
<%
	ArrayList lisCicloBloque = CicloBloqueL.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
	if(bloqueId == null||bloqueId.equals("")){
		if(lisCicloBloque.size() > 0)
			bloqueId = ((aca.ciclo.CicloBloque) lisCicloBloque.get(0)).getBloqueId();
	}
	for(int j = 0; j < lisCicloBloque.size(); j++){
		aca.ciclo.CicloBloque bloque = (aca.ciclo.CicloBloque) lisCicloBloque.get(j);
%>
		<option value="<%= bloque.getBloqueId()%>"<%= bloque.getBloqueId().equals(bloqueId)?" Selected":"" %>><%=bloque.getBloqueNombre()%></option>
<%	} %>
		</select>
		
		<a style="float:right;" class="btn btn-info showAll"><i class="icon-plus icon-white"></i> <fmt:message key="boton.MostrarMaterias" /></a>
</div>
	 
<%	HashMap<String, String> mapaPromGeneral =   EvalL.getMapPromMaestro(conElias,cicloId, bloqueId,"");
	HashMap<String, String> mapaPromMateria =   EvalL.getMapPromMaestroMateria(conElias,cicloId, bloqueId,"");
	for(int i=0; i<lisMaestros.size(); i++){
		aca.empleado.EmpPersonal maestros = (aca.empleado.EmpPersonal) lisMaestros.get(i);
%>

	<div class="alert alert-info">
		<h5><a class="btn btn-mini btn-primary showMaterias"><i class="icon-zoom-in icon-white"></i></a> &nbsp;&nbsp;<small><%=maestros.getCodigoId() %></small> <%=maestros.getNombre()+" "+maestros.getApaterno()+" "+maestros.getAmaterno()%></h5>
		<br />
		<fmt:message key="aca.PromedioGeneral" />:&nbsp;<%= getformato.format(Float.parseFloat(mapaPromGeneral.get(maestros.getCodigoId())))%>
	</div>
	
	<div class="materias">
		<table style="width:60%;margin-left:20px;" class="table table-condensed">
		
		<tr>
			<th width="2%"> #</th>
			<th width="2%"><fmt:message key="catalogo.Nivel" /></th>
			<th width="5%"><fmt:message key="aca.Grado" />/<fmt:message key="aca.Grupo" /></th>
			<th width="15%"><fmt:message key="aca.Materia" /></th>
			<th width="5%"><fmt:message key="aca.Promedio" /></th>
		</tr>
		<% 	ArrayList lisMaterias		= GrupoCursoL.getListMateriasEmpleado(conElias, cicloId, maestros.getCodigoId(), " ORDER BY CURSO_ID ");
			int cont = 0;
			for (int j=0;j<lisMaterias.size();j++){ cont++;  					
				aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(j);
				CicloGrupo.mapeaRegId(conElias, grupoCurso.getCicloGrupoId());	
				
				String gradoNombre 	= aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, CicloGrupo.getNivelId(), CicloGrupo.getGrado());
				String grado		= gradoNombre+" \""+CicloGrupo.getGrupo() + "\"";
		%>
		<tr>
			<td><%= cont %></td>
			<td><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, CicloGrupo.getNivelId())%></td>
			<td align="center"><%=grado %></td>
			<td align="center"><%= aca.plan.PlanCurso.getCursoNombre(conElias, grupoCurso.getCursoId()) %></td>
			<td><%= getformato.format(Float.parseFloat(mapaPromMateria.get(maestros.getCodigoId()+grupoCurso.getCicloGrupoId()+grupoCurso.getCursoId())))%></td>
		</tr>
		<% }%>
		</table>
	</div>
<% }%>
</form>

</div>

<script>
	jQuery(".showMaterias").on('click', function(){
		$this = $(this);
		
		if($this.find('i').hasClass('icon-zoom-in')){
			$this.parents('div.alert').next('div.materias').slideDown(300);
			
			$this.find('i').removeClass('icon-zoom-in').addClass('icon-zoom-out');
		}else{
			$this.parents('div.alert').next('div.materias').slideUp(300);
			
			$this.find('i').removeClass('icon-zoom-out').addClass('icon-zoom-in');
		}
		
	});
	
	var icons = jQuery(".showMaterias").find('i');
	jQuery(".showAll").on('click', function(){
		var $this = $(this);
		
		if($this.find('i').hasClass('icon-plus')){
			$this.find('i').removeClass('icon-plus').addClass('icon-minus');
			icons.removeClass('icon-zoom-in').addClass('icon-zoom-out');
			icons.parents('div.alert').next('div.materias').slideDown(300);
		}else{
			$this.find('i').removeClass('icon-minus').addClass('icon-plus');
			icons.removeClass('icon-zoom-out').addClass('icon-zoom-in');
			icons.parents('div.alert').next('div.materias').slideUp(300);
		}
		
	});
</script>

<%@ include file="../../cierra_elias.jsp" %>