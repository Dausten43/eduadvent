<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file="../../menu.jsp"%>

<%@page import="java.io.File"%>

<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.ciclo.CicloGrupoActividad"%>
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="cicloGrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="cicloGrupoActividad" scope="page" class="aca.ciclo.CicloGrupoActividad"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>

<jsp:useBean id="krdxAlumAct" scope="page" class="aca.kardex.KrdxAlumActiv"/>
<jsp:useBean id="tipoactLista" scope="page" class="aca.catalogo.CatTipoactLista"/>

<jsp:useBean id="ArchivosEnviadosLista" scope="page" class="aca.kardex.KrdxAlumArchivoLista"/>
<jsp:useBean id="archivo" scope="page" class="aca.kardex.KrdxAlumArchivo"/>
<jsp:useBean id="ActEtiquetalista" scope="page" class="aca.catalogo.CatActividadEtiquetaLista"/>

<script>	
	function guardar(){
		if(document.forma.Nombre.value != "" &&
		  document.forma.Fecha.value != "" &&
		  document.forma.Valor.value != ""){
			document.forma.action += "&Accion=2";
			return true;
		}else{
			alert("<fmt:message key="js.CompletaCamposAsterisco"/>");
		}
		return false;
	}
	
	function modificar(evaluacionId, actividadId){
		document.forma.action += "&Accion=4&EvaluacionId="+evaluacionId+"&ActividadId="+actividadId;
		document.forma.submit();
	}
	
	function borrar(evaluacionId, actividadId){
		if(confirm("<fmt:message key="aca.BorrarActividad"/>")){
			document.forma.action += "&Accion=3&EvaluacionId="+evaluacionId+"&ActividadId="+actividadId;
			document.forma.submit();
		}
	}
</script>
<% 
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloGrupoId 	= (String) session.getAttribute("cicloGrupoId");
	String cursoId 			= (String) session.getAttribute("cursoId");
	String cicloId 			= (String) session.getAttribute("cicloId");
	
	String unionId 			= aca.catalogo.CatAsociacion.getUnionEscuela(conElias, escuelaId);
	
	String evaluacionId	    = request.getParameter("EvaluacionId")==null?"0":request.getParameter("EvaluacionId");
	String actividadId	    = request.getParameter("ActividadId")==null?"0":request.getParameter("ActividadId");
	String valor	        = request.getParameter("Valor")==null?"0":request.getParameter("Valor");
	int accion 			    = request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	String resultado		= "";
	String salto			= "X";
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	
	String isNueva = "no";
	if (accion == 1){ 
		cicloGrupoActividad.setCicloGrupoId(cicloGrupoId);
		cicloGrupoActividad.setCursoId(cursoId);
		cicloGrupoActividad.setEvaluacionId(request.getParameter("EvaluacionId"));
		cicloGrupoActividad.setActividadId(cicloGrupoActividad.maximoReg(conElias));
		isNueva = "si";
	}else{
		cicloGrupoActividad.setEvaluacionId(request.getParameter("ActividadId"));
		cicloGrupoActividad.mapeaRegId(conElias, cicloGrupoId, cursoId, evaluacionId, actividadId);
	}		
	
	ArrayList<aca.ciclo.CicloGrupoEval> lisEvaluacion = cicloGrupoEvalL.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY SUBSTR(TO_CHAR(FECHA,'DD/MM/YYYY'),7,4)||SUBSTR(TO_CHAR(FECHA,'DD/MM/YYYY'),4,5)||SUBSTR(TO_CHAR(FECHA,'DD/MM/YYYY'),1,2), EVALUACION_ID");
		
		
	// Operaciones a realizar en la pantalla
	switch (accion){
		case 2: { // Grabar y Modificar
			cicloGrupoActividad.setActividadId(request.getParameter("ActividadId"));
		    cicloGrupoActividad.setCicloGrupoId(cicloGrupoId);
			cicloGrupoActividad.setCursoId(cursoId);
			cicloGrupoActividad.setEvaluacionId(request.getParameter("EvaluacionId"));
			cicloGrupoActividad.setActividadNombre(request.getParameter("Nombre"));
			cicloGrupoActividad.setValor(valor);
			cicloGrupoActividad.setTipoactId(request.getParameter("Tipoact"));	
			cicloGrupoActividad.setEtiquetaId(request.getParameter("EtiquetaId"));
			cicloGrupoActividad.setMostrar(request.getParameter("Mostrar"));
			
			String Hora 	= request.getParameter("Hora").length()==1 ? "0"+request.getParameter("Hora") : request.getParameter("Hora");
			String Min 		= request.getParameter("Min").length()==1 ? "0"+request.getParameter("Min") : request.getParameter("Min");
			if(request.getParameter("AM/PM").equals("PM") && !Hora.equals("12")) Hora = (Integer.parseInt(Hora)+12)+"";
			else if(request.getParameter("AM/PM").equals("AM") && Hora.equals("12")) Hora = "00";
			String fecha 	= request.getParameter("Fecha")+" "+Hora+":"+Min; 
			
			cicloGrupoActividad.setFecha(fecha);
			
			Ciclo.mapeaRegId(conElias, cicloId);
			boolean tieneNotasLaEstrategia = cicloGrupoEval.notasReg(conElias, cicloGrupoId, cursoId, cicloGrupoActividad.getEvaluacionId());
			boolean esKinderOPrekinder = Ciclo.getNivelAcademicoSistema() == null ? false
													: Ciclo.getNivelAcademicoSistema().equals("1") || Ciclo.getNivelAcademicoSistema().equals("2");
			if(esKinderOPrekinder|| (!tieneNotasLaEstrategia) || (tieneNotasLaEstrategia && CicloGrupoActividad.tieneActividades(conElias, cicloGrupoId, cursoId, cicloGrupoActividad.getEvaluacionId()))){
				if((CicloGrupoActividad.getSumActividades(conElias, cicloGrupoId, cursoId, cicloGrupoActividad.getEvaluacionId(), cicloGrupoActividad.getActividadId())+Float.parseFloat(cicloGrupoActividad.getValor()))<= 100){
					if(cicloGrupoActividad.existeReg(conElias) == false){//Grabar
						if(cicloGrupoActividad.insertReg(conElias)){
							resultado = "Guardado";
							salto = "metodo.jsp";
						}else{
							resultado = "NoGuardo";
						}
					}else{//Modificar
						if(cicloGrupoActividad.updateReg(conElias)){
							resultado = "Modificado";
							salto = "metodo.jsp";
						}else{
							resultado = "NoModifico";
						}
					}
				}else{
					resultado = "SerCien";
				}
			}else{
				resultado = "ErrorGrabarAct";
			}
		}break;
		case 3: { // Borrar
			
			String eval 		= request.getParameter("EvaluacionId");
			String activ		= request.getParameter("ActividadId");
			boolean tieneNotas	= false;
			boolean borroNotas	= false;
			conElias.setAutoCommit(false);
			//Busca las evaluaciones registradas en esta actividad
			if (aca.kardex.KrdxAlumActiv.tieneNotas(conElias, cicloGrupoId, cursoId, eval,activ) ){
				tieneNotas = true;
				if (aca.kardex.KrdxAlumActiv.deleteNotasAct(conElias, cicloGrupoId, cursoId, eval, activ)){
					borroNotas = true;
				}
			}
			
			// Si no había notas o si borró las notas que tenia la actividad 
			if (tieneNotas==false || (tieneNotas && borroNotas)){				
			
				cicloGrupoActividad.setCicloGrupoId(cicloGrupoId);
				cicloGrupoActividad.setCursoId(cursoId);
				cicloGrupoActividad.setEvaluacionId(eval);
				cicloGrupoActividad.setActividadId(activ);
				if(cicloGrupoActividad.deleteReg(conElias)){
					conElias.commit();
					resultado = "Eliminado";
					salto = "metodo.jsp";
				}else{
					resultado = "ErrorBorrar";
				}
				cicloGrupoActividad = new CicloGrupoActividad();
				
				ArrayList<String> archivosEnviados = ArchivosEnviadosLista.getListCodigoSinRepetir(conElias, cicloGrupoId, cursoId, evaluacionId, actividadId, " ORDER BY CODIGO_ID");
				
				for(int i=0; i<archivosEnviados.size(); i++){
					
					ArrayList<aca.kardex.KrdxAlumArchivo> archivosEnviadosAlum = ArchivosEnviadosLista.getListEvaluacionAlumno(conElias, archivosEnviados.get(i), cicloGrupoId, cursoId, evaluacionId, actividadId, " ORDER BY CODIGO_ID, FECHA");
					
					archivo.setCodigoId(archivosEnviados.get(i));
					
					for(int j=0; j<archivosEnviadosAlum.size(); j++){
						archivo.setFolio(archivosEnviadosAlum.get(j).getFolio());
						archivo.deleteReg(conElias);
						
						String [] arrExt = archivosEnviadosAlum.get(j).getArchivo().split("\\.");
						String ext = arrExt[arrExt.length-1];
						
						String dirArchivo = application.getRealPath("/WEB-INF/archivos")+"/"+String.valueOf(session.getAttribute("escuela"))+"/"+archivosEnviados.get(i)+"/"+archivosEnviados.get(i)+"-"+archivosEnviadosAlum.get(j).getFolio()+"."+ext;
						new File(dirArchivo).delete();					
					}
					
				}
			}else{
				resultado = "ImposibleBorrarNotas";
			}	
			conElias.setAutoCommit(true);
			
		}break;
		case 4: { // Consultar
			cicloGrupoActividad.mapeaRegId(conElias, cicloGrupoId, cursoId, evaluacionId, actividadId);
		}break;
		
	}
	
	
	pageContext.setAttribute("resultado",resultado);
	ArrayList<aca.catalogo.CatTipoact> lisTipoact = tipoactLista.getListUnion(conElias, unionId, "ORDER BY TIPOACT_NOMBRE");
	ArrayList<aca.catalogo.CatActividadEtiqueta> etiquetas = ActEtiquetalista.getListAll(conElias, aca.catalogo.CatEscuela.getUnionId(conElias, (String)session.getAttribute("escuela")) , " ORDER BY ORDEN ");
%>
<div id="content">
	<h2>
		<%if(accion==1){ %>
			<fmt:message key="boton.AnadirActividad"/>
		<%}else{%>
			<fmt:message key="boton.EditarActividad"/>
	 	<%}%>
	</h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a href="metodo.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>

	<form id="forma" name="forma" action="actividad.jsp?CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>&EvaluacionId=<%=evaluacionId%>" method="post">
		<input type="hidden" id="ActividadId" name="ActividadId" value="<%= cicloGrupoActividad.getActividadId()%>" />
		<input type="hidden" id="isNueva" value="<%= isNueva %>">
		<input type="hidden" id="FechaOriginal" value="<%= cicloGrupoActividad.getFecha().length()>1 ? cicloGrupoActividad.getFecha().substring(0,10) :"" %>">
		<fieldset>
			<label for="Nombre"><fmt:message key="aca.Descripcion"/></label>
			<textarea id="Nombre" name="Nombre" ><%=cicloGrupoActividad.getActividadNombre() %></textarea>
		</fieldset>
		
		<fieldset>
			<label for="Fecha"><fmt:message key="aca.Fecha"/></label>
			<input type="text" id="Fecha" name="Fecha" value="<%=cicloGrupoActividad.getFecha().length()>1 ? cicloGrupoActividad.getFecha().substring(0,10) : sdf.format(new Date()) %>" maxlength="10" size="8" readonly /> <span style="font-weight: bolder; color: red;" id="numeroTareas"></span>			
		</fieldset>
		
		<fieldset>
			<label for="Hora"><fmt:message key="aca.Hora"/></label>
			<select name="Hora" id="Hora" class="input-mini">
			<%	String tmpHora = "";
				if(cicloGrupoActividad.getFecha().length()>1){
					tmpHora = cicloGrupoActividad.getFecha().substring(11,13);
					if(Integer.parseInt(tmpHora)>12){
						tmpHora = Integer.parseInt(tmpHora)-12+"";
					}
				}
				for(int i=1; i<13; i++){%>
					<option value="<%=i%>" <%if(cicloGrupoActividad.getFecha().length()>1){if (i==Integer.parseInt(tmpHora)) out.println("selected");}%>><%=i%></option>
			<%	}%>
		  	</select>
		  	<b>:</b>
		  	<select name="Min" id="Min" class="input-mini">
				<%for(int i=0; i<60; i++){%>
					<option value="<%=i%>" <%if(cicloGrupoActividad.getFecha().length()>1){if (i==Integer.parseInt(cicloGrupoActividad.getFecha().substring(14,16))) out.println("selected");}%>><%=i<10 ? "0"+i : i%></option>
				<%}%>
		  	</select>
		  	<select name="AM/PM" id="AM/PM" class="input-mini">
				<option value="AM" <%if(cicloGrupoActividad.getFecha().length()>1){if(cicloGrupoActividad.getFecha().length()>17){if(cicloGrupoActividad.getFecha().substring(17,19).equals("AM")){out.println("selected");}}else if(request.getParameter("AM/PM").equals("AM")){out.println("selected");}}%>>AM</option>
				<option value="PM" <%if(cicloGrupoActividad.getFecha().length()>1){if(cicloGrupoActividad.getFecha().length()>17){if(cicloGrupoActividad.getFecha().substring(17,19).equals("PM")){out.println("selected");}}else if(request.getParameter("AM/PM").equals("PM")){out.println("selected");}}%>>PM</option>
		  	</select>
		  	HH/MM
		</fieldset>
		
		<fieldset>
			<label for="Valor"><fmt:message key="aca.Valor"/> %</label>
			<input type="text" id="Valor" name="Valor" value="<%= valor %>" maxlength="3" size="1" <%=cicloGrupoActividad.getValor() %> />
		</fieldset>
			
		<fieldset>
			<label for="Tipoact"><fmt:message key="aca.Tipo"/></label>
			<select name="Tipoact" id="Tipoact">
			<%for(int i = 0; i < lisTipoact.size(); i++){ 
				 aca.catalogo.CatTipoact tipoact = (aca.catalogo.CatTipoact)lisTipoact.get(i);
			 %>
			  	<option value="<%=tipoact.getTipoactId() %>" <%if ( tipoact.getTipoactId().equals(cicloGrupoActividad.getTipoactId()) ) out.println("selected"); %> ><%=tipoact.getTipoactNombre() %></option>
			 <%} %>
			 </select>		
		</fieldset>
		
		<fieldset>
			<label for="Mostrar"><fmt:message key="aca.Mostrar"/></label>
			<select name="Mostrar" id="Mostrar">
			
			  	<option value="S" <%if ( cicloGrupoActividad.getMostrar().equals("S") ) out.println("selected"); %> >Si</option>
				<option value="N" <%if ( cicloGrupoActividad.getMostrar().equals("N") ) out.println("selected"); %> >No</option>
			
			 </select>		
		</fieldset>
		
		<%if(etiquetas.size()>0){ %>
			<fieldset>
				<label for="EtiquetaId"><fmt:message key="aca.Etiqueta" /></label>
				<select name="EtiquetaId" id="EtiquetaId">
					<%for(aca.catalogo.CatActividadEtiqueta et : etiquetas){ %>
						<option value="<%=et.getEtiquetaId() %>"><%=et.getEtiquetaNombre() %></option>
					<%} %>
				</select>
			</fieldset>
		<%} %>
		
		<div class="well">
			<button class="btn btn-primary btn-large" id="guardarLink" type="submit" onclick="return guardar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/></button>
		</div>
	</form>
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	const MAX_ACTIVIDADES = 200;
	
	$(function() {
		if($('#isNueva').val()=='si')		
	    	$('#Fecha').trigger('change');
	});

	$('#Fecha').datepicker().on('changeDate', function(e){
		if($('#isNueva').val()=='si'){
			$('#Fecha').trigger('change');
		}else{
			if($('#Fecha').val()!=$('#FechaOriginal').val()){
				$('#Fecha').trigger('change');
			}else{
				$('#numeroTareas').html('');
				$('#guardarLink').removeAttr('disabled');
			}
		}
		});
	
	$('#Fecha').change(function(){
		var ciclogpoid = '<%= cicloGrupoId %>';
		var fecha = $(this).val();
		var numeroTareas = 0;
		var datadata = 'fecha='+fecha+'&ciclo_gpo_id='+ciclogpoid+'&numeroTareas=true';
		
		$.ajax({
			url : 'ajaxLimiteTareas.jsp',
			type : 'post',
			data : datadata,
			success : function(output) {
				numeroTareas = parseInt(output);
				if(numeroTareas >= MAX_ACTIVIDADES){
					$('#numeroTareas').html('Las ' + MAX_ACTIVIDADES + ' tareas para este día ya están asignadas. Selecciona una nueva fecha o elija no mostrar la actividad');
					$('#guardarLink').attr("disabled", "true");
				}else{
					$('#numeroTareas').html('');
					$('#guardarLink').removeAttr('disabled');
				}
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	});
	
	$('#Mostrar').change(function (){
		if($(this).val()=='S'){
			$('#Fecha').trigger('change');
		}else{
			$('#numeroTareas').html('');
			$('#guardarLink').removeAttr('disabled');
		}
	});
</script>

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>

	$('#Nombre').maxlength({ 
	    max: 500
	});
	
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>