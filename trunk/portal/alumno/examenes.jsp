<%@page import="com.google.gson.Gson"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="krdxCursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<%
	String codigoIdAlumno 		= (String) session.getAttribute("codigoId");
	String cicloIdM 			= (String) session.getAttribute("cicloId");

	alumPersonal.mapeaRegId(conElias, codigoIdAlumno);
	alumPlan.mapeaRegActual(conElias, codigoIdAlumno);
	
	cicloGrupo.mapeaRegId(conElias, alumPersonal.getNivelId(), alumPersonal.getGrado(), alumPersonal.getGrupo(), cicloIdM, alumPlan.getPlanId());

	ArrayList<aca.kardex.KrdxCursoAct> lisKrdx = krdxCursoActLista.getListAll(conElias, escuelaMenu, "AND CODIGO_ID = '"+codigoIdAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID),CURSO_NOMBRE(CURSO_ID)");
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
	<input type="hidden" name="cicloGpoId" id="cicloGpoId" value="<%=cicloGrupo.getCicloGrupoId()%>">
	<input type="hidden" name="cursoId" id="cursoId" value="">
	<input type="hidden" name="examenId" id="examenId" value="">
	<input type="hidden" name="codigoPersonal" id="codigoPersonal" value="<%=codigoIdAlumno%>">
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
		
        fetch('https://wso2am.um.edu.mx/eduadventexam/1.0/examen/visible/', {
            method: 'POST',
            body: JSON.stringify(data),
            cache: 'no-store',
            headers: {
            	'apiKey': 'eyJ4NXQiOiJOVGRtWmpNNFpEazNOalkwWXpjNU1tWm1PRGd3TVRFM01XWXdOREU1TVdSbFpEZzROemM0WkE9PSIsImtpZCI6ImdhdGV3YXlfY2VydGlmaWNhdGVfYWxpYXMiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJqb25hdGhhbmdvbXpAY2FyYm9uLnN1cGVyIiwiYXBwbGljYXRpb24iOnsib3duZXIiOiJqb25hdGhhbmdvbXoiLCJ0aWVyUXVvdGFUeXBlIjpudWxsLCJ0aWVyIjoiVW5saW1pdGVkIiwibmFtZSI6IkVkdUFkdmVudCIsImlkIjozMCwidXVpZCI6IjIyNGYwMjgwLWFhOGItNDJkYy1iNGUxLWUyYTFhMzFmMjc1MiJ9LCJpc3MiOiJodHRwczpcL1wvYW0udW0uZWR1Lm14OjQ0M1wvb2F1dGgyXC90b2tlbiIsInRpZXJJbmZvIjp7IlVubGltaXRlZCI6eyJ0aWVyUXVvdGFUeXBlIjoicmVxdWVzdENvdW50Iiwic3RvcE9uUXVvdGFSZWFjaCI6dHJ1ZSwic3Bpa2VBcnJlc3RMaW1pdCI6MCwic3Bpa2VBcnJlc3RVbml0IjpudWxsfX0sImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiRWR1YWR2ZW50RXhhbSIsImNvbnRleHQiOiJcL2VkdWFkdmVudGV4YW1cLzEuMCIsInB1Ymxpc2hlciI6ImxhZnVlbnRlLmRhbmllbCIsInZlcnNpb24iOiIxLjAiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGVkIn1dLCJpYXQiOjE2MzE2MzY5NjUsImp0aSI6ImQxODZiY2ZlLTBlN2MtNDQxMi1iODBjLTNkYmI5NTY4NWQ0NiJ9.EukEeQYTtOLYa3zj18F4CvKOXR9Y1k707OzHYEdaVvDM4RIuzkVsRfqlnkmlY0foSp8s0ctmaAWt1zTQYjbF_vn-7P4jOO4pdtfjQlYZyxYVR42QaL5flizHGaXZmWsJbDdzxAp__oRd1-pmnlweTHHmOTMa4pHWWWLD2aUVF7NGIvVhHIJPiekOb127sM2H_f9iSuwcF7h9pVtk_fGvsCSPr59Ht797lbSCT3dNj2i1tf6dPf9O48lFzArAATAI5ydyZsMmAz07nJ5bimjd7tS6R9Q5wq3qJZ2UBsLyODZQ7kg66UC7ZU3-zyMbnDB8mOFqKO6FJEprEjHzlgVa-Q==',
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