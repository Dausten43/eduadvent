<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="catNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="AlumnoL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="CatClas" scope="page" class="aca.catalogo.CatClasFinLista"/>

<%
	java.text.DecimalFormat getformato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	String fecha = aca.util.Fecha.getHoy();
	String escuela 	= (String)session.getAttribute("escuela");
	String ciclo	= request.getParameter("ciclo")==null?aca.ciclo.Ciclo.getCargaActual(conElias,escuela):request.getParameter("ciclo");
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivosHoy(conElias,fecha, escuela, "ORDER BY 1");
	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel = catNivelL.getListEscuela(conElias,escuela,"ORDER BY NIVEL_ID");
	
%>
<div id="content">
	<h2><fmt:message key="reportes.EstadisticaInscritos" /> <small>( <%= aca.catalogo.CatEscuela.getNombreCorto(conElias, escuela)%> )</small></h2>
<%		
	String ciclosActivos = "";
	for(int i = 0; i < lisCiclo.size(); i++){
		Ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
		ciclosActivos += "'"+Ciclo.getCicloId()+"',";
		
	
	}
	ciclosActivos = ciclosActivos.substring(0, ciclosActivos.length()-1);
%>
<%	for( aca.catalogo.CatNivelEscuela catNivel: lisNivel){

		ArrayList<aca.alumno.AlumPersonal> lisInscritos = AlumnoL.getListTotalAlumnosInscritosNivel(conElias, escuela, ciclosActivos, catNivel.getNivelId(), "ORDER BY NIVEL_ID, GRADO, GRUPO, CODIGO_ID");
		
		if(!lisInscritos.isEmpty()){
			
			//Traer todos los grados y grupos de los alumnos
			ArrayList<String> gradosYgrupos = new ArrayList<String>();
			String gradoTmp = "";
			String grupoTmp = "";
			for(aca.alumno.AlumPersonal inscrito: lisInscritos){
					if(!inscrito.getGrado().equals(gradoTmp) || !inscrito.getGrupo().equals(grupoTmp)){
						gradoTmp = inscrito.getGrado();
						grupoTmp = inscrito.getGrupo();
						gradosYgrupos.add(gradoTmp+"&"+grupoTmp);
					}
			}
			//END Traer los grados y grupos de los alumnos
			
%>
			<div class="alert alert-info"><h4><%=catNivel.getNivelNombre() %></h4></div>
			
			<table class="table table-fullcondensed">				
					<tr>
						<th><fmt:message key="aca.Grado" /> y <fmt:message key="aca.Grupo" /></th>
						<th># <fmt:message key="aca.Alumnos" /></th>
						<th># <fmt:message key="aca.Hombres" /></th>
						<th># <fmt:message key="aca.Mujeres" /></th>
						<%ArrayList<String> lisClasFin = CatClas.getListClas(conElias, escuela);
						String clasNom		= "";
						for(String clasFin : lisClasFin){
							clasNom			= aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuela, clasFin);%>
							<th># <%=clasNom%></th>
						<%}%>
						<th>% <fmt:message key="aca.Hombres" /></th>
						<th>% <fmt:message key="aca.Mujeres" /></th>
					</tr>			
			<%
					int totAlumnos = 0;
					int totHombres = 0;
					int totMujeres = 0;
					int totAcfe    = 0;
					int totNoAcfe  = 0;
					float totHombresPor = 0;
					float totMujeresPor = 0;
			
					for(String gradoGrupo: gradosYgrupos){
						
						String gradoNombre = aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuela, catNivel.getNivelId(), gradoGrupo.split("&")[0]);
						String grado = gradoGrupo.split("&")[0];
						String grupo = gradoGrupo.split("&")[1];
						
						
						int alumnos    		= 0;
						int hombres    		= 0;
						int mujeres    		= 0;
						int acfe 	   		= 0;
						int noAcfe     		= 0;
						float hombresPor 	= 0;
						float mujeresPor 	= 0;
						
						for(aca.alumno.AlumPersonal inscrito: lisInscritos){
								if(inscrito.getGrado().equals(grado) && inscrito.getGrupo().equals(grupo)){
									if(inscrito.getGenero().trim().equals("M")) hombres++; else mujeres++;
									if(inscrito.getReligion().trim().equals("1")) acfe++; else noAcfe++;
								}
						}
						alumnos = hombres+mujeres;
						
						if(hombres == 0) hombresPor = 0; else hombresPor = (float)hombres/(float)alumnos*100f;
						if(mujeres == 0) mujeresPor = 0; else mujeresPor = (float)mujeres/(float)alumnos*100f;
			%>
					<tr>
						<td><%=gradoNombre %> "<%=grupo %>"</td>
						<td><%=alumnos %></td>
						<td><%=hombres %></td>
						<td><%=mujeres %></td>
						<td><%=acfe %></td>
						<td><%=noAcfe %></td>
						<td><%=getformato.format( hombresPor ) %></td>
						<td><%=getformato.format( mujeresPor ) %></td>
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
						<td><strong><%=totAcfe %></strong></td>
						<td><strong><%=totNoAcfe %></strong></td>
						<td><strong><%=getformato.format( totHombresPor ) %></strong></td>
						<td><strong><%=getformato.format( totMujeresPor ) %></strong></td>
					</tr>
			</table>
<%		}
	}
%>
	</div>

<%@ include file="../../cierra_elias.jsp" %>