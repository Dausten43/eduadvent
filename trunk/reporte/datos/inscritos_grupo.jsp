<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.alumno.AlumCicloLista"/>\

<%@page import="java.util.HashMap"%>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String ciclo			= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");
	
	String strBgcolor		= "";
	String nivelTemp        = "0";
	String grado = "", grupo = "";
	int cont				= 1;
	int hombres				= 0;
	int mujeres				= 0;
	int relAdv				= 0;
	int relDif				= 0;
	int totMujeres			= 0; 
	int totHombres			= 0;
	int totACFE 			= 0;
	int totNACFE 			= 0;
	int totalInscritos 		= 0;
	
	// Lista de ciclos activos en la escuela
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY 1");
	
	// Lista de Alumnos Inscritos en un ciclo escolar
	ArrayList lisInscritos = AlumnoL.getListAlumnosInscritos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID,GRADO,GRUPO,APATERNO,AMATERNO,NOMBRE");	
	
	HashMap<String, aca.alumno.AlumCiclo > mapaGradoGrupo =   aca.alumno.AlumCicloLista.getMapHistoria(conElias, "");
%>
<style>
	body{
		background: white;
	}
</style>
<body>
<div id="content">	
  <h2>Reporte de Alumnos Inscritos</h2>
  <form name="forma" action="inscritos_grupo.jsp" method='post'>
  <div class="well">
  	<select id="ciclo" name="ciclo" onchange="document.forma.submit();">
<%
	for(int i = 0; i < lisCiclo.size(); i++){
		Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
		<option value="<%=Ciclo.getCicloId() %>"<%=Ciclo.getCicloId().equals(ciclo)?" Selected":"" %>><%=Ciclo.getCicloNombre() %></option>
<%	}%>
	</select>
	&nbsp;
	<a onclick="location='inscritos.jsp'" class="btn btn-primary" ><i class="icon-th-list icon-white"></i> <fmt:message key="catalogo.ListaInscritos" /></a>
  </div>
  </form>
<table class="table table-fullcondensed" width="80%">
<%	 	
		String gradoAndGrupo = "0";
		for(int i=0; i<lisInscritos.size();i++){
			cont++;			
			aca.alumno.AlumPersonal inscrito = (aca.alumno.AlumPersonal) lisInscritos.get(i);
			if (mapaGradoGrupo.containsKey(inscrito.getCodigoId()+ciclo+"1")){
				aca.alumno.AlumCiclo historia = (aca.alumno.AlumCiclo) mapaGradoGrupo.get(inscrito.getCodigoId()+ciclo+"1");
				grado 		= historia.getGrado();			
				grupo 		= historia.getGrupo();			 
								
			}else{
				grado = "-"; grupo = "-";
			}

			if(!gradoAndGrupo.equals(grado+grupo)){
			    cont=1;
			    gradoAndGrupo = grado+grupo;
				if(i!=0){%>
					<table class="table table-fullcondensed" width="100%">
					<tr>
						<td class="th3" colspan="3" align="left"><b>TOTALES</b></td>
						<td class="th3" align="left" colspan="14">
							<b>Hombres: </b><%=hombres%>&nbsp;&nbsp;
							<b>Mujeres: </b><%=mujeres%>&nbsp;&nbsp;
							<b>Adventistas: </b><%=relAdv%>&nbsp;&nbsp;
							<b>No Adventistas: </b><%=relDif%>
						</td>
					</tr>
					</table>
				<%	hombres = 0;
					mujeres = 0;
					relAdv	= 0;
					relDif	= 0;
				}
				
				if(!nivelTemp.equals(inscrito.getNivelId())){
					nivelTemp = inscrito.getNivelId();
					
				%>
				<div class="alert alert-info">
  				<h4><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivelId())%></h4>
  				</div>
<%  			} %>				
				<table class="table table-fullcondensed" width="100%">
				  	<tr><td style="font-size:11pt; "><b>Grado y Grupo: <%=grado%>° "<%= grupo%>"</b></td></tr>
			  	</table>
				<table width="100%" class="table table-fullcondensed table-fontsmall table-striped">
					<tr>
					    <th>#</th>
					    <th>Matr&iacute;cula</th>
					    <th>Nombre</th>
					    <th>Grado</th>
					    <th>Grupo</th>
					    <th>F. Nac.</th>
					    <th>Género</th>
					    <th>Curp</th>
					    <th>País</th>
					    <th>Estado</th>
					    <th>Ciudad</th>
					    <th>Colonia</th>
					    <th>Dirección</th>
					    <th>Teléfono</th>
					    <th>Clas. Fin</th>
					    <th>Religi&oacute;n</th>
					    <th>Tutor</th>    
					  </tr>
		<%	} %>
			<tr >
			  <td align="center"><%= cont %></td>
			  <td align="center"><%= inscrito.getCodigoId() %></td>
			  <td align="left"><%= inscrito.getApaterno()+" "+inscrito.getAmaterno()+", "+inscrito.getNombre()%></td>
			  <td align="center"><%= grado%></td>
			  <td align="center"><%= grupo%></td>
			  <td align="left"><%= inscrito.getFNacimiento()%></td>
			  <td align="center"><%= inscrito.getGenero().equals("M")?"H":"M" %></td>
			  <td align="left"><%= inscrito.getCurp()%></td>
			  <td align="left"><%= aca.catalogo.CatPais.getPais(conElias,inscrito.getPaisId())%></td>
			  <td align="left"><%= aca.catalogo.CatEstado.getEstado(conElias,inscrito.getPaisId(),inscrito.getEstadoId())%></td>
			  <td align="left"><%= aca.catalogo.CatCiudad.getCiudad(conElias,inscrito.getPaisId(),inscrito.getEstadoId(),inscrito.getCiudadId())%></td>
			  <td align="left"><%= inscrito.getColonia()%></td>
			  <td align="left"><%= inscrito.getDireccion()%></td>
			  <td align="left"><%= inscrito.getTelefono()%></td>
			  <td align="left"><%= aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, inscrito.getClasfinId())%></td>
			  <td align="left"><%= aca.catalogo.CatReligion.getReligionNombre(conElias,inscrito.getReligion())%></td>
			  <td align="left"><%= inscrito.getTutor()%></td>  
			  
			  <%String gen 		= inscrito.getGenero();
			  	String relig 	= inscrito.getReligion();
			  	if(relig.equals("1")){
			  		relAdv++;
			  		totACFE++;
			  	}else{
			  		relDif++;
			  		totNACFE++;
			  	}
			  	
			  	if(gen.equals("M")){
			  		hombres++;
			  		totHombres ++;
			  	}else{
			  		mujeres++;
			  		totMujeres++;
			  	}%> 
			</tr>
<% 	} %>
	<tr>
		<td class="th3" colspan="3" align="left"><b>TOTALES</b></td>
		<td class="th3" align="left" colspan="14" align="right">
			<b>Hombres: </b><%=hombres%>&nbsp;&nbsp;
			<b>Mujeres: </b><%=mujeres%>&nbsp;&nbsp;
			<b>Adventistas: </b><%=relAdv%>&nbsp;&nbsp;
			<b>No Adventistas: </b><%=relDif%>
		</td>
	</tr>
</table>
<br>
<table align="center" class="table table-fullcondensed" width="30%">
  <tr><th colspan="2">Total General</th></tr>
  <tr>
    <td><b>Hombres:</b></td>
    <td><%= totHombres %></td>
  </tr>
    <tr>
    <td><b>Mujeres:</b></td>
    <td><%=totMujeres %></td>
  </tr>
    <tr>
    <td><b>ACFE:</b></td>
    <td><%= totACFE %></td>
  </tr>
  <tr>
    <td><b>NO ACFE:</b></td>
    <td><%= totNACFE %></td>
  </tr>
  <tr>
    <td><b>TOT INSC:</b></td>
    <td><%= lisInscritos.size() %></td>
  </tr>
</table>
</body>
<%@ include file="../../cierra_elias.jsp" %>