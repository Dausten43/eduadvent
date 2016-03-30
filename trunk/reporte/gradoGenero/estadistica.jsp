<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>



<jsp:useBean id="personalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>

<head>
<%
	String escuela 		= (String)session.getAttribute("escuela");
	String ciclo		= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuela):request.getParameter("ciclo");
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuela, "ORDER BY 1");
	ArrayList<aca.alumno.AlumPersonal> Inscritos = personalLista.getListAlumnosInscritos(conElias, escuela, ciclo, "ORDER BY NIVEL_ID, GRADO, GENERO");
%>
<style>
	.tabla td{
		border:1px solid gray;
		padding:6px;
		text-align:center;
		width:40px;
		background:#E6E6E6;
		font-size:13px;
	}
	.liga{
		cursor:pointer;
		cursor:hand;
	}
	body{
		background: white;
	}
</style>
</head>
<body>
<div id="content">
  
  <form name="forma" action="estadistica.jsp" method='post'>  
    <h2><fmt:message key="reportes.EstaGradoGeneroEdad" /> <small>( <%= aca.catalogo.CatEscuela.getNombreCorto(conElias, escuela)%> )</small></h2>
    <div class="well">
	<select id="ciclo" name="ciclo" onchange="document.forma.submit();" style="width:310px;">
<%
		for(int i = 0; i < lisCiclo.size(); i++){
			Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
			<option value="<%=Ciclo.getCicloId() %>"<%=Ciclo.getCicloId().equals(ciclo)?" Selected":"" %>><%=Ciclo.getCicloNombre() %></option>
<%		}	%>
	</select>
  </div>
  </form>
  <table width="90%" align="center" class="tabla">
	<tr>
		<td></td>
		<td style="width:2px;"></td>
		<td>3 <fmt:message key="aca.Anos" /></td>
		<td>4 <fmt:message key="aca.Anos" /></td>
		<td>5 <fmt:message key="aca.Anos" /></td>
		<td>6 <fmt:message key="aca.Anos" /></td>
		<td>7 <fmt:message key="aca.Anos" /></td>
		<td>8 <fmt:message key="aca.Anos" /></td>
		<td>9 <fmt:message key="aca.Anos" /></td>
		<td>10 <fmt:message key="aca.Anos" /></td>
		<td>11 <fmt:message key="aca.Anos" /></td>
		<td>12 <fmt:message key="aca.Anos" /></td>
		<td>13 <fmt:message key="aca.Anos" /></td>
		<td>14 <fmt:message key="aca.Anos" /></td>
		<td>15 <fmt:message key="aca.Anos" /></td>
		<td>16 <fmt:message key="aca.Anos" /></td>
		<td>17 <fmt:message key="aca.Anos" /></td>
		<td>18 <fmt:message key="aca.Anos" /></td>
		<td>19 <fmt:message key="aca.Anos" /></td>
		<td>20 <fmt:message key="aca.AnosyMas" /></td>
	</tr>
<%
String nivel = "";
String grado = "";
for(aca.alumno.AlumPersonal alumno: Inscritos){ 
	if(!nivel.equals(alumno.getNivelId())){
		nivel= alumno.getNivelId();
%>
	<tr><td colspan="20" style="background:#D8D8D8;border:1px solid black;"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), alumno.getNivelId()) %></td></tr>
<%
	}
	
	if(!grado.equals(alumno.getGrado())){
%>
	<tr>
		<td  style="cursor:pointer;cursor:hand;" rowspan="2" onclick="location.href='porGrado.jsp?ciclo=<%=ciclo%>&nivel=<%=nivel%>&grado=<%=alumno.getGrado()%>'"><%=alumno.getGrado()%></td>
		<td style="text-align:left;"><a href="porGrado.jsp?ciclo=<%=ciclo%>&nivel=<%=nivel%>&grado=<%=alumno.getGrado()%>&genero=M"><fmt:message key="aca.Hombres" /></a></td>
		<%
		ArrayList<Integer> edadMujeres = new ArrayList<Integer>();	
		for(int i=3; i<=20; i++){ 
			int contHombres = 0;
			int contMujeres = 0;
			for(aca.alumno.AlumPersonal alum: Inscritos){
				
				boolean edad = false;
				if(alum.getCodigoId().equals("0110787"))System.out.println(alum.getFNacimiento());
				
				if(i==3){
					if(aca.util.Edad.getEdad(alum.getFNacimiento())<=3)edad=true;
				}else if(i==20){
					if(aca.util.Edad.getEdad(alum.getFNacimiento())>=20)edad=true;
				}else{
					if(aca.util.Edad.getEdad(alum.getFNacimiento())==i)edad=true;
				}
				
				if(alum.getNivelId().equals(nivel) && alum.getGrado().equals(alumno.getGrado()) && edad){
					if(alum.getGenero().equals("M")){
						contHombres++;
					}else if(alum.getGenero().equals("F")){
						contMujeres++;
					}
				}
			}
			edadMujeres.add(contMujeres);
		%>
			<td style="background:white;cursor:pointer;cursor:hand;" onclick="document.location='porGrado.jsp?ciclo=<%=ciclo%>&nivel=<%=nivel%>&grado=<%=alumno.getGrado()%>&genero=M&edad=<%=i%>'"><%=contHombres==0?"":contHombres%></td>
		<%}%>
	</tr>
	<tr>
		<td style="text-align:left;"><a href="porGrado.jsp?ciclo=<%=ciclo%>&nivel=<%=nivel%>&grado=<%=alumno.getGrado()%>&genero=F"><fmt:message key="aca.Mujeres" /></a></td>
		<%
		int cont=3;
		for(Integer edad: edadMujeres){
		%>
			<td style="background:white;cursor:pointer;cursor:hand;" onclick="document.location='porGrado.jsp?ciclo=<%=ciclo%>&nivel=<%=nivel%>&grado=<%=alumno.getGrado()%>&genero=F&edad=<%=cont%>'"><%=edad==0?"":edad%></td>
		<%
		cont++;
		}
		
		%>
	</tr>
<%	
			grado = alumno.getGrado();
	}
} 
%>
  </table>
</div>  
</body>
<%@ include file="../../cierra_elias.jsp" %>