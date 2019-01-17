<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>


<jsp:useBean id="PlanLista" class="aca.plan.PlanLista" scope="page" />
<jsp:useBean id="CicloLista" class="aca.ciclo.CicloLista" scope="page" />
<jsp:useBean id="AlumLista" class="aca.alumno.AlumPersonalLista" scope="page" />
<jsp:useBean id="Alum" class="aca.alumno.AlumPersonal" scope="page" />
<jsp:useBean id="AlumPlan" class="aca.alumno.AlumPlan" scope="page" />

<script>

	function Promover() {
		if (document.formBuscar.PlanId2.value != "Selecciona" && document.formBuscar.grado2 != null && document.formBuscar.grupo2 != null) {
			document.formBuscar.Accion.value = "2";
			document.formBuscar.submit();
		} else {
			alert("<fmt:message key="aca.CompletaCampos"/>");
		}
	}

	function seleccionarTodos(CheckAll) {
		var inputs = document.getElementsByTagName("INPUT");
		for (i = 0; i < inputs.length; i++) {
			if (inputs[i].type == "checkbox") {
				inputs[i].checked = CheckAll.checked;
			}
		}
	}
</script>

<%
	String escuelaId	= (String) session.getAttribute("escuela");
	String fecha 		= aca.util.Fecha.getHoy();
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String ciclo			= request.getParameter("ciclo");	
	String planId	 		= request.getParameter("PlanId")==null?"Selecciona":request.getParameter("PlanId");
	String grado	 		= request.getParameter("grado")==null?"":request.getParameter("grado");
	String grupo	 		= request.getParameter("grupo")==null?"":request.getParameter("grupo").toUpperCase();
	
	String planId2	 		= request.getParameter("PlanId2")==null?"Selecciona":request.getParameter("PlanId2");
	String grado2	 		= request.getParameter("grado2")==null?"":request.getParameter("grado2");
	String grupo2	 		= request.getParameter("grupo2")==null?"":request.getParameter("grupo2").toUpperCase();	
	
	int cont 				= 0;
	int num 				= 0;
	int contadorArreglo 	= 0;	
	
	String nivelId			= "0";
	String sResultado		= "";
	
	ArrayList<aca.plan.Plan> lisPlan		= PlanLista.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID");
	ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, " ORDER BY CICLO_ID");
	String [] arreglo 						= new String[0];// arreglo para guardar codigos_id a promover
	
	
%>
<div id="content">
		<input type="hidden" name="Accion">
		<h3><fmt:message key="aca.PromoverAlumnos" /></h3>
   		<div class='alert alert-info' id="info"><fmt:message key="aca.InstruccionPromover" /></div>
   		<div class='alert alert-success' id="Resultado"></div>
		<hr>
		
		<div class="row">
			<div class="span4">
			<h4><fmt:message key="aca.BuscarAlumnos" /></h4>
				<form action="promover.jsp" method="post" name="formBuscar">
				<fieldset>
					<label><fmt:message key="aca.Ciclo" /></label> 
					<select name="ciclo" id="ciclo" style="width: 310px;">
						<option value="" selected><fmt:message key="aca.SeleccionaCiclo" /></option>
						<%for(aca.ciclo.Ciclo cic : lisCiclo){%>
							<option value="<%=cic.getCicloId() %>" <%if (cic.getCicloId().equals(ciclo)){ out.print("selected"); } %>><%=cic.getCicloNombre() %></option>
						<%}%>
					</select>
				</fieldset>
				<fieldset>
					<label> <fmt:message key="aca.Plan"/> </label>
					<select name="PlanId" id="PlanId">
						<option value="" selected><fmt:message key="aca.SeleccionaPlan" /></option>
						<%for(aca.plan.Plan plan : lisPlan){%>
							<option value="<%=plan.getPlanId() %>" <%if (plan.getPlanId().equals(planId)){ out.print("selected"); } %>><%=plan.getPlanNombre() %></option>
						<%} %>	
					</select>
				</fieldset>
				<fieldset>
					<label> <fmt:message key="aca.Grado" /> </label> 
					<select name="grado" id="grado">
						<option value="" selected><fmt:message key="aca.SeleccionaGdo" /></option>
					</select>
				</fieldset>
				<fieldset>	
					<label> <fmt:message key="aca.Grupo" /> </label> 
					<select name="grupo" id="grupo">
						<option value="" selected><fmt:message key="aca.SeleccionaGpo" /></option>
					</select>
				</fieldset>
				
				<div class="well">
					<a class="btn btn-primary" id="buscar" >
						<i class="icon-search icon-white"></i> <fmt:message key="boton.Buscar" />
					</a>
				</div>
				</form>
				
			</div>
			
			<div class="span4" id="tablaAlum"></div>
		
			<div class="span4" id="Promover">
				<h4><fmt:message key="aca.PromoverA" /></h4>
				
				<form action="promover.jsp" method="post" name="formPromover">
				
				<fieldset>
					<label><fmt:message key="aca.Plan" /></label>
					<select name="PlanId2" id="PlanId2">
						<option value="" selected><fmt:message key="aca.SeleccionaPlan" /></option>
						<%for(aca.plan.Plan plan : lisPlan){%>
							<option value="<%=plan.getPlanId() %>" <%if (plan.getPlanId().equals(planId2)){ out.print("selected"); } %>><%=plan.getPlanNombre() %></option>
						<%} %>
					</select>
				</fieldset>
				
				<fieldset>
					<label><fmt:message key="aca.Grado" /></label>
					<select name="grado2" id="grado2">
						<option value="" selected><fmt:message key="aca.SeleccionaGdo" /></option>
					</select>
				</fieldset>
				
				<fieldset>
					<label><fmt:message key="aca.Grupo" /></label>
					<select name="grupo2" id="grupo2">
						<option value="" selected><fmt:message key="aca.SeleccionaGpo" /></option>
					</select>
				</fieldset>
				
				
				<br>
				<br>
				<br>
				
				<div class="well">
					<a class="btn btn-primary" id="promover">
						<i class="icon icon-ok icon-white"></i> <fmt:message key="boton.Promovers" />
					</a>
				</div>
				</form>
				
			</div>
		</div>
		
</div>


<script>

	$('#Promover').hide();
	$('#Resultado').hide();
	
	$('#ciclo').change(function (){
		$('#PlanId').html('<option>Actualizando</option>');
		
		var accion = '1';
		var actualizar = 'plan';
		var ciclo = document.formBuscar.ciclo.value;
		var dataSend = 'Accion='+accion+'&Actualizar='+actualizar+'&ciclo='+ciclo;
		
		$.get('getPlanes.jsp?' + dataSend, function(data) {
			$("#PlanId").html(data);
			fnRefreshGrade();
		});
	});
	
	$('#PlanId').change(function(){
	
		fnRefreshGrade();
	});
		
	function fnRefreshGrade(){
		jQuery('#grado').html('<option>Actualizando</option>');

		var accion = '1';
		var actualizar = 'grado';
		var plan = document.formBuscar.PlanId.value;
		var dataSend = 'Accion='+accion+'&Actualizar='+actualizar+"&PlanId="+plan+"&escuelaId="+'<%=escuelaId%>';
		
		jQuery.get('getPlanes.jsp?' + dataSend, function(data) {
			jQuery("#grado").html(data);
			fnRefreshGroup();
		});
	}
	
	$('#grado').change(function(){
		fnRefreshGroup();
	});
		
	function fnRefreshGroup(){
		jQuery('#grupo').html('<option>Actualizando</option>');
		
		var accion = '1';
		var actualizar = 'grupo';
		var ciclo = document.formBuscar.ciclo.value;
		var plan = document.formBuscar.PlanId.value;
		var grado = document.formBuscar.grado.value;
		var dataSend = 'Accion='+accion+'&Actualizar='+actualizar+"&ciclo="+ciclo+"&PlanId="+plan+"&grado="+grado+"&escuelaId="+'<%=escuelaId%>';
		
		jQuery.get('getPlanes.jsp?' + dataSend, function(data){
			jQuery("#grupo").html('<option value=""> - </option>');
			jQuery("#grupo").append(data);
		});
	}
	
	
	
	$('#PlanId2').change(function(){
		
		fnRefreshGrade2();
	});
		
	function fnRefreshGrade2(){
		jQuery('#grado2').html('<option>Actualizando</option>');
	
		var accion = '2';
		var actualizar = 'grado';
		var plan = document.formPromover.PlanId2.value;
		var dataSend = "Accion="+accion+"&Actualizar="+actualizar+"&PlanId="+plan+"&escuelaId="+'<%=escuelaId%>';
		
		jQuery.get('getPlanes.jsp?' + dataSend, function(data) {
			jQuery("#grado2").html(data);
			fnRefreshGroup2();
		});
	}
	
	$('#grado2').change(function(){
		
		fnRefreshGroup2();
	});
		
	function fnRefreshGroup2(){
		jQuery('#grupo2').html('<option>Actualizando</option>');
		
		var accion = '2';
		var actualizar = 'grupo2';
		var ciclo = document.formBuscar.ciclo.value;
		var plan = document.formPromover.PlanId2.value;
		var grado = document.formPromover.grado2.value;
		var dataSend = "Accion="+accion+"&Actualizar="+actualizar+"&ciclo="+ciclo+"&PlanId="+plan+"&grado="+grado+"&escuelaId="+'<%=escuelaId%>';
		
		jQuery.get('getPlanes.jsp?' + dataSend, function(data) {
			jQuery("#grupo2").html(data);
		});
	}
	
	$('#buscar').click(function(){
		if($('#ciclo').val()==""){
			alert("<fmt:message key='aca.SeleccionaCiclo'/>.");
		}else{
			var $accion = '1';
			var $ciclo = document.formBuscar.ciclo.value;
			var $planId = document.formBuscar.PlanId.value;
			var $grado = document.formBuscar.grado.value;
			var $grupo = document.formBuscar.grupo.value;
			var dataSend = {Accion:$accion,
							ciclo:$ciclo,
							PlanId:$planId,
							grado:$grado,
							grupo:$grupo};
			
			$.get('ajaxPromover.jsp?'+$.param(dataSend), function(data){
				$("#tablaAlum").html(data);
				$('#Resultado').hide();
				$('#Promover').show();
			});
		}
	});
	
	
	$('#promover').click(function(){
		if($('#PlanId2').val()==""){
			alert("<fmt:message key='aca.SeleccionaPlan'/>.");
		}else{
			// Se obtienen los datos del formulario
			var $accion = '2'; // Promover
			var $ciclo = document.formBuscar.ciclo.value;
			var $planId = document.getElementById('planId').value;
			var $grado = document.formBuscar.grado.value;
			var $grupo = document.formBuscar.grupo.value;
			var $planId2 = document.formPromover.PlanId2.value;
			var $grado2 = document.formPromover.grado2.value;
			var $grupo2 = document.formPromover.grupo2.value;
			
			// Se crea una lista con los codigos de los alumnos a promover
			var $listaAlumnos = [];
			$(':checkbox[name=Alum]').each(function(){
				if(this.checked){
					$listaAlumnos.push($(this).val());	
				}
			});
			// Parámetros a enviar
			var dataSend = { Accion:$accion, 
							 ciclo:$ciclo, 
							 PlanId:$planId, 
							 grado:$grado, 
							 grupo:$grupo,
							 PlanId2:$planId2, 
							 grado2:$grado2, 
							 grupo2:$grupo2, 
							 alumnos:$listaAlumnos };
			
			// Verifica que se hayan seleccionado alumnos
			if($listaAlumnos.length){
				
				// Se envian los parametros al jsp
				jQuery.get('ajaxPromover.jsp?'+$.param(dataSend), function(data){
					// Se añade la lista de alumnos al HTML
					jQuery("#tablaAlum").html(data);
					if(continuar){
						jQuery.get('ajaxPromover.jsp?continuar=1&'+$.param(dataSend), function(data){
							$("#tablaAlum").html(data);
						    var result = $('#result').val();
							if(result=="1"){
						    	$('#Resultado').html("<fmt:message key='aca.Guardado'/>");
							} else if(result=="2"){ 
								$('#Resultado').html("<fmt:message key='aca.NoGuardo'/>");
						    	$('#Resultado').attr('class', 'alert alert-danger');
							}					    
					    	$('#Resultado').show();
						});
					}
				});
			} else {
				alert("<fmt:message key='aca.NoAlumnoSeleccionado'/>.");
			}
		}
		});
	
</script>
<%@ include file="../../cierra_elias.jsp"%>
