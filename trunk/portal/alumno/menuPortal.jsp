<%@page import="java.math.BigDecimal"%>
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
System.out.println("NIVEL SISTEMA " + nivelsistema);
if(nivelsistema>-1 && nivelsistema<3){
	urlNotas = "notas_kinder.jsp";
	iskinder = true;
}

double saldoAlumnoMenu 		= aca.fin.FinMovimientos.saldoAlumno(conElias, auxiliarMenu, fechaHoyMenu);
CatParametro.mapeaRegId(conElias, escuelaMenu);
double deudaLimite = Double.parseDouble(CatParametro.getBloqueaPortal());
//System.out.println("Datos:"+saldoAlumno+":"+deudaLimite);
FinProrrogas fp = new FinProrrogas();
boolean pasa = false;

BigDecimal saldo = BigDecimal.ZERO;
BigDecimal tope = BigDecimal.ZERO;

saldo = saldo.add(new BigDecimal(saldoAlumnoMenu));
tope = tope.add(new BigDecimal(deudaLimite));

System.out.println(auxiliarMenu +" saldo y tope :"+saldoAlumnoMenu+":"+deudaLimite);
if(saldo.compareTo(BigDecimal.ZERO)>=0){
	System.out.println(auxiliarMenu +" SALDO ES POSITIVO Y TIENE CREDITO");
	pasa = true;
}else{
	System.out.println(auxiliarMenu +" SALDO ES NEGATIVO");
	
	if(saldo.abs().compareTo(tope.abs())<0){
			pasa=true;
			System.out.println(auxiliarMenu +" SALDO ES MENOR QUE EL TOPE " +saldo.abs() + " : " + tope.abs());
	}else{
		if(fp.existeReg(conElias, escuelaMenu, auxiliarMenu, "", "")){
			System.out.println(auxiliarMenu +" TIENE PRORROGA Y NO SE BLOQUEA");
			saldoAlumnoMenu = Double.parseDouble("0.00");
			
			pasa = true;
		}else{
			System.out.println(auxiliarMenu +" NO TIENE PRORROGA Y SE BLOQUEA");
		}
	}
}



String codigoAlumno = (String) session.getAttribute("codigoAlumno");
%>

<ul class="nav nav-tabs">	
	  <li class="datos"><a href="datos.jsp"><fmt:message key="aca.Datos"/></a></li>
	  <li class="finanzas"><a href="edo_cta_alum.jsp"><fmt:message key="aca.Finanzas"/></a></li>
<%	if(pasa){ %>  
	  <li class="documentos"><a href="docalum.jsp">Documentos</a></li>
	  <li class="materias"><a href="materias.jsp"><fmt:message key="aca.Materias"/></a></li>
	  <li class="notas"><a href="<%= urlNotas %>"><fmt:message key="aca.Notas"/></a></li>
	  <li class="disciplina"><a href="disciplina.jsp"><fmt:message key="aca.Mentoria"/></a></li>	
	  <% if(false){ %>
	  <li class="examenes"><a href="examenes.jsp">Exámenes</a></li>
	  <% } %>
<%	} %>
	  <% if(aca.kardex.KrdxCursoAct.getAlumGrupo(conElias, codigoAlumno, cicloId).equals("H992020A001")){ %>
	  <li class="tareas"><a href="foros.jsp">Foro</a></li>
	  <% } %>
	  <li class="tareas"><a href="tareas_new.jsp"><fmt:message key="portal.Tareas"/></a></li>
  
</ul>
