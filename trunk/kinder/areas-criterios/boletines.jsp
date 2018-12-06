<%@page import="aca.ciclo.CicloGrupo"%>
<%@page import="java.util.List"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloGpoLista" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<%
String escuelaId		= (String) session.getAttribute("escuela");	
if(request.getParameter("Ciclo")!=null){
	session.setAttribute("cicloId", request.getParameter("Ciclo"));	
}		
String cicloId			= (String) session.getAttribute("cicloId");
ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID DESC");	
%>
<div id="content">
<h2>
Boletines Maternal, Pre-Kinder y Kinder
</h2>
	<form name="frmCiclo" action="boletines.jsp" method="post">
		<input type="hidden" name="Accion">
		<div class="well">
			<select name="Ciclo" id="Ciclo"
				onchange="document.frmCiclo.submit();" class="input-xxlarge">
				<%
					for (aca.ciclo.Ciclo ciclo : lisCiclo) {
						int nivel;
						try{
							nivel = Integer.parseInt(ciclo.getNivelAcademicoSistema());
							if(0 <= nivel && nivel <= 2){
								%>
									<option value="<%=ciclo.getCicloId()%>"
									<%if (ciclo.getCicloId().equals(cicloId)) {
										out.print("selected");
									}%>><%=ciclo.getCicloNombre()%></option>
								<%
							}
						}catch(Exception e){
							System.out.println("Probable formato erroneo en la base de datos en el ciclo "+ciclo.getCicloNombre()+". ERROR => "+e);
						}
					}
				%>
			</select>
		</div>
	</form>
	
	<form>
	<%
if(cicloId!=null){
	List<CicloGrupo> lsCicloGpo = new ArrayList();
	lsCicloGpo.addAll(CicloGpoLista.getListGrupos(conElias, cicloId, ""));
%>
<label for="select">Grupo: </label>
	<select name="ciclo_gpo_id" id="ciclo_gpo_id">
	<option>Seleccione...</option>
	<% 
		for(CicloGrupo cg : lsCicloGpo){
	%>
		<option value="<%= cg.getCicloGrupoId() %>"><%= cg.getGrupoNombre() %></option>
	<%
		}
	%>
	</select>
<%
}
%>
	</form>
	
	<hr>
	
	<div id="tablaBoletines"></div>
</div>
<script>

function cargaTabla(datadata){
	$.ajax({
		url : 'ajaxBoletines.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			$('#tablaBoletines').html(output);
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
		}
	});
}

$('#ciclo_gpo_id').change(function(){
	var ciclogpoid =  $(this).val();
	var datadata = 'ciclo_gpo_id='+ciclogpoid;
	cargaTabla(datadata);
});


</script>
<%@ include file="../../cierra_elias.jsp"%>