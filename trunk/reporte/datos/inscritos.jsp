<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="Personal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.alumno.AlumCicloLista"/>
<jsp:useBean id="CatNivelEscuela" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<jsp:useBean id="CatNivelEscuelaLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

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
	
	int totMujeres			= 0; 
	int totHombres			= 0;
	int totACFE 			= 0;
	int totNACFE 			= 0;
	int numero				= 0;
	
	
	// Lista de Alumnos Inscritos en un ciclo escolar
	ArrayList<aca.alumno.AlumPersonal> lisInscritos = AlumnoL.getListAlumnosInscritos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID,GRADO,GRUPO,APATERNO,AMATERNO,NOMBRE");
	//LIsta de niveles de escuela
	ArrayList<aca.catalogo.CatNivelEscuela> lisNiveles = CatNivelEscuelaLista.getListNivelesPermitidos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID");
	
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
		<a onclick="location='inscritos_grupo.jsp?ciclo=<%=ciclo %>'" class="btn btn-primary"><i class="icon-th-list icon-white"></i> <fmt:message key="boton.ListaGrado" /></a>
	</div>
  </form>
<%  
		for(aca.catalogo.CatNivelEscuela nivel : lisNiveles){
			
%>
			 <div class="alert alert-info">
			  	<h4><%= nivel.getNivelNombre()%></h4>
			 </div>
<%
			int ho    = 0;
			int mu    = 0;
			int adv   = 0;
			int noAdv = 0;
			//Recorrido para obtener informacion
  			for(aca.alumno.AlumPersonal inscrito : lisInscritos){
  				
  				if(inscrito.getNivelId().equals(nivel.getNivelId())){
  				
	  				if(inscrito.getGenero().equals("F")){
	  					mu = mu + 1;
	  				}else{
	  					ho = ho + 1;
	  				}
	  				
	  				if(inscrito.getReligion().equals("1")){
	  					adv = adv + 1;
	  				}else{
	  					noAdv = noAdv + 1;
	  				}
  				}
  			}
  			
  			totMujeres = totMujeres + mu;
  			totHombres = totHombres + ho;
  			totACFE = totACFE + adv;
  			totNACFE = totNACFE + noAdv;
%>			 
			 
			<div class="alert"> 
			 	<b><fmt:message key="aca.Hombres" />: </b><%=ho%>&nbsp;&nbsp;
				<b><fmt:message key="aca.Mujeres" />: </b><%=mu%>&nbsp;&nbsp;
				<b><fmt:message key="aca.Adventistas" />: </b><%=adv%>&nbsp;&nbsp;
				<b><fmt:message key="aca.NoAdventistas" />: </b><%=noAdv%>
			</div>
			 
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
			     	 <th><fmt:message key="aca.TipoSangre" /></th>
			     	<th><fmt:message key="aca.CorreoAlumno" /></th>  
			     	<th><fmt:message key="aca.Iglesia" /></th>
			     	<th><fmt:message key="aca.Padre" /></th>
			     	<th><fmt:message key="aca.Ocupacion" /> <fmt:message key="aca.Padre" /></th> 
			     	<th>C&eacute;dula Padre</th> 
			     	<th><fmt:message key="aca.CRIP"/></th> 
			     	<th><fmt:message key="aca.NoActa"/></th> 
				  </tr>		  
<%
  			for(aca.alumno.AlumPersonal inscrito : lisInscritos){
  				
  				alumPadres.mapeaRegId(conElias, inscrito.getCodigoId());
  				
  				String padre     = "";
  				String ocupacion = "";
  				
  				if(!alumPadres.getCodigoPadre().equals("-")){
  					padre = alumPadres.getCodigoPadre();
  				}else{
  					padre = alumPadres.getCodigoMadre();
  				}
  				
  				Personal.mapeaRegId(conElias, padre);

  				if (mapaGradoGrupo.containsKey(inscrito.getCodigoId()+ciclo+"1")){
  					aca.alumno.AlumCiclo historia = (aca.alumno.AlumCiclo) mapaGradoGrupo.get(inscrito.getCodigoId()+ciclo+"1");
  					grado 		= aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, historia.getNivel(), historia.getGrado());
  					grupo 		= historia.getGrupo();			 
  									
  				}else{
  					grado = "-"; grupo = "-";
  				}
  				
  				if(inscrito.getNivelId().equals(nivel.getNivelId())){
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
					  <td align="left"><%= Personal.getColonia() != null ? Personal.getColonia() : inscrito.getColonia() != null ? inscrito.getColonia() : "-"%></td>
					  <td align="left"><%= Personal.getDireccion() != null ? Personal.getDireccion() : inscrito.getDireccion() != null ? inscrito.getDireccion(): "-"%></td>
					  <td align="left"><%= Personal.getTelefono()%></td>
					  <td align="left"><%= aca.catalogo.CatClasFin.getClasFinNombre(conElias,escuelaId,inscrito.getClasfinId())%></td>
					  <td align="left"><%= aca.catalogo.CatReligion.getReligionNombre(conElias,inscrito.getReligion())%></td>
					  <td align="left"><%= inscrito.getTutor() == null ? "-" : inscrito.getTutor()%></td> 
					  <td align="left"><%= inscrito.getCelular() == null ? "-" : inscrito.getCelular()%></td> 
					  <td align="left"><%= Personal.getEmail() != null ? Personal.getEmail() : inscrito.getEmail() != null ? inscrito.getEmail() : "-"%></td>
					  <td align="left"><%= inscrito.getTipoSangre() %></td>
					  <td align="left"><%= inscrito.getCorreo()%></td>
					  <td align="left"><%= inscrito.getIglesia()%></td> 
					  <td align="left"><%= Personal.getNombre()+" " +Personal.getApaterno()+" " +Personal.getAmaterno() %></td> 
					  <td align="left"><%= Personal.getOcupacion()%></td>
					  <td align="left"><%= Personal.getRfc() != null ? Personal.getRfc() : (inscrito.getTutorCedula()==null || inscrito.getTutorCedula().equals("-") || inscrito.getTutorCedula().equals("null"))? "" : inscrito.getTutorCedula()%></td>
					  <td align="left"><%= inscrito.getCrip()%></td>
					  <td align="left"><%= inscrito.getActa()%></td> 
				</tr> 				
<% 				
				Personal.setNombre(" "); Personal.setApaterno(" "); Personal.setAmaterno(" "); Personal.setOcupacion(" ");
				cont++;
						}
  			}
%>
  			</table>
<% 	
		}
%>
	
	<div class="alert alert-success" >
		<h5><fmt:message key="aca.TotalesGenerales" /></h5>
	 	<b><fmt:message key="aca.Hombres" />: </b><%=totHombres%>&nbsp;&nbsp;
		<b><fmt:message key="aca.Mujeres" />: </b><%=totMujeres%>&nbsp;&nbsp;
		<b>ACFE: </b><%=totACFE%>&nbsp;&nbsp;
		<b>No ACFE: </b><%=totNACFE%>&nbsp;&nbsp;
		<b><fmt:message key="aca.TotalInscritos" />:</b> <%= lisInscritos.size() %>
	</div>
	
	
</div>
<%@ include file="../../cierra_elias.jsp" %>