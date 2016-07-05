<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.fin.FinMovimiento"%>
<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="AlumSaldoL" scope="page" class="aca.vista.AlumnoSaldoLista"/>


<%@page import="java.util.HashMap"%>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String ejercicioId		= (String) session.getAttribute("ejercicioId");
	String ciclo			= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");

	String nivel 	="-";
	String grado 	= "-";
	String grupo 	= "-";
	int cont		= 1;	
	// Lista de Alumnos deudores
	ArrayList <aca.vista.AlumnoSaldo> listAlumSaldo		= AlumSaldoL.getListAll(conElias, escuelaId);	
	HashMap<String, aca.vista.AlumnoSaldo> mapAlumSaldo	= AlumSaldoL.mapAlumSaldo(conElias, escuelaId);
%>

<div id="content">	
	<h2>Alumnos con deuda</h2>
	<form name="forma" action="reporte_deudor.jsp" method='post'>
		<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		 </div>
	 </form>
<% 	
	
	for(int i=0; i<listAlumSaldo.size(); i++){
		System.out.println(i);
		if(!nivel.equals(listAlumSaldo.get(i).getNivelId())){
		nivel=listAlumSaldo.get(i).getNivelId();
		if(i>=1){
			out.print("</table>");
		}
		out.print("<div class='alert alert-info'>Nivel:"+nivel+"</div>");
		grado="-";
		grupo="-";
		}
		System.out.println(grado+" "+listAlumSaldo.get(i).getGrado()+grupo+" "+listAlumSaldo.get(i).getGrupo());
		if(!grado.equals(listAlumSaldo.get(i).getGrado())||!grupo.equals(listAlumSaldo.get(i).getGrupo())){
				grado=listAlumSaldo.get(i).getGrado();
				grupo = listAlumSaldo.get(i).getGrupo();
				if (!grupo.equals(listAlumSaldo.get(i).getGrupo())){
					out.print("</table>");
				}
				out.print("</table><div class='alert' >Grado: "+grado+" Grupo: "+grupo+"</div>");
	
%>
			<table class="table  table-fontsmall table-striped">
				<tr>
				    <th>#</th>
				    <th>Matr&iacute;cula</th> 
				    <th>Nombre</th>
				    <th style="text-align:right">Saldo</th>
				 </tr>
<%			}%> 
		<tr>
		  <td width="5%"><%=cont%></td>
		  <td width="10%"><%=listAlumSaldo.get(i).getCodigoId()%></td>
		  <td width="50%"><%=aca.alumno.AlumPersonal.getNombre(conElias, listAlumSaldo.get(i).getCodigoId(), "APELLIDO")%></td>
		  <td width="10%" style="text-align:right"><%=listAlumSaldo.get(i).getSaldo() %></td>	 
		</tr>
<%
cont++;}%>

</div>

<%@ include file="../../cierra_elias.jsp" %>