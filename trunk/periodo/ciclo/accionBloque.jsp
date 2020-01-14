<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Bloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="CicloGrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="GrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>

<script>	
	function Grabar(){
		if(document.frmbloque.BloqueId.value!="" && document.frmbloque.BloqueId!=""){			
			document.frmbloque.Accion.value="2";
			document.frmbloque.submit();			
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}
	
	function Modificar(){
		document.frmbloque.Accion.value="3";
		document.frmbloque.submit();
	}
	
	function Consultar(){
		document.frmbloque.Accion.value="5";
		document.frmbloque.submit();		
	}
</script>

<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	// Declaracion de variables	
	String cicloId 		= session.getAttribute("cicloId").toString();
	String promedioId	= session.getAttribute("promedioId").toString();
	String bloqueId		= request.getParameter("BloqueId")==null?"0":request.getParameter("BloqueId");
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	int numModulos 		= aca.ciclo.Ciclo.getModulos(conElias, cicloId);
	String strResultado	= "";
	
	String salto 		= "";
	
	java.util.HashMap<String, String> mapAlumnos 		= aca.kardex.KrdxAlumEvalLista.mapAlumnosEvaluadosCiclo(conElias, cicloId);
	java.util.HashMap<String, String> mapActividades 	= aca.ciclo.CicloGrupoActividadLista.getMapActividadesCiclo(conElias, cicloId);	
		
	Bloque.setCicloId(cicloId);
	Bloque.setPromedioId(promedioId);
	if ( !accion.equals("1") ){
		Bloque.setBloqueId(bloqueId);
	}
			
	// Operaciones a realizar en la pantalla	
	if( accion.equals("1") ){ // Nuevo
		Bloque.setBloqueId(Bloque.maximoReg(conElias,Bloque.getCicloId()));
		Bloque.setFInicio(aca.util.Fecha.getHoy());
	}else if( accion.equals("2") ){ // Grabar
		
		/* BEGIN TRANSACTION */
		boolean error = false;
		conElias.setAutoCommit(false);		
		
		/* GUARDANDO EN EL BLOQUE DEL CICLO */
		Bloque.setPromedioId(promedioId);
		Bloque.setBloqueId(request.getParameter("BloqueId"));			
		Bloque.setBloqueNombre(request.getParameter("BloqueNombre"));
		Bloque.setFInicio(request.getParameter("FInicio"));
		Bloque.setFFinal(request.getParameter("FFinal"));
		Bloque.setValor(request.getParameter("Valor"));
		Bloque.setOrden(request.getParameter("Orden"));
		Bloque.setRedondeo(request.getParameter("Redondeo"));		
		Bloque.setCorto(request.getParameter("Corto"));
		Bloque.setDecimales(request.getParameter("Decimales"));
		Bloque.setCalculo(request.getParameter("Calculo"));		
											
		if (Bloque.existeReg(conElias) == false){
			if (Bloque.insertReg(conElias)){
				//GUARDADO
			}else{
				error = true;
				accion = "1";
			}
		}else{
			error = true;
			accion = "1";
		}
		
		/* GUARDANDO EN LAS EVALUACIONES DE LAS MATERIAS ACTIVADAS */
		ArrayList<aca.ciclo.CicloGrupoCurso> gruposCicloCurso 		= CicloGrupoCursoL.getListGruposDelCiclo(conElias, cicloId, "");
		for(aca.ciclo.CicloGrupoCurso gpo : gruposCicloCurso){
			GrupoEval.setCicloGrupoId(gpo.getCicloGrupoId());
			GrupoEval.setCursoId(gpo.getCursoId());
			GrupoEval.setEvaluacionId(Bloque.getBloqueId());
			GrupoEval.setEvaluacionNombre(Bloque.getBloqueNombre());						
			GrupoEval.setFecha(Bloque.getFFinal());
			GrupoEval.setValor(Bloque.getValor());
			GrupoEval.setTipo("P");
			GrupoEval.setEstado("A");
			GrupoEval.setCalculo("V");
			GrupoEval.setOrden(Bloque.getOrden());
			if(!GrupoEval.existeReg(conElias)){
				if(GrupoEval.insertReg(conElias)){
					// INSERTADO					
				}else{
					error = true; 
					break;
				}
			}
		}	
		
		if(error){
			strResultado = "NoGrabo";
			conElias.rollback();
		}else{
			strResultado = "Grabado";
			conElias.commit();	
			salto = "bloque.jsp";
		}
		
		conElias.setAutoCommit(true);
		/* END TRANSACTION */
	}
	
	else if( accion.equals("3") ){ // Modificar
		
		//No modificar si ya hay alumnos evaluados en esta evaluacion
		if(!mapAlumnos.containsKey(Bloque.getBloqueId())){		
		
				/* BEGIN TRANSACTION */
				boolean error = false;
				conElias.setAutoCommit(false);			
				Bloque.setPromedioId(promedioId);
				Bloque.setBloqueId(request.getParameter("BloqueId"));		
				Bloque.setBloqueNombre(request.getParameter("BloqueNombre"));
				Bloque.setFInicio(request.getParameter("FInicio"));
				Bloque.setFFinal(request.getParameter("FFinal"));
				Bloque.setValor(request.getParameter("Valor"));
				Bloque.setOrden(request.getParameter("Orden"));
				Bloque.setRedondeo(request.getParameter("Redondeo"));		
				Bloque.setCorto(request.getParameter("Corto"));
				Bloque.setDecimales(request.getParameter("Decimales"));
				Bloque.setCalculo(request.getParameter("Calculo"));		
					
				if (Bloque.existeReg(conElias) == true){
					if (Bloque.updateReg(conElias)){
						
						//ACTUALIZANDO LAS EVALUACIONES DE TODAS LAS MATERIAS
						if( aca.ciclo.CicloGrupoEval.updateEvalDatos(conElias,Bloque.getCicloId(),Bloque.getBloqueId(),Bloque.getBloqueNombre(),Bloque.getFFinal(), Bloque.getValor(), Bloque.getOrden()) ){
							//CICLO GRUPO EVALUACION ACTUALIZADO
						}else{
							error = true;
						}
					}else{
						error = true;
						accion = "5";
					}
				}else{
					error = true;
					accion = "5";
				}			
				
				if(error){
					strResultado = "NoModificó";
					conElias.rollback();
				}else{
					strResultado = "Modificado";
					conElias.commit();	
// 					salto = "bloque.jsp";
					salto = "accionBloque.jsp?Accion=5&BloqueId="+Bloque.getBloqueId();
				}
				
				conElias.setAutoCommit(true);
				/* END TRANSACTION */
			
				
		}else{
			strResultado = "NoEditarEvaluacion";
		}			
		
	}
	
	else if( accion.equals("4") ){ // Borrar
		
		//Eliminar solo si no hay alumnos evaluados en esa evaluacion y si esa evaluacion no tiene actividades (ya que quizas algun maestro ya agrego sus actividades) y si es el ultimo bloque (para que no borre bloques de enmedio y el ID no sea consecutivo)
		if( !mapAlumnos.containsKey(Bloque.getBloqueId()) && !mapActividades.containsKey(Bloque.getBloqueId()) && Bloque.getUltimoBloque(conElias, cicloId).equals( Bloque.getBloqueId() ) ){		
		
				/* BEGIN TRANSACTION */
				boolean error = false;
				conElias.setAutoCommit(false);
				
				if (Bloque.existeReg(conElias) == true){
					if (Bloque.deleteReg(conElias)){
						
						if( aca.ciclo.CicloGrupoEval.deleteEvalDatos(conElias, cicloId, Bloque.getBloqueId()) ){
							//ELIMINADO DE CICLO GRUPO EVALUACION
						}else{
							error = true;
						}
						
					}else{
						error = true;
					}	
				}else{
					error = true;
				}			
				
				if(error){
					strResultado = "NoElimino";
					conElias.rollback();
				}else{
					strResultado = "Eliminado";
					conElias.commit();	
					salto = "bloque.jsp";
				}
				
				conElias.setAutoCommit(true);
				/* END TRANSACTION */
				
		
		}else{
			strResultado = "NoEditarEvaluacion";
		}		
	
	}
	
	else if( accion.equals("5") ){ // Consultar						
		if (Bloque.existeReg(conElias) == true){
			Bloque.mapeaRegId(conElias, cicloId, request.getParameter("BloqueId"));
		}	
	}
	
	pageContext.setAttribute("resultado", strResultado);
%>

<div id="content">

	<h2>
		<fmt:message key="aca.Evaluacionn" />
		<small><%=Bloque.getCicloId()%> | <%=aca.ciclo.Ciclo.nombreCiclo(conElias, cicloId)%> </small>
	</h2>
	
	<% if (strResultado.equals("Eliminado") || strResultado.equals("Modificado") || strResultado.equals("Grabado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!strResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	<div class="well">
		<a class="btn btn-primary" href="bloque.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="catalogo.Listado" /></a>
	</div>
	
	<form action="accionBloque.jsp" method="post" name="frmbloque" target="_self">
		<input type="hidden" name="Accion">
       <input name="BloqueId" type="hidden" id="BloqueId" maxlength="3" value="<%=Bloque.getBloqueId()%>" class="onlyNumbers input-mini">
 	   
 	   <fieldset>
	    	<label for="BloqueNombre"><fmt:message key="aca.Nombre" /></label>
	        <input name="BloqueNombre" type="text" id="BloqueNombre" size="80" maxlength="99" value="<%=Bloque.getBloqueNombre()%>" style="width: 700px;">  
 	   </fieldset>
 	   
 	   <fieldset>
	    	<label for="Corto"><fmt:message key="aca.Corto" /></label>
	        <input name="Corto" type="text" id="Corto" size="10" maxlength="10" value="<%=Bloque.getCorto()%>">  
 	   </fieldset>
 	   
 	   <fieldset>
	    	<label for="FInicio"><fmt:message key="aca.FechaInicio" /></label>
	       <input name="FInicio" type="text" id="FInicio" maxlength="10" value="<%=Bloque.getFInicio()%>" class="input-medium"> 
 	   </fieldset>
 	   
 	   <fieldset>
	    	<label for="BloqueNombre"><fmt:message key="aca.FechaFinal" /></label>
	        <input name="FFinal" type="text" id="FFinal" maxlength="10" value="<%=Bloque.getFFinal()%>" class="input-medium">
		</fieldset>
		
		<fieldset>
			<label for="Valor"><fmt:message key="aca.Valor" /></label>			
			<div class="input-append">
				<input name="Valor" type="text" id="Valor" maxlength="6" value="<%=Bloque.getValor().equals("")? getformato.format( 100f/(float)numModulos ):Bloque.getValor() %>" class="onlyNumbers input-mini" data-max-num="100">
				<span class="add-on">%</span>
			</div>
		</fieldset>
		
		<fieldset>
			<label for="Decimales"><fmt:message key="aca.Decimales" /></label>
			<select name="Decimales" id="Decimales" class="input input-small">
				<option value="0" <% if (Bloque.getDecimales().equals("0")) out.print(" selected");%>>0</option>
				<option value="1" <% if (Bloque.getDecimales().equals("1")) out.print(" selected");%>>1</option>
			</select>
		</fieldset>
		
		<fieldset>
			<label for="Redondeo"><fmt:message key="aca.Redondeo" /></label>
			<select name="Redondeo" id="Redondeo" class="input input-small">
				<option value="A" <% if (Bloque.getRedondeo().equals("A")){out.print(" selected");}%>>Arriba</option>
				<option value="T" <% if (Bloque.getRedondeo().equals("T")){out.print(" selected");}%>>Truncado</option>
			</select>
		</fieldset>
		
		<fieldset>
			<label for="Orden"><fmt:message key="aca.Orden" /></label>
			<input name="Orden" type="text" id="Orden" class="onlyNumbers input-mini" value="<%=(Bloque.getOrden()==null||Bloque.getOrden().equals(""))?Bloque.getBloqueId():Bloque.getOrden() %>" />
		</fieldset>
		
		<fieldset>
			<label for="Calculo"><fmt:message key="aca.Calculo" /></label>
			<select name="Calculo" id="Calculo" class="input input-small">
				<option value="V" <% if (Bloque.getCalculo().equals("V")){out.print(" selected");}%>>Valor</option>
				<option value="P" <% if (Bloque.getCalculo().equals("P")){out.print(" selected");}%>>Promedio</option>
			</select>
		</fieldset>
		
	</form>
	
   	<div class="well">
   		<%if(accion .equals( "1" )){ %>
   			<a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></a>
   		<%} %>
   		<%if(accion .equals( "5" )){ %>
			<a class="btn btn-primary btn-large" href="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
		<%} %> 
   	</div>
	
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FInicio').datepicker();
	$('#FFinal').datepicker();
</script>

<%	
	// Salto de pagina
	if (salto.length()>0){%>
	<meta http-equiv="refresh" content="0; url=<%=salto%>">
<%	} %>

<%@ include file= "../../cierra_elias.jsp" %>