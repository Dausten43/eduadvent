<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<jsp:useBean id="AlumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="NivelLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>

<%	//Declaracion de Variables
	java.text.DecimalFormat getformato= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId		= (String) session.getAttribute("escuela");
	String periodoId    	= "";
	String nivelId			= request.getParameter("nivelId");
	String cicloId			= request.getParameter("ciclo")==null?Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");	
	String Insc				= "Inscritos";	

	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel 		= NivelLista.getListNivelesPermitidos(conElias, escuelaId, cicloId, "ORDER BY NIVEL_ID");
	
	ArrayList<aca.alumno.AlumPersonal> alumnos  			= AlumnoLista.getListAll(conElias,escuelaId,"ORDER BY NOMBRE");
	
	int  totGrado=0, totNivel=0, totAlumnos;
	int grupoA=0, grupoB=0, grupoC=0, grupoD=0, grupoE=0, grupoF=0, grupoG=0, grupoU=0, grupoX=0;
	int totA= 0, totB=0, totC=0, totD=0, totE=0, totF=0, totG=0, totU=0;
	int nivel1=0, nivel2=0, nivel3=0, nivel4=0, nivel0=0;
	
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY F_INICIAL");
%>

<div id="content">
	<h2><fmt:message key="alumnos.DistribuciondeAlumnos"/></h2>
	
	<form name="forma" action="grupo.jsp" method="post">
		<div class="well">		
   			<select id="ciclo" name="ciclo" onchange="document.forma.submit();" style="width:310px;">	
			<%for(aca.ciclo.Ciclo c : lisCiclo){%>
				<option value="<%=c.getCicloId() %>"<%=c.getCicloId().equals(cicloId)?" Selected":"" %>><%=c.getCicloNombre() %></option>
			<%}%>
  			</select>
		</div>  
	</form>
	<%	
		totAlumnos= 0;
		for (aca.catalogo.CatNivelEscuela nivel : lisNivel){ 

			totNivel=0; totA=0; totB=0; totC=0; totD=0; totU=0;
	%>
			<table class="table table-bordered">
  				<tr>
  					<td colspan="10" class="alert alert-info">
  						<strong><%=nivel.getNivelNombre()%></strong>
  					</td>
  				</tr>
  				<tr>
    				<th><fmt:message key="aca.Grado"/></th>
   	 				<th class="text-center" style="width:10%;">A</th>
		   			<th class="text-center" style="width:10%;">B</th>
		    		<th class="text-center" style="width:10%;">C</th>
		    		<th class="text-center" style="width:10%;">D</th>
		    		<th class="text-center" style="width:10%;">E</th>
		    		<th class="text-center" style="width:10%;">F</th>
		    		<th class="text-center" style="width:10%;">G</th>
		    		<th class="text-center" style="width:10%;"><fmt:message key="aca.Total"/></th>
		  		</tr>
	<%
				int sinGrupo =0;
				for (int j=Integer.parseInt(nivel.getGradoIni());j<=Integer.parseInt(nivel.getGradoFin());j++){
					totGrado=0;
			
					grupoA = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, "A");
					grupoB = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, "B");
					grupoC = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, "C");
					grupoD = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, "D");
					grupoE = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, "E");
					grupoF = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, "F");
					grupoG = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, "G");					
					grupoX = aca.alumno.AlumPersonal.getCantidad(conElias,cicloId, Integer.parseInt(nivel.getNivelId()), j, " ");
				
					totGrado = grupoA+grupoB+grupoC+grupoD+grupoE+grupoF+grupoG;
					totA += grupoA;
					totB += grupoB;
					totC += grupoC;
					totD += grupoD;
					totE += grupoE;
					totF += grupoF;
					totG += grupoG;
					totNivel+= totGrado;
	%>		
					<tr>
						<td><%=aca.catalogo.CatNivel.getGradoNombre(j)%></td>
						<td class="text-center">
							<a href="listaAlumnos.jsp?nivel_id=<%=nivel.getNivelId()%>&grado=<%=j%>&grupo=A&Cantidad=<%=grupoA%>&ciclo=<%=cicloId %>"><%=grupoA%></a>
						</td>	
						<td class="text-center">
							<a href="listaAlumnos.jsp?nivel_id=<%=nivel.getNivelId()%>&grado=<%=j%>&grupo=B&Cantidad=<%=grupoB%>&ciclo=<%=cicloId %>"><%=grupoB%></a>
						</td>	
						<td class="text-center">
							<a href="listaAlumnos.jsp?nivel_id=<%=nivel.getNivelId()%>&grado=<%=j%>&grupo=C&Cantidad=<%=grupoC%>&ciclo=<%=cicloId %>"><%=grupoC%></a>
						</td>	
						<td class="text-center">
							<a href="listaAlumnos.jsp?nivel_id=<%=nivel.getNivelId()%>&grado=<%=j%>&grupo=D&Cantidad=<%=grupoD%>&ciclo=<%=cicloId %>"><%=grupoD%></a>
						</td>
						<td class="text-center">
							<a href="listaAlumnos.jsp?nivel_id=<%=nivel.getNivelId()%>&grado=<%=j%>&grupo=D&Cantidad=<%=grupoE%>&ciclo=<%=cicloId %>"><%=grupoE%></a>
						</td>
						<td class="text-center">
							<a href="listaAlumnos.jsp?nivel_id=<%=nivel.getNivelId()%>&grado=<%=j%>&grupo=D&Cantidad=<%=grupoF%>&ciclo=<%=cicloId %>"><%=grupoF%></a>
						</td>
						<td class="text-center">
							<a href="listaAlumnos.jsp?nivel_id=<%=nivel.getNivelId()%>&grado=<%=j%>&grupo=D&Cantidad=<%=grupoG%>&ciclo=<%=cicloId %>"><%=grupoG%></a>
						</td>
						<td class="text-center">
							<%=totGrado%>
						</td>
					</tr>
	<%		
				} 
	%>
				<tr>
				    <td><strong><fmt:message key="aca.Totales"/> <%=nivel.getNivelNombre()%></strong></td>
				    <td class="text-center"><strong><%=totA%></strong></td>
				    <td class="text-center"><strong><%=totB%></strong></td>
				    <td class="text-center"><strong><%=totC%></strong></td>
				    <td class="text-center"><strong><%=totD%></strong></td>
				    <td class="text-center"><strong><%=totE%></strong></td>
				    <td class="text-center"><strong><%=totF%></strong></td>
				    <td class="text-center"><strong><%=totG%></strong></td>
				    <td class="text-center"><strong><%=totNivel%></strong></td>
				</tr>
			</table>
	<%
			if (nivel.getNivelId().equals("0")) nivel0 = totNivel;
			if (nivel.getNivelId().equals("1")) nivel1 = totNivel; 
			if (nivel.getNivelId().equals("2")) nivel2 = totNivel;
			if (nivel.getNivelId().equals("3")) nivel3 = totNivel;
			if (nivel.getNivelId().equals("4")) nivel4 = totNivel;		
			totAlumnos+= totNivel;
		}
	%> 
	
	<hr />

	<table class="table table-bordered">
  		<tr>
    		<td colspan="3">
				<strong><fmt:message key="aca.Porcentaje"/></strong>
			</td>
  		</tr>
  		<tr>
    		<th><fmt:message key="maestros.NivelEscolar"/></th>
    		<th class="text-right"><fmt:message key="aca.NoAlumnos"/></th>
    		<th class="text-right">%</th>
  		</tr>
		<%	
			double por = 0;
			for (int i=0;i<lisNivel.size();i++){
				aca.catalogo.CatNivelEscuela nivel = (aca.catalogo.CatNivelEscuela) lisNivel.get(i);
				switch (Integer.parseInt(nivel.getNivelId())){
					case 0:{ totNivel= nivel0; por = (double)nivel0*100/totAlumnos; break; }
					case 1:{ totNivel= nivel1; por = (double)nivel1*100/totAlumnos; break; }
					case 2:{ totNivel= nivel2; por = (double)nivel2*100/totAlumnos; break; }
					case 3:{ totNivel= nivel3; por = (double)nivel3*100/totAlumnos; break; }
					case 4:{ totNivel= nivel4; por = (double)nivel4*100/totAlumnos; break; }			
				}
		%>
				<tr>
					<td><%=nivel.getNivelNombre()%></td>
					<td class="text-right"><%=totNivel%></td>
					<td class="text-right"><%=getformato.format(por)%></td>
  				</tr>
		<%	
			}
		%>
		<tr>
			<td><strong><fmt:message key="aca.Totales"/></strong></td>
			<td class="text-right"><strong><%=totAlumnos%></strong></td>
			<td class="text-right"><strong>100%</strong></td>  
		</tr> 
	</table>  
	
</div>

<%@ include file= "../../cierra_elias.jsp" %>