<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="catNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<script>
	
	function Grabar(){
		if(document.frmcarga.CicloNombre.value !="" && document.frmcarga.FInicio.value != "" && document.frmcarga.FFinal.value != "" && document.frmcarga.Modulos.value != ""){
			
			document.frmcarga.CicloId.value = document.frmcarga.cicloNum1.value + document.frmcarga.cicloNum2.value + document.frmcarga.cicloLetra.value; 
			document.frmcarga.Accion.value="2";
			document.frmcarga.submit();
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}
	
	function Modificar(){
		document.frmcarga.Accion.value="3";
		document.frmcarga.submit();
	}
	
	function Consultar(){
		document.frmcarga.Accion.value="5";
		document.frmcarga.submit();		
	}
	
</script>

<%
	// Declaracion de variables
	
	String escuelaId	= (String) session.getAttribute("escuela");
	
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String sResultado	= "";
		
	ArrayList<aca.catalogo.CatNivelEscuela> lisNiveles = catNivelL.getListEscuela(conElias, escuelaId, "ORDER BY NIVEL_ID");
	
	
	if ( !accion.equals("1") ){
		Ciclo.setCicloId(request.getParameter("CicloId"));
	}
		
	// Operaciones a realizar en la pantalla
	if( accion.equals("1")){ // Nuevo
		String fecha 		= aca.util.Fecha.getHoy();
		Ciclo.setFCreada(fecha);
		Ciclo.setFInicial(fecha);
		Ciclo.setFFinal(fecha);
		Ciclo.setNumCursos("0");
		Ciclo.setEstado("A");
		Ciclo.setEscala("10");
	}		
	
	else if( accion.equals("2") ){ // Grabar
		Ciclo.setCicloId(escuelaId+request.getParameter("CicloId"));
		Ciclo.setCicloNombre(request.getParameter("CicloNombre"));
		Ciclo.setFCreada(request.getParameter("FCreada"));
		Ciclo.setFInicial(request.getParameter("FInicio"));
		Ciclo.setFFinal(request.getParameter("FFinal"));
		Ciclo.setNumCursos("0"); /* No se usa por el momento esta columna */
		Ciclo.setEstado(request.getParameter("Estado"));
		Ciclo.setEscala(request.getParameter("Escala"));
		Ciclo.setEditarActividad(request.getParameter("Editar"));
		Ciclo.setModulos(request.getParameter("Modulos"));
		Ciclo.setCicloEscolar(request.getParameter("cicloEscolar"));
		Ciclo.setDecimales(request.getParameter("decimal"));
		Ciclo.setRedondeo(request.getParameter("redondeo"));
		Ciclo.setNivelEval(request.getParameter("nivelEval"));
		Ciclo.setNivelAcademicoSistema(request.getParameter("nivelAcademicoSistema"));

		if (Ciclo.existeReg(conElias) == false){
			if (Ciclo.insertReg(conElias)){
				sResultado = "Grabado";
%>
				<meta http-equiv="refresh" content="0; URL='ciclo.jsp'" />
<%
			}else{
				sResultado = "NoGrabó";
				accion = "1";
			}
		}else{
			sResultado = "Existe";
			accion = "1";
		}
		
	}
	
	else if( accion.equals("3") ){ // Modificar
		Ciclo.setCicloId(escuelaId+request.getParameter("CicloId"));
		Ciclo.setCicloNombre(request.getParameter("CicloNombre"));
		Ciclo.setFCreada(request.getParameter("FCreada"));
		Ciclo.setFInicial(request.getParameter("FInicio"));
		Ciclo.setFFinal(request.getParameter("FFinal"));
		Ciclo.setNumCursos("0"); /* No se usa por el momento esta columna */
		Ciclo.setEstado(request.getParameter("Estado"));
		Ciclo.setEscala(request.getParameter("Escala"));
		Ciclo.setEditarActividad(request.getParameter("Editar"));
		Ciclo.setModulos(request.getParameter("Modulos"));
		Ciclo.setCicloEscolar(request.getParameter("cicloEscolar"));
		Ciclo.setDecimales(request.getParameter("decimal"));
		Ciclo.setRedondeo(request.getParameter("redondeo"));
		Ciclo.setNivelEval(request.getParameter("nivelEval"));
		Ciclo.setNivelAcademicoSistema(request.getParameter("nivelAcademicoSistema"));
		
		if (Ciclo.existeReg(conElias) == true){
			if (Ciclo.updateReg(conElias)){
				sResultado = "Modificado";
%>
				<meta http-equiv="refresh" content="0; URL='ciclo.jsp'" />
<%
			}else{
				sResultado = "Nocambio";
				accion = "5";
			}
		}else{
			sResultado = "NoExiste";
			accion = "5";
		}
	}
	
	else if( accion.equals("4") ){ // Borrar
		if (Ciclo.existeReg(conElias) == true){
			if (Ciclo.deleteReg(conElias)){
				sResultado = "Eliminado";
%>
				<meta http-equiv="refresh" content="0; URL='ciclo.jsp'" />
<%
			}else{
				sResultado = "NoElimino";
				accion = "5";
			}	
		}else{
			sResultado = "NoExiste";
			accion = "5";
		}
	}
	
	else if( accion.equals("5") ){ // Consultar			
		if (Ciclo.existeReg(conElias) == true){
			Ciclo.mapeaRegId(conElias, request.getParameter("CicloId"));
			if (Ciclo.getNumCursos()==null){
				Ciclo.setNumCursos("0");
			}
		}else{
			sResultado = "NoExiste";
		}		
	}	
	
	pageContext.setAttribute("resultado", sResultado);
	
%>

<div id="content">
	
	<h2><fmt:message key="catalago.CatalogoCargas" /></h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Grabado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a class="btn btn-primary" href="ciclo.jsp"><i class="icon-arrow-left icon-white" ></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form action="accion.jsp" method="post" name="frmcarga" target="_self">
		<input type="hidden" name="Accion">
		<input name="FCreada" type="hidden" id="FCreada" size="10" maxlength="10" value="<%=Ciclo.getFCreada()%>" readonly="YES">
		
		<%if(accion.equals("5")){%>
			<div class="input-prepend">
			  <span class="add-on"><%=escuelaId %></span>
			  <input name="CicloId" type="text" id="CicloId" size="7" maxlength="5" value="<%=!Ciclo.getCicloId().equals("")?Ciclo.getCicloId().substring(3):"" %>" class="input-mini" readonly>
			</div>
		<%}else{ %>
			<input type="hidden" name="CicloId" id="CicloId" />
			<fieldset>
				<label for="CicloId"><fmt:message key="aca.Clave" /></label>
				<div class="input-prepend input-append">
				  <span class="add-on"><%=escuelaId %></span>
				  
				  <div class="select-style" style="border-right:0;">
					  <select name="cicloNum1" id="cicloNum1">
					  	<%
					  		for( int i=aca.util.Fecha.getYearNum()-5; i<aca.util.Fecha.getYearNum()+3; i++ ){
					  			String yr = (i+"").substring(2,4);
					  	%>
					  			<option value="<%=yr %>" <%if(aca.util.Fecha.getHoy().substring(8, 10).equals(yr)){out.print("selected");} %>><%= yr %></option>
					  	<%
					  		} 
					  	%>
					  </select>
				  </div>
				  
				  
				  
				  <div class="select-style" style="border-right:0;">
					  <select name="cicloNum2" id="cicloNum2">
					  	<%
					  		for( int i=aca.util.Fecha.getYearNum()-5; i<aca.util.Fecha.getYearNum()+3; i++ ){
					  			String yr = (i+"").substring(2,4);
					  	%>
					  			<option value="<%=yr %>" <%if(aca.util.Fecha.getHoy().substring(8, 10).equals(yr)){out.print("selected");} %>><%=yr %></option>
					  	<%
					  		}
					  	%>
					  </select>
				  </div>
				  <div class="select-style">
					  <select name="cicloLetra" id="cicloLetra">
					  	<option value="A">A</option>
					  	<option value="B">B</option>
					  	<option value="C">C</option>
					  	<option value="D">D</option>
					  	<option value="E">E</option>
					  	<option value="F">F</option>
					  	<option value="G">G</option>
					  	<option value="H">H</option>
					  	<option value="I">I</option>
					  	<option value="J">J</option>
					  	<option value="K">K</option>
					  	<option value="L">L</option>
					  	<option value="M">M</option>
					  	<option value="N">N</option>
					  	<option value="O">O</option>
					  	<option value="P">P</option>
					  	<option value="Q">Q</option>
					  	<option value="R">R</option>
					  	<option value="S">S</option>
					  	<option value="T">T</option>
					  </select>
				  </div>
				</div>
			</fieldset>
		<%} 
		String nivelAcademicoSistema = Ciclo.getNivelAcademicoSistema()!=null ? Ciclo.getNivelAcademicoSistema() : "-1";
		
		%>
		<fieldset>
		<% 
		//NO MOVER POR QUE ESTE NIVEL NO TIENE QUE VER CON LOS QUE CREAN LAS ESCUELAS YA QUE LAS ESCUELAS PUEDEN CREAR AL ANTOJO ENTONCES NO HAY FORMA DE DEFINIR EL CICLO PAREJO PARA TODOS
		//ES UN DATO DURO Y ASI SE DEJA ... ATTE DANIEL
		
		%>
			<label form="nivelAcademicoSistema">Nivel de ciclo:</label>
		  	<select name="nivelAcademicoSistema" id="nivelAcademicoSistema">
		  		<option value="-1" <%if(nivelAcademicoSistema.equals("-1")  ){out.print("selected");}%>>No Definido</option>
		  		<option value="0" <%if(nivelAcademicoSistema.equals("0")){out.print("selected");}%>>Maternal</option>
		  		<option value="1" <%if(nivelAcademicoSistema.equals("1")){out.print("selected");}%>>Pre-Kinder</option>
		  		<option value="2" <%if(nivelAcademicoSistema.equals("2")){out.print("selected");}%>>Kinder</option>
		  		<option value="3" <%if(nivelAcademicoSistema.equals("3")){out.print("selected");}%>>Primaria</option>
		  		<option value="4" <%if(nivelAcademicoSistema.equals("4")){out.print("selected");}%>>Secundaria o Pre-Media</option>
		  		<option value="5" <%if(nivelAcademicoSistema.equals("5")){out.print("selected");}%>>Bachillerato</option>
		  		
		  	</select>
	
<!-- 		  <label form="nivelAcademicoSistema">Nivel de ciclo:</label> -->
<!-- 		  	<select name="nivelAcademicoSistema" id="nivelAcademicoSistema"> -->
<%-- 			  	<option value="-1" <%if(nivelAcademicoSistema.equals("-1")  ){out.print("selected");}%>>No Definido</option> --%>
<%-- 		  		<%for(aca.catalogo.CatNivelEscuela catNivel : lisNiveles){%> --%>
<%-- 					<option value="<%=catNivel.getNivelId() %>" <%if(nivelAcademicoSistema.equals(catNivel.getNivelId())){out.print("selected");}%>><%=catNivel.getNivelNombre() %></option> --%>
					
<%-- 				<%}%> --%>
		  		
<!-- 		  	</select> -->
	 	
	  	</fieldset>
		<fieldset>
			<label for="CicloNombre"><fmt:message key="aca.Nombre" /></label>
			<input name="CicloNombre" type="text" id="CicloNombre" size="30" maxlength="30" value="<%=Ciclo.getCicloNombre()%>" class="input-xlarge">
		</fieldset>
		
		<fieldset>
			<label for="FInicio"><fmt:message key="aca.FechaInicio" /></label>
			<input name="FInicio" type="text" id="FInicio" size="10" maxlength="10" value="<%=Ciclo.getFInicial()%>" class="input-medium">
		</fieldset>
		
		<fieldset>
			<label for="FFinal"><fmt:message key="aca.FechaFinal" /></label>
			<input name="FFinal" type="text" id="FFinal" size="10" maxlength="10" value="<%=Ciclo.getFFinal()%>" class="input-medium">
		</fieldset>
				
		<fieldset>
			<label for="Estado"><fmt:message key="aca.Estado" /></label>
			<select name="Estado" class="input-medium">
           		<option value='A' <%if(Ciclo.getEstado().equals("A")){out.print("selected");}%>><fmt:message key="aca.Activo" /></option>
           		<option value='I' <%if(Ciclo.getEstado().equals("I")){out.print("selected");}%>><fmt:message key="aca.Inactivo" /></option>
          	</select>
		</fieldset>
		
		<fieldset>
			<label for="Escala"><fmt:message key="aca.Escala" /></label>
			<select name="Escala" id="Escala" class="input-mini">
				<option value="5" <%if(Ciclo.getEscala().equals("5")){out.print("selected");} %>>5</option>
				<option value="10" <%if(Ciclo.getEscala().equals("10")){out.print("selected");} %>>10</option>
				<option value="100" <%if(Ciclo.getEscala().equals("100")){out.print("selected");} %>>100</option>
			</select>
		</fieldset>
		
		<fieldset>
			<label><fmt:message key="aca.EditarActividad" /></label>
			<select name="Editar" id="Editar" class="input-mini">
				<option value="SI" <%if(Ciclo.getEditarActividad().equals("SI")){out.print("selected");}%>><fmt:message key="aca.Si" /></option>
				<option value="NO" <%if(Ciclo.getEditarActividad().equals("NO")){out.print("selected");}%>><fmt:message key="aca.Negacion" /></option>
			</select>
		</fieldset>
		
		<fieldset>
			<label for="Modulos">Num. de módulos en planeación</label>
			<input name="Modulos" type="text" id="Modulos" size="2" maxlength="2" value="<%=Ciclo.getModulos()%>" class="onlyNumbers input-mini">
		</fieldset>
		
		<fieldset>
			<label for="cicloEscolar"><fmt:message key="aca.CicloEscuela" /></label>
			<input name="cicloEscolar" type="text" id="cicloEscolar" size="4" maxlength="4" value="<%=Ciclo.getCicloEscolar()%>" class="onlyNumbers input-mini">
		</fieldset>
		<fieldset>
			<label for="Decimal"><fmt:message key="aca.Decimal" /></label>
			<select id="decimal" name="decimal">
				<option value="0" <%if(Ciclo.getDecimales().equals("0")){out.print("selected");}%>>0</option>
				<option value="1" <%if(Ciclo.getDecimales().equals("1")){out.print("selected");}%>>1</option>
			</select>
		</fieldset>
		<fieldset>
			<label for="Redondeo"><fmt:message key="aca.Redondeo" /></label>
			<select id="redondeo" name="redondeo">
				<option value="A" <%if(Ciclo.getRedondeo().equals("A")){out.print("selected");}%>>Arriba</option>
				<option value="T" <%if(Ciclo.getRedondeo().equals("T")){out.print("selected");}%>>Truncado</option>
			</select>
		</fieldset>
		
		<fieldset>
			<label for="nivelEval"><fmt:message key="aca.nivelEval" /></label>
			<select id="nivelEval" name="nivelEval">
				<option value="P" <%if(Ciclo.getNivelEval().equals("P")){out.print("selected");}%>>Promedios</option>
				<option value="E" <%if(Ciclo.getNivelEval().equals("E")){out.print("selected");}%>>Evaluaciones</option>
				<option value="A" <%if(Ciclo.getNivelEval().equals("A")){out.print("selected");}%>>Actividades</option>
			</select>
		</fieldset>
		
	</form>
	                  
	<%if( accion.equals("1") ){%>				
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Anadir" /></button>
		</div>
	<%}%>
	
	<%if( accion.equals("5") ){%>
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></button>
		</div>
     <%}%>
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FInicio').datepicker();
	$('#FFinal').datepicker();
</script>

<%@ include file= "../../cierra_elias.jsp" %>