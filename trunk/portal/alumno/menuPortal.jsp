<%@page import="java.math.BigDecimal"%>
<%@page import="aca.fin.FinProrrogas"%>
<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="cicloPrincipal" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="FinLimite" scope="page" class="aca.fin.FinTopeNivelEscuelaUtils"/>

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
BigDecimal limiteNivel = FinLimite.importeTope(conElias,escuelaMenu,nivelsistema);

System.out.println("LIMITE NIVEL :"+ limiteNivel);
FinProrrogas fp = new FinProrrogas();
boolean pasa = false;

BigDecimal saldo = BigDecimal.ZERO;
BigDecimal tope = BigDecimal.ZERO;

saldo = saldo.add(new BigDecimal(saldoAlumnoMenu));

if(limiteNivel.compareTo(BigDecimal.ZERO)>0){
	tope = tope.add(limiteNivel);
}else{
	tope = tope.add(new BigDecimal(deudaLimite));	
}
	
System.out.println("TOPE :"+ tope);



System.out.println(auxiliarMenu +" saldo y tope :"+saldoAlumnoMenu+":"+ tope);
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
	  <li class="examenes"><a href="examenes.jsp">Exámenes</a></li>
<%	} %>
	  <li class="foros"><a href="foros.jsp">Foro</a></li>
	  <li class="tareas"><a href="tareas_new.jsp"><fmt:message key="portal.Tareas"/></a></li>
  
</ul>
