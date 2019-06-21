<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>


<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>

<head>
<script>
	$('.datos').addClass('active');
</script>
</head>
<%
	
	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	if(accion.equals("1")){
		session.setAttribute("codigoAlumno",request.getParameter("codigo"));
		
		
	}

	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	String colorPortal 		= (String)session.getAttribute("colorPortal");	
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	cicloId 			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	String periodoId		= aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId);
	
	alumPersonal.mapeaRegId(conElias, codigoId);
	String acfe = alumPersonal.getClasfinId().equals("1")?"SI":"No";
%>
<body>

<div id="content">



<% if(codigoId!=null){ %>
		<form action="datos_update.jsp" method="post" name="frmdatos" target="_self">
			<input type="hidden" name="cotejado" id="cotejado" value="<%=alumPersonal.getCotejado()%>">
			<input type="hidden" name="estado1" id="estado1" value="<%=alumPersonal.getEstado()%>">
			<input type="hidden" name="transporte" id="transporte" value="<%=alumPersonal.getTransporte()%>">
			  
				
				<h2><fmt:message key="empleados.DatosPersonales" /></h2>
				
				<div style="float:left;margin-right:40px;">
					<p>
						<a href="" class="thumbnail">
						  <img src='imagen.jsp?id=<%=new java.util.Date().getTime()%>' width="270">
						</a>
					</p>
					<p>
					</p>
					<p>
						<button class="btn btn-info fam" style="width:100%;"><i class="icon-user icon-white"></i> <fmt:message key="boton.DatosFam" /></button>
					</p>
				</div>
				    
				<div style="float:left;">
					
					 <div class="row">
					  <div class="span3">
					  		<address>
							  <strong><fmt:message key="aca.Matricula" /></strong><br>
							  <input type="hidden" name="matricula" id="matricula" value="<%=codigoId %>"><%=codigoId %><%session.setAttribute("mat",codigoId);%>
							</address>
					  </div>
					
					   <div class="span3">
					  		<address>
							  <strong><fmt:message key="aca.Telefono" /></strong><br>
							  <input type="hidden" name="telefono" id="telefono" value="<%=alumPersonal.getTelefono() %>"><%=alumPersonal.getTelefono() %>
							</address>
					   </div>
					</div>
					
					<div class="row">
					  <div class="span3">
						   	<address>
							  <strong><fmt:message key="aca.Nombre" /></strong><br>
							  <input type="hidden" name="nombre" id="nombre" value="<%=alumPersonal.getNombre() %>">
							  <input type="hidden" name="aPaterno" id="nombre" value="<%=alumPersonal.getApaterno() %>">
							  <input type="hidden" name="aMaterno" id="nombre" value="<%=alumPersonal.getAmaterno() %>">
							  <%=alumPersonal.getNombre() %> <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %>
							</address>
					  </div>
					  <div class="span3">
					  		<address>
							  <strong><fmt:message key="aca.Correo" /></strong><br>
							  <input type="hidden" name="email" id="email" value="<%=alumPersonal.getEmail()%>"><%=alumPersonal.getEmail()%>
							</address>
					  </div>
					</div>
					
					<div class="row">
					  <div class="span3">
						   	<address>
							  <strong><fmt:message key="aca.Direccion" /></strong><br>
							  <input type="hidden" name="direccion" id="direccion" value="<%=alumPersonal.getDireccion()%>"><input type="hidden" name="colonia" id="colonia" value="<%=alumPersonal.getColonia() %>"><%=alumPersonal.getDireccion() %> Col. <%=alumPersonal.getColonia() %>
							</address>
					  </div>
					  <div class="span3">
					  		<address>
							  <strong><fmt:message key="aca.CURP" /></strong><br>
							  <input type="hidden" name="curp" id="curp" value="<%=alumPersonal.getCurp() %>"><%=alumPersonal.getCurp() %>
							</address>
					  </div>
					</div>
					
					<div class="row">
					  <div class="span3">
						   <address>
							  <strong><fmt:message key="aca.Genero" /></strong><br>
							  <input type="hidden" name="sexo" id="sexo" value="<%=alumPersonal.getGenero() %>"><%=alumPersonal.getGenero().equals("M") ? "Hombre" : "Mujer" %>
							</address>
					  </div>
					  <div class="span3">
					  		<address>
							  <strong><fmt:message key="catalogo.Nivel" /></strong><br>
							  <input type="hidden" name="nivelId" id="nivelId" value="<%=Integer.parseInt(alumPersonal.getNivelId())%>">
							  <%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, alumPersonal.getNivelId()) %>
							</address>
					  </div>
					</div>
					
					<div class="row">
					  <div class="span3">
						   <address>
							  <strong><fmt:message key="aca.FechadeNacimiento" /></strong><br>
							  <input type="hidden" name="FNacimiento" id="FNacimiento" value="<%=alumPersonal.getFNacimiento() %>"><%=alumPersonal.getFNacimiento() %>
							</address>
					  </div>
					  <div class="span3">
					  		<address>
							  <strong><fmt:message key="aca.Grado" /></strong><br>
							  <input type="hidden" name="grado" id="grado" value="<%=alumPersonal.getGrado() %>" ><%=alumPersonal.getGrado() %>°
							</address>
					  </div>
					</div>
					
					<div class="row">
					  <div class="span3">
						    <address>
							  <strong><fmt:message key="aca.ACFE" /></strong><br>
							  <input type="hidden" name="acfe" id="acfe" value="<%=alumPersonal.getClasfinId()  %>" ><%=acfe%>
							</address>
					  </div>
					  <div class="span3">
					  		<address>
							  <strong><fmt:message key="aca.Grupo" /></strong><br>
							  <input type="hidden" name="grupo" id="grupo" value="<%=alumPersonal.getGrupo() %>"><%=alumPersonal.getGrupo() %>
							</address>
					  </div>
					</div>
					
					<div class="row">
					  <div class="span3">
						    <address>
							  <strong><fmt:message key="aca.Estado" /></strong><br>
							  <%  boolean inscrito = aca.vista.AlumInscrito.estaInscrito(conElias, alumPersonal.getCodigoId()); %>
							  <input type="hidden" name="status" id="status"><%=inscrito ? "INSCRITO" : "NO INSCRITO"%>
							</address>
					  </div>
					</div>
				</div>
	</form>
<%  }%>

<script>

	function Datos(){
	    document.location = "familiares.jsp";
	}
	
	$('.fam').on('click', function(e){
			e.preventDefault();
			location.href='familiares.jsp';
	});
	
</script>


</div>
</body>

<%@ include file="../../cierra_elias.jsp" %>