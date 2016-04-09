<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.HashMap"%>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CatNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="CicloGrupoL" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="EvalL" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>

<script src="../../js/jquery-1.7.1.min.js"></script>

<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= request.getParameter("Ciclo");
	String bloqueId			= request.getParameter("Bloque");
	
	if(cicloId == null) cicloId = (String) session.getAttribute("cicloId"); 
	
	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel = CatNivelL.getListNivelesPermitidos(conElias,escuelaId,cicloId,"ORDER BY NIVEL_ID");
	
	java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.0;(###,##0.0)");
	
	int cont = 0;
%>

<style>
	body{
		background: white;
	}
	.materias{
		display: none;
	}
</style>

<div id="content">

<h2><fmt:message key="informes.RendimientoAlumnos" /> <small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%> )</small></small></h2>

<form name="forma" action="alumnos.jsp" method='post'>

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
	
	<a style="float:right;" class="btn btn-info showAll"><i class="icon-plus icon-white"></i><fmt:message key="boton.MostrarMaterias" /></a>
</div>

<%	
	HashMap<String, String> mapaProm =   EvalL.getMapPromBim(conElias,cicloId, bloqueId,"");
	for(int i=0;i<lisNivel.size();i++){
		aca.catalogo.CatNivelEscuela nivel = (aca.catalogo.CatNivelEscuela) lisNivel.get(i);
%>
		<div class="alert alert-info">
			<h4><%= nivel.getNivelNombre()%></h4>
		</div>

<%	 ArrayList<aca.ciclo.CicloGrupo> lisGrupos = CicloGrupoL.getListGrupos(conElias, cicloId, "AND NIVEL_ID = '"+nivel.getNivelId()+"' ORDER BY GRADO, GRUPO ") ;
		for(int j=0; j<lisGrupos.size(); j++){cont++;
			aca.ciclo.CicloGrupo grupo = (aca.ciclo.CicloGrupo) lisGrupos.get(j);
%>
	<div class="alert" style="margin-left:20px;">
			
		<h5><a class="btn btn-mini showMaterias"><i class="icon-zoom-in"></i></a> &nbsp;&nbsp;<%= grupo.getGrupoNombre() %> &nbsp;&nbsp;<small><%= aca.empleado.EmpPersonal.getNombre(conElias,grupo.getEmpleadoId(), "NOMBRE")%></small></h5>
		<br />
		<fmt:message key="aca.PromedioGeneral" />: <%= mapaProm.get(grupo.getCicloGrupoId())!=null?getformato.format(Float.parseFloat(mapaProm.get(grupo.getCicloGrupoId()))):""%>
	</div>

		<div class="materias">
				<table align="center" class="table table-condensed" style="margin-left:40px;width:80%;">
					<tr>
						<th width="4%">#</th>
						<th width="10%"><fmt:message key="aca.Matricula" /></th>
						<th width="40%"><fmt:message key="aca.Nombre" /></th>
						<th width="5%"><fmt:message key="aca.Promedio" /></th>
					</tr>
					<%
						ArrayList<String> alumnos = EvalL.getListaPromTopAlum(conElias, grupo.getCicloGrupoId(),bloqueId);
						int conta = 0;
						for(String str: alumnos){
							conta++;
							String [] arr = str.split("@");
							
					%>
								<tr>
									<td><%=conta %></td>
									<td><%=arr[0] %></td>
									<td><%=arr[1] %></td>
									<td><%= !(arr[2].equals("null"))?getformato.format(Float.parseFloat(arr[2])):"" %></td>
								</tr>
					<%
						}
					%>
				</table>
		</div>	
	
<% 		}%>
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