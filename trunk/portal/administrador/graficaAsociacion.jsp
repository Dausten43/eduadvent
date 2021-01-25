<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="catEscuela" scope="page" class="aca.catalogo.CatEscuela"/>
<jsp:useBean id="catEscuelaU" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="personalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="EmpPersonalL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<%@page import="aca.alumno.AlumPersonal"%>

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
	String asociacionId = request.getParameter("AsociacionId");

	//---------------- TRAER LAS ESCUELAS DE LA ASOCIACION-------------- 
	usuario.mapeaRegId(conElias, codigoId);
	String escuelaUsuario 			= usuario.getEscuela();
	String [] escuelasUsuario 		= escuelaUsuario.trim().split("-");
	
	java.util.HashMap <String, String> mapEmpDoc 	= EmpPersonalL.mapMaestrosCursoEscuela(conElias, asociacionId);
	
	ArrayList <aca.catalogo.CatEscuela> escuelasAsociacion = catEscuelaU.getListAsociacion(conElias, asociacionId, "ORDER BY ESCUELA_ID");
	
	ArrayList <String> EscuelasUsuario = new ArrayList<String>();
	
	for(String str: escuelasUsuario){
		for(aca.catalogo.CatEscuela esc :escuelasAsociacion){
			if(esc.getEscuelaId().equals(str))EscuelasUsuario.add(str);
		}
	}
	//---------------- END TRAER LAS ESCUELAS DE LA ASOCIACION-------------- 
	
	String allEscuelas = "";
	for(String str: EscuelasUsuario){
		allEscuelas+="'"+str+"',";
	}
	if(allEscuelas.length()!=0)allEscuelas=allEscuelas.substring(0,allEscuelas.length()-1);
	
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
	
		String serieEscuela  = "";
		
		if(totalInscritos > 0) {
			for (int i=0; i<EscuelasUsuario.size();i++){
				String nombre = aca.catalogo.CatEscuela.getNombre(conElias, EscuelasUsuario.get(i));
				int inscritosAsoc = AlumPersonal.getNumInscritosPorEscuela(conElias, EscuelasUsuario.get(i));
	
				serieEscuela += "['"+nombre+": "+inscritosAsoc+"',"+Double.valueOf(getformato.format((double)inscritosAsoc*100/(double)totalInscritos).replaceAll(",","."))+"],";
				
		    }
		}
	
%>

	<h2><%= aca.catalogo.CatAsociacion.getNombre(conElias, asociacionId)%> <small><%=totalInscritos%> <fmt:message key="aca.Inscritos" /></small></h2>
	
	<div class="well">
		<a href="grafica.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a class="btn btn-primary" href="reporteInscritosAsoc.jsp?AsociacionId=<%=asociacionId %>"><i class="icon-th-list icon-white"></i> Reporte de Inscritos</a>
	</div>
	<%if(totalInscritos <= 0) out.println("<div class='alert alert-warning'>No hay Inscritos</div>"); %>
	<div class="row">
 		<div class="span4">
 		
 			<script  type="text/javascript">Pie('Escuelas','escuelas',[<%=serieEscuela%>])</script>
			<div id="escuelas" style="width: 100%; height: 350px; margin: 0 auto"></div>	
 		
 		</div>
 		
 		<div class="span8">
 		
 			<table class="table table-bordered table-hover">
					<tr>
						<th width="90%"><fmt:message key="aca.Escuelas" /></th>
						<th><fmt:message key="aca.Alumnos" /></th>
						<th><fmt:message key="aca.Inscritos" /></th>
						<th><fmt:message key="aca.Empleados" /></th>
						<th><fmt:message key="aca.EnDocencia" /></th>
						
					</tr>
					<%
					int total	 	= 0;
					int totalReg 	= 0;
					int totalEmp	= 0;
					int totalEmpDoc	= 0;
					for (int i=0; i<EscuelasUsuario.size();i++){
						if(aca.catalogo.CatEscuela.getStatus(conElias, EscuelasUsuario.get(i)).equals("A")){
							String nombre = aca.catalogo.CatEscuela.getNombre(conElias, EscuelasUsuario.get(i));
							int inscritosAsoc = AlumPersonal.getNumInscritosPorEscuela(conElias, EscuelasUsuario.get(i));
							int registrosAsoc = AlumPersonal.getTotalRegistros(conElias, EscuelasUsuario.get(i));
							
							int empTotEsc	  = aca.empleado.EmpPersonal.getTotalEmpleadosActivos(conElias, EscuelasUsuario.get(i));
							int empDocenciaEsc =0;
							if(mapEmpDoc.containsKey(EscuelasUsuario.get(i))){
								empDocenciaEsc = Integer.parseInt(mapEmpDoc.get(EscuelasUsuario.get(i)));
							}
							total		+=inscritosAsoc;
							totalReg 	+= registrosAsoc;
							totalEmp	+=empTotEsc;
							totalEmpDoc += empDocenciaEsc;
						%>
						<tr style="cursor:pointer;" onclick="document.location='graficaEscuela.jsp?EscuelaId=<%=EscuelasUsuario.get(i)%>&AsociacionId=<%=asociacionId%>'"
							class="button">
							<td><%=nombre %></td>
							<td><%=registrosAsoc %></td>
							<td><%=inscritosAsoc %></td>
							<td><%=empTotEsc %></td>
							<td><%=empDocenciaEsc %></td>
						</tr>
					<%	}
					} %>
					<tr>
						<td><strong><fmt:message key="aca.Total" /></strong></td>
						<td><strong><%=totalReg %></strong></td>
						<td><strong><%=total %></strong></td>
						<td><strong><%=totalEmp %></strong></td>
						<td><strong><%=totalEmpDoc %></strong></td>
						
					</tr>
				</table>
 		
 		</div>
 	</div>
 	
 	<br />
 	
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
						ArrayList<String> list = personalLista.getListEdadesEscuela(conElias, allEscuelas);
						java.util.LinkedHashMap <String, Integer> edadOrden = new java.util.LinkedHashMap<String, Integer>();
						for(String edad: list){
						      if(edadOrden.containsKey(edad)){
						        int contEdad = edadOrden.get(edad);
						        edadOrden.put(edad, ++contEdad);
						      }else{
						        edadOrden.put(edad,1);
						      }
						}
												
						String edadTemp="";
						int contTmp=0;
						int otros = 0;
						ArrayList<Double> porcentajes = new ArrayList<Double>();
						ArrayList<String> edades = new ArrayList<String>();
						ArrayList<Integer> contadorEdades = new ArrayList<Integer>(edadOrden.values());
						for (int i=0; i<list.size();i++){
							
							
							if(!edadTemp.equals(list.get(i))){
								double numEdades = contadorEdades.get(contTmp);
								contTmp++;
								
								if(Integer.parseInt(list.get(i))>3 && Integer.parseInt(list.get(i))<20){
									
									porcentajes.add(((double)numEdades)*100/totalInscritos);//añadir los porcenatjes de la lista
									
									edades.add(list.get(i));
%>         					<tr>					
								<td align="center" width="8%"><%=list.get(i) %></td>		
								<td align="right"width="8%"><%=(int)numEdades %></td>
								<td align="right"width="15%"><%=getformato.format((numEdades)*100/totalInscritos).replaceAll(",", ".") %>%</td>
							</tr>
<%								}else{
									otros = otros + (int)numEdades;
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
								<td><fmt:message key="aca.Otros" /></td>		
								<td><%=otros %></td>
								<td><%=otros>0 ? getformato.format(((double)otros)*100/totalInscritos) : "00.00"%>%</td>
							</tr>  						
<%
%>						<tr>
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


</div>
</body>
<script>
	jQuery('.estadistica').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>