<%@page import="aca.ciclo.CicloGrupo"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.kardex.KrdxAlumObs"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kardex.UtilKrdxAlumObs"%>
<%@page import="java.util.List"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%> 
<jsp:useBean id="krdxCursoActL" scope="page"
	class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="empPersonal" scope="page"
	class="aca.empleado.EmpPersonal" />
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="CicloGpoLista" scope="page"
	class="aca.ciclo.CicloGrupoLista" />
<%
	String escuelaId = (String) session.getAttribute("escuela");
		String codigoId = (String) session.getAttribute("codigoEmpleado");

		String cicloGrupoId = request.getParameter("CicloGrupoId");
		String cursoId = request.getParameter("CursoId");
		String planId = aca.plan.PlanCurso.getPlanId(conElias, cursoId);
		if (request.getParameter("Ciclo") != null) {
			session.setAttribute("cicloId", request.getParameter("Ciclo"));
		}
		String cicloId = (String) session.getAttribute("cicloId");
		ArrayList<aca.ciclo.Ciclo> lisCiclo = CicloLista.getListActivos(conElias, escuelaId,
				"ORDER BY CICLO_ID DESC");
%>

<div id="content">
<h2>Observaciones para boletín</h2>
	<div class="well ">
		<form name="frmCiclo" action="observaciones.jsp" method="post" class="form-inline">
			<input type="hidden" name="Accion"> <select name="Ciclo"
				id="Ciclo" onchange="document.frmCiclo.submit();"
				class="input-xxlarge">
				<%
					for (aca.ciclo.Ciclo ciclo : lisCiclo) {
				%>
				<option value="<%=ciclo.getCicloId()%>"
					<%if (ciclo.getCicloId().equals(cicloId)) {
						out.print("selected");
					}%>><%=ciclo.getCicloNombre()%></option>
				<%
					}
				%>
			</select>

		</form>

		<form  class="form-inline">
			<%
				if (cicloId != null) {
						List<CicloGrupo> lsCicloGpo = new ArrayList();
						lsCicloGpo.addAll(CicloGpoLista.getListGrupos(conElias, cicloId, ""));
			%>
			<label for="select">Grupo: </label> <select name="ciclo_gpo_id"
				id="ciclo_gpo_id">
				<option>Seleccione...</option>
				<%
					for (CicloGrupo cg : lsCicloGpo) {
				%>
				<option value="<%=cg.getCicloGrupoId()%>"><%=cg.getGrupoNombre()%> <%=cg.getGrupo()%></option>
				<%
					}
				%>
			</select>
			<%
				}
			%>
		</form>
	</div>


	<div id="tableData"></div>
</div>
<!-- MODAL -->
<div id="obsBox" class="modal hide fade" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">x</button>
		<h3 id="myModalLabel">Observaciones</h3>
	</div>
	<div class="modal-body ">
		<table style="width: 100%">
			<tr>
				<td ><label for="asunto">Observaciones</label> <textarea cols="60" name="observacion" id="observacion"
					> </textarea> <br>  <input
					type="hidden" id="codigoid" value=""> <input type="hidden"
					id="periodo" value=""> <input type="hidden" id="tipo"
					value=""> <input type="hidden" id="cicloGpoId"
					value=""> <input type="hidden"
					id="idobs" value=""></td>
				<td>
<!-- 					<div id="divMok" style="width: 72px; font-size: 8px"></div> -->
				</td>
			<tr>
				<td style="width: 50%"><label for="asunto"></label>
					<input type="hidden" name="observacion2" id="observacion2"
					onkeyup="mok(this);"> <br> </td>
				<td>
					<div id="divMok" style="width: 72px; font-size: 8px"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">
			<i class="icon-remove"></i>
			<fmt:message key="boton.Cancelar" />
		</button>
		<a class="btn btn-primary" href="javascript:addObservacion()">Agregar
			observaciones</a>
	</div>
</div>
<!-- END MODAL -->
<!-- nuevo modal -->

<div class="modal fade" id="enviadoMsg" role="dialog">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">Aviso</h4>
			</div>
			<div class="modal-body">
				<p>La petición se ejecutó correctamente.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="failMsg" role="dialog">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">Aviso</h4>
			</div>
			<div class="modal-body">
				<p>El proceso no esta funcionando o hay problemas.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>
		</div>
	</div>

	<!-- end nuevo modal -->
	<script>
		function mok(inp) {
			$('#divMok').html($(inp).val());
		}

		$(document).on("click", ".open-ObsBox", function() {
			var codigoid = $(this).data('id');
			var periodo = $(this).data('periodo');
			var tipo = $(this).data('tipo');
			var observacion = $(this).data('obs');
			var observacion2 = $(this).data('obs2');
			var id = $(this).data('idobs');

			$(".modal-body #codigoid").val(codigoid);
			$(".modal-body #periodo").val(periodo);
			$(".modal-body #tipo").val(tipo);
			$(".modal-body #observacion").val(observacion);
			$(".modal-body #observacion2").val(observacion2);
			$(".modal-body #idobs").val(id);
			// As pointed out in comments, 
			// it is superfluous to have to manually call the modal.
			// $('#addBookDialog').modal('show');
		});

		function limpiaForma() {
			$('#codigoid').val('');
			$('#periodo').val('');
			$('#observacion').val('');
			$('#observacion2').val('');
			$('#idobs').val('');

		}

		function addObservacion() {

			var datadata = 'codigoid=' + $('#codigoid').val() + '&CicloGrupoId='
					+ $('#cicloGpoId').val() + '&periodo='
					+ $('#periodo').val() + '&tipo=' + $('#tipo').val()
					+ '&observacion=' + $('#observacion').val()
					+ '&observacion2=' + $('#observacion2').val() + '&id='
					+ $('#idobs').val() + '&guardar=true';

			var idremove = 'td-' + $('#codigoid').val() + '-'
					+ $('#periodo').val();

			$
					.ajax({
						url : 'accionObservaciones.jsp',
						type : 'post',
						data : datadata,
						success : function(output) {
							var idobs = parseInt(output);
							if (idobs > 0) {
								var iSelector = $(
										'#' + $('#tipo').val() + '-'
												+ $('#codigoid').val() + '-'
												+ $('#periodo').val())
										.find('i');
								if (iSelector.hasClass('icon-plus')) {
									iSelector.removeClass('icon-plus');
									iSelector.addClass('icon-pencil');
								}
								
								if (!$('#td-'+ $('#codigoid').val() + '-'+ $('#periodo').val()).find('a:last').children('i').hasClass('icon-remove') ) {
								$(
										'#td-' + $('#codigoid').val() + '-'
												+ $('#periodo').val())
										.append(
												'&nbsp&nbsp&nbsp&nbsp<a href="#" onclick="borrar('
														+ idobs
														+ ',\''
														+ $('#codigoid').val()
														+ '\','
														+ $('#periodo').val()
														+ ');" class="btn btn-danger btn-mini"><i class="icon-remove icon-white"></i></a>');
								}
								$(
										'#' + $('#tipo').val() + '-'
												+ $('#codigoid').val() + '-'
												+ $('#periodo').val()).data(
										'idobs', idobs);
								$(
										'#' + $('#tipo').val() + '-'
												+ $('#codigoid').val() + '-'
												+ $('#periodo').val()).data(
										'obs', $('#observacion').val());
								$(
										'#' + $('#tipo').val() + '-'
												+ $('#codigoid').val() + '-'
												+ $('#periodo').val()).data(
										'obs2', $('#observacion2').val());
								$('#obsBox').modal('toggle');
								$('#enviadoMsg').modal('show');
								limpiaForma();
							} else {
								$('#obsBox').modal('toggle');
								$('#failMsg').modal('show');
							}

						},
						error : function(xhr, ajaxOptions, thrownError) {
							console.log("error " + datadata);
							alert(xhr.status + " " + thrownError);
							$('#obsBox').modal('toggle');
							$('#failMsg').modal('show');

						}
					});

		}

		function borrar(idobs, codigoid, periodo) {
			var datadata = 'id=' + idobs + '&borrar=true';

			$
					.ajax({
						url : 'accionObservaciones.jsp',
						type : 'post',
						data : datadata,
						success : function(output) {
							$('#enviadoMsg').modal('show');
							$('#td-' + codigoid + '-' + periodo).empty();
							$('#td-' + codigoid + '-' + periodo)
									.append(
											'<a data-toggle="modal" title="Observacion" data-idobs="" data-obs="" data-obs2="" data-id="'+codigoid+'" data-tipo="O" data-periodo="'+periodo+'" class="open-ObsBox btn btn-default btn-mini" href="#obsBox" id="O-'+codigoid+'-'+periodo+'"><i class="icon-plus"></i></a>');
						},
						error : function(xhr, ajaxOptions, thrownError) {
							console.log("error " + datadata);
							alert(xhr.status + " " + thrownError);

						}
					});
		}

		function cargaTabla(datadata) {
			$.ajax({
				url : 'accionObservaciones.jsp',
				type : 'post',
				data : datadata,
				success : function(output) {
					$('#tableData').html(output);
				},
				error : function(xhr, ajaxOptions, thrownError) {
					console.log("error " + datadata);
					alert(xhr.status + " " + thrownError);
				}
			});
		}

		$('#ciclo_gpo_id').change(function() {
			var ciclogpoid = $(this).val();
			var datadata = 'CicloGrupoId=' + ciclogpoid + '&showTable=true';
			$('#cicloGpoId').val(ciclogpoid);
			cargaTabla(datadata);
		});
	</script>
	<%@ include file="../../cierra_elias.jsp"%>