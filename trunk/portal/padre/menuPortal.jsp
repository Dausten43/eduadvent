<%@page import="java.math.BigDecimal"%>
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
if(request.getParameter("codigo")!=null){
	session.setAttribute("codigoAlumno", request.getParameter("codigo"));
}

String auxiliar		= session.getAttribute("codigoAlumno").toString();
String escuela		= (String) session.getAttribute("escuela");
String fechaHoy 	= aca.util.Fecha.getHoy();

double saldoAlumno 		= aca.fin.FinMovimientos.saldoAlumno(conElias, auxiliar, fechaHoy);
CatParametro.mapeaRegId(conElias, escuela);
double deudaLimite = Double.parseDouble(CatParametro.getBloqueaPortal()) ;
System.out.println("Datos:"+saldoAlumno+":"+deudaLimite);
FinProrrogas fp = new FinProrrogas();
boolean pasa = false;

BigDecimal saldo = BigDecimal.ZERO;
BigDecimal tope = BigDecimal.ZERO;

saldo = saldo.add(new BigDecimal(saldoAlumno));
tope = tope.add(new BigDecimal(deudaLimite));

System.out.println(auxiliar +" saldo y tope :"+saldoAlumno+":"+deudaLimite);
if(saldo.compareTo(BigDecimal.ZERO)>=0){
	System.out.println(auxiliar +" SALDO ES POSITIVO Y TIENE CREDITO");
	pasa = true;
}else{
	System.out.println(auxiliar +" SALDO ES NEGATIVO");
	
	if(saldo.abs().compareTo(tope.abs())<0){
			pasa=true;
			System.out.println(auxiliar +" SALDO ES MENOR QUE EL TOPE " +saldo.abs() + " : " + tope.abs());
	}else{
		if(fp.existeReg(conElias, escuela, auxiliar, "", "")){
			System.out.println(auxiliar +" TIENE PRORROGA Y NO SE BLOQUEA");
			saldoAlumno = Double.parseDouble("0.00");
			
			pasa = true;
		}else{
			System.out.println(auxiliar +" NO TIENE PRORROGA Y SE BLOQUEA");
		}
	}
}




%>
<ul class="nav nav-tabs">
  <li class="hijo"><a href="portalPadre.jsp">Padre</a></li>
  <li class="datos"><a href="datos.jsp">Datos</a></li>
  
<%	if(pasa){ %>  
  <li class="documentos"><a href="docalum.jsp">Documentos</a></li>
  <li class="materias"><a href="materias.jsp">Materias</a></li>
  <li class="notas"><a href="notas.jsp">Notas</a></li>
  <li class="disciplina"><a href="disciplina.jsp"><fmt:message key="aca.Mentoria"/></a></li>
<%	} %>
  <li class="finanzas"><a href="finanzas.jsp">Finanzas</a></li>
  <li class="tareas"><a href="tareas.jsp">Tareas</a></li>
</ul>