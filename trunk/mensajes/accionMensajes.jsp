
<%@page import="java.util.Map"%>
<%@page import="aca.conecta.Conectar"%>
<%@page import="java.sql.Connection"%>
<%@page import="aca.mensajes.Mensajeria"%>
<%@page import="aca.mensajes.UtilMensajes"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>

    
<%
Connection  conElias 	= new Conectar().conEliasPostgres();

UtilMensajes umsg = new UtilMensajes();


if(request.getParameter("envia_mensaje")!=null){
	String envia = request.getParameter("envia")!=null ? request.getParameter("envia") : "-";
	String tipo_destino = request.getParameter("tipo_destino")!=null ? request.getParameter("tipo_destino") :  "X";
	String destino =  request.getParameter("destino")!=null ? request.getParameter("destino") :  "X";
	Integer es_respuesta =  request.getParameter("es_respuesta")!=null ? 1 :  0;
	Long mensaje_original =  request.getParameter("mensaje_original")!=null ? new Long(request.getParameter("mensaje_original")) :  0L;
	String asunto =  request.getParameter("asunto")!=null ? request.getParameter("asunto") :  "-";
	String mensaje =  request.getParameter("mensaje")!=null ? request.getParameter("mensaje") :  "-";
	Integer estado =  request.getParameter("estado")!=null ? 1 :  1;
	Mensajeria m = new Mensajeria(null,envia,tipo_destino,destino,"",es_respuesta,mensaje_original,asunto,mensaje,estado);
	umsg.guardaMensaje(conElias, m);
}

if(request.getParameter("cuenta_msgs")!=null){
	String destino = request.getParameter("destino")!=null ? request.getParameter("destino") : "X";
	String tipodestino = request.getParameter("tipodestino")!=null ? request.getParameter("tipodestino") : "";
	
	Map<Long, Mensajeria> mapMensajes = umsg.getMensaje(conElias, 0L, "", "", tipodestino, "",destino, -1, 0L, -1, "1", " order by fecha desc ");
	
	out.println(mapMensajes.size());
	mapMensajes.clear();
}

if(request.getParameter("lista-mensajes")!=null){
	String destino = request.getParameter("destino")!=null ? request.getParameter("destino") : "";
	String tipodestino = request.getParameter("tipodestino")!=null ? request.getParameter("tipodestino") : "";
	String envia = request.getParameter("envia")!=null ? request.getParameter("envia") : "";
	String enviados = request.getParameter("enviados")!=null ? "&enviados=true" : "";
	String escuela = request.getParameter("escuela")!=null ? request.getParameter("escuela") : "";
	Map<Long, Mensajeria> mapMensajes = umsg.getMensaje(conElias, 0L, envia, "", tipodestino,"", destino, -1, 0L, -1, "1,2", " order by estado, fecha  desc ");
	//System.out.println(mapMensajes.size() + " "+destino);
	%>
	<table style="width: 100%">
	<% for(Mensajeria m : mapMensajes.values()){ 
		empPersonal.mapeaRegId(conElias, m.getUsr_envia());
		String btn = "";
		if(m.getTipo_destino().equals("P")){
			btn ="btn btn-default btn-mini";
		}
		if(m.getTipo_destino().equals("G")){
			btn ="btn btn-warning btn-mini";
		}
		if(m.getTipo_destino().equals("I")){
			btn ="btn btn-danger btn-mini";
		}
		if(m.getTipo_destino().equals("A")){
			btn ="btn btn-primary btn-mini";
		}
		if(m.getTipo_destino().equals("D")){
			btn ="btn btn-info btn-mini";
		}
	%>
		<tr>
		<% if(m.getEstado()==1){ %>
			<td onclick="showMsg(<%= m.getId() %>,'<%= enviados %>')" style="border-bottom: 1px solid #000000 ; font-weight: bold;" id="msg-<%= m.getId() %>" class="listmsg"><span class="<%= btn %>"> <%= m.getTipo_destino() %></span> <%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%> <%= m.getAsunto() %></td>
		<% }else{ %>
			<td onclick="showMsg(<%= m.getId() %>,'<%= enviados %>')" style="border-bottom: 1px solid #000000 ; " id="msg-<%= m.getId() %>" class="listmsg"><span class="<%= btn %>"> <%= m.getTipo_destino() %></span> <%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%> <%= m.getAsunto() %></td>
		<% } %>	
		</tr>
	<% } %>
	</table>
	<%
}

if(request.getParameter("show-msg")!=null){
	Long id = new Long(request.getParameter("idmsg"));
	Map<Long, Mensajeria> mapMensajes = umsg.getMensaje(conElias, id, "", "", "", "", "", -1, 0L, -1, "", "");
	if(request.getParameter("enviados")==null)
		if( mapMensajes.get(id).getEstado().equals(1))
    			umsg.guardaMensaje(conElias, 2, id);
	
	%>
	
	<% for(Mensajeria m : mapMensajes.values()){
		String nombreEnvia = "";
		String nombrePara = "";
		if(m.getUsr_envia().contains("E")){
			empPersonal.mapeaRegId(conElias, m.getUsr_envia());
			nombreEnvia = empPersonal.getNombre()+ " " +empPersonal.getApaterno()+ " " +empPersonal.getAmaterno();
		}else 
		if(m.getUsr_envia().contains("P")){
			nombreEnvia= aca.empleado.EmpPersonal.getNombre(conElias, m.getUsr_envia(), "NOMBRE");
		}else{
			nombreEnvia = aca.alumno.AlumPersonal.getNombre(conElias, m.getUsr_envia(), "NOMBRE");
		}
		
		System.out.println("tamaño de destino " + m.getDestino());
		if(m.getDestino().length()==3){
			nombrePara="ESCUELA";
		}else if(m.getDestino().length()==8){
			if(m.getDestino().contains("E")){
				nombrePara= aca.empleado.EmpPersonal.getNombre(conElias, m.getDestino(), "NOMBRE");
			}else{
				nombrePara = aca.alumno.AlumPersonal.getNombre(conElias, m.getDestino(), "NOMBRE");
			}
		}else{
			nombrePara="GRUPO";
		}
	%>
		<div class="pull-right">
			 <% if(request.getParameter("enviados")==null){ %>  
		<a data-toggle="modal" data-id="<%= m.getUsr_envia() %>" data-idmsg="<%= m.getId() %>" data-asunto="RE: <%= m.getAsunto() %>"
							class="open-RespuestaBox btn btn-warning btn-mini" href="#respuestaBox"><i class="icon-retweet icon-white"></i>  Responder</a>
<%-- 							<a data-toggle="modal" data-idmsg="<%= m.getId() %>" --%>
<%-- 							class="open-RemoveBox btn btn-danger btn-mini" href="#removeBox"><i class="icon-trash icon-white"></i>  Eliminar</a>--%><% } %> 
		</div>
		<span><strong>De: </strong><%= nombreEnvia %></span><br>
		<span><strong>Para: </strong><%= nombrePara %> 
		</span><br>
							
	    <span>Asunto: <%= m.getAsunto() %></span><br>
	    <span>Fecha: <%= m.getFecha() %></span><br>
	    <hr style="color: #000">
		<p><%= m.getMensaje() %></p>
	<% } %>
	
	<%
}

if(request.getParameter("elimina_mensaje")!=null){
	Long id = new Long(request.getParameter("idmsg"));
	umsg.guardaMensaje(conElias, 0, id);
	
}

conElias.close();

%>
