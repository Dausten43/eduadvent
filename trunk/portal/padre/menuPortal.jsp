<%@page import="java.util.ArrayList"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="aca.fin.FinProrrogas"%>
<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="cicloPrincipal" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="ciclom" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloListam" scope="page" class="aca.ciclo.CicloLista"/>
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
if(request.getParameter("codigo")!=null){
	session.setAttribute("codigoAlumno", request.getParameter("codigo"));
}

String auxiliar		= session.getAttribute("codigoAlumno").toString();
String escuela		= (String) session.getAttribute("escuela");
String fechaHoy 	= aca.util.Fecha.getHoy();
String cicloId 		= session.getAttribute("cicloId").toString();


 ArrayList<aca.ciclo.Ciclo> lisCiclom	= cicloListam.getListCiclosAlumno(conElias, auxiliar, "ORDER BY CICLO_ID");

// //Verifica que el ciclo este en la lista de ciclo
	boolean encontro = false;
	for(aca.ciclo.Ciclo c : lisCiclom){
		if(cicloId != null && c.equals(cicloId)){
			encontro = true; break;
		}
	}
	
	// Elige el mejor ciclo para el alumno. 
	if( encontro==false && lisCiclom.size()>0 ){
		ciclom 	= (aca.ciclo.Ciclo) lisCiclom.get(lisCiclom.size()-1);
		cicloId = ciclom.getCicloId();
			
		
	}
	
 	session.setAttribute("cicloId", cicloId);

// Define si despliega notas de kinder
cicloPrincipal.mapeaRegId(conElias, cicloId);

boolean iskinder = false;
Integer nivelsistema = new Integer(cicloPrincipal.getNivelAcademicoSistema()!=null ? cicloPrincipal.getNivelAcademicoSistema() : "-1");
String urlNotas = "notas.jsp";
System.out.println(nivelsistema + " nivel sistema 2 " +  (nivelsistema>-1 && nivelsistema<3));
if(nivelsistema>-1 && nivelsistema<3){
	urlNotas = "notas_kinder.jsp";
	iskinder = true;
}
//

double saldoAlumno 		= aca.fin.FinMovimientos.saldoAlumno(conElias, auxiliar, fechaHoy);
CatParametro.mapeaRegId(conElias, escuela);
double deudaLimite = Double.parseDouble(CatParametro.getBloqueaPortal());
BigDecimal limiteNivel = FinLimite.importeTope(conElias,escuela,nivelsistema);
//System.out.println("Datos:"+saldoAlumno+":"+deudaLimite);
FinProrrogas fp = new FinProrrogas();
boolean pasa = false;

BigDecimal saldo = BigDecimal.ZERO;
BigDecimal tope = BigDecimal.ZERO;

saldo = saldo.add(new BigDecimal(saldoAlumno));


if(limiteNivel.compareTo(BigDecimal.ZERO)>0){
	tope = tope.add(limiteNivel);
}else{
	tope = tope.add(new BigDecimal(deudaLimite));	
}
	
System.out.println("TOPE :"+ tope);


//System.out.println(auxiliar +" saldo y tope :"+saldoAlumno+":"+deudaLimite);
if(saldo.compareTo(BigDecimal.ZERO)>=0){
	//System.out.println(auxiliar +" SALDO ES POSITIVO Y TIENE CREDITO");
	pasa = true;
}else{
	//System.out.println(auxiliar +" SALDO ES NEGATIVO");
	
	if(saldo.abs().compareTo(tope.abs())<0){
			pasa=true;
			//System.out.println(auxiliar +" SALDO ES MENOR QUE EL TOPE " +saldo.abs() + " : " + tope.abs());
	}else{
		if(fp.existeReg(conElias, escuela, auxiliar, "", "")){
			//System.out.println(auxiliar +" TIENE PRORROGA Y NO SE BLOQUEA");
			saldoAlumno = Double.parseDouble("0.00");
			
			pasa = true;
		}else{
			//System.out.println(auxiliar +" NO TIENE PRORROGA Y SE BLOQUEA");
		}
	}
}




%>
<ul class="nav nav-tabs">
  <li class="hijo"><a href="portalPadre.jsp">Padre</a></li>
  <li class="datos"><a href="datos.jsp"><fmt:message key="aca.Datos"/></a></li>
  <li class="finanzas"><a href="finanzas.jsp"><fmt:message key="aca.Finanzas"/></a></li>
  
<%	if(pasa){ %>  
  <li class="documentos"><a href="docalum.jsp">Documentos</a></li>
  <li class="materias"><a href="materias.jsp"><fmt:message key="aca.Materias"/></a></li>
  <li class="notas"><a href="<%= urlNotas %>"><fmt:message key="aca.Notas"/></a></li>
  <li class="disciplina"><a href="disciplina.jsp"><fmt:message key="aca.Mentoria"/></a></li>
<%	} %>
  <li class="tareas"><a href="tareas_new.jsp"><fmt:message key="portal.Tareas"/></a></li>
</ul>
