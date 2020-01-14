<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="catNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="CatNivelEscuela" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CatClas" scope="page" class="aca.catalogo.CatClasFinLista"/>
<jsp:useBean id="GrupoL" scope="page" class="aca.catalogo.CatGrupoLista"/>

<%
	java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuela 			= (String)session.getAttribute("escuela");
	String cicloId			= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuela):request.getParameter("ciclo");
	
	// Lista de ciclos en la escuela
	ArrayList<aca.ciclo.Ciclo> lisCiclo 				= CicloLista.getListActivos(conElias, escuela, "ORDER BY 1");
	
	// Lista de clasificaciones por escuela
	ArrayList<String> lisClasFin 						= CatClas.getListClas(conElias, escuela);
	
	// Lista de grupos con alumnos incritos en el ciclo
	ArrayList<aca.catalogo.CatGrupo> lisGrupos 			= GrupoL.listGruposEnCiclo(conElias, cicloId, escuela, "ORDER BY NIVEL_ID, GRADO, GRUPO");
	
	// Map de inscritos
	java.util.HashMap<String, String> mapInscritos 		= aca.alumno.AlumCicloLista.mapCuentaInscritos(conElias, cicloId);
	
	// Map de Genero
	java.util.HashMap<String, String> mapGenero 		= aca.alumno.AlumCicloLista.mapCuentaGenero(conElias, cicloId);
	
	// Map de Clas.Financiera
	java.util.HashMap<String, String> mapClasificacion 	= aca.alumno.AlumCicloLista.mapCuentaClasificacion(conElias, cicloId);
	
%>
<div id="content">
	<h2><fmt:message key="reportes.EstadisticaInscritos" /> <small>( <%= aca.catalogo.CatEscuela.getNombreCorto(conElias, escuela)%> )</small></h2>
	<form name="forma" action="inscrito.jsp" method='post'>		
	<div class="well">
		<select id="ciclo" name="ciclo" onchange="document.forma.submit();" class="input-xxlarge">
<%		
	for(int i = 0; i < lisCiclo.size(); i++){
		aca.ciclo.Ciclo ciclo  = (aca.ciclo.Ciclo) lisCiclo.get(i);
%>
			<option value="<%=ciclo.getCicloId() %>"<%=ciclo.getCicloId().equals(cicloId)?" Selected":"" %>>[<%=ciclo.getCicloId()%>] <%=ciclo.getCicloNombre() %></option>
<%	}%>
		</select>
	</div>
	</form>	
<%	
	String nivelTemp 	= "X";
	String gradoTemp 	= "X";	
	boolean openTabla 	= false;
	int totAlumnos 		= 0;
	int totHombres 		= 0;
	int totMujeres 		= 0;
	int totAcfe   	 	= 0;
	int totNoAcfe  		= 0;
	float totHombresPor = 0;
	float totMujeresPor = 0;
	
	for( aca.catalogo.CatGrupo grupo: lisGrupos){		
		if (!nivelTemp.equals(grupo.getNivelId())){
			nivelTemp = grupo.getNivelId();
			
			if (openTabla) out.print("</table>");
			openTabla = true;
			String nombreNivel = aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuela, grupo.getNivelId());
			out.print("<div class='alert alert-info'><h4>"+nombreNivel+"</h4></div>");		
%>
	<table class='table table-fullcondensed'>
	<tr>
		<th><fmt:message key="aca.Grado" /> y <fmt:message key="aca.Grupo" /></th>
		<th># <fmt:message key="aca.Alumnos" /></th>
		<th># <fmt:message key="aca.Hombres" /></th>
		<th># <fmt:message key="aca.Mujeres" /></th>		
		<th>% <fmt:message key="aca.Hombres" /></th>
		<th>% <fmt:message key="aca.Mujeres" /></th>
<%			
			String clasNom		= "";
			for(String clasFin : lisClasFin){
				clasNom			= aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuela, clasFin);%>
		<th># <%=clasNom%></th>
<%			}%>	
	</tr>
<%			
		}								
						
		int alumnos    		= 0;
		if (mapInscritos.containsKey(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()))
			alumnos = Integer.parseInt(mapInscritos.get(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()));
		
		int hombres    		= 0;
		if (mapGenero.containsKey(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"M"))
			hombres = Integer.parseInt(mapGenero.get(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"M"));
		
		int mujeres    		= 0;
		if (mapGenero.containsKey(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"F"))
			mujeres = Integer.parseInt(mapGenero.get(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"F"));
		
		float hombresPor 	= 0;		
		if(hombres == 0) hombresPor = 0; else hombresPor = (float)hombres/(float)alumnos*100f;
		
		float mujeresPor 	= 0;
		if(mujeres == 0) mujeresPor = 0; else mujeresPor = (float)mujeres/(float)alumnos*100f;
		
		int acfe 	   		= 0;
		if (mapClasificacion.containsKey(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"1"))
			acfe = Integer.parseInt(mapClasificacion.get(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"1"));
		
		int noAcfe     		= 0;
		if (mapClasificacion.containsKey(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"2"))
			noAcfe = Integer.parseInt(mapClasificacion.get(grupo.getNivelId()+grupo.getGrado()+grupo.getGrupo()+"2"));		
%>
	<tr>
		<td><%=grupo.getGrado() %> "<%=grupo.getGrupo()%>"</td>
		<td><%=alumnos %></td>
		<td><%=hombres %></td>
		<td><%=mujeres %></td>
		<td><%=getformato.format( hombresPor ) %></td>
		<td><%=getformato.format( mujeresPor ) %></td>
		<td><%=acfe %></td>
		<td><%=noAcfe %></td>		
	</tr>
<%
		totAlumnos += alumnos;
		totHombres += hombres;
		totMujeres += mujeres;
		totAcfe    += acfe;
		totNoAcfe  += noAcfe;
	}
					
	if(totHombres == 0) totHombresPor = 0; else totHombresPor = (float)totHombres/(float)totAlumnos*100f;
	if(totMujeres == 0) totMujeresPor = 0; else totMujeresPor = (float)totMujeres/(float)totAlumnos*100f;
%>
		
		<tr>
			<td><strong>Total</strong></td>
			<td><strong><%=totAlumnos %></strong></td>
			<td><strong><%=totHombres %></strong></td>
			<td><strong><%=totMujeres %></strong></td>
			<td><strong><%=getformato.format( totHombresPor ) %></strong></td>
			<td><strong><%=getformato.format( totMujeresPor ) %></strong></td>
			<td><strong><%=totAcfe %></strong></td>
			<td><strong><%=totNoAcfe %></strong></td>		
		</tr>
	</table>
</div>

<%@ include file="../../cierra_elias.jsp" %>