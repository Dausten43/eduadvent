<%@page import="java.util.HashMap"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<%@page import="aca.alumno.AlumPersonal"%>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="catEscuela" scope="page" class="aca.catalogo.CatEscuela"/>
<jsp:useBean id="catEscuelaU" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="personalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="EmpPersonalL" scope="page" class="aca.empleado.EmpPersonalLista"/>

<head>
  <!-- ---------------------JS GRAFICAS--------------------- -->
  <script type="text/javascript" src="../../js/highcharts.js"></script>
  <script type="text/javascript" src="../../js/highChart/pie.js"></script>
  <script type="text/javascript" src="../../js/exporting.js"></script>
  <!-- ---------------------END JS GRAFICAS--------------------- -->
<%
	
	String codigoId = (String)session.getAttribute("codigoId");

//----------------TRAER LAS ESCUELAS DE CADA ASOCIACION-------------- 
	usuario.mapeaRegId(conElias, codigoId);
	String [] asociacionesUsuario 	= usuario.getAsociacion().trim().split("-");
	
	
	String [] escuelasUsuario = usuario.getEscuela().trim().split("-");
	ArrayList<String> arrayEscuelas = new ArrayList<String>();
	java.util.Collections.addAll(arrayEscuelas, escuelasUsuario);
	
	
	ArrayList<aca.catalogo.CatEscuela> escuelas = catEscuelaU.getListAll(conElias, " ORDER BY ASOCIACION_ID ");
	
	ArrayList<String> EscuelasPorAsociacion = new ArrayList<String>();
	ArrayList<String> AsociacionesDeEscuelasPorAsociacion = new ArrayList<String>();
	HashMap <String, String> mapEmpDoc 	= EmpPersonalL.mapMaestrosCurso(conElias, codigoId);
	
	
	for(String asoc: asociacionesUsuario){
		String schools  = "";
		for(aca.catalogo.CatEscuela escTmp: escuelas){
			String asocTmp = escTmp.getAsociacionId()==null?"*":escTmp.getAsociacionId();
			
			if(asocTmp.equals(asoc)){
				if(arrayEscuelas.contains(escTmp.getEscuelaId())){
					schools+="'"+escTmp.getEscuelaId()+"',";
				}
			}
		}
		if(!schools.equals("")){
			schools=schools.substring(0, schools.length()-1);
			EscuelasPorAsociacion.add(schools);
			AsociacionesDeEscuelasPorAsociacion.add(asoc);
			
		}
	}
//---------------- END TRAER LAS ESCUELAS DE CADA ASOCIACION-------------- 
	
	String allEscuelas = "";
	int contador=0;
	for(String str: EscuelasPorAsociacion){
		contador++;
		String coma = ",";
		if(contador==EscuelasPorAsociacion.size())coma="";
		allEscuelas+=""+str+""+coma;
	}
	
%>
</head>
<body>

<style>
	.table tr td:first-child{
		text-align: left;
	}
	.table tr td{
		text-align: right;
	}
</style>

<div id="content">

<%
	java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	int maternal 			= AlumPersonal.getCantidadPorNivelEscuela(conElias, allEscuelas, "0");
	int preescolar 			= AlumPersonal.getCantidadPorNivelEscuela(conElias, allEscuelas, "1");
	int primaria 			= AlumPersonal.getCantidadPorNivelEscuela(conElias, allEscuelas, "2");
	int secundaria 			= AlumPersonal.getCantidadPorNivelEscuela(conElias, allEscuelas, "3");
	int prepa 				= AlumPersonal.getCantidadPorNivelEscuela(conElias, allEscuelas, "4");
	int totalInscritos 		= maternal+preescolar+primaria+secundaria+prepa;
	
	int mujeres 			= AlumPersonal.getNumMujeresTotalEscuela(conElias, allEscuelas);
	int hombres 			= AlumPersonal.getNumHombresTotalEscuela(conElias, allEscuelas);
	
	int acfe 				= AlumPersonal.getNumAcfeTotalEscuela(conElias, allEscuelas);
	int nAcfe 				= AlumPersonal.getNumNAcfeTotalEscuela(conElias, allEscuelas);
	
	if (totalInscritos>0){
		double promMaternal 	= maternal==0 ? 0 : ((double)maternal)*100/totalInscritos;
		promMaternal 			= Double.valueOf(getformato.format(promMaternal).replaceAll(",","."));
		
		double promPreescolar 	= preescolar==0 ? 0 : ((double)preescolar)*100/totalInscritos;
		promPreescolar 			= Double.valueOf(getformato.format(promPreescolar).replaceAll(",","."));
		
		double promPrimaria  	= primaria==0 ? 0 : ((double)primaria)*100/totalInscritos;
		promPrimaria		    = Double.valueOf(getformato.format(promPrimaria).replaceAll(",","."));
		
		double promSecundaria	= secundaria==0 ? 0 : ((double)secundaria)*100/totalInscritos;
		promSecundaria			= Double.valueOf(getformato.format(promSecundaria).replaceAll(",","."));
		
		double promPrepa		= prepa==0 ? 0 : ((double)prepa)*100/totalInscritos;
		promPrepa				= Double.valueOf(getformato.format(promPrepa).replaceAll(",","."));
		
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
		
	
		String serieNivel 		= "['Maternal: "+maternal+"', "+promMaternal+"], ['Preescolar: "+preescolar+"', "+promPreescolar+"], ['Primaria: "+primaria+"',"+promPrimaria+"],"+
			  "['Secundaria: "+secundaria+"',"+promSecundaria+"], ['Preparatoria: "+prepa+"',"+promPrepa+"]";
		
		String serieGenero 		= "['Hombres: "+hombres+"', "+promHombres+"], ['Mujeres: "+mujeres+"',"+promMujeres+"]";
		
		String serieAcfe 		= "['ACFE: "+acfe+"', "+promAcfe+"], ['NO ACFE: "+nAcfe+"',"+promNAcfe+"]";
		
		String serieAsociacion  = "";
		
		ArrayList<String> lisReligion = personalLista.getListInscritosReligionDivision(conElias,allEscuelas);
		for (int i=0; i<AsociacionesDeEscuelasPorAsociacion.size();i++){
			String nombre = aca.catalogo.CatAsociacion.getNombre(conElias, AsociacionesDeEscuelasPorAsociacion.get(i));
			int inscritosAsoc = AlumPersonal.getNumInscritosPorAsociacion(conElias, EscuelasPorAsociacion.get(i));
			
			if (i==0){
				serieAsociacion += "['"+nombre+": "+inscritosAsoc+"',"+Double.valueOf(getformato.format((int)inscritosAsoc*100/(int)totalInscritos).replaceAll(",","."))+"]";
			}else{
				serieAsociacion += ",['"+nombre+": "+inscritosAsoc+"',"+Double.valueOf(getformato.format((int)inscritosAsoc*100/(int)totalInscritos).replaceAll(",","."))+"]";
			}
	    }

		int cantReligion		= 0;
		String religion			= "";
		String nombrer			= "";
		String serieReligion	= "";
		double porcentaje		= 0;
		for(String alumno : lisReligion){
			String [] datos  	= alumno.split("@@");
			religion  			= datos[1];
			nombrer 				= aca.catalogo.CatReligion.getReligionNombre(conElias, religion);
			cantReligion 		= Integer.parseInt(datos[0]);
			porcentaje			= ((double)cantReligion*100)/totalInscritos;
			serieReligion 		+= "['"+nombrer+": "+cantReligion+"', "+Double.valueOf(getformato.format(porcentaje).replaceAll(",","."))+"],";	
		}
 %>
 
 
 	<h2><fmt:message key="reportes.GraficaAsoc" /> <small><%=totalInscritos %> <fmt:message key="aca.Inscritos" /></small></h2>
 
 	<div class="well">
 		<a class="btn btn-primary" href="reporteInscritos.jsp"><i class="icon-th-list icon-white"></i> Reporte de Inscritos</a>
 	</div>
 
 	<div class="row">
 		<div class="span4" style="border-width: 2px; border-style: solid; border-color: black; ">
 				<script  type="text/javascript">Pie('Asociaciones','asociacion',[<%=serieAsociacion%>])</script>
				<div id="asociacion" style="width: 100%; height: 450px; margin: 0 auto"></div>		
 		</div>
 		
 		
 		<div class="span8">
 				<!-- ************ TABLA DE INSCRITOS ************** -->
 				
 				<table class="table table-bordered table-hover">
					<tr>
						<th width="90%"><fmt:message key="aca.Asociaciones" /></th>
						<th><fmt:message key="aca.Alumnos" /></th>
						<th><fmt:message key="aca.Inscritos" /></th>
						<th><fmt:message key="empleados.Empleados" /></th>
						<th><fmt:message key="aca.EnDocencia" /></th>
						
					</tr>
					<%
					int total = 0;
					int totalReg = 0;
					int totalRegEmp = 0;
					int totalEmpDoc	= 0;
					
					for (int i=0; i<AsociacionesDeEscuelasPorAsociacion.size();i++){
						String asociacionId = AsociacionesDeEscuelasPorAsociacion.get(i);
						String nombre = aca.catalogo.CatAsociacion.getNombre(conElias, AsociacionesDeEscuelasPorAsociacion.get(i));
						int inscritosAsoc = AlumPersonal.getNumInscritosPorAsociacion(conElias, EscuelasPorAsociacion.get(i));
						int registradosAsoc = AlumPersonal.getTotalRegistrosAsocicacion(conElias, EscuelasPorAsociacion.get(i));
						int empRegAsoc = aca.empleado.EmpPersonal.getTotalRegistrosAsocicacion(conElias, EscuelasPorAsociacion.get(i));
						int empDocenciaAsoc =0;
						if(mapEmpDoc.containsKey(asociacionId)){
							empDocenciaAsoc = Integer.parseInt(mapEmpDoc.get(asociacionId));
						}
						total+=inscritosAsoc;
						totalReg += registradosAsoc;
						totalRegEmp += empRegAsoc;
						totalEmpDoc += empDocenciaAsoc;
						%>
						
						<tr style="cursor:pointer;" onclick="document.location='graficaAsociacion.jsp?AsociacionId=<%=AsociacionesDeEscuelasPorAsociacion.get(i)%>'"
							class="button">
							<td><%=nombre %></td>
							<td><%=registradosAsoc %></td>
							<td><%=inscritosAsoc %></td>
							<td><%=empRegAsoc %></td>
							<td><%=empDocenciaAsoc %></td>
							
						</tr>
						
					<%} %>
					<tr>
						<td><strong><fmt:message key="aca.Total" /></strong></td>
						<td><strong><%=totalReg %></strong></td>
						<td><strong><%=total %></strong></td>
						<td><strong><%=totalRegEmp %></strong></td>
						<td><strong><%=totalEmpDoc %></strong></td>
						
					</tr>
				</table>
 				
 		</div>
 		
 	</div>
 	
 	<div class="row">
 		<div class="span4" style="border-width: 2px; border-style: solid; border-color: black; ">
 				<script  type="text/javascript">Pie('Nivel','nivel',[<%=serieNivel%>])</script>
			    <div id="nivel" style="width: 100%; height: 300px; margin: 0 auto"></div>	
 		</div>
 		<div class="span4" style="border-width: 2px; border-style: solid; border-color: black; ">
			    <script  type="text/javascript">Pie('Género','genero',[<%=serieGenero%>])</script>
			    <div id="genero" style="width: 100%; height: 300px; margin: 0 auto"></div>					    
 		</div>
 		<div class="span4" style="border-width: 2px; border-style: solid; border-color: black; ">  
			<script  type="text/javascript">Pie('Religión','religion',[<%=serieReligion%>])</script>
		    <div id="religion" style="width: 340px; height: 450px; margin: 0 auto"></div>						
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
 	
 		<div class="span8" style="border-width: 2px; border-style: solid; border-color: black; ">
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
 
	
<% 	}  else{ %>
	<div class="alert alert-danger"><fmt:message key="reportes.NoAlumnosInsc" /></div>
<%} %>

</div>
</body>
<script>
	jQuery('.estadistica').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>