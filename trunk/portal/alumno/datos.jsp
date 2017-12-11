<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<%@ include file= "menuPortal.jsp" %>


<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<%
	String codigoId			= session.getAttribute("codigoId").toString();
	String escuelaId	= (String) session.getAttribute("escuela");
	String cicloIdM 	= (String) session.getAttribute("cicloId");
	
ArrayList<aca.ciclo.Ciclo> lisCiclo	= cicloLista.getListCiclosAlumno(conElias, codigoId, "ORDER BY CICLO_ID");
	
	//Verifica que el ciclo este en la lista de ciclo
	boolean encontro = false;
	for(aca.ciclo.Ciclo c : lisCiclo){
		if(cicloIdM != null && c.equals(cicloIdM)){
			encontro = true; break;
		}
	}
	
	// Elige el mejor ciclo para el alumno. 
	if( encontro==false && lisCiclo.size()>0 ){
		ciclo 	= (aca.ciclo.Ciclo) lisCiclo.get(lisCiclo.size()-1);
		cicloIdM = ciclo.getCicloId();
			
		session.setAttribute("cicloId", cicloIdM);
	}
	
	if( request.getParameter("ciclo") != null ){
		cicloIdM = request.getParameter("ciclo");
		session.setAttribute("cicloId", cicloIdM);
	}
	
	alumPersonal.mapeaRegId(conElias, codigoId);	
	
	session.setAttribute("mat",codigoId); 
	
	
	cicloGrupo.mapeaRegId(conElias,aca.kardex.KrdxCursoAct.getAlumGrupo(conElias,codigoId,cicloIdM)); 
	
	System.out.println("ciclo " + cicloGrupo.getCicloGrupoId() + " ---- " + cicloIdM + " ----  " + codigoId);
	
	System.out.println("Si llega a la 19");
%>


<div id="content">


<h2><fmt:message key="empleados.DatosPersonalesMin"/></h2>
<a href="mensaje.jsp?cicloGrupoId=<%= cicloGrupo.getCicloGrupoId() %>&codigoAlumno=<%= codigoId %>" id="msg-<%= codigoId %>" class="btn btn-info btn-mini"></a> <br />
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
			  <%=alumPersonal.getGrado() %>�
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
	
	$(function(){
		contarMensajesNuevos('<%= cicloGrupo.getCicloGrupoId() %>','<%= codigoId %>')
	})
	
	function contarMensajesNuevos(ciclogpoid, codigoid){
		var suma = 0;	
		var escuela = '<%= escuelaId %>';
		var ciclo = ciclogpoid.substring(0, 8);
		var tipodestino = '\'P\',\'I\',\'G\'';
		var datadataA = 'cuenta_msgs=true&destino=\''+codigoid+'\',\''+ciclogpoid+'\',\''+escuela+'\',\''+ciclo+'\'&tipodestino='+tipodestino+'&usuario='+codigoid;
		console.log(datadataA);
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
			type : 'post',
			data : datadataA,
			success : function(output) {
				suma += $.isNumeric(output) ? parseInt(output) : 0;
				$('#msg-'+codigoid).html(suma + ' Mensajes Nuevos');
				console.log('suma 1 ' + suma);
				if(suma>0){
					
					$('#msg-'+codigoid).css('btn-danger')
				}
				$('#msg-'+codigoid).css('')
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
		
	}

</script>
	
</script>
<%@ include file="../../cierra_elias.jsp" %>