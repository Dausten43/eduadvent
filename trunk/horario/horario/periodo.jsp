<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="periodo" scope="page" class="aca.catalogo.CatHorarioPeriodo"/>
<jsp:useBean id="periodo2" scope="page" class="aca.catalogo.CatHorarioPeriodo"/>
<jsp:useBean id="periodoU" scope="page" class="aca.catalogo.CatHorarioPeriodoLista"/>

<script>
	function grabar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
	
	function checkPeriodo(horarioId, periodoId){
		
		var hInicio = $('#hInicio').attr('disabled', true),
			mInicio = $('#mInicio').attr('disabled', true),
			hFin = $('#hFin').attr('disabled', true),
			mFin = $('#mFin').attr('disabled', true);
		
		$.get('checkPeriodo.jsp?horarioId='+horarioId+'&periodoId='+periodoId, function(r){
			res = $.trim(r).split(":");
			
			hInicio.attr('disabled', false).find('option[value="'+res[0]+'"]').attr('selected', true);
			mInicio.attr('disabled', false).find('option[value="'+res[1]+'"]').attr('selected', true);
			hFin.attr('disabled', false).find('option[value="'+res[2]+'"]').attr('selected', true);
			mFin.attr('disabled', false).find('option[value="'+res[3]+'"]').attr('selected', true);
			
		});
	}
	
	function borrar(periodoId){
		if(confirm("Esta seguro que desea borrar este periodo?")){
			$('#periodo').find('option[value="'+periodoId+'"]').attr('selected', true);
			
			document.forma.Accion.value = "2";
			document.forma.submit();
		}
	}
	
	function modificar(periodoId, horarioId){
		$('#periodo').find('option[value="'+periodoId+'"]').attr('selected', true);
		
		checkPeriodo(horarioId, periodoId);
	}
</script>
<%
	String escuelaId = (String) session.getAttribute("escuela");

	String horarioId = request.getParameter("horarioId");
	
	String accion = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj    = "";
	
	ArrayList<aca.catalogo.CatHorarioPeriodo> periodos = periodoU.getListAll(conElias, horarioId, "ORDER BY PERIODO_ID" );
	
	if(accion.equals("1")){//grabar
		
		String periodoId = request.getParameter("periodo");
		
		String hInicio = request.getParameter("hInicio");
		String mInicio = request.getParameter("mInicio");
		String hFin = request.getParameter("hFin");
		String mFin = request.getParameter("mFin");
		
		periodo.setHorarioId(horarioId);
		periodo.setPeriodoId(periodoId);
		periodo.setHoraInicio(hInicio);
		periodo.setMinInicio(mInicio);
		periodo.setHorafin(hFin);
		periodo.setMinfin(mFin);
		
		String periodoIdAnterior = "";
		for(aca.catalogo.CatHorarioPeriodo per: periodos){
			if(Integer.parseInt(per.getPeriodoId())<Integer.parseInt(periodoId)){
				periodoIdAnterior = per.getPeriodoId();	
			}
		}
		if(!periodoIdAnterior.equals("")){
			periodo2.mapeaRegId(conElias, horarioId, periodoIdAnterior);
		}
		
		if(!periodoIdAnterior.equals("") && Integer.parseInt(periodo2.getHorafin()+periodo2.getMinfin())>Integer.parseInt(hInicio+mInicio)){
			msj = "HoraInicioError";
		}else if(Integer.parseInt(hInicio+mInicio)>Integer.parseInt(hFin+mFin)){
			msj = "HoraFinError";
		}else{
			
			if(periodo.existeReg(conElias)){
				if(periodo.updateReg(conElias)){
					msj = "Modificado";
				}else{
					msj = "NoModifico";
				}
			}else{
				if(periodo.insertReg(conElias)){
					msj = "Guardado";
				}else{
					msj = "NoGuardo";
				}	
			}
			
			periodos = periodoU.getListAll(conElias, horarioId, "ORDER BY PERIODO_ID" );//refrescar lista de periodos
		}
		
	}else if(accion.equals("2")){
		String periodoId = request.getParameter("periodo");	
		
		periodo.setHorarioId(horarioId);
		periodo.setPeriodoId(periodoId);
		
		if(periodo.deleteReg(conElias) && aca.ciclo.CicloGrupoHorario.existePeriodoHorario(conElias, escuelaId, horarioId, periodoId)== false){
			msj = "Eliminado";
		}else{
			msj = "NoElimino";
		}
		
		periodos = periodoU.getListAll(conElias, horarioId, "ORDER BY PERIODO_ID" );//refrescar lista de periodos
	}
	
	pageContext.setAttribute("resultado", msj);
	
%>

<style>
	.controls{
		border: 1px solid 
	}
</style>

<div id="content">


	<h2><fmt:message key="catalogo.AnadirPeriodo" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a class="btn btn-primary" href="horario.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>


	<div class="row">
	
		<div class="span3 alert">
			<form name="forma" action="periodo.jsp" method="post" style="margin:0;">
				<input type="hidden" name="Accion">
				<input type="hidden" name="horarioId" value="<%=horarioId%>">
				<p>
					<label for="periodo"><fmt:message key="aca.Periodo" />:</label>
					<select id="periodo" name="periodo" onchange="checkPeriodo(document.forma.horarioId.value, document.forma.periodo.value);">
						<%for(int i=1; i<=10; i++){ %>
							<option value="<%=i%>" <%if(periodo.getPeriodoId().equals(i+""))out.print("selected");%>><fmt:message key="aca.Periodo" />: <%=i %></option>
						<%} %>
					</select>
				</p>
				<p>
					<label for="hInicio"><fmt:message key="aca.HoraInicio" /></label>
					<select id="hInicio" name="hInicio" class="input-mini">
						<%for(int i=0; i<=23; i++){ 
							String formato = i<10?"0"+i:i+"";
						%>	
							<option value="<%=formato%>" <%if(periodo.getHoraInicio().equals(formato))out.print("selected");%>><%=formato %></option>
						<%} %>
					</select>
					:
					<select id="mInicio" name="mInicio" class="input-mini">
						<%for(int i=0; i<=55; i+=5){
							String formato = i<10?"0"+i:i+"";
						%>	
							<option value="<%=formato%>" <%if(periodo.getMinInicio().equals(formato))out.print("selected");%>><%=formato %></option>
						<%} %>
					</select>
					
					HH:MM
				</p>
				<p>
					<label for="hFin"><fmt:message key="aca.HoraFinal" /></label>
					<select id="hFin" name="hFin" class="input-mini">
						<%for(int i=0; i<=23; i++){ 
							String formato = i<10?"0"+i:i+"";
						%>	
							<option value="<%=formato%>" <%if(periodo.getHorafin().equals(formato))out.print("selected");%>><%=formato %></option>
						<%} %>
					</select>
					:
					<select id="mFin" name="mFin" class="input-mini">
						<%for(int i=0; i<=55; i+=5){
							String formato = i<10?"0"+i:i+"";
						%>	
							<option value="<%=formato%>" <%if(periodo.getMinfin().equals(formato))out.print("selected");%>><%=formato %></option>
						<%} %>
					</select>
					
					HH:MM
				</p>
				<p>
					<a class="btn btn-primary btn-large" onclick="grabar();">
						<i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" />
					</a> 
				</p>
			</form>
		</div>

		<div class="span4">
			<table class="table table-striped table-bordered">
				<tr>
					<th><fmt:message key="aca.Operacion" /></th>
					<th><fmt:message key="aca.Periodo" /></th>
					<th><fmt:message key="aca.HoraInicio" /></th>
					<th><fmt:message key="aca.HoraFinal" /></th>
				</tr>
				<%					
					int cont = 0;
					for(aca.catalogo.CatHorarioPeriodo per: periodos){
					
				%>
					<tr>
						<td>
							<%if(aca.ciclo.CicloGrupoHorario.existePeriodoHorario(conElias, escuelaId, horarioId, per.getPeriodoId())){ %>
								<i class="icon-remove" title="No se puede eliminar este periodo, porque ya esta siendo usado por alguna materia"></i>
							<%}else{ %>
								<i onclick="borrar(<%=per.getPeriodoId() %>);" class="icon-remove"></i>
							<%}%>
							<i onclick="modificar(<%=per.getPeriodoId() %>, <%=per.getHorarioId() %>);" class="icon-pencil"></i>
						</td>
						<td><%=per.getPeriodoId() %></td>
						<td><%=per.getHoraInicio()+":"+per.getMinInicio() %></td>
						<td><%=per.getHorafin()+":"+per.getMinfin() %></td>
					</tr>
				<%
					}
				%>
			</table>
		</div>

	</div>
</div>
<%if(!accion.equals("1")){ %>
	<script>
	$(document).ready(function(){	
		checkPeriodo(document.forma.horarioId.value, document.forma.periodo.value);	
	});
	</script>
<%} %>
<%@ include file= "../../cierra_elias.jsp" %>