<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Mensaje" scope="page" class="aca.alumno.AlumMensaje"/>
<jsp:useBean id="MensajeL" scope="page" class="aca.alumno.AlumMensajeLista"/>


<% 
	String escuelaId	= (String) session.getAttribute("escuela");
	
	String codigoPadre	= (String) session.getAttribute("codigoId");
	String cicloGrupoId	= request.getParameter("CicloGrupoId");
	String cursoId	    = request.getParameter("CursoId");
	String maestroId	= request.getParameter("CodigoEmpleado");
	
	String accion 		= request.getParameter("Accion")==null?"1":request.getParameter("Accion");
	String sResultado	= "";
		
	if(accion.equals("2")){// Grabar la cuenta
		Mensaje.setFolio(Mensaje.maximoReg(conElias,maestroId));
		//Mensaje.setCodigoId(codigoId);
		Mensaje.setPadreId(codigoPadre);
		Mensaje.setCursoId(cursoId);
		Mensaje.setCicloGrupoId(cicloGrupoId);
		Mensaje.setMaestroId(maestroId);
		Mensaje.setFecha(aca.util.Fecha.getDateTime());
		Mensaje.setComentario(request.getParameter("Comentario"));
		Mensaje.setFromMaestro("SI");
		
		if (Mensaje.existeReg(conElias) == false){
			if (Mensaje.insertReg(conElias)){
				sResultado = "MensajeEnviado";
				conElias.commit();
			}else{
				sResultado = "NoMensajeEnviado";
			}
		}
	}	
	
	pageContext.setAttribute("resultado", sResultado);
	
	String op = request.getParameter("op")==null?"Bandeja":request.getParameter("op");
	String sql = "AND FROM_PADRE = 'SI' ";
	if(op.equals("Enviados")){
		sql = "AND FROM_MAESTRO = 'SI' ";
	}
	
	ArrayList<aca.alumno.AlumMensaje> lisMensajes = MensajeL.getListCicloGrupoId(conElias, escuelaId, maestroId, cicloGrupoId, sql+" ORDER BY FECHA DESC, FOLIO");
%>


<style>
	.boxsizingBorder {
	    -webkit-box-sizing: border-box;
	       -moz-box-sizing: border-box;
	            box-sizing: border-box;
	}
</style>

<div id="content">
	
	<h2><fmt:message key="aca.Mensajes" /></h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado") || sResultado.equals("MensajeEnviado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a href="cursos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a href="#myModal" data-toggle="modal" class="btn btn-info nuevoMsj"><i class="icon-file icon-white"></i> <fmt:message key="boton.EscribirMensaje" /></a>
	</div>
	
<!-- ESCRIBIR MENSAJE -->
 	<form action="mensaje.jsp" method="post" name="frmmsj" target="_self" style="margin:0;">
		<input type="hidden" name="Accion">
		<input type="hidden" name="CicloGrupoId" value="<%=cicloGrupoId%>">
		<input type="hidden" name="CursoId" value="<%=cursoId%>">
		<input type="hidden" name="CodigoEmpleado" value="<%=maestroId%>">
		
	<!-- MODAL -->
		<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		    <h3 id="myModalLabel"><fmt:message key="boton.EscribirMensaje" /></h3>
		  </div>
		  <div class="modal-body ">
		        <textarea name="Comentario"  class="boxsizingBorder" id="Comentario" style="width:100%;height:80px;margin:0;" placeholder="Escribe tu Mensaje Aqui"></textarea>
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
		    <a class="btn btn-primary" href="javascript:Grabar()"><i class="icon-envelope icon-white"></i> <fmt:message key="boton.EnviarMensaje" /></a>
		  </div>
		</div>
	<!-- END MODAL -->
	</form>
<!-- END ESCRIBIR MENSAJE -->

	<ul class="nav nav-tabs">
	  <li <%if(op.equals("Bandeja"))out.print("class='active'"); %>>
	    <a href="mensaje.jsp?CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>&CodigoEmpleado=<%=maestroId %>&op=Bandeja"><fmt:message key="aca.Bandeja" /></a>
	  </li>
	  <li <%if(op.equals("Enviados"))out.print("class='active'"); %>>
	    <a href="mensaje.jsp?CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>&CodigoEmpleado=<%=maestroId %>&op=Enviados"><fmt:message key="aca.Enviados" /></a>
	  </li>
	</ul>

<%
	if(lisMensajes.size()==0){
%>
		<div class="alert alert-info">Usted no tiene mensajes.</div>
<%
	} 
%>
	

	<table class="table table-nohover">
<%   
	for(int i=0; i<lisMensajes.size();i++){
			aca.alumno.AlumMensaje msj = (aca.alumno.AlumMensaje) lisMensajes.get(i);  			
%>
	  <tr>
	    <td align="left"><%= msj.getComentario() %></td>
	    <td  width="15%" align="left"><%= msj.getFecha() %></td>
	  </tr>
<% 
	}
%>
	</table>

</div>

<script>
	
	function Grabar(){
		if(document.frmmsj.Comentario.value!=""){			
			document.frmmsj.Accion.value="2";
			document.frmmsj.submit();			
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}	
	
</script>

<%@ include file= "../../cierra_elias.jsp" %>
