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
String auxiliar		= session.getAttribute("codigoId").toString();
String escuela		= (String) session.getAttribute("escuela");
String fechaHoy 	= aca.util.Fecha.getHoy();

double saldoAlumno 		= aca.fin.FinMovimientos.saldoAlumno(conElias, auxiliar, fechaHoy);
CatParametro.mapeaRegId(conElias, escuela);
double deudaLimite = Double.parseDouble(CatParametro.getBloqueaPortal()) * -1;
//System.out.println("Datos:"+saldoAlumno+":"+deudaLimite);




%>

<ul class="nav nav-tabs">	
	  <li class="datos"><a href="datos.jsp"><fmt:message key="aca.Datos"/></a></li>
	  <li class="finanzas"><a href="finanzas.jsp"><fmt:message key="aca.Finanzas"/></a></li>
<%	if(saldoAlumno >= deudaLimite){ %>  
	  <li class="documentos"><a href="docalum.jsp">Documentos</a></li>
	  <li class="materias"><a href="materias.jsp"><fmt:message key="aca.Materias"/></a></li>
	  <li class="notas"><a href="notas.jsp"><fmt:message key="aca.Notas"/></a></li>
	  <li class="disciplina"><a href="disciplina.jsp"><fmt:message key="aca.Mentoria"/></a></li>	
<%	} %>	  
	  <li class="tareas"><a href="tareas.jsp"><fmt:message key="portal.Tareas"/></a></li>
  
</ul>