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
			<label for="cicloid">Buscar por:</label>
			<select id="tipo_busqueda">
				<option value="G" selected>Grupo</option>
				<option value="M">Matr�cula</option>
			</select>
		</section>
	</div>
	
	<div id="form_grid" class="container-fluid">
		<section class="busqueda_grupo">
			<form>
				<div id="cicloSelect">
					<label for="cicloid">Ciclo:</label>
					<select name="ciclo_id" id="cicloid" style="width: 350px;">
						<option value="">Seleccione un ciclo</option>
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
				
				<div id="grupoButtonSelect">
					<input type="button" id="btnListAlm" onclick="cargaListaAlumnos();" value="Listar Alumnos">
				</div>
			</form>
		</section>
		<section class="busqueda_matricula">
			<form name="frmEstado" id="frmEstado" method="post"	action="http://localhost:8082/kardex/pdf" target="_new">
			
				<div id="matriculaSelect">
					<label for="codigoid">C�digo(s) Alumno:</label> 
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
				<div id="kardexButtonUp">
					<input type="submit" name="enviar" value="Generar">
				</div>
				
				<div id="modeloSelect">
					<label>Modelo de Certificado</label>
					<select name="modelo">
						<option value="3">Primaria incompleta</option>
						<option value="2">Educaci�n b�sica primaria</option>
						<option value="5">Premedia incompleta</option>
						<option value="6">Educaci�n b�sica general</option>
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
		$('#btnListAlm').attr("disabled", true);

		$('#codigoid').keyup(function(e){
			
			var codigoid = $(this).val();
			console.log(codigoid);
			if(codigoid!=''){
				
				$('#cicloSelect').hide();
				$('#nivelSelect').hide();
				$('#gradoSelect').hide();
				$('#grupoSelect').hide();
				$('#btnListAlm').attr("disabled", true);
			}else{
				$('#cicloSelect').show();
			}
		});	
		
		$('#cicloid').each(function(e) {
			
			var cicloSelected = $(this).val();
			
			if(cicloSelected!=''){
				var datadata = 'ciclo_id='+ cicloSelected + '&getniveles=true';
				console.log(datadata);
				//Make AJAX request, using the selected value as the GET
	            $.ajax({url: 'ajaxCombos.jsp',
	                type: "post",
	                data: datadata,
	                success: function (output) {
	                    //alert(output);
	                    $('#nivelid').html(output);
	                    $('#nivelSelect').show();
	                },
	                error: function (xhr, ajaxOptions, thrownError) {
	                    alert(xhr.status + " " + thrownError);
	                }
	            });
			}else{
				$('#nivelSelect').hide();
				$('#gradoSelect').hide();
				$('#grupoSelect').hide();
				$('#btnListAlm').attr("disabled", true);
			}
			
	
		});
	
		$('#cicloid').change(function(e) {
			
			$('#gradoSelect').hide();
			$('#grupoSelect').hide();
			
			var cicloSelected = $(this).val();
			
			if(cicloSelected!=''){
				var datadata = 'ciclo_id='+ cicloSelected + '&getniveles=true';
				//Make AJAX request, using the selected value as the GET
				console.log(datadata);
		           $.ajax({url: 'ajaxCombos.jsp',
		               type: "post",
		               data: datadata,
		               success: function (output) {
		                   //alert(output);
		                   $('#nivelid').html(output);
		                   $('#nivelSelect').show();
		               },
		               error: function (xhr, ajaxOptions, thrownError) {
		                   alert(xhr.status + " " + thrownError);
		               }
		           });
			}else{
				$('#nivelSelect').hide();
				$('#gradoSelect').hide();
				$('#grupoSelect').hide();
				$('#btnListAlm').attr("disabled", true);
			}
				
		
		});
	
		$('#nivelid').change(function(e) {
			
			$('#grupoSelect').hide();
			
			var cicloSelected = $('#cicloid').val();
			var nivelSelected = $(this).val();
			
			if(nivelSelected!=''){
				var datadata = 'nivel_id='+ nivelSelected + '&ciclo_id=' + cicloSelected + '&getgrados=true';
				//Make AJAX request, using the selected value as the GET
				console.log(datadata);
		        $.ajax({url: 'ajaxCombos.jsp',
		            type: "post",
		            data: datadata,
		            success: function (output) {
		                //alert(output);
		                $('#gradoid').html(output);
		                $('#gradoSelect').show();
		            },
		            error: function (xhr, ajaxOptions, thrownError) {
		                alert(xhr.status + " " + thrownError);
		            }
		        });
			}else{
				//$('#nivelSelect').hide();
				$('#gradoSelect').hide();
				$('#grupoSelect').hide();
				$('#btnListAlm').attr("disabled", true);
			}
		});

		$('#gradoid').change(function(e) {
			
			var cicloSelected = $('#cicloid').val();
			var nivelSelected = $('#nivelid').val();
			var gradoSelected = $(this).val();
			
			if(gradoSelected!=''){
				var datadata = 'nivel_id='+ nivelSelected + '&ciclo_id=' + cicloSelected + '&grado_id=' + gradoSelected + '&getgrupos=true';
				//Make AJAX request, using the selected value as the GET
				console.log(datadata);
		        $.ajax({url: 'ajaxCombos.jsp',
		            type: "post",
		            data: datadata,
		            success: function (output) {
		                //alert(output);
		                $('#grupoid').html(output);
		                $('#grupoSelect').show();
		                $('#btnListAlm').attr("disabled", false);
		            },
		            error: function (xhr, ajaxOptions, thrownError) {
		                alert(xhr.status + " " + thrownError);
		            }
		        });
			}else{
				//$('#nivelSelect').hide();
				//$('#gradoSelect').hide();
				$('#grupoSelect').hide();
				$('#btnListAlm').attr("disabled", true);
			}
			
		
		});
		
		$('#tipo_busqueda').change(function(e){
			$('#matriculaSelect').toggle();
			$('.busqueda_grupo').toggle();
			
			var tipo = $('#tipo_busqueda').val();
			if(tipo === 'M'){
				$('#alumList').html('');
				$('#kardexButtonDown').hide();
			}
			else if(tipo === 'G'){
				$('.chosen').val('').trigger("chosen:updated");
			}
		});

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
			console.log(datadata);
			
				$.ajax({url: 'ajaxListado.jsp',
		        type: "post",
		        data: datadata,
		        success: function (output) {
		            //alert(output);
		            $('#alumList').html(output);
		            $('#kardexButtonDown').show();
		            
		        },
		        error: function (xhr, ajaxOptions, thrownError) {
		            alert(xhr.status + " " + thrownError);
		        }
		    });
			
			
		}


		function selecciona(elemento){
			if( $(elemento).is(':checked')){
				console.log('checados');
				$('.alumnos').prop('checked',true);
			}else{
				console.log('no checados');
				$('.alumnos').prop('checked',false);
			}
		}
	</script>
</div>
<%@ include file="../../cierra_elias.jsp"%>