<%@page import="aca.fin.FinProrrogas"%>
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
String auxiliar		= session.getAttribute("codigoAlumno").toString();
String escuela		= (String) session.getAttribute("escuela");
String fechaHoy 	= aca.util.Fecha.getHoy();

double saldoAlumno 		= aca.fin.FinMovimientos.saldoAlumno(conElias, auxiliar, fechaHoy);
CatParametro.mapeaRegId(conElias, escuela);
double deudaLimite = Double.parseDouble(CatParametro.getBloqueaPortal()) * -1;
//System.out.println("Datos:"+saldoAlumno+":"+deudaLimite);
FinProrrogas fp = new FinProrrogas();
if(fp.existeReg(conElias, escuela, auxiliar, "", "")){
	saldoAlumno = Double.parseDouble("0.00");
	System.out.println("Accion el saldo se puso en cero por el saldo :"+saldoAlumno+":"+deudaLimite);
}



%>
<ul class="nav nav-tabs">
  <li class="hijo"><a href="portalPadre.jsp">Padre</a></li>
  <li class="datos"><a href="datos.jsp">Datos</a></li>
  
<%	if(saldoAlumno >= deudaLimite){ %>  
  <li class="documentos"><a href="docalum.jsp">Documentos</a></li>
  <li class="materias"><a href="materias.jsp">Materias</a></li>
  <li class="notas"><a href="notas.jsp">Notas</a></li>
  <li class="disciplina"><a href="disciplina.jsp"><fmt:message key="aca.Mentoria"/></a></li>
<%	} %>
  <li class="finanzas"><a href="finanzas.jsp">Finanzas</a></li>
  <li class="tareas"><a href="tareas.jsp">Tareas</a></li>
</ul>