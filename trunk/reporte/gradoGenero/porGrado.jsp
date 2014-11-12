<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>



<jsp:useBean id="personalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<head>
<%
	String escuela 	= (String)session.getAttribute("escuela");
	
	String ciclo			= request.getParameter("ciclo");
	String nivel			= request.getParameter("nivel");
	String grado			= request.getParameter("grado");
	String sexo 			= request.getParameter("genero");
	String edad 			= request.getParameter("edad");
	
	if(sexo==null){
		sexo="'F','M'";
	}else{
		sexo = "'"+sexo+"'";
	}
	
	String query = "";
	if(edad!=null){
		if(edad.equals("5")){
			query = "AND TO_NUMBER(ALUM_EDAD(CODIGO_ID),'999')<6 ";
		}else if(edad.equals("15")){
			query = "AND TO_NUMBER(ALUM_EDAD(CODIGO_ID),'999')>14";
		}else{
			query = "AND TO_NUMBER(ALUM_EDAD(CODIGO_ID),'999')="+edad+" ";
		}
	}
	/* style="position:absolute;top:15px;left:20px;" */
	
	ArrayList<aca.alumno.AlumPersonal> Inscritos = personalLista.getListAlumnosInscritosNivelGrado(conElias, escuela, ciclo, nivel, grado, sexo, query+" ORDER BY NIVEL_ID, GRADO, GENERO desc, ALUM_EDAD(CODIGO_ID), NOMBRE");
%>
</head>
<style>
	body{
		background: white;
	}
</style>
<body>
<div id="content">  
    <h2>
    <%= aca.catalogo.CatEscuela.getNombre(conElias,escuela)%> (<small><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuela, nivel)%> <%=grado%>º grado </small>)	
	</h2>
  <div class="well">
    <a class="btn btn-info showAll" href="estadistica.jsp?ciclo=<%=ciclo%>"><fmt:message key="boton.Regresar" /></a>
  </div>	
<table class="table table-fullcondensed" width="80%">
	<tr>
		<th>#</th>
		<th><fmt:message key="aca.Matricula" /></th>
		<th><fmt:message key="aca.Nombre" /></th>
		<th><fmt:message key="aca.FechadeNacimiento" /></th>
		<th><fmt:message key="aca.Edad" /></th>
	</tr>
<%
	int cont = 0;
	String genero = "";
	for(aca.alumno.AlumPersonal alumno: Inscritos){ cont++;
	
	if(!alumno.getGenero().equals(genero)){
	%>
		<tr>
			<td colspan="5" align="center" style="padding:4px;font-size:15px;background:#E6E6E6;border:1px solid black;"><%=alumno.getGenero().equals("M")?"Hombres":"Mujeres" %></td>
		</tr>
	<%
		genero=alumno.getGenero();
	}	
%>
	<tr>
		<td align="center"><%=cont %></td>
		<td align="center"><%=alumno.getCodigoId() %></td>
		<td><%=alumno.getNombre()+" "+alumno.getApaterno()+" "+alumno.getAmaterno() %></td>
		<td align="center"><%=alumno.getFNacimiento() %></td>
		<td align="center"><%=aca.util.Edad.getEdad(alumno.getFNacimiento()) %></td>
	</tr>
<%	}%>
</table>
</div>
</body>
<%@ include file="../../cierra_elias.jsp" %>