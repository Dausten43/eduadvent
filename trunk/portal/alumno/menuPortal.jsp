<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>

<style>
	.navbar{
		margin-bottom:10px;
	}
	
	.nav-tabs li:first-child{
		margin-left: 10px;
	}
</style>

<%
String codigo		= session.getAttribute("codigoId").toString();

System.out.println("IMPRIME : "+codigo);
%>

<ul class="nav nav-tabs">
	<%if(codigo.length() == 8){
	%>
	  <li class="datos"><a href="datos.jsp"><fmt:message key="aca.Datos"/></a></li>
	  <li class="finanzas"><a href="finanzas.jsp"><fmt:message key="aca.Finanzas"/></a></li>
	  <%
	  }else{
	  %>
	  <li class="datos"><a href="datos.jsp"><fmt:message key="aca.Datos"/></a></li>
	  <li class="finanzas"><a href="finanzas.jsp"><fmt:message key="aca.Finanzas"/></a></li>
	  <li class="documentos"><a href="docalum.jsp">Documentos</a></li>
	  <li class="materias"><a href="materias.jsp"><fmt:message key="aca.Materias"/></a></li>
	  <li class="notas"><a href="notas.jsp"><fmt:message key="aca.Notas"/></a></li>
	  <li class="disciplina"><a href="disciplina.jsp"><fmt:message key="aca.Mentoria"/></a></li>	  
	  <li class="tareas"><a href="tareas.jsp"><fmt:message key="portal.Tareas"/></a></li>
	 <%
	  }
	%>	  
</ul>