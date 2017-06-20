<%@page import="java.util.Calendar"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.List"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="TareaL" scope="page" class="aca.ciclo.CicloGrupoTareaLista"/>

<%
	String codigoId = (String) session.getAttribute("codigoAlumno");

	alumPersonal.mapeaRegId(conElias, codigoId);
	String strNivel						= alumPersonal.getNivelId();
	String strGrado						= alumPersonal.getGrado();
	String cicloIdM 			= (String) session.getAttribute("cicloId");
	
	List<String> lsSemanas = new ArrayList();
	lsSemanas.addAll(TareaL.getTareasFecha(conElias, codigoId, "", "", cicloIdM));
	System.out.println("CICLO ID "+cicloIdM);
%>
<div id="content">

	<h2><fmt:message key="portal.Tareas"/> <small><%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %> <%=alumPersonal.getNombre() %></small></h2>
	<div class="alert alert-info">
		<strong><fmt:message key="aca.Nivel"/>:</strong> <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), strNivel)%> |
 	  	<strong><fmt:message key="aca.Grado"/>:</strong> <%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(strGrado))%> |
 	  	<strong><fmt:message key="aca.Grupo"/>:</strong> <%=alumPersonal.getGrupo()%> 
 	  	
 	  	
 	  	</div>

    <div class="well">
    	<select name="semanas" id="semanas" style="width: 400px;">
    		<%
    		Collections.sort(lsSemanas);
    		Collections.reverse(lsSemanas);
    		
    		for(String sem : lsSemanas){
    		%>
    			<option value="<%= sem %>"><%= TareaL.getInicioFinSemana(sem) %></option>
    		<% } %>
    	</select>
    </div>
<br>
<div id="tablaTareas"></div>

</div>
<%

Calendar cal = Calendar.getInstance();
int week = cal.get(Calendar.WEEK_OF_YEAR);
int year = cal.get(Calendar.YEAR);

%>
<script>
function cargaTabla(datadata){
	console.log(datadata);
	$.ajax({
		url : 'ajaxTareas.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			$('#tablaTareas').html(output);
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
		}
	});
}

$(function() {
    var we = $('#semanas').val();
    console.log(we);
    var datadata = 'semana='+we+'&aview';
    cargaTabla(datadata);
    
})

$('#semanas').change(function(){
	var we = $('#semanas').val();
    console.log(we);
    var datadata = 'semana='+we+'&aview';
    cargaTabla(datadata);
});

</script>
<%@ include file="../../cierra_elias.jsp" %>