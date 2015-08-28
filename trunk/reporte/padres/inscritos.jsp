<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="PadresL" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="datosL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.alumno.AlumCicloLista"/>

<%@page import="java.util.HashMap"%>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String ciclo			= request.getParameter("ciclo")==null?Ciclo.getCargaActual(conElias,escuelaId):request.getParameter("ciclo");
	
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
	
	// Map de padres
	HashMap<String, aca.alumno.AlumPadres> mapPadres = PadresL.getMapEscuela(conElias, escuelaId);
	// Map de datos de padres
	HashMap<String, aca.empleado.EmpPersonal> mapPadresDatos = datosL.getMap(conElias, escuelaId);
	
	// Lista de Alumnos Inscritos en un ciclo escolar
	ArrayList lisInscritos 	= AlumnoL.getListAlumnosInscritos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID,GRADO,GRUPO,APATERNO,AMATERNO,NOMBRE");
	HashMap<String, aca.alumno.AlumCiclo > mapaGradoGrupo =   CicloLista.getMapHistoria(conElias, "");
%>
<style>
	td{
		font-size:10px;
	}
	body{
		background: white;
	}
</style>
<body>

<div id="content">

<h2><fmt:message key="reportes.PadresInscritos" /> <small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%> )</small></h2>

<form name="forma" action="inscritos.jsp" method='post'>

<div class="well">
	
	<select id="ciclo" name="ciclo" onchange="document.forma.submit();" style="width:310px;">
		<%
		ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY 1");
		for(int i = 0; i < lisCiclo.size(); i++){
			Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
		%>
		<option value="<%=Ciclo.getCicloId() %>"<%=Ciclo.getCicloId().equals(ciclo)?" Selected":"" %>><%=Ciclo.getCicloNombre() %></option>
		<%
		}
		%>
	</select>
	
</div>

<%	 	
	for(int i=0; i<lisInscritos.size();i++){ cont++;
		aca.alumno.AlumPersonal inscrito = (aca.alumno.AlumPersonal) lisInscritos.get(i);
		
		  if(!nivelTemp.equals(inscrito.getNivelId())){
			  if(!nivelTemp.equals("0")){%>
				</table>
				</div>
				<div class="alert" style="margin-left:20px;">
				<h5><fmt:message key="aca.TotalesMayus" /></h5>
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
  		  
  		  <div class="alert alert-info">
  			<h4><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivelId())%></h4>	
  		  </div>	
  		  
  		  <div style="margin-left:20px;">
		  <table class="table table-fullcondensed table-fontsmall table-striped" align="center" style="width:100%;">
		  <tr>
		    <th width="2%">#</th>
		    <th width="5%"><fmt:message key="aca.Matricula" /></th>
		    <th width="20%"><fmt:message key="aca.Nombre" /></th>
		    <th><fmt:message key="aca.Grado" /></th>
		    <th><fmt:message key="aca.Grupo" /></th>    
		    <th width="10%"><fmt:message key="aca.Padre" /></th>
		    <th width="10%"><fmt:message key="aca.Correo" /></th>
		    <th width="7%"><fmt:message key="aca.Telefono" /></th>
		    <th width="10%"><fmt:message key="aca.Madre" /></th>
		    <th width="10%"><fmt:message key="aca.Correo" /></th>  
		    <th width="7%"><fmt:message key="aca.Telefono" /></th>         
		  </tr>
<%  		}
			if (mapaGradoGrupo.containsKey(inscrito.getCodigoId()+ciclo+"1")){
				aca.alumno.AlumCiclo historia = (aca.alumno.AlumCiclo) mapaGradoGrupo.get(inscrito.getCodigoId()+ciclo+"1");
				grado 		= aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, historia.getNivel(), historia.getGrado());
				grupo 		= historia.getGrupo();
								
			}else{
				grado = "-"; grupo = "-";
			}
			
			String padre 		= "&nbsp;";
			String pcorreo 		= "&nbsp;";
			String ptelefono 	= "&nbsp;";
			String madre 		= "&nbsp;";
			String mcorreo 		= "&nbsp;";
			String mtelefono	= "&nbsp;";
			
			if(mapPadres.containsKey(inscrito.getCodigoId())){
				
				aca.alumno.AlumPadres padres = mapPadres.get(inscrito.getCodigoId());
				if(mapPadresDatos.containsKey(padres.getCodigoPadre()) && !padres.getCodigoPadre().equals("-")){
					padre = mapPadresDatos.get(padres.getCodigoPadre()).getNombre() +" "+ mapPadresDatos.get(padres.getCodigoPadre()).getApaterno() +" "+mapPadresDatos.get(padres.getCodigoPadre()).getAmaterno(); 
					pcorreo = mapPadresDatos.get(padres.getCodigoPadre()).getEmail();
					ptelefono = mapPadresDatos.get(padres.getCodigoPadre()).getTelefono();
				}
				
				if(mapPadresDatos.containsKey(padres.getCodigoMadre()) && !padres.getCodigoMadre().equals("-")){
					madre = mapPadresDatos.get(padres.getCodigoMadre()).getNombre() +" "+ mapPadresDatos.get(padres.getCodigoMadre()).getApaterno() +" "+mapPadresDatos.get(padres.getCodigoMadre()).getAmaterno(); 
					mcorreo = mapPadresDatos.get(padres.getCodigoMadre()).getEmail();
					mtelefono = mapPadresDatos.get(padres.getCodigoMadre()).getTelefono();
				}
				
			}

%>
	<tr >
	  <td align="center"><%= cont %></td>
	  <td align="center"><%= inscrito.getCodigoId() %></td>
	  <td align="left"><%= inscrito.getApaterno()+" "+inscrito.getAmaterno()+", "+inscrito.getNombre()%></td>
	  <td align="center"><%= grado %></td>
	  <td align="center"><%= grupo %></td>	  
	  <td align="left"><%=padre %></td>
	  <td align="left"><%=pcorreo %></td>
	  <td align="left"><%=ptelefono %></td>
	  <td align="left"><%=madre %></td>
	  <td align="left"><%=mcorreo %></td>  
	  <td align="left"><%=mtelefono %></td>  	  	    
	  
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
	</tr>
	
<% 
		if(i== lisInscritos.size()-1){
			out.print("</table></div>");
		}
	} %>

	
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

</form>


</div>

</body>


<%@ include file="../../cierra_elias.jsp" %>