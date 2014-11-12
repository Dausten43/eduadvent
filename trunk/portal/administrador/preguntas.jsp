<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<%@page import="java.util.HashMap"%>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario" />
<jsp:useBean id="catEscuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista" />
<jsp:useBean id="estPregLista" scope="page" class="aca.est.EstPreguntaLista" />
<jsp:useBean id="estRespLista" scope="page" class="aca.est.EstRespuestaLista" />


<%
	String codigoId = (String)session.getAttribute("codigoId");

	usuario.mapeaRegId(conElias, codigoId);
	String [] asociacionesUsuario 	= usuario.getAsociacion().trim().split("-");
	
	
	String [] escuelasUsuario = usuario.getEscuela().trim().split("-");
	ArrayList<String> arrayEscuelas = new ArrayList<String>();
	java.util.Collections.addAll(arrayEscuelas, escuelasUsuario);
	String encuestaId  = request.getParameter("encuestaId")==null?"1":request.getParameter("encuestaId");
	
	
	ArrayList<aca.catalogo.CatEscuela> escuelas = catEscuelaLista.getListAll(conElias, " ORDER BY ASOCIACION_ID ");
		
		String EscuelasPorAsociacion= "";
		ArrayList<String> AsociacionesDeEscuelasPorAsociacion = new ArrayList<String>();
		
		for(String asoc: asociacionesUsuario){
			
	String schools  = "";
	for(aca.catalogo.CatEscuela escTmp: escuelas){
		String asocTmp = escTmp.getAsociacionId()==null?"*":escTmp.getAsociacionId();
		
		if(asocTmp.equals(asoc)){
			if(arrayEscuelas.contains(escTmp.getEscuelaId())){
				schools+=escTmp.getEscuelaId()+",";
			}
		}
	}
	if(!schools.equals("")){
		EscuelasPorAsociacion+=schools;
		AsociacionesDeEscuelasPorAsociacion.add(asoc);
	}
		}
		ArrayList <aca.est.EstPregunta> lista = estPregLista.getListEncuesta(conElias, encuestaId, "");
		HashMap<String, aca.est.EstRespuesta> mapRespuestas  = estRespLista.getMapEscuela(conElias);
		int [] totales = new int [lista.size()];

%>

<div id="content">
	<h2>
		<fmt:message key="catalogo.ListadoDeAsoc" />
	</h2>
	
	<div class="well">
		<a href="encuestas.jsp" class="btn btn-primary"><i class="icon-arrow-right icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<table class="table table-bordered">
		<tr>
			<th>Escuelas</th>
			<%
				for(int i =1; i<lista.size()+1; i++){
			%>
			<th><a  href="#" title="<%=lista.get(i-1).getPreguntaNombre()%>"><%=i%></a></th>
			<%
				}
			%>
		</tr>
		<%	
			String asociacion = "";
			
			for(int i=0; i<AsociacionesDeEscuelasPorAsociacion.size(); i++){
			asociacion = aca.catalogo.CatAsociacion.getNombre(conElias, AsociacionesDeEscuelasPorAsociacion.get(i));
			int datos [] = new int[lista.size()]; 
		%>
		<tr class="alert alert-info">
			<td><h4><%=asociacion%></h4></td>
			<td colspan="<%=lista.size()%>"></td>
		<tr>
		<%
			String asociacionId="";
			String esc[] = EscuelasPorAsociacion.split(",");
			for (String x : esc){
				String nombre = aca.catalogo.CatEscuela.getNombre(conElias, x);
				asociacionId = aca.catalogo.CatEscuela.getAsociacionId(conElias, x);
			if(AsociacionesDeEscuelasPorAsociacion.get(i).equals(asociacionId)){
			%>
		<tr>
			<td><%=nombre%></td>
				<%
				String respuesta = "";
				for(int j =1; j<lista.size()+1; j++){
					if(mapRespuestas.containsKey(x+","+encuestaId+","+j)){
						respuesta = mapRespuestas.get(x+","+encuestaId+","+j).getRespuesta();
					}
					int dato=0;
					if(respuesta.equals("")){
						datos[j-1] += dato;
					}else{
						datos[j-1] += Integer.parseInt(respuesta);
					}
					%>
					<td><%=respuesta%></td>
		
		
				<%}
				}else{
				
				}
			}%>
		</tr>
		<tr class="alert">
			<td>Total</td>
			<%for (int m=0; m<datos.length; m++){
					totales[m] += datos[m];	
			%>
			<td><a href="#" title="<%=lista.get(m).getPreguntaNombre()%>"><%=datos[m]%></a></td>
				<%} %>
		</tr>
			<%}	%>
		<tr class="alert">
			<td><h4>Total General</h4></td>
			<%for(int z = 0; z<totales.length; z++){ %>
			<td><strong><%=totales[z]%></strong></td>
			<%} %>
		</tr>
	</table>
</div>
<script>
	jQuery('.encuestas').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp"%>
