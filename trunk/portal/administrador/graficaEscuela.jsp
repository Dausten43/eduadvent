<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="catEscuela" scope="page" class="aca.catalogo.CatEscuela"/>
<jsp:useBean id="catEscuelaU" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="catNivelEscList" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="personalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.catalogo.CatNivelEscuela"%>

<head>
  <!-- ---------------------JS GRAFICAS--------------------- -->
  <script type="text/javascript" src="../../js/highcharts.js"></script>
  <script type="text/javascript" src="../../js/highChart/pie.js"></script>
  <script type="text/javascript" src="../../js/highChart/modules/exporting.js"></script>
  <script type="text/javascript" src="../../js/highChart/themes/grid.js"></script>
  <!-- ---------------------END JS GRAFICAS--------------------- -->
<%

	java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	String codigoId 	= (String)session.getAttribute("codigoId");
	String escuelaId	= request.getParameter("EscuelaId");

	
	String allEscuelas 		= "'"+escuelaId+"'";
	
	int mujeres 			= AlumPersonal.getNumMujeresTotalEscuela(conElias, allEscuelas);
	int hombres 			= AlumPersonal.getNumHombresTotalEscuela(conElias, allEscuelas);
	int totalInscritos 		= mujeres+hombres;
	
	int acfe 				= AlumPersonal.getNumAcfeTotalEscuela(conElias, allEscuelas);
	int nAcfe 				= AlumPersonal.getNumNAcfeTotalEscuela(conElias, allEscuelas);

%>

<style>
	.table tr td:first-child{
		text-align: left;
	}
	.table tr td{
		text-align: right;
	}
</style>

</head>
<body>

<div id="content">

<%
	if (totalInscritos>0){
		
		double promHombres 		= 0;
		if (totalInscritos>0){ promHombres = ((double)hombres)*100/totalInscritos;}
		promHombres 			= Double.valueOf(getformato.format(promHombres).replaceAll(",","."));
		
		double promMujeres 		= 0;
		if (totalInscritos>0){ promMujeres = mujeres==0 ? 0 : ((double)mujeres)*100/totalInscritos;}	
		promMujeres 			= Double.valueOf(getformato.format(promMujeres).replaceAll(",","."));
		
		double promAcfe 		= acfe==0 ? 0 : ((double)acfe)*100/totalInscritos;
		promAcfe 				= Double.valueOf(getformato.format(promAcfe).replaceAll(",","."));
		
		double promNAcfe		= nAcfe==0 ? 0 : ((double)nAcfe)*100/totalInscritos;
		promNAcfe				= Double.valueOf(getformato.format(promNAcfe).replaceAll(",","."));
		
		String serieNivel = "";
		
		ArrayList<CatNivelEscuela> ListNivel = new ArrayList<CatNivelEscuela>();
		ListNivel = catNivelEscList.getListEscuela(conElias, escuelaId, "");
		
		for (CatNivelEscuela n: ListNivel)
		{
			int totalNiv 	 	= AlumPersonal.getCantidadPorNivelEscuela(conElias, allEscuelas, n.getNivelId());
			double promNivel 	= totalNiv == 0 ? 0 : ((double)totalNiv)*100/totalInscritos;
			promNivel 	     	= Double.valueOf(getformato.format(promNivel).replaceAll(",","."));		
			String nombreNivel 	= n.getNivelNombre();
			
			serieNivel += "['"+nombreNivel+": "+totalNiv+"', "+promNivel+"],";
			
		}
			
		String serieGenero 		= "['Hombres: "+hombres+"', "+promHombres+"], ['Mujeres: "+mujeres+"',"+promMujeres+"]";
		
		String serieAcfe 		= "['ACFE: "+acfe+"', "+promAcfe+"], ['NO ACFE: "+nAcfe+"',"+promNAcfe+"]";
	
		String serieEscuela  = "";
		
	
%>

	<h2><%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> <small><%=totalInscritos%> <fmt:message key="aca.Inscritos" /></small></h2>
	
	<div class="well">
		<a href="graficaAsociacion.jsp?AsociacionId=<%=request.getParameter("AsociacionId")%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	
	<div class="row">
	
		<div class="span4">
		
			<script  type="text/javascript">Pie('Nivel','nivel',[<%=serieNivel%>])</script>
			<div id="nivel" style="width: 100%; height: 300px; margin: 0 auto"></div>		
		
		</div>
		<div class="span4">
		
			<script  type="text/javascript">Pie('Genero','genero',[<%=serieGenero%>])</script>
			<div id="genero" style="width: 100%; height: 300px; margin: 0 auto"></div>
		
		</div>
		<div class="span4">
		
			<script  type="text/javascript">Pie('Clasificación','acfe',[<%=serieAcfe%>])</script>
			<div id="acfe" style="width: 100%; height: 300px; margin: 0 auto"></div>
		
		</div>
	
	</div>
	
	<br />
	
	<div class="row">
		
		<div class="span4">
		
			<table class="table table-bordered">
		          	<tr>
		          		<th width="90%"><fmt:message key="aca.Edades" /></th>
		          		<th>#</th>
		          		<th>%</th>
		          	</tr>
<%						
						String edadTemp = "";
						int otros = 0;
						int cont = 0;
						ArrayList<String> list = personalLista.getListEdadesEscuela(conElias, allEscuelas);
						ArrayList<Double> porcentajes = new ArrayList<Double>();
						ArrayList<String> edades = new ArrayList<String>();
						int contEdades = 0;
						
						ArrayList<Integer> contadorEdades = new ArrayList<Integer>();
						edadTemp = list.get(0);
						for (int i=0; i<list.size();i++){
							if(!edadTemp.equals(list.get(i))){
								contadorEdades.add(contEdades);
								edadTemp=list.get(i);
								contEdades=0;
							}
							contEdades++;
							if(i==list.size()-1)contadorEdades.add(contEdades);
						}
						
						edadTemp="";
						int contTmp=0;
						for (int i=0; i<list.size();i++){
							
							
							if(!edadTemp.equals(list.get(i))){
								double numEdades = contadorEdades.get(contTmp);
								contTmp++;
								
								if(Integer.parseInt(list.get(i))>3 && Integer.parseInt(list.get(i))<20){
									
									porcentajes.add(((double)numEdades)*100/totalInscritos);//añadir los porcenatjes de la lista
									edades.add(list.get(i));
%>         					<tr>					
								<td><%=list.get(i) %></td>		
								<td><%=(int)numEdades %></td>
								<td><%=getformato.format((numEdades)*100/totalInscritos).replaceAll(",", ".") %>%</td>
							</tr>
<%								cont++;
								}else{
									otros = otros + (int)numEdades;
								}
								edadTemp=list.get(i);
								
								contEdades=0;
							}
							contEdades++;
						}
						if(totalInscritos!=0){
							porcentajes.add(((double)otros)*100/totalInscritos);//añadir los porcentajes de la clasificacion "otros"
						}else{
							out.print("<font size='3'>No hay datos para graficar en esta carga</font>");
						}
						edades.add("Otros");
%>
							<tr>					
								<td><fmt:message key="aca.Otros" /></td>		
								<td><%=otros %></td>
								<td><%=getformato.format(((double)otros)*100/totalInscritos)%>%</td>
							</tr>  						
						<tr>
							<td><strong><fmt:message key="aca.Total" /></strong></td>
							<td><strong><%=totalInscritos%></strong></td>
							<td><strong>100%</strong></td>
						</tr>
				</table>
		
		</div>
		
		<div class="span8">
		
			<%				
							String serieEdad		= "";
			
							for (int i=0; i<porcentajes.size();i++){
								if (i==0){
									serieEdad += "['"+edades.get(i)+"',"+Double.valueOf(getformato.format(porcentajes.get(i)).replaceAll(",","."))+"]";
								}else{
									serieEdad += ",['"+edades.get(i)+"',"+Double.valueOf(getformato.format(porcentajes.get(i)).replaceAll(",","."))+"]";
								}
						    }
			%>						
			               <script  type="text/javascript">Pie('Edad','edad',[<%=serieEdad%>])</script>
						   <div id="edad" style="width: 100%; height: 400px; margin: 0 auto"></div> 	
		
		</div>
	
	</div>

<%}else{ %>

		<div class="alert alert-danger"><fmt:message key="reportes.NoAlumnosInsc" /> <a href="graficaAsociacion.jsp?AsociacionId=<%=request.getParameter("AsociacionId")%>"><fmt:message key="boton.Regresar" /></a></div>
	
<%} %>

</div>
</body>
<script>
	jQuery('.estadistica').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>