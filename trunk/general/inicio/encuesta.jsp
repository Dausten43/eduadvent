<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Encuesta" scope="page" class="aca.est.EstEncuesta" />
<jsp:useBean id="PreguntaLista" scope="page" class="aca.est.EstPreguntaLista" />
<jsp:useBean id="Respuesta" scope="page" class="aca.est.EstRespuesta" />

<%
	String strEscuela 			= (String)session.getAttribute("escuela");
	String sCodigoPersonal 		= (String)session.getAttribute("codigoId");
	String salto				= "X";
	
	
	
	/* SOLO PARA ADMINISTRADORES DE LAS ESCUELAS */
	if (aca.usuario.Usuario.esAdministrador(conElias, sCodigoPersonal) == false){
		salto = "index.jsp";
	}
	
	String encuestaId = request.getParameter("encuestaId");
	
	if(encuestaId == null)salto = "index.jsp";
	
	Encuesta.mapeaRegId(conElias, encuestaId);
	
	ArrayList<aca.est.EstPregunta> preguntas = PreguntaLista.getListEncuesta(conElias, encuestaId, "");
	
	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String sResultado    = "";
	
	if(accion.equals("1")){/* Guardar encuesta*/
		for(aca.est.EstPregunta pregunta: preguntas){
			String respuesta = request.getParameter("respuesta"+pregunta.getEncuestaId()+pregunta.getPreguntaId());
			
			Respuesta.setEscuelaId(strEscuela);
			Respuesta.setEncuestaId(pregunta.getEncuestaId());
			Respuesta.setPreguntaId(pregunta.getPreguntaId());
			Respuesta.setRespuesta(respuesta);
			Respuesta.setFecha( aca.util.Fecha.getHoy() );
			
			if(Respuesta.existeReg(conElias)){
				
				if(Respuesta.updateReg(conElias)){
		       		sResultado = "Modificado";
		       		
				}else{
					sResultado = "NoModifico"; 
				}
				
			}else{
				
				if(Respuesta.insertReg(conElias)){
					sResultado = "Guardado";
				}else{
					sResultado = "NoGuardo";
				}
				
			}
			
			
		}
	}
	
	
	pageContext.setAttribute("resultado", sResultado);
%>

<style>
	.table input{
		margin: 0 !important;
	}
</style>

<div id="content">
	
	<h2><%=Encuesta.getEncuestaNombre() %></h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a href="index.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form action="" method="post">
		<input type="hidden" name="Accion" value="1" />
	
		<table class="table table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Pregunta" /></th>
				<th><fmt:message key="aca.Respuesta" /></th>
			</tr>
		<%
			int cont = 0;
			for(aca.est.EstPregunta pregunta: preguntas){
				cont++;
				String value = "0";
				
				Respuesta.mapeaRegId(conElias, strEscuela, pregunta.getEncuestaId(), pregunta.getPreguntaId());
				if(!Respuesta.getRespuesta().equals("")){
					value = Respuesta.getRespuesta();	
				}
		%>
			<tr>
				<td><%=cont %></td>
				<td><%= pregunta.getPreguntaNombre() %></td>
				<td>
				<%
					if(pregunta.getTipo().equals("1")){
				%>
					<input class="onlyNumbers" type="number" value="<%=value %>" id="respuesta<%= pregunta.getEncuestaId()+pregunta.getPreguntaId() %>" name="respuesta<%= pregunta.getEncuestaId()+pregunta.getPreguntaId() %>" />
				<%
					}else if(pregunta.getTipo().equals("2")){
				%>
					<select id="respuesta<%= pregunta.getEncuestaId()+pregunta.getPreguntaId() %>" name="respuesta<%= pregunta.getEncuestaId()+pregunta.getPreguntaId() %>">
						<option value="1" <% if(value.equals("1"))out.print("selected"); %> >Si</option>
						<option value="0" <% if(value.equals("0"))out.print("selected"); %> >No</option>
					</select>
				<%
					}
				%>
				</td>
			</tr>
		<%
			}
		%>
		</table>
		
		<div class="well">
			<button class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></button>
		</div>
		
	</form>
	
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>