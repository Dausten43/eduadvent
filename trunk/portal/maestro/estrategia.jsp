<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="GrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>


<script>
	function guardar(){
			if(document.forma.EvaluacionId.value != "" &&
			  document.forma.Nombre.value != "" &&
			  document.forma.Fecha.value != "" &&
			  document.forma.Orden.value != ""){
			  document.forma.action += "&Accion=2";
			  document.forma.submit();
			}else{
				alert("<fmt:message key="js.Completar"/>");
			}
			return false;
	}
		
		
</script>

<%   
	 String cicloGrupoId 	= (String) session.getAttribute("cicloGrupoId");
	 String cursoId 		= (String) session.getAttribute("cursoId");
	 
	 String evaluacionId	= request.getParameter("EvaluacionId")==null?"0":request.getParameter("EvaluacionId");

	 int accion 		    = request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	 
	 String maxOrden        = aca.ciclo.CicloGrupoEval.getMaxOrden(conElias, cicloGrupoId, cursoId);
	
	 String sResultado		= "";
	 String salto			= "X";
	 
	 if (accion == 1){ 
			GrupoEval.setCicloGrupoId(cicloGrupoId);
			GrupoEval.setCursoId(cursoId);
			GrupoEval.setEvaluacionId(GrupoEval.maximoReg(conElias, cicloGrupoId, cursoId));
		}else{
			GrupoEval.setEvaluacionId(request.getParameter("EvaluacionId"));
	}
		 
	switch (accion){
	    case 0: { // Consulta
	    
			GrupoEval.mapeaRegId(conElias, cicloGrupoId,cursoId, evaluacionId);
	    	maxOrden = GrupoEval.getOrden();
	    	if(GrupoEval.getEstado().equals("C")){
	    		salto = "metodo.jsp";//Si la evaluacione esta cerrada no deberias poder editarlo, asi que regresalo
	    	}
			break;
		}	
	    
	    case 2: { // Grabar y modificar
			GrupoEval.setCicloGrupoId(cicloGrupoId);
			GrupoEval.setCursoId(cursoId);
			GrupoEval.setEvaluacionId(request.getParameter("EvaluacionId"));
			GrupoEval.setEvaluacionNombre(request.getParameter("Nombre"));
			GrupoEval.setFecha(request.getParameter("Fecha"));
			GrupoEval.setValor(request.getParameter("Valor"));
			GrupoEval.setCalculo("V");
			GrupoEval.setTipo("P");	
			GrupoEval.setEstado("A");//Solo puede guardar si esta Abierta la evaluacion
			
			GrupoEval.setOrden(request.getParameter("Orden"));
			if (GrupoEval.existeReg(conElias) == false){
				if (GrupoEval.insertReg(conElias)){
					sResultado = "Guardado";
					conElias.commit();
					salto = "metodo.jsp";
				}else{
					sResultado = "NoGuardo";
				}
			}else{	
				if (GrupoEval.updateReg(conElias)){ 
					sResultado = "Modificado";
					conElias.commit();
					salto = "metodo.jsp";
				}else{
					sResultado = "NoModifico";
				}
			}
			break;	
			
		}
		
		case 3:{//borrar
					
					GrupoEval.setCicloGrupoId(cicloGrupoId);
					GrupoEval.setCursoId(cursoId);			
					GrupoEval.setEvaluacionId(request.getParameter("EvaluacionId"));
					
					if (GrupoEval.existeReg(conElias) == true){
						if (GrupoEval.deleteReg(conElias)){
							sResultado = "Eliminado";
							conElias.commit();
							salto = "metodo.jsp";
						}else{
							sResultado = "NoBorro";
						}	
					}else{
							sResultado = "NoExiste";
					}
					break;
		}	
	}	
	
	pageContext.setAttribute("resultado", sResultado);
	
%>
<div id="content">
	<h2>
		<%if(accion==1){ %>
			<fmt:message key="aca.NuevaEstrategia"/>
		<%}else{%>
			<fmt:message key="aca.EditarEstrategia"/>
	 	<%}%>
	</h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well" style="overflow: hidden;"><a href="metodo.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a></div>
	
	<form id="forma" name="forma" action="estrategia.jsp?cicloGrupoId=<%=cicloGrupoId %>&cursoId=<%=cursoId %>" method="post">
		<input name="Accion" type= "hidden">
		<input type="hidden" id="EvaluacionId" name="EvaluacionId" value="<%= GrupoEval.getEvaluacionId()%>" />		
		
		<fieldset>
			<label for="Nombre"><fmt:message key="aca.Nombre"/></label>
			<input type="text" id="Nombre" name="Nombre"  maxlength="40" size="30" value="<%= GrupoEval.getEvaluacionNombre() %>" />	
		</fieldset>
		
		<fieldset>
			<label for="Fecha"><fmt:message key="aca.Fecha"/></label>
			<input type="text" id="Fecha" name="Fecha"  maxlength="10" size="7" value="<%= GrupoEval.getFecha() %>" />
		</fieldset>
		
		<fieldset>
			<label for="Valor"><fmt:message key="aca.Valor"/> %</label>
			<input class="onlyNumbers" type="text" id="Valor" name="Valor" maxlength="7" size="5" value="<%= GrupoEval.getValor()%>" />
		</fieldset>
			
		<fieldset>
			<label for="Orden"><fmt:message key="aca.Orden"/></label>
			<input class="onlyNumbers" type="text" id="Orden" name="Orden" maxlength="2" size="5" value="<%= maxOrden%>" />
		</fieldset>
	</form>
			
	<div class="well">
		<button class="btn btn-primary btn-large" onclick="guardar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/></button>
	</div>
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();
</script>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>