<form name="formActividad" method="post">
	<table style="width: 100%;">
		<tr>
			<th><label>Actividad</label></th>
			<th><label>Observación</label></th>
			<th></th>
			<th></th>
		</tr>
		<tr>
			<td><input type="text" id="formactividad"></td>
			<td><input type="text" id="formobservacion"></td>
			<td>
			<input type="hidden" name="formcicloid" id="formcicloid" value="<%= request.getParameter("cicloid") %>">
			<input type="hidden" name="formcursoid" id="formcursoid" value="<%= request.getParameter("cursoid") %>">
			<input type="hidden" name="formciclogrupoid" id="formciclogrupoid" value="<%= request.getParameter("ciclogrupoid") %>">
			<input type="hidden" name="formactividadid" id="formactividadid" value="<%= request.getParameter("actividadid") %>">
			<input type="hidden" name="formevaluacionid" id="formevaluacionid" value="<%= request.getParameter("evaluacionid") %>">
			<input type="hidden" name="formpromedioid" id="formpromedioid" value="<%= request.getParameter("promedioid") %>">
			</td>
			<td>
			<input type="submit" onclick="guardaFormulario(); return false;" class="btn btn-primary" value="Guardar">
			</td>
		</tr>
	</table>
</form>