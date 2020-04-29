<%@page import="com.google.gson.Gson"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="krdxCursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<%
	
	String cicloGrupoId = aca.kardex.KrdxCursoAct.getAlumGrupo(conElias, codigoAlumno, cicloId);

	ArrayList<aca.kardex.KrdxCursoAct> lisKrdx = krdxCursoActLista.getListAll(conElias, escuelaMenu, "AND CODIGO_ID = '"+codigoAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID),CURSO_NOMBRE(CURSO_ID)");
	ArrayList<String> cursos = new ArrayList<>();
	for(aca.kardex.KrdxCursoAct kca: lisKrdx){
		cursos.add(kca.getCursoId());
	}
	
	String rep = new Gson().toJson(cursos);
%>

<div id="content">

	<h2>Exámenes <small><%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %> <%=alumPersonal.getNombre() %></small></h2>

	<div id="tablaTareas">
		<table class="table table-responsive">
			<tr>
				<th>Examen</th>
				<th>Fecha inicio</th>
				<th>Fecha Final</th>
				<th></th>
			</tr>
			<tbody id="showAlumno">
				<tr v-for="item in exams">
			   		<td>{{item.nombre}} </td>
			    	<td>{{item.fechaInicio.substr(0,10) + ' ' + item.fechaInicio.substr(11,5)}}</td>
			   	 	<td>{{item.fechaFinal.substr(0,10) + ' ' + item.fechaFinal.substr(11,5)}}</td>
			   		<td>
			      		<a class="btn btn-sm" id="btnGoExam" @click="goExam(item.cursoId, item.examenId)"> Ir a examen</a>
			    	</td>
			    </tr>
			</tbody>
		</table>
	</div>
</div>
<form action="https://eduadvent.um.edu.mx/exam/test/alumno/examen/" method="POST" name="startExam" target="_blank">
	<input type="hidden" name="cicloGpoId" id="cicloGpoId" value="<%=cicloGrupoId%>">
	<input type="hidden" name="cursoId" id="cursoId" value="">
	<input type="hidden" name="examenId" id="examenId" value="">
	<input type="hidden" name="codigoPersonal" id="codigoPersonal" value="<%=codigoAlumno%>">
</form>
<script src="https://cdn.jsdelivr.net/npm/vue"></script>
<script>
document.addEventListener("DOMContentLoaded", function(){

	const cursos = <%=rep%>;
	
	const app = new Vue({
		el: "#showAlumno",
		data: {
			exams: []
		},
		methods: {
			goExam: function(cursoId, examId){
				document.getElementById('cursoId').value = cursoId;
			    document.getElementById('examenId').value = examId;

				document.forms['startExam'].submit();
			}
		}
	});
	
	cursos.forEach((cursoId) => getExams(cursoId));
	
	function getExams(cursoId) {
		let data = {
				codigoId: document.getElementById('codigoPersonal').value,
				cicloGpoId: document.getElementById('cicloGpoId').value,
				cursoId: cursoId
		};
		
        fetch('https://eduadvent.um.edu.mx/exam/test/alumno/api/examen/visible/', {
            method: 'POST',
            body: JSON.stringify(data),
            cache: 'no-store',
            headers: {
	            'Content-Type': 'application/json'
		    }
        })
        .then( res => res.text())
        .then(JSON.parse)
        .then( listExams => app.exams.push(...listExams))
        .catch((err) => {
            console.log("error " + data);
            alert(err);
        });
	}
});
</script>
<%@ include file="../../cierra_elias.jsp" %>