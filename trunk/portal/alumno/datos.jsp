<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<%@ include file= "menuPortal.jsp" %>


<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>

<%
	String codigoId			= session.getAttribute("codigoId").toString();
	
	alumPersonal.mapeaRegId(conElias, codigoId);	
	session.setAttribute("mat",codigoId);
%>


<div id="content">


<h2><fmt:message key="empleados.DatosPersonalesMin"/></h2>
<hr />

<div style="float:left;">
	<a href="" class="thumbnail">
	  <img src='imagen.jsp?id=<%=new java.util.Date().getTime()%>' width="270">
	</a>
</div>
    
<div style="margin-left:40px;float:left;background:white;" class="alert alert-info ">
	
	<div class="row">
	  <div class="span3">
		   	<address>
			  <strong><fmt:message key="aca.Matricula"/></strong><br>
			  <%=codigoId %>
			</address>
	  </div>
	  <div class="span3">
	  		<address>
			  <strong><fmt:message key="aca.Telefono"/></strong><br>
			  <%=alumPersonal.getTelefono() %>
			</address>
	  </div>
	</div>
	
	<div class="row">
	  <div class="span3">
		   	<address>
			  <strong><fmt:message key="aca.Nombre"/></strong><br>
			  <%=alumPersonal.getNombre() %> <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %>
			</address>
	  </div>
	  <div class="span3">
	  		<address>
			  <strong><fmt:message key="aca.Email"/></strong><br>
			  <%= alumPersonal.getCorreo() %>
			</address>
	  </div>
	</div>
	
	<div class="row">
	  <div class="span3">
		   	<address>
			  <strong><fmt:message key="aca.Direccion"/></strong><br>
			  <%=alumPersonal.getDireccion() %> <fmt:message key="aca.Col"/> <%=alumPersonal.getColonia() %>
			</address>
	  </div>
	  <div class="span3">
	  		<address>
			  <strong><fmt:message key="aca.CURP"/></strong><br>
			  <%=alumPersonal.getCurp() %>
			</address>
	  </div>
	</div>
	
	<div class="row">
	  <div class="span3">
		   <address>
			  <strong><fmt:message key="aca.Genero"/></strong><br>
			  <%=alumPersonal.getGenero() %>
			</address>
	  </div>
	  <div class="span3">
	  		<address>
			  <strong><fmt:message key="aca.Nivel"/></strong><br>
			  <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), alumPersonal.getNivelId()) %>
			</address>
	  </div>
	</div>
	
	<div class="row">
	  <div class="span3">
		   <address>
			  <strong><fmt:message key="aca.FechadeNacimiento"/></strong><br>
			  <%=alumPersonal.getFNacimiento() %>
			</address>
	  </div>
	  <div class="span3">
	  		<address>
			  <strong><fmt:message key="aca.Grado"/></strong><br>
			  <%=alumPersonal.getGrado() %>°
			</address>
	  </div>
	</div>
	
	<div class="row">
	  <div class="span3">
		    <address>
			  <strong><fmt:message key="aca.ACFE"/></strong><br>
			  <%if(alumPersonal.getClasfinId().equals("1")) out.print("Socio"); else out.print("No Socio"); %>
			</address>
	  </div>
	  <div class="span3">
	  		<address>
			  <strong><fmt:message key="aca.Grupo"/></strong><br>
			  <%=alumPersonal.getGrupo() %>
			</address>
	  </div>
	</div>
	
</div>
	
</div>

<script>
	jQuery('.datos').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>