<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.alumno.AlumPersonal"%>
<jsp:useBean id="personalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CatClas" scope="page" class="aca.catalogo.CatClasFinLista"/>
<jsp:useBean id="nivelU" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>

<head>
  <script type="text/javascript" src="../../js/jquery-1.4.4.min.js"></script>
  <script type="text/javascript" src="../../js/highcharts.js"></script>
  <script type="text/javascript" src="../../js/highChart/pie.js"></script>
  <script type="text/javascript" src="../../js/exporting.js"></script>
</head>
<%
	java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuela 		= (String)session.getAttribute("escuela");	
	String ciclo 		= request.getParameter("ciclo")==null?(String)session.getAttribute("cicloId"):request.getParameter("ciclo");
	System.out.println(ciclo);
	
	//String ciclo		= request.getParameter("ciclo")==null?Ciclo.getCargaActual(conElias,escuela):request.getParameter("ciclo");
	
	int maternal 			= AlumPersonal.getCantidadPorNivel(conElias, ciclo, "0");
	int pre_kinder 			= AlumPersonal.getCantidadPorNivel(conElias, ciclo, "1");
	int preescolar_kinder 	= AlumPersonal.getCantidadPorNivel(conElias, ciclo, "2");
	int primaria 			= AlumPersonal.getCantidadPorNivel(conElias, ciclo, "3");
	int secundaria 			= AlumPersonal.getCantidadPorNivel(conElias, ciclo, "4");
	int prepa 				= AlumPersonal.getCantidadPorNivel(conElias, ciclo, "5");
	int totalInscritos 		= maternal+preescolar_kinder+pre_kinder+primaria+secundaria+prepa;
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuela, "ORDER BY 1");
	ArrayList<String> lisReligion = personalLista.getListAlumnosInscritosReligion(conElias, escuela, ciclo);
	ArrayList<String> lisClasFin = CatClas.getListClas(conElias, escuela);
	
	ArrayList<aca.catalogo.CatNivelEscuela> niveles = nivelU.getListEscuela(conElias, escuela, "ORDER BY 2");
%>
<style>	
	body{
		background: white;
	}
</style>

<div id="content">
	<h2><fmt:message key="reportes.GraficaInscritos" /> <small>( <%= aca.catalogo.CatEscuela.getNombreCorto(conElias, escuela)%> )</small></h2>
	<form id="noayuda" name="forma" action="estadistica.jsp" method='post'>	
	<div class="well">		
	<select id="ciclo" name="ciclo" onchange="document.forma.submit();" style="width:310px;">
<%	
	for(int i = 0; i < lisCiclo.size(); i++){
		Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
		Ciclo.getNivelAcademicoSistema();
%>
		<option value="<%=Ciclo.getCicloId() %>"<%=Ciclo.getCicloId().equals(ciclo)?" Selected":"" %>><%=Ciclo.getCicloNombre() %></option>
<%	}%>
  	</select>  	
  	</div> 
  	</form>
<%	
	if (totalInscritos>0){		
	
		int mujeres 			= AlumPersonal.getNumMujeresTotal(conElias, ciclo);
		int hombres 			= AlumPersonal.getNumHombresTotal(conElias, ciclo);
		
		int acfe 				= AlumPersonal.getNumAcfeTotal(conElias, ciclo);
		int nAcfe 				= AlumPersonal.getNumNAcfeTotal(conElias, ciclo);
		
		//PROMEDIOS
		double promHombres 		= 0;
		if (totalInscritos>0){ promHombres = ((double)hombres)*100/totalInscritos;}
		promHombres 			= Double.valueOf(getformato.format(promHombres).replaceAll(",","."));
		
		double promMujeres 		= 0;
		if (totalInscritos>0){ promMujeres = mujeres==0 ? 0 : ((double)mujeres)*100/totalInscritos;}	
		promMujeres 			= Double.valueOf(getformato.format(promMujeres).replaceAll(",","."));
		
		double promMaternal 	= maternal==0 ? 0 : ((double)maternal)*100/totalInscritos;
		promMaternal 			= Double.valueOf(getformato.format(promMaternal).replaceAll(",","."));
		
		double promPreKinder 	= pre_kinder==0 ? 0 : ((double)pre_kinder)*100/totalInscritos;
		promPreKinder 			= Double.valueOf(getformato.format(promPreKinder).replaceAll(",","."));
		
		double promPreescolar 	= preescolar_kinder==0 ? 0 : ((double)preescolar_kinder)*100/totalInscritos;
		promPreescolar 			= Double.valueOf(getformato.format(promPreescolar).replaceAll(",","."));
		
		double promPrimaria  	= primaria==0 ? 0 : ((double)primaria)*100/totalInscritos;
		promPrimaria		    = Double.valueOf(getformato.format(promPrimaria).replaceAll(",","."));
		
		double promSecundaria	= secundaria==0 ? 0 : ((double)secundaria)*100/totalInscritos;
		promSecundaria			= Double.valueOf(getformato.format(promSecundaria).replaceAll(",","."));
		
		double promPrepa		= prepa==0 ? 0 : ((double)prepa)*100/totalInscritos;
		promPrepa				= Double.valueOf(getformato.format(promPrepa).replaceAll(",","."));
		
		double promAcfe 		= acfe==0 ? 0 : ((double)acfe)*100/totalInscritos;
		promAcfe 				= Double.valueOf(getformato.format(promAcfe).replaceAll(",","."));
		
		double promNAcfe		= nAcfe==0 ? 0 : ((double)nAcfe)*100/totalInscritos;
		promNAcfe				= Double.valueOf(getformato.format(promNAcfe).replaceAll(",","."));
		
		int cantReligion		= 0;
		String religion			= "";
		String nombre			= "";
		String serieReligion	= "";
		double porcentaje		= 0;
		for(String alumno : lisReligion){
			String [] datos  	= alumno.split("@@");
			religion  			= datos[1];
			nombre 				= aca.catalogo.CatReligion.getReligionNombre(conElias, religion);
			cantReligion 		= Integer.parseInt(datos[0]);
			porcentaje			= ((double)cantReligion*100)/totalInscritos;
			serieReligion 		+= "['"+nombre+": "+cantReligion+"', "+Double.valueOf(getformato.format(porcentaje).replaceAll(",","."))+"],";	
		}
		
		int cantClas		= 0;
		String clasNom		= "";
		String serieClas	= "";
		double porClas		= 0;
		for(String clasFin : lisClasFin){
			cantClas 		= Integer.parseInt(aca.alumno.AlumPersonal.getTotalClas(conElias, escuela, clasFin, ciclo));
			porClas			= ((double)cantClas*100)/totalInscritos;
			clasNom			= aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuela, clasFin);
			serieClas 		+= "['"+clasNom+": "+cantClas+"', "+Double.valueOf(getformato.format(porClas).replaceAll(",","."))+"],";	
		}
		
		
		//SERIES
		String serieGenero 		 = "['Hombres: "+hombres+"', "+promHombres+"], ['Mujeres: "+mujeres+"',"+promMujeres+"]";
		
		String muestraSerieNivel = "";
		
		for(aca.catalogo.CatNivelEscuela nivel: niveles){
			int cantidad	 	= AlumPersonal.getCantidadPorNivel(conElias, ciclo, nivel.getNivelId());
			double promedio 	= cantidad==0 ? 0 : ((double)cantidad)*100/totalInscritos;
			promedio 			= Double.valueOf(getformato.format(promedio).replaceAll(",","."));

			muestraSerieNivel += "['"+nivel.getNivelNombre()+": "+AlumPersonal.getCantidadPorNivel(conElias, ciclo, nivel.getNivelId())+"',"+promedio+"],";
		}

		String serieNivel 		 = muestraSerieNivel;
		
		String serieAcfe 		 = "['ACFE: "+acfe+"', "+promAcfe+"], ['NO ACFE: "+nAcfe+"',"+promNAcfe+"]";
		String serieEdad		 = "";

%>
	<table width="90%" class="table table-fullcondensed table-nohover"  align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" id="noayuda">
		<tr><td>
		<table width="100%" border="0">			
           <tr>
          	  <td style="text-align:center;">
			  	<table align="center" width="100%">
					<tr>
						<td style="text-align:center;">
							<script  type="text/javascript">Pie('Nivel','nivel',[<%=serieNivel%>])</script>
						    <div id="nivel" style="width: 340px; height: 300px; margin: 0 auto"></div>					
						</td>
						<td  style="text-align:center;">			
							<script  type="text/javascript">Pie('Género','genero',[<%=serieGenero%>])</script>
						    <div id="genero" style="width: 340px; height: 300px; margin: 0 auto"></div>			
						</td>
						<td  style="text-align:center;">
							<script  type="text/javascript">Pie('Clasificación','acfe',[<%=serieClas%>])</script>
						    <div id="acfe" style="width: 340px; height: 300px; margin: 0 auto"></div>						
						</td>
						<td  style="text-align:center;">
							<script  type="text/javascript">Pie('Religión','religion',[<%=serieReligion%>])</script>
						    <div id="religion" style="width: 340px; height: 300px; margin: 0 auto"></div>						
						</td>	
					</tr>
				</table>
			  </td>
       	  </tr>
		 </table>
		</td></tr>	
  		<tr><td>
			<table width="100%" border="0" >
          	<tr><td  style="text-align:center;" colspan="3"><strong>Grafica por Edades</strong></td></tr>
			<tr><td width="40%" valign="top">
				<table width="100%" class="table table-striped">
		          	<tr><th>Edades</th><th>#</th><th>%</th></tr>
<%						
						String edadTemp = "";
						String sColorBk="";
						int otros = 0;
						int cont = 0;
						ArrayList<String> list = personalLista.getListEdades(conElias, ciclo);
						ArrayList<Double> porcentajes = new ArrayList<Double>();
						ArrayList<String> edades = new ArrayList<String>();
						for (int i=0; i<list.size();i++){
							if(cont%2==1) sColorBk=" bgcolor = '#C8D4A3'"; else sColorBk="";
							if(!edadTemp.equals(list.get(i))){
								
								int numEdades = AlumPersonal.getNumEdades(conElias, Integer.parseInt(list.get(i)),ciclo);
								if(Integer.parseInt(list.get(i))>3 && Integer.parseInt(list.get(i))<20){
									porcentajes.add(((double)numEdades)*100/totalInscritos);//añadir los porcenatjes de la lista
									edades.add(list.get(i));
%>         					<tr>					
								<td align="left" width="8%"><b><font color='#000000'><b>&nbsp;&nbsp;<%=list.get(i) %><b></font></a></b></td>		
								<td align="right"width="8%"><b><%=numEdades %></b></td>
								<td align="right"width="15%"><b><%=getformato.format(((double)numEdades)*100/totalInscritos) %>%</b></td>
							</tr>
<%								cont++;
								}else{
									otros = otros + numEdades;
								}
								edadTemp=list.get(i);
							}
						}
						if(totalInscritos!=0){
							porcentajes.add(((double)otros)*100/totalInscritos);//añadir los porcentajes de la clasificacion "otros"
						}else{
							out.print("<font size='3'>No hay datos para graficar en esta carga</font>");
						}
						edades.add("Otros");
%>
							<tr>					   
								<td align="left" width="20%"><b><font color='#000000'><b>&nbsp;&nbsp;Otros<b></font></a></b></td>		
								<td align="right"width="2%"><b><%=otros %></b></td>
								<td align="right"width="10%"><b><%=getformato.format(((double)otros)*100/totalInscritos)%>%</b></td>
							</tr>  						
<%
						if(sColorBk.equals("")) sColorBk=" bgcolor = '#C8D4A3'"; else sColorBk="";
%>						<tr>
							<td align="right" width="90%"><font color="#0000FF"><b>Total:</b></font></td>
							<td align="right"width="10%"><font color="#0000FF"><b><%=totalInscritos%></b></font></td>
						</tr>
				</table>
			</td>
			<td align="right" width="40%">
<%				for (int i=0; i<porcentajes.size();i++){
					if (i==0){
						serieEdad += "['"+edades.get(i)+"',"+Double.valueOf(getformato.format(porcentajes.get(i)).replaceAll(",","."))+"]";
					}else{
						serieEdad += ",['"+edades.get(i)+"',"+Double.valueOf(getformato.format(porcentajes.get(i)).replaceAll(",","."))+"]";
					}
			    }
%>						
               <script  type="text/javascript">Pie('Edad','edad',[<%=serieEdad%>])</script>
			   <div id="edad" style="width: 900px; height: 400px; margin: 0 auto"></div> 
			</td>
		</tr>			
      </table>
  	</td></tr>
	</table>
<%
	}else{
%>
	<table align="center">
	  <tr>
	    <td style="font-size:12pt;"><fmt:message key="reportes.NoAlumnos" /> <%=ciclo%> - <%=aca.ciclo.Ciclo.getCicloNombre(conElias, ciclo) %></td>
	  </tr>
	</table>	
<%		
	}
%>
</div>
<%@ include file="../../cierra_elias.jsp" %>