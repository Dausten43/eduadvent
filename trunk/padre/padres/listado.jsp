<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="AlumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="AlumDatos" scope="page" class="aca.alumno.AlumDatos"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<% 
	String escuelaId		= (String) session.getAttribute("escuela");
	String ciclo			= request.getParameter("ciclo");
	if(ciclo==null)
		ciclo = Ciclo.getCargaActual(conElias,escuelaId);
	
	String strBgcolor		= "";
	String nivelTemp        = "0";
	
	int cont =0;
	
	// Lista de Alumnos Inscritos en un ciclo escolar
	ArrayList lisInscritos = AlumnoL.getListAlumnosInscritos(conElias,escuelaId,ciclo, " ORDER BY NIVEL_ID,GRADO,GRUPO,APATERNO,AMATERNO,NOMBRE");
%>
<style>
	td{
		font-size:10px;
	}
</style>
<body>
<div id="content">
<h2><fmt:message key="maestros.ReportedeAlumnosInscritos" /></h2>
<form name="forma" action="listado.jsp" method='post'>

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
	String gradoAndGrupo = "0";
	for(int i=0; i<lisInscritos.size();i++){ cont++;
		aca.alumno.AlumPersonal inscrito = (aca.alumno.AlumPersonal) lisInscritos.get(i);
		AlumPadres = new aca.alumno.AlumPadres();
		AlumPadres.mapeaRegId(conElias,inscrito.getCodigoId());
		AlumDatos.mapeaRegId(conElias, inscrito.getCodigoId(),escuelaId);

		if(!gradoAndGrupo.equals(inscrito.getGrado()+inscrito.getGrupo())){
		    cont=1;
		    gradoAndGrupo = inscrito.getGrado()+inscrito.getGrupo();
		  	if(!nivelTemp.equals(inscrito.getNivelId())){
				nivelTemp = inscrito.getNivelId();
			
%>
	

<%
%>
 </table>
  		<div class="alert alert-info">
			<h4><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivelId())%></h4>
		</div>
  	  
		
<% } %>
  <table width="70%" align="center" >
    <tr><td style="font-size:11pt;" ><b>Grado y Grupo: <%=inscrito.getGrado()%>° "<%=inscrito.getGrupo()%>"</b></td></tr>
  </table>
  
 <table width="70%" class="table table-condensed table-striped" align="center">
  <tr>
    <th>#</th>
    <th><fmt:message key="aca.Matricula" /></th>
    <th><fmt:message key="aca.Nombre" /></th>
	<th><fmt:message key="aca.CodPadre" /></th>
	<th><fmt:message key="aca.NombrePadre" /></th>
    <th><fmt:message key="aca.CodMadre" /></th>
    <th><fmt:message key="aca.NombreMadre" /></th>  
    <th>Cod Tutor</th>
    <th><fmt:message key="aca.Tutor" /></th>  
  </tr>
<%  		} 
			  
%>
	<tr>
	  <td align="center"><%= cont %></td>
	  <td align="center"><%= inscrito.getCodigoId() %></td>
	  <td align="left"><%= inscrito.getApaterno()+" "+inscrito.getAmaterno()+", "+inscrito.getNombre()%></td>
	  <td align="center"><%= AlumPadres.getCodigoPadre()%></td>
	  <td align="left"><%= aca.empleado.EmpPersonal.getNombre(conElias,AlumPadres.getCodigoPadre(),"NOMBRE") %></td>
	  <td align="center"><%= AlumPadres.getCodigoMadre()%></td>
	  <td align="left"><%= aca.empleado.EmpPersonal.getNombre(conElias,AlumPadres.getCodigoMadre(),"NOMBRE") %></td>
	  <td align="left"><%= AlumPadres.getCodigoTutor() %></td>
	  <td align="left"><%= aca.empleado.EmpPersonal.getNombre(conElias,AlumPadres.getCodigoTutor(),"NOMBRE") %></td>
	</tr>
<% 	} %>
</table>
</form>
</div>
</body>

<%@ include file="../../cierra_elias.jsp" %>