<%@page import="aca.fin.FinProrrogas"%>
<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="cicloPrincipal" scope="page" class="aca.ciclo.Ciclo"/>

<style>
	.navbar{
		margin-bottom:10px;
	}
	
	.nav-tabs li:first-child{
		margin-left: 10px;
	}
</style>

<%

String auxiliarMenu		= session.getAttribute("codigoId").toString();
String escuelaMenu		= (String) session.getAttribute("escuela");
String fechaHoyMenu 	= aca.util.Fecha.getHoy();
String cicloId 		= session.getAttribute("cicloId").toString();


cicloPrincipal.mapeaRegId(conElias, cicloId);
//System.out.println("cicloid menu portal "+ cicloId + " " + ciclo.getNivelAcademicoSistema());

//------ para elegir notas
boolean iskinder = false;
Integer nivelsistema = new Integer(cicloPrincipal.getNivelAcademicoSistema()!=null ? cicloPrincipal.getNivelAcademicoSistema() : "-1");
String urlNotas = "notas.jsp";

if(nivelsistema>-1 && nivelsistema<3){
	urlNotas = "notas_kinder.jsp";
	iskinder = true;
}

double saldoAlumnoMenu 		= aca.fin.FinMovimientos.saldoAlumno(conElias, auxiliarMenu, fechaHoyMenu);
CatParametro.mapeaRegId(conElias, escuelaMenu);
double deudaLimite = Double.parseDouble(CatParametro.getBloqueaPortal()) * -1;
//System.out.println("Datos:"+saldoAlumno+":"+deudaLimite);
FinProrrogas fp = new FinProrrogas();
if(fp.existeReg(conElias, escuelaMenu, auxiliarMenu, "", "")){
	saldoAlumnoMenu = Double.parseDouble("0.00");
	System.out.println("Accion el saldo se puso en cero por el saldo :"+saldoAlumnoMenu+":"+deudaLimite);
}



%>

<ul class="nav nav-tabs">	
	  <li class="datos"><a href="datos.jsp"><fmt:message key="aca.Datos"/></a></li>
	  <li class="finanzas"><a href="edo_cta_alum.jsp"><fmt:message key="aca.Finanzas"/></a></li>
<%	if(saldoAlumnoMenu >= deudaLimite){ %>  
	  <li class="documentos"><a href="docalum.jsp">Documentos</a></li>
	  <li class="materias"><a href="materias.jsp"><fmt:message key="aca.Materias"/></a></li>
	  <li class="notas"><a href="<%= urlNotas %>"><fmt:message key="aca.Notas"/></a></li>
	  <li class="disciplina"><a href="disciplina.jsp"><fmt:message key="aca.Mentoria"/></a></li>	
<%	} %>	  
	  <li class="tareas"><a href="tareas.jsp"><fmt:message key="portal.Tareas"/></a></li>
  
</ul>
