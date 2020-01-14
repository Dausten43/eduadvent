<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.alumno.AlumPersonal"%>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="NivelLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="catNivel" scope="page" class="aca.catalogo.CatNivel"/>

<%	//Declaracion de Variables
	java.text.DecimalFormat getformato= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId	= (String) session.getAttribute("escuela");
	
	String nivelId		= request.getParameter("nivelId");
	String cicloId		= request.getParameter("ciclo")==null?Ciclo.getCargaActual(conElias, escuelaId):request.getParameter("ciclo");
	String Insc			= request.getParameter("ins")==null?"Inscritos":request.getParameter("ins");	
	
	int totGrado=0, totNivel=0, totAlumnos;
	int grupoA=0, grupoB=0, grupoC=0, grupoD=0, grupoU=0;
	int totA= 0, totB=0, totC=0, totD=0, totU=0;
	int totHombres=0, totMujeres=0, totASD=0 , totNASD=0, totMNivel=0, totHNivel=0, totASDnivel=0, totNASDnivel=0; ; 
	int nivel1=0, nivel2=0, nivel3=0, nivel4=0;
	
	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel	= NivelLista.getListEscuela(conElias, escuelaId,"ORDER BY NIVEL_ID");
	ArrayList<aca.ciclo.Ciclo> lisCiclo	= cicloLista.getListActivos(conElias, escuelaId, "ORDER BY 1");
%>
<body>
<style>
	body{
		background: white;
	}	
</style>

<div id="content">
  <h2><%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%> <small>( <fmt:message key="reportes.DistribucionAlumnos" /> )</small></h2>
  <form id="forma" name="forma" action="estadistica.jsp" method="post">    
  <div class="well">	
	<select id="ciclo" name="ciclo" onchange="document.forma.submit();" style="width:310px;">
<%	
	for(int i = 0; i < lisCiclo.size(); i++){
		ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
			<option value="<%=ciclo.getCicloId() %>"<%=ciclo.getCicloId().equals(cicloId)?" Selected":"" %>><%=ciclo.getCicloNombre() %></option>
<%	}%>
  		</select>
  		&nbsp;
  		<select id="ins" name="ins" onchange="document.forma.submit();">
			<option value="Inscritos" <%=Insc.equals("Inscitos")?" Selected":"" %>><fmt:message key="reportes.SoloInscritos" /></option>
			<option value="Todos" <%=Insc.equals("Todos")?" Selected":"" %>><fmt:message key="reportes.Todos" /></option>
	</select> 		
  </div>
  </form>
      
<%	totAlumnos= 0;

	for (aca.catalogo.CatNivelEscuela nivel : lisNivel){

		totNivel=0; totA=0; totB=0; totC=0; totD=0; totU=0;
		totHombres=0; totMujeres=0; totASD=0; totNASD=0;
		totMNivel=0; totHNivel=0; totASDnivel=0; totNASDnivel=0;
%>
	<div class="alert alert-info"><h4><%=nivel.getNivelNombre()%></h4></div> 
	
	<div style="margin-left:20px;">
	<table width="75%" class="table table-fullcondensed">  	
  	<tr valign="top">
    	<th align="center"><fmt:message key="aca.Grado" /></th>
    	<th align="center">A</th>
    	<th align="center">B</th>
    	<th align="center">C</th>
    	<th align="center">D</th>
    	<th align="center">U</th>
    	<th align="center"><fmt:message key="aca.Total" /></th>
    	<th align="center"># M</th>
    	<th align="center"># H</th>
    	<th align="center">% M</th>
    	<th align="center">% H</th>
    	<th align="center"># ASD</th>
    	<th align="center"># NOASD</th>
  	</tr>
<%
		
		int iniciaGrado = Integer.parseInt(nivel.getGradoIni());
	
		for (int j=iniciaGrado;j<=Integer.parseInt(nivel.getGradoFin());j++){
			totGrado=0;
						
			if(Insc.equals("Inscritos")){
				grupoA = aca.alumno.AlumPersonal.getCantidad(conElias, cicloId, Integer.parseInt(nivel.getNivelId()), j, "A");
				grupoB = aca.alumno.AlumPersonal.getCantidad(conElias, cicloId, Integer.parseInt(nivel.getNivelId()), j, "B");
				grupoC = aca.alumno.AlumPersonal.getCantidad(conElias, cicloId, Integer.parseInt(nivel.getNivelId()), j, "C");
				grupoD = aca.alumno.AlumPersonal.getCantidad(conElias, cicloId, Integer.parseInt(nivel.getNivelId()), j, "D");
				grupoU = aca.alumno.AlumPersonal.getCantidad(conElias, cicloId, Integer.parseInt(nivel.getNivelId()), j, "U");
				totHombres = AlumPersonal.getNumHombres(conElias,nivel.getNivelId(),String.valueOf(j),cicloId);
				totMujeres = AlumPersonal.getNumMujeres(conElias,nivel.getNivelId(),String.valueOf(j),cicloId);
				totASD = AlumPersonal.getNumAcfe(conElias,nivel.getNivelId(),String.valueOf(j),cicloId);
				totNASD = AlumPersonal.getNumNAcfe(conElias,nivel.getNivelId(),String.valueOf(j),cicloId);	    
			}else{
				grupoA = aca.alumno.AlumPersonal.getCantidadTodos(conElias, escuelaId, Integer.parseInt(nivel.getNivelId()), j,"A");
				grupoB = aca.alumno.AlumPersonal.getCantidadTodos(conElias, escuelaId, Integer.parseInt(nivel.getNivelId()), j,"B");
				grupoC = aca.alumno.AlumPersonal.getCantidadTodos(conElias, escuelaId, Integer.parseInt(nivel.getNivelId()), j,"C");
				grupoD = aca.alumno.AlumPersonal.getCantidadTodos(conElias, escuelaId, Integer.parseInt(nivel.getNivelId()), j,"D");
				grupoU = aca.alumno.AlumPersonal.getCantidadTodos(conElias, escuelaId, Integer.parseInt(nivel.getNivelId()), j,"U");
				totHombres = AlumPersonal.getNumHombresTodos(conElias,nivel.getNivelId(),String.valueOf(j));
				totMujeres = AlumPersonal.getNumMujeresTodos(conElias,nivel.getNivelId(),String.valueOf(j));
				totASD = AlumPersonal.getNumAcfeTodos(conElias,nivel.getNivelId(),String.valueOf(j));
				totNASD = AlumPersonal.getNumNAcfeTodos(conElias,nivel.getNivelId(),String.valueOf(j));
				
			}
			
			totGrado = grupoA+grupoB+grupoC+grupoD+grupoU; 
			totA += grupoA;
			totB += grupoB;
			totC += grupoC;
			totD += grupoD;
			totU += grupoU;
			totNivel+= totGrado;
			totMNivel += totMujeres;
			totHNivel += totHombres;
			totASDnivel += totASD;
			totNASDnivel += totNASD;
			
%>		
  	<tr valign="top">
		<td><%=aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, nivel.getNivelId(), j+"") %></td>
		<td><%=grupoA%></td>	
		<td><%=grupoB%></td>	
		<td><%=grupoC%></td>	
		<td><%=grupoD%></td>
		<td><%=grupoU%></td>
		<td><%=totGrado%></td>
		<td><%=totMujeres %></td>
		<td><%=totHombres%></td>
<%
			if(totMujeres == 0){
%>
		<td align="center">0%</td>
<%
			}else if(totGrado==0){
%>
		<td align="center">0%</td>
<%
			}else{
%>
		<td align="center"><%=(totMujeres*100/totGrado) %>%</td>
<%
			}

			if(totHombres == 0){
%>
		<td align="center">0%</td>
<%
			}else{
				int total = 0;
				if (totGrado!=0) total = totHombres*100/totGrado;  
%>
		<td align="center"><%=total%>%</td>
<%
			}
%>	
		<td align=center><%=totASD%></td>
		<td align=center><%=totNASD%></td>	
	</tr>
<%		} %>
	<tr valign="top">
    	<td align="center"><strong><fmt:message key="aca.Total" /> <%=nivel.getNivelNombre()%></strong></td>
    	<td align="center"><strong><%=totA%></strong></td>
    	<td align="center"><strong><%=totB%></strong></td>
    	<td align="center"><strong><%=totC%></strong></td>
    	<td align="center"><strong><%=totD%></strong></td>
    	<td align="center"><strong><%=totU%></strong></td>
    	<td align="center"><strong><%=totNivel%></td>
    	<td align="center"><strong><%=totMNivel%></td>
    	<td align="center"><strong><%=totHNivel%></td>
		<td align="center"><strong>&nbsp;</td>
    	<td align="center"><strong>&nbsp;</td>
    	<td align="center"><strong><%=totASDnivel%></td>
    	<td align="center"><strong><%=totNASDnivel%></td>
    </tr>   
<%
		if (nivel.getNivelId().equals("1")) nivel1 = totNivel;
		if (nivel.getNivelId().equals("2")) nivel2 = totNivel;
		if (nivel.getNivelId().equals("3")) nivel3 = totNivel;
		if (nivel.getNivelId().equals("4")) nivel4 = totNivel;	
		totAlumnos+= totNivel;
%>
	</table>
	</div>
<%		
	} 
%> 
	
</div>	
</body>
<%@ include file= "../../cierra_elias.jsp" %>