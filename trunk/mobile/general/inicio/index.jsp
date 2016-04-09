<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ page import="sun.misc.BASE64Encoder"%>
<%@ page import="java.security.MessageDigest"%>

<jsp:useBean id="escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="EncuestaLista" scope="page" class="aca.est.EstEncuestaLista" />
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario" />

<%
	String strEscuela 			= (String)session.getAttribute("escuela");
	String sCodigoPersonal 		= (String)session.getAttribute("codigoId");
	String salto				= "X";
	
	escuela.mapeaRegId(conElias, strEscuela);
	String asociacion			= aca.catalogo.CatEscuela.getAsociacionId(conElias, escuela.getEscuelaId());
	String union				= aca.catalogo.CatAsociacion.getUnionId(conElias, asociacion);
	String strNombreUsuario		= "";
	String paisNombre 			= aca.catalogo.CatPais.getPais(conElias, escuela.getPaisId() );
	String barrioNombre			= aca.catalogo.CatBarrio.getBarrio(conElias, escuela.getPaisId(), escuela.getEstadoId(), escuela.getCiudadId(), escuela.getBarrioId());
	
	int intTipoUsuario	= aca.usuario.Usuario.getTipo(conElias, sCodigoPersonal);
	if (intTipoUsuario ==1){
		strNombreUsuario = aca.alumno.AlumPersonal.getNombre(conElias,sCodigoPersonal,"NOMBRE");
	}else if (intTipoUsuario ==2 || intTipoUsuario ==3){
		strNombreUsuario = aca.empleado.EmpPersonal.getNombre(conElias,sCodigoPersonal,"NOMBRE");
	}
	 
	String mensaje = request.getParameter("mensaje")==null?"":request.getParameter("mensaje");
	
	MessageDigest md5 			= MessageDigest.getInstance("MD5");
	md5.update(((String)session.getAttribute("user")).getBytes("UTF-8"));
    byte raw[] = md5.digest();    
    String claveDigest = (new BASE64Encoder()).encode(raw);
	
%>
<div id="content">
<h2><fmt:message key="aca.Bienvenido"/> <small><%=aca.vista.UsuariosLista.getNombreCorto(conElias, (String)session.getAttribute("codigoId")) %></small></h2>

<%
	if(mensaje.equals("1")){
%>
	<div class="alert alert-danger">
		<fmt:message key="aca.UsuarioNoExiste" />
	</div>
<%
	}
%>

<%
	/* 
	 * ENCUESTA
	 */
	 
	 ArrayList<aca.est.EstEncuesta> encuestas = EncuestaLista.getListAll(conElias, " WHERE NOW() <= FECHA_LIMITE AND UNIONES LIKE '%-"+union+"-%' ");
	 
	if (aca.usuario.Usuario.esAdministrador(conElias, sCodigoPersonal) && encuestas.size()>0){
%>
	<div class="alert">
		<h3>Mensaje!</h3>
		<p>
			Ustead ha recibido una o mas encuestas, favor de contestarlas.
		</p>
		<p>	
			<ul class="nav nav-tabs nav-stacked" style="background:white;">
			<%
				for(aca.est.EstEncuesta encuesta: encuestas){
			%>
					<li><a href="encuesta.jsp?encuestaId=<%=encuesta.getEncuestaId() %>"> <h5><%=encuesta.getEncuestaNombre() %> <i style="float:right;margin-top:3px;" class="icon-chevron-right"></i> </h5> </a></li>
			<%
				}
			%>
			</ul>
		</p>
	</div>
<%
	}
%>

<%
	if(!usuario.getEsUsuario(conElias, (String)session.getAttribute("user"), claveDigest).equals("x")){
		salto = "../editar/cambia_clave.jsp";
	}
%>
		
	<div class="alert alert-info">
		<button type="button" class="close" data-dismiss="alert">&times;</button>	
		<h3><%=escuela.getEscuelaNombre() %></h3>
		<h5><%=aca.catalogo.CatUnion.getNombre(conElias, union) %> - <%=aca.catalogo.CatAsociacion.getNombre(conElias, asociacion) %></h5>	
		<h5>
		<%
			if(!escuela.getBarrioId().equals("0")){
		%>
			<%= barrioNombre %> ,
		<%
			}
		%>
		<%=aca.catalogo.CatCiudad.getCiudad(conElias, escuela.getPaisId(), escuela.getEstadoId(), escuela.getCiudadId()) %>, <%=aca.catalogo.CatEstado.getEstado(conElias, escuela.getPaisId(), escuela.getEstadoId())%>, <%=paisNombre%>
		</h5>
		<h6> <%=sCodigoPersonal%> | <%=strNombreUsuario %></h6> 
		
	</div>

	

	<%//SI ES ERY MOSTRAR INFORMACION EXTRA
	if(session.getAttribute("admin").equals("B01P0002")){
	%>
	<div class="alert">		
			<h5><fmt:message key="aca.InformacionSesion"/></h5>
			<p><strong>codigoId:</strong> <%=session.getAttribute("codigoId") %> | <%=aca.vista.Usuarios.getNombreUsuario(conElias,(String)session.getAttribute("codigoId")) %></p>
			<p><strong>admin:</strong> <%=session.getAttribute("admin") %> | <%=aca.empleado.EmpPersonal.getNombre(conElias,(String)session.getAttribute("admin"),"NOMBRE") %></p>
			<p><strong>codigoEmpleado:</strong> <%=session.getAttribute("codigoEmpleado") %> | <%=aca.vista.Usuarios.getNombreUsuario(conElias,(String)session.getAttribute("codigoEmpleado")) %></p>
			<p><strong>codigoAlumno:</strong> <%=session.getAttribute("codigoAlumno") %> | <%=aca.vista.Usuarios.getNombreUsuario(conElias, (String)session.getAttribute("codigoAlumno")) %></p>
			<p><strong>codigoReciente:</strong> <%=session.getAttribute("codigoReciente") %> | <%=aca.vista.Usuarios.getNombreUsuario(conElias, (String)session.getAttribute("codigoReciente")) %></p>
			<p><strong>Escuela Id:</strong> <%=session.getAttribute("escuela") %></p>
			<p><strong>Ejercicio Id:</strong> <%=session.getAttribute("ejercicioId") %></p>
			<p><strong>Ciclo Id:</strong> <%=session.getAttribute("cicloId") %></p>
			<p><strong>user:</strong> <%=session.getAttribute("user") %> | <%=aca.vista.Usuarios.getNombreUsuario(conElias, (String)session.getAttribute("user"))%> </p>
	</div>	
	<%
	}
	%>
	
<!-- mibew button -->
<a href="http://soporte.eduadvent.um.edu.mx/client.php?locale=es&amp;style=silver&amp;group=1" target="_blank" onclick="if(navigator.userAgent.toLowerCase().indexOf('opera') != -1 &amp;&amp; window.event.preventDefault) window.event.preventDefault();this.newWindow = window.open('http://soporte.eduadvent.um.edu.mx/client.php?locale=es&amp;style=silver&amp;group=1&amp;url='+escape(document.location.href)+'&amp;referrer='+escape(document.referrer), 'webim', 'toolbar=0,scrollbars=0,location=0,status=1,menubar=0,width=640,height=480,resizable=1');this.newWindow.focus();this.newWindow.opener=window;return false;"><img src="http://soporte.eduadvent.um.edu.mx/b.php?i=mblue&amp;lang=es&amp;group=1" border="0" width="177" height="61" alt="" align="right"/></a><!-- / mibew button -->

</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>