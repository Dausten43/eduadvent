<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<jsp:useBean id="nivelU" scope="page" class="aca.catalogo.CatNivelLista"/>
<jsp:useBean id="nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<jsp:useBean id="empleadoU" scope="page" class="aca.empleado.EmpPersonalLista"/>

<script>
	function grabar(){
		if(document.forma.notaminima.value!=""){
			document.forma.Accion.value="1";
			document.forma.submit();
		}else{
			alert("Favor de especificar una nota mínima");
		}
	}
</script>
<%
	String escuela 	= (String)session.getAttribute("escuela");
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	String salto 	= "X";
	
	if(accion.equals("1")){//grabar
		nivel.setEscuelaId(escuela);
		nivel.setNivelId(request.getParameter("nivelId"));
		nivel.setNivelNombre(request.getParameter("nombre"));
		nivel.setTitulo(request.getParameter("titulo"));
		nivel.setGradoIni(request.getParameter("gradoIni"));
		nivel.setGradoFin(request.getParameter("gradoFin"));
		nivel.setNotaminima(request.getParameter("notaminima"));
		nivel.setPeso("1");
		nivel.setFuncionId(request.getParameter("funcionId"));
		nivel.setDirector(request.getParameter("director"));
		nivel.setRegistro(request.getParameter("registro"));
		
		if(nivel.existeReg(conElias)){
			if(nivel.updateReg(conElias)){
				msj = "Modificado";
				salto = "nivel.jsp";
			}else{
				msj = "NoModifico";
			}
			accion = "2";
		}else{
			if(nivel.insertReg(conElias)){
				msj = "Guardado";				
				salto = "nivel.jsp";
			}else{
				msj = "NoGuardo";
			}
		}
	}else if(accion.equals("2")){
		nivel.mapeaRegId(conElias, request.getParameter("nivelId"), escuela);
	}
	

	pageContext.setAttribute("resultado", msj);
	
	ArrayList<aca.catalogo.CatNivel> niveles = nivelU.getListAll(conElias," WHERE NIVEL_ID NOT IN(SELECT NIVEL_ID FROM CAT_NIVEL_ESCUELA WHERE ESCUELA_ID='"+escuela+"')  ORDER BY NIVEL_ID");
	ArrayList<aca.empleado.EmpPersonal> lisEmpleados = empleadoU.getListEmp(conElias, escuela,"AND ESTADO = 'A' ");
%>

<div id="content">
 	

<h2><fmt:message key="catalogo.AnadirNivel" /></h2>

<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
	<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
<% }else if(!msj.equals("")){%>
	<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
<%} %>

<%if(niveles.size()>0 || accion.equals("2")){ %>
	
	<div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="nivel.jsp"><i class="icon-arrow-left icon-white"></i>&nbsp;<fmt:message key="boton.Regresar" /></a>
	</div>		

	<form method="post" action="accion.jsp" name="forma">
		<input type="hidden" name="Accion">
		
		<fieldset>
			<label for="nivel">
		       	<fmt:message key="catalogo.Nivel" />
		    </label>
	        <%if(accion.equals("2")){ %>
				<select name="nivelId" id="nivelId" class="input-mini" readonly>
					<option value="<%=nivel.getNivelId() %>"><%=nivel.getNivelId() %></option>
				</select>
			<%}else{ %>
				<select name="nivelId" id="nivelId" class="input-mini">
					<%for(aca.catalogo.CatNivel lvl: niveles){%>
						<option value="<%=lvl.getNivelId() %>"><%=lvl.getNivelId() %></option>
					<%} %>
				</select>
			<%} %>
		</fieldset>
		
		<fieldset>
		    <label for="nombre">
		       	<fmt:message key="aca.Nombre" />
		    </label>
		    <input value="<%=nivel.getNivelNombre() %>" name="nombre" id="nombre" type="text"/>
		</fieldset>
		
		<fieldset>
		    <label for="titulo">
		       	<fmt:message key="aca.TituloPeriodo" /> 
		    </label>
		    <select name="titulo" id="titulo" class="input-medium">
		    	<option value="Grado" <%if(nivel.getTitulo().equals("Grado")){out.print("selected");} %>><fmt:message key="aca.Grado" /></option>		    			
		    	<option value="Semestre" <%if(nivel.getTitulo().equals("Semestre")){out.print("selected");} %>><fmt:message key="aca.Semestre" /></option>
		    	<option value="Cuatrimestre" <%if(nivel.getTitulo().equals("Cuatrimestre")){out.print("selected");} %>><fmt:message key="aca.Cuatrimestre" /></option>
		    	<option value="Trimestre" <%if(nivel.getTitulo().equals("Trimestre")){out.print("selected");} %>><fmt:message key="aca.Trimestre" /></option>
		    </select>
		</fieldset>
		
		<fieldset>
		    <label for="gradoIni">
		    	<span class="grado"><fmt:message key="aca.Grado"/> <fmt:message key="aca.Inicial"/></span>
		    	<span class="semestre"><fmt:message key="aca.Semestre"/> <fmt:message key="aca.Inicial"/></span>
		    	<span class="trimestre"><fmt:message key="aca.Trimestre"/> <fmt:message key="aca.Inicial"/></span>
		    	<span class="cuatrimestre"><fmt:message key="aca.Cuatrimestre"/> <fmt:message key="aca.Inicial"/></span>
		    </label>
		    <select name="gradoIni" id="gradoIni" class="input-mini">
		    	<%for(int i = 1; i<=12; i++){ %>
		    		<option value="<%=i %>" <%if(nivel.getGradoIni().equals(i+"")){out.print("selected");} %>><%=i %></option>
		    	<%} %>
		    </select>
		</fieldset>
		
		<fieldset>
		    <label for="gradoFin">
		       	<span class="grado"><fmt:message key="aca.Grado"/> <fmt:message key="aca.Final"/></span>
		    	<span class="semestre"><fmt:message key="aca.Semestre"/> <fmt:message key="aca.Final"/></span>
		    	<span class="trimestre"><fmt:message key="aca.Trimestre"/> <fmt:message key="aca.Final"/></span>
		    	<span class="cuatrimestre"><fmt:message key="aca.Cuatrimestre"/> <fmt:message key="aca.Final"/></span>
		    </label>
		    <select name="gradoFin" id="gradoFin" class="input-mini">
		    	<%for(int i = 1; i<=12; i++){ %>
		    		<option value="<%=i %>" <%if(nivel.getGradoFin().equals(i+"")){out.print("selected");} %>><%=i %></option>
		    	<%} %>
		    </select>
		</fieldset>
		
		<fieldset>
		    <label for="notaminima">
		       	<fmt:message key="aca.NotaMin" />
		    </label>
		    <select name="notaminima" id="notaminima" class="input-mini">
		    	<%for(int i = 0; i<=10; i++){ %>
		    		<option value="<%=i %>" <%if(nivel.getNotaminima().equals(i+"")){out.print("selected");} %>><%=i %></option>
		    	<%} %>
		    </select>
		</fieldset>
		
		<fieldset>
		    <label for="funcionId">
		       	<fmt:message key="aca.Funcion" />
		    </label>
		    <input value="<%=nivel.getFuncionId() %>" name="funcionId" id="funcionId" type="text" maxlength="10" />
		</fieldset>
		
		<fieldset>
		    <label for="director">
		       	<fmt:message key="aca.Director" /> 
		    </label>
		    <select name="director" id="director" class="input input-xlarge"> 			
				<%for(aca.empleado.EmpPersonal empleado: lisEmpleados){%>
					<option value="<%=empleado.getCodigoId()%>" <%
					if(nivel.getDirector() != null ){
						if(nivel.getDirector().equals(empleado.getCodigoId())){
							out.print("selected");
						}
					}
					%>>
						<%=empleado.getNombre()+" "+empleado.getApaterno()+" "+empleado.getAmaterno() %>
					</option>
				<%} %>
			</select>
		</fieldset>
		
		<fieldset>
		    <label for="registro">
		       	<fmt:message key="aca.Registro" />
		    </label>
		    <input value="<%=nivel.getRegistro()%>" name="registro" id="registro" type="text" maxlength="30" />
		</fieldset>
		
		<div class="well">
			<a class="btn btn-primary btn-large" onclick="grabar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
	    </div>	
	</form>

	<%
		nivel.setEscuelaId(escuela);
		nivel.setNivelId(request.getParameter("nivelId"));
		nivel.setNotaminima(request.getParameter("notaminima"));
		
		
		if(!nivel.existeReg(conElias)){
	%>
			<script>
				
				var nombre 		= $('#nombre');
				var titulo 		= $('#titulo');
				var gradoIni 	= $('#gradoIni');
				var gradoFin 	= $('#gradoFin');
				var notaminima 	= $('#notaminima');
			
				function getSugerencias(nivelId){
					var e = document.getElementById("nivelId");    
					var value = e.options[e.selectedIndex].value;
					
					$.get('getSugerencias.jsp?NivelId='+value, function(r){
						var rs = $($.trim(r));
						
						nombre.val(rs.find('.nombre').html());
						titulo.val(rs.find('.titulo').html());
						gradoIni.val(rs.find('.gradoIni').html());
						gradoFin.val(rs.find('.gradoFin').html());
						notaminima.val(rs.find('.notaMinima').html());
					});
				}
				
				$('#nivelId').change(function(){
					getSugerencias();	
				});
				getSugerencias();
				
				
			</script>
	<%
		}
	%>
	
	
	<script>
		/* CAMBIAR GRADO Y SEMESTRE DEPENDIENDO CUAL ELIJAN */
		var tipo = $('#titulo');
		var grado = $('.grado');
		var semestre = $('.semestre').hide();
		var trimestre = $('.trimestre').hide();
		var cuatrimestre = $('.cuatrimestre').hide();
		
		function cambiarTipo(){
			
			if(tipo.val() == 'Grado'){
				grado.show();				
				semestre.hide();
				trimestre.hide();
				cuatrimestre.hide();
			}else if (tipo.val() == 'Semestre'){
				grado.hide();
				semestre.show();
				trimestre.hide();
				cuatrimestre.hide();
			}else if (tipo.val() == 'Trimestre'){
				grado.hide();
				semestre.hide();
				trimestre.show();
				cuatrimestre.hide();
			}else{
				grado.hide();
				semestre.hide();
				trimestre.hide();
				cuatrimestre.show();
			}
		}
		
		cambiarTipo();
		tipo.on('change', function(){
			cambiarTipo();
		});
	</script>


<%} else{ %>
	<div class='alert'>
		<fmt:message key="aca.NoMasDisp" />
	</div>

<%} %>
</div>
<% 	if (!salto.equals("X")){%>
	<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %> 
