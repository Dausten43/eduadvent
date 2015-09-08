<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.alumno.AlumCicloLista"/>
<jsp:useBean id="CatNivelEscuela" scope="page" class="aca.catalogo.CatNivelEscuela"/>

<%@page import="java.util.HashMap"%>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String ciclo			= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");
	
	// Lista de ciclos activos en la escuela
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY 1");
	
	// Busca el ciclo en la lista de ciclos
	boolean ok = false;
	for (aca.ciclo.Ciclo lista: lisCiclo ){
		if (lista.getCicloId().equals(ciclo)) ok = true;
	}
	
	// Si no esta el ciclo en la lista asigna el primer elemento de la lista como el ciclo actual
	if (!ok && lisCiclo.size() > 0){
		ciclo = lisCiclo.get(0).getCicloId();
	}
	
	String strBgcolor		= "";
	String nivelTemp        = "-1";
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
	int numero				= 0;
	
	
	// Lista de Alumnos Inscritos en un ciclo escolar
	ArrayList<aca.alumno.AlumPersonal> lisInscritos = AlumnoL.getListAlumnosInscritos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID,GRADO,GRUPO,APATERNO,AMATERNO,NOMBRE");
	
	// Map de historico del alumno
	HashMap<String, aca.alumno.AlumCiclo > mapaGradoGrupo =   aca.alumno.AlumCicloLista.getMapHistoria(conElias, "");
%>
<style>
	body{
		background: white;
	}
	td{
		font-size:10px;
	}
</style>

<div id="content">
  <h2><fmt:message key="reportes.AlumnosInscritos" /></h2>
  <form name="forma" action="inscritos.jsp" method='post'>
	<div class="well">
		<select id="ciclo" name="ciclo" onchange="document.forma.submit();" style="width:310px;">
<%
			
			for(int i = 0; i < lisCiclo.size(); i++){
				Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
				<option value="<%=Ciclo.getCicloId() %>"<%=Ciclo.getCicloId().equals(ciclo)?" Selected":"" %>><%=Ciclo.getCicloNombre() %></option>
<%
			}
%>
			</select>
			&nbsp; &nbsp; 			
			<a onclick="location='inscritos_grupo.jsp'" class="btn btn-primary"><i class="icon-th-list icon-white"></i> <fmt:message key="boton.ListaGrado" /></a>
	</div>
  </form>			
<%	 	
	for(int i=0; i<lisInscritos.size();i++){ cont++;
		aca.alumno.AlumPersonal inscrito = (aca.alumno.AlumPersonal) lisInscritos.get(i);
		
		  if(!nivelTemp.equals(inscrito.getNivelId())){
			  if(!nivelTemp.equals("-1")){%>
				
				</div>
				<div class="alert" style="margin-left:20px;">
				<h5><fmt:message key="aca.Totales" /></h5>
					<b><fmt:message key="aca.Hombres" />: </b><%=hombres%>&nbsp;&nbsp;
					<b><fmt:message key="aca.Mujeres" />: </b><%=mujeres%>&nbsp;&nbsp;
					<b><fmt:message key="aca.Adventistas" />: </b><%=relAdv%>&nbsp;&nbsp;
					<b><fmt:message key="aca.NoAdventistas" />: </b><%=relDif%>
				</div>					
			<%
				hombres = 0;
				mujeres = 0;
				relAdv	= 0;
				relDif	= 0;
				
			  }
		    cont=1;
			nivelTemp = inscrito.getNivelId();		
						
			%>
			  
</table> </div>
			
  <div class="alert alert-info">
  	<h4><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivelId())%></h4>
  </div>  
  
  <div style="margin-left:20px;">
	  <table width="100%" class="table table-fullcondensed table-fontsmall table-bordered table-striped" align="center">
		  <tr>
		    <th>#</th>
		    <th><fmt:message key="aca.Matricula" /></th>
		    <th><fmt:message key="aca.Nombre" /></th>
		    <th><fmt:message key="aca.Grado" /></th>
		    <th><fmt:message key="aca.Grupo" /></th>
		    <th><fmt:message key="aca.FNac" /></th>
		    <th><fmt:message key="aca.Genero" /></th>
		    <th><fmt:message key="aca.CURP" /></th>
		    <th><fmt:message key="aca.Pais" /></th>
		    <th><fmt:message key="aca.Estado" /></th>
		    <th><fmt:message key="aca.Ciudad" /></th>
		    <th><fmt:message key="aca.Colonia" /></th>
		    <th><fmt:message key="aca.Direccion" /></th>
		    <th><fmt:message key="aca.Telefono" /></th>
		    <th><fmt:message key="aca.ClassFin" /></th>
		    <th><fmt:message key="aca.Religion" /></th>
		    <th><fmt:message key="aca.Tutor" /></th>    
	     	<th><fmt:message key="aca.Celular" /></th> 
	     	<th><fmt:message key="aca.Correo" /></th>    
		  </tr>
<%  		}
			if (mapaGradoGrupo.containsKey(inscrito.getCodigoId()+ciclo+"1")){
				aca.alumno.AlumCiclo historia = (aca.alumno.AlumCiclo) mapaGradoGrupo.get(inscrito.getCodigoId()+ciclo+"1");
				grado 		= aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, historia.getNivel(), historia.getGrado());
				grupo 		= historia.getGrupo();			 
								
			}else{
				grado = "-"; grupo = "-";
			}
			//System.out.println("Alumno:"+inscrito.getCodigoId()+" Religion:"+inscrito.getReligion());
%>
		<tr >
		  <td align="center"><%= cont %></td>
		  <td align="center"><%= inscrito.getCodigoId() %></td>
		  <td align="left"><%= inscrito.getApaterno()+" "+inscrito.getAmaterno()+", "+inscrito.getNombre()%></td>
		  <td align="center"><%= grado %></td>
		  <td align="center"><%= grupo %></td>
		  <td align="left"><%= inscrito.getFNacimiento()%></td>
		  <td align="center"><%= inscrito.getGenero().equals("M")?"H":"M" %></td>
		  <td align="left"><%= inscrito.getCurp()%></td>
		  <td align="left"><%= aca.catalogo.CatPais.getPais(conElias,inscrito.getPaisId())%></td>
		  <td align="left"><%= aca.catalogo.CatEstado.getEstado(conElias,inscrito.getPaisId(),inscrito.getEstadoId())%></td>
		  <td align="left"><%= aca.catalogo.CatCiudad.getCiudad(conElias,inscrito.getPaisId(),inscrito.getEstadoId(),inscrito.getCiudadId())%></td>
		  <td align="left"><%= inscrito.getColonia()%></td>
		  <td align="left"><%= inscrito.getDireccion()%></td>
		  <td align="left"><%= inscrito.getTelefono()%></td>
		  <td align="left"><%= aca.catalogo.CatClasFin.getClasFinNombre(conElias,escuelaId,inscrito.getClasfinId())%></td>
		  <td align="left"><%= aca.catalogo.CatReligion.getReligionNombre(conElias,inscrito.getReligion())%></td>
		  <td align="left"><%= inscrito.getTutor()%></td> 
		  <td align="left"><%= inscrito.getCelular()%></td> 
		  <td align="left"><%= inscrito.getCorreo()%></td> 
		  
	</tr> 
	  
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
	  	}
	  
	  %> 
	
<% 	
		if(i == lisInscritos.size()-1){
			out.print("</table></div>");
		}
	} 
%>
	
	
	
	<div class="alert" style="margin-left:20px;">
		<h5><fmt:message key="aca.TotalesMayus" /></h5>
		<b><fmt:message key="aca.Hombres" />: </b><%=hombres%>&nbsp;&nbsp;
		<b><fmt:message key="aca.Mujeres" />: </b><%=mujeres%>&nbsp;&nbsp;
		<b><fmt:message key="aca.Adventistas" />: </b><%=relAdv%>&nbsp;&nbsp;
		<b><fmt:message key="aca.NoAdventistas" />: </b><%=relDif%>
	</div>
	
	<br>
	
	<div class="alert alert-success" >
		<h5><fmt:message key="aca.TotalesGenerales" /></h5>
	 	<b><fmt:message key="aca.Hombres" />: </b><%=totHombres%>&nbsp;&nbsp;
		<b><fmt:message key="aca.Mujeres" />: </b><%=totMujeres%>&nbsp;&nbsp;
		<b>ACFE: </b><%=totACFE%>&nbsp;&nbsp;
		<b>No ACFE: </b><%=totNACFE%>
		<b><fmt:message key="aca.TotalInscritos" />:</b> <%= lisInscritos.size() %>
	</div>
	
	
</div>
<%@ include file="../../cierra_elias.jsp" %>