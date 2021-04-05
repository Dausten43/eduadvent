<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.alumno.AlumCicloLista"/>

<%@page import="java.util.HashMap"%>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");

	String ciclo			= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");
	
	String strBgcolor		= "";
	String nivelTemp        = "0";
	String grado = "", grupo = "", nombre = "", apaterno = "", amaterno ="", nacimiento = "", genero = "", curp="", pais = "", 
			estado = "", ciudad = "", colonia = "", direccion = "", telefono = "", clasFin = "", religion = "", iglesia = "", tutor = "";
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
	ArrayList<aca.alumno.AlumCiclo> lisInscritos = CicloLista.getArrayListInscritos(conElias, ciclo, "ORDER BY NIVEL, GRADO, GRUPO");
	
	
	HashMap<String, aca.alumno.AlumPersonal > mapaGradoGrupo =   aca.alumno.AlumPersonalLista.getMapHistoria(conElias, ciclo);
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
  	<select id="ciclo" name="ciclo" onchange="document.forma.submit();" style="width:310px;">
<%
	for(int i = 0; i < lisCiclo.size(); i++){
		Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
		<option value="<%=Ciclo.getCicloId() %>"<%=Ciclo.getCicloId().equals(ciclo)?" Selected":"" %>><%=Ciclo.getCicloNombre() %></option>
<%	}%>
	</select>
	&nbsp;
	<a onclick="location='inscritos.jsp?ciclo=<%=ciclo%>'" class="btn btn-primary" ><i class="icon-th-list icon-white"></i> <fmt:message key="catalogo.ListaInscritos" /></a>
  </div>
  </form>
<table class="table table-fullcondensed" width="80%">
<%	 	
for(int i=0; i<lisInscritos.size();i++){
	aca.alumno.AlumCiclo inscrito = null;
	inscrito = (aca.alumno.AlumCiclo) lisInscritos.get(i);
	
	//System.out.println(inscrito.getCodigoId()+" GRADO: "+aca.alumno.AlumPersonal.getGrado(conElias, inscrito.getCodigoId())+" grado list:"+ lisInscritos.get(i).getGrado() +" GRUPO: "+aca.alumno.AlumPersonal.getGrupo(conElias, inscrito.getCodigoId())+ " NIVEL: "+aca.alumno.AlumPersonal.getNivel(conElias, inscrito.getCodigoId()) );
		
}

		String gradoAndGrupo = "0";
		int count = 0;
		for(int i=0; i<lisInscritos.size();i++){
			cont++;
			
			aca.alumno.AlumCiclo inscrito = null;
			grado 		= "-";			
			grupo 		= "-";	
			nombre 		= "-";
			apaterno 	= "-";
			amaterno 	= "-";
			nacimiento 	= "-";
			genero 		= "-";
			curp		= "-";
			pais 		= "-";
			estado 		= "-";
			ciudad 		= "-";
			colonia 	= "-";
			direccion	= "-";
			telefono 	= "-";
			clasFin 	= "";
			religion 	= "-";
			iglesia 	= "-";
			tutor 		= "-";			
			
			
			//System.out.println(i);
			inscrito = (aca.alumno.AlumCiclo) lisInscritos.get(i);
			//System.out.println(inscrito.getCodigoId()+" GRADO: "+aca.alumno.AlumPersonal.getGrado(conElias, inscrito.getCodigoId()) +" GRUPO: "+aca.alumno.AlumPersonal.getGrupo(conElias, inscrito.getCodigoId())+ " NIVEL: "+aca.alumno.AlumPersonal.getNivel(conElias, inscrito.getCodigoId()) );
			if (mapaGradoGrupo.containsKey(inscrito.getCodigoId())){
				aca.alumno.AlumPersonal historia = (aca.alumno.AlumPersonal) mapaGradoGrupo.get(inscrito.getCodigoId());
				grado 		= lisInscritos.get(i).getGrado();			
				grupo 		= lisInscritos.get(i).getGrupo();	
				nombre 		= historia.getNombre();  
				apaterno 	= historia.getApaterno();  
				amaterno 	= historia.getAmaterno(); 
				nacimiento 	= historia.getFNacimiento();  
				genero 		= historia.getGenero();  
				curp		= historia.getCurp(); 
				pais 		= historia.getPaisId();  
				estado 		= historia.getEstadoId(); 
				ciudad 		= historia.getCiudadId();  
				colonia 	= historia.getColonia();  
				direccion	= historia.getDireccion();  
				telefono 	= historia.getTelefono();  
				clasFin 	= historia.getClasfinId();
				religion 	= historia.getReligion();  
				iglesia 	= historia.getIglesia();
				tutor 		= historia.getTutor(); 
								
			}else{
				grado = "-"; grupo = "-";
			}
			
				//System.out.println(++count+ " Before if: "+ gradoAndGrupo +" "+grado+grupo);
			if(!gradoAndGrupo.equals(grado+grupo)){
			    cont=1;
			    gradoAndGrupo = grado+grupo;
			    
			   // System.out.println("Afer if: "+ gradoAndGrupo +" "+grado+grupo);
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
				
				if(!nivelTemp.equals(inscrito.getNivel())){
					nivelTemp = inscrito.getNivel();
					
				%>
				<div class="alert alert-info">
  				<h4><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivel())%></h4>
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
					    <th>Iglesia</th>
					    <th>Tutor</th>    
					  </tr>
		<%	} %>
			<tr >
			  <td align="center"><%= cont %></td>
			  <td align="center"><%= inscrito.getCodigoId() %></td>
			  <td align="left"><%= apaterno+" "+amaterno+", "+nombre%></td>
			  <td align="center"><%= grado%></td>
			  <td align="center"><%= grupo%></td>
			  <td align="left"><%= nacimiento%></td>
			  <td align="center"><%= genero.equals("M")?"H":"M" %></td>
			  <td align="left"><%= curp%></td>
			  <td align="left"><%= aca.catalogo.CatPais.getPais(conElias,pais)%></td>
			  <td align="left"><%= aca.catalogo.CatEstado.getEstado(conElias, pais, estado)%></td>
			  <td align="left"><%= aca.catalogo.CatCiudad.getCiudad(conElias,pais,estado,ciudad)%></td>
			  <td align="left"><%= colonia%></td>
			  <td width="150%" align="left"><%= direccion%></td>
			  <td align="left"><%= telefono%></td>
			  <td align="left"><%= aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, clasFin)%></td>
			  <td align="left"><%= aca.catalogo.CatReligion.getReligionNombre(conElias,religion)%></td>
			  <td align="left"><%= iglesia%></td>
			  <td align="left"><%= tutor%></td>  
			  
			  <%String gen 		= genero;
			  	String relig 	= religion;
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