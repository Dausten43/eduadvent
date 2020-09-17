<%@page import="aca.alumno.AlumPersonalLista"%>
<%@page import="java.util.Collections"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="CicloLista" scope="page" class="aca.alumno.AlumCicloLista" />
<link rel="stylesheet" href="../../js/chosen/chosen.css"  />
<link rel="stylesheet" href="../../css/certificados.css"  />
<%
String escuelaId = (String) session.getAttribute("escuela");

String ciclo = request.getParameter("ciclo") == null
					? aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId)
					: request.getParameter("ciclo");

//Lista de ciclos activos en la escuela
ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
%>
<div id="content">
	<h2>Generador de certificados</h2>
	<div class="well">
		<section class="tipo_busqueda">
			<label for="cicloid" style="display: inline;">Buscar por:</label>
			<select id="tipo_busqueda">
				<option value="G" selected>Grupo</option>
				<option value="M">Matrícula</option>
			</select>
		</section>
	</div>
	
	<div id="form_grid" class="container-fluid">
		<section class="busqueda_grupo">
			<form>
				<div id="cicloSelect">
					<label for="cicloid">Ciclo:</label>
					<select name="ciclo_id" id="cicloid">
						<option disabled value="">Seleccione un ciclo</option>
						<%
							Collections.reverse(lisCiclo);
								for (aca.ciclo.Ciclo c : lisCiclo) {
						%>
						<option value="<%=c.getCicloId()%>"
							<%=c.getCicloId().equals(ciclo) ? " Selected" : ""%>><%=c.getCicloNombre()%></option>
						<%
							}
						%>
					</select>
				</div>
				
				<div id="nivelSelect">
					<label for="nivel_id">Nivel:</label>
					<select name="nivel_id" id="nivelid">
						<option value=""></option>
					</select>
				</div>
				
				<div id="gradoSelect">
					<label for="gradoid">Grado:</label>
					<select name="grado_id" id="gradoid">
						<option></option>
					</select>
				</div>
				
				<div id="grupoSelect">
					<label for="grupoid">Grupo:</label>
					<select name="grupo_id" id="grupoid">
						<option></option>
					</select>
				</div>
			</form>
		</section>
		<section class="busqueda_matricula">
			<form name="frmEstado" id="frmEstado" method="post"	action="/reportes/kardex/pdf" target="_new">
			
				<div id="matriculaSelect">
					<label for="codigoid">Código(s) Alumno:</label> 
					<select multiple="multiple" name="matricula" id="matricula" class="chosen" >
					<%
					AlumPersonalLista ap = new AlumPersonalLista();
					
						Map<String, AlumPersonal> mapAlumEscuela = new HashMap();
						mapAlumEscuela.putAll(ap.getLsAlumEscuela(conElias, escuelaId));
						for(String codigo : mapAlumEscuela.keySet()){
					%>
						<option value="<%= codigo%>"><%= mapAlumEscuela.get(codigo).getCodigoId() %> <%= mapAlumEscuela.get(codigo).getNombre() + " " + mapAlumEscuela.get(codigo).getApaterno() + " " + mapAlumEscuela.get(codigo).getAmaterno() %></option>
					<% } %>
					</select>
					
				</div>
				
				<div id="modeloSelect">
					<label>Modelo de Certificado</label>
					<select name="modelo">
						<option value="3">Primaria incompleta</option>
						<option value="2">Educación básica primaria</option>
						<option value="5">Premedia incompleta</option>
						<option value="6">Educación básica general</option>
						<option value="12">Premedia incompleta o media incompleta</option>
						<option value="11">Premedia incompleta y media incompleta</option>
						<option value="10">Premedia completa y media incompleta</option>
						<option value="7">Media incompleta</option>
						<option value="9">Media completa</option>
						<option value="8">Premedia y media completas</option>
						<!-- <option value="1">Normal</option> -->
						<!-- <option value="4">Premedia y Media</option> -->
					</select>
				</div>
				
				<div id="kardexButtonUp">
					<input type="submit" id="btnGenera" name="enviar" value="Generar">
				</div>
										
				<div id="alumList">
					<!-- Se rellena con la lista de alumnos al generarla -->
				</div>
				
				<div id="kardexButtonDown">
					<input type="submit" name="enviar" value="Generar">
				</div>
			</form>
		</section>
	</div>
	<script src="../../js/chosen/chosen.jquery.js" type="text/javascript"></script>
	<script>
		jQuery(".chosen").chosen({width: "50%"});

		$('#nivelSelect').hide();
		$('#gradoSelect').hide();
		$('#grupoSelect').hide();
		$('#matriculaSelect').hide();
		$('#kardexButtonDown').hide();
		$('#btnGenera').prop("disabled", true);

		// For defining the search type
		$('#tipo_busqueda').change(function(e){
			$('#matriculaSelect').toggle();
			$('.busqueda_grupo').toggle();
			
			var tipo = $('#tipo_busqueda').val();
			if(tipo === 'M'){
				$('#alumList').html('');
				$('#kardexButtonDown').hide();
				$('#btnGenera').prop("disabled", true);
			}
			else if(tipo === 'G'){
				$('.chosen').val('').trigger("chosen:updated");
				$('#btnGenera').prop("disabled", true);
			}
		});

		// For ids search
		$('#matricula').change(function(e) {
			var codigosid = $(this).val();
			if(codigosid) $('#btnGenera').prop("disabled", false);
			else $('#btnGenera').prop("disabled", true);
		});

		// For group search
		$('#cicloid').each(function(e) {
			refreshLevel(this);	
		});
	
		$('#cicloid').change(function(e) {
			$('#gradoSelect').hide();
			$('#grupoSelect').hide();
			
			refreshLevel(this);
		});
	
		$('#nivelid').change(function(e) {
			refreshGrade(this);
		});

		$('#gradoid').change(function(e) {			
			refreshGroup(this);
		});
		
		$('#grupoid').change(function(e) {
			cargaListaAlumnos();
		});
		
		function refreshLevel(cicle) {
			var cicloSelected = $(cicle).val();
			
			if(cicloSelected!=''){
				var datadata = 'ciclo_id='+ cicloSelected + '&getniveles=true';
		           $.ajax({url: 'ajaxCombos.jsp',
		               type: "post",
		               data: datadata,
		               success: function (output) {
		                   $('#nivelid').html(output);
		                   $('#nivelSelect').show();
		                   refreshGrade($('#nivelid'));
		               },
		               error: function (xhr, ajaxOptions, thrownError) {
		                   alert(xhr.status + " " + thrownError);
		               }
		           });
			}else{
				$('#nivelSelect').hide();
				$('#gradoSelect').hide();
				$('#grupoSelect').hide();
				$('#btnGenera').prop("disabled", true);
			}
		}

		function refreshGrade(level) {
			$('#grupoSelect').hide();
			
			var cicloSelected = $('#cicloid').val();
			var nivelSelected = $(level).val();
			
			if(nivelSelected!=''){
				var datadata = 'nivel_id='+ nivelSelected + '&ciclo_id=' + cicloSelected + '&getgrados=true';
		        $.ajax({url: 'ajaxCombos.jsp',
		            type: "post",
		            data: datadata,
		            success: function (output) {
		                $('#gradoid').html(output);
		                $('#gradoSelect').show();
		                refreshGroup($('#gradoid'));
		            },
		            error: function (xhr, ajaxOptions, thrownError) {
		                alert(xhr.status + " " + thrownError);
		            }
		        });
			}else{
				$('#gradoSelect').hide();
				$('#grupoSelect').hide();
				$('#btnGenera').prop("disabled", true);
			}
		}

		function refreshGroup(grade) {
			var cicloSelected = $('#cicloid').val();
			var nivelSelected = $('#nivelid').val();
			var gradoSelected = $(grade).val();
			
			if(gradoSelected!=''){
				var datadata = 'nivel_id='+ nivelSelected + '&ciclo_id=' + cicloSelected + '&grado_id=' + gradoSelected + '&getgrupos=true';
		        $.ajax({url: 'ajaxCombos.jsp',
		            type: "post",
		            data: datadata,
		            success: function (output) {
		                $('#grupoid').html(output);
		                $('#grupoSelect').show();
		                cargaListaAlumnos();
		                $('#btnGenera').prop("disabled", true);
		            },
		            error: function (xhr, ajaxOptions, thrownError) {
		                alert(xhr.status + " " + thrownError);
		            }
		        });
			}else{
				$('#grupoSelect').hide();
			}
		}

		function cargaListaAlumnos(){
			var cicloSelected = $('#cicloid').val();
			var nivelSelected = $('#nivelid').val();
			var gradoSelected = $('#gradoid').val();
			var grupoSelected = $('#grupoid').val();
			var datadata = 'nivel_id='+ nivelSelected + '&ciclo_id=' + cicloSelected ;
			if(gradoSelected!= undefined)
				datadata+= '&grado_id=' + gradoSelected;
			if(grupoSelected!= undefined)
				datadata+= '&grupo_id=' + grupoSelected;
			
				$.ajax({url: 'ajaxListado.jsp',
		        type: "post",
		        data: datadata,
		        success: function (output) {
		            $('#alumList').html(output);
		            $('#kardexButtonDown').show();
		            $('#btnGenera').prop("disabled", false);
		        },
		        error: function (xhr, ajaxOptions, thrownError) {
		            alert(xhr.status + " " + thrownError);
		        }
		    });
			
			
		}

		function selecciona(elemento){
			if( $(elemento).is(':checked'))
				$('.alumnos').prop('checked',true);
			else
				$('.alumnos').prop('checked',false);
		}
	</script>
</div>
<%@ include file="../../cierra_elias.jsp"%>