<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Grupo" scope="page" class="aca.catalogo.CatGrupo"/>
<jsp:useBean id="GrupoLista" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="CatNivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>


<script>
	function Nuevo(){		
		document.frmGrupo.Grado.value 		= "1";
		document.frmGrupo.Grupo.value 		= "A";
		document.frmGrupo.submit();		
	}
	
	function Grabar(){		
		document.frmGrupo.Accion.value="2";
		document.frmGrupo.submit();
	}		
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");	
	String nivelId 			= request.getParameter("nivelId");
	String folio 			= request.getParameter("folio");
	
	String grupos			= GrupoLista.getGrupos(conElias, escuelaId, nivelId);	
	String grupo			= "";
	String sResultado 		= "";
	String salto			= "X";
	
	CatNivel.mapeaRegId(conElias, nivelId, escuelaId);
	
	int numAccion 			= request.getParameter("Accion")==null?Integer.parseInt("0"):Integer.parseInt(request.getParameter("Accion"));
	
	// Operaciones a realizar en la pantalla
	switch (numAccion){
	
		case 2: { // Grabar
			Grupo.setEscuelaId(escuelaId);			
			Grupo.setNivelId(nivelId);
			Grupo.setGrado(request.getParameter("Grado"));
			Grupo.setGrupo(request.getParameter("Grupo"));
			Grupo.setTurno(request.getParameter("turno"));
			
			if (Grupo.existeReg(conElias, escuelaId, nivelId, request.getParameter("Grado"), request.getParameter("Grupo")) == false){
				
				Grupo.setFolio(Grupo.maximoReg(conElias));
				if (Grupo.insertReg(conElias)){
					sResultado = "Guardado";
					salto = "grupo.jsp?nivelId="+request.getParameter("nivelId");
				}else{
					sResultado = "NoGuardo";
				}
			}else{
				Grupo.setFolio(Grupo.getFolio(conElias, escuelaId, nivelId, request.getParameter("Grado"), request.getParameter("Grupo")));
				
				if (Grupo.updateReg(conElias)){
					sResultado = "Modificado";
					salto = "grupo.jsp?nivelId="+request.getParameter("nivelId");
				}else{
					sResultado = "NoModifico";
				}
			}			
			break;
		}		
		case 4: { //Prepara el modificar
			Grupo.mapeaRegId(conElias, folio);
			break;
		}
		case 5: { // Borrar
			Grupo.setFolio(folio);
			Grupo.deleteReg(conElias);
			salto = "grupo.jsp?nivelId="+request.getParameter("nivelId");
			break;
		}
	}
	
	pageContext.setAttribute("resultado", sResultado);
%>

<div id="content">
	<h2><fmt:message key="catalogo.AnadirGrupo" />  <small><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId) %></small></h2>
	<% if (!sResultado.equals("") && (sResultado.equals("Guardado") || sResultado.equals("Modificado"))){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){ %>
  		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
  	<% }%>
	<div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="grupo.jsp?nivelId=<%=nivelId %>"><i class="icon-arrow-left icon-white"></i>&nbsp;<fmt:message key="boton.Regresar" /></a>
	</div>		
	
	<form action="accionGrupo.jsp?nivelId=<%=nivelId %>" method="post" name="frmGrupo" target="_self">
	<input type="hidden" name="Accion">
	<input type="hidden" name="folio" value="<%=folio%>">
	<input type="hidden" name="nivelId" value="<%=nivelId %>">

  	<fieldset>
    	<label for="Grado">
        	<%if(aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivelId).equals("Grado")){ %>
 				<fmt:message key="aca.Grado" /> 
 			<%}else{ %>
 				<fmt:message key="aca.Semestre" />
 			<%} %>
        </label>
       	<select id="Grado" name="Grado">
			<%for(int i = Integer.parseInt(CatNivel.getGradoIni()); i <= Integer.parseInt(CatNivel.getGradoFin()); i++){%>
				<option value="<%=i %>" <%if(Grupo.getGrado().equals(String.valueOf(i))) out.print("Selected"); %>><%=i%></option>
			<%}%>
         </select>
	</fieldset>
	
	<fieldset>	        
	    <label for="NivelNombre">
	       	<fmt:message key="aca.Grupo" />
	    </label>
	    <select id="Grupo" name="Grupo">         		
			<%
			for(int i = 65; i <= 84; i++){
				grupo = String.valueOf((char)i);
			%>
				<option value="<%=(char)i %>" <%if(Grupo.getGrupo().equals(String.valueOf((char)i))) out.print("Selected"); %>><%=(char)i%></option>
			<%	
			}
			%>
       	</select>
	</fieldset>
	
	<%
		String turno = Grupo.getTurno()==null?"":Grupo.getTurno();
	%>
	<fieldset>
		<label for="turno"><fmt:message key="aca.Turno" /></label>
		<select name="turno" id="turno">
			<option value="" <%if(turno.equals("")){out.print("selected");} %>><fmt:message key="aca.NoAplica" /></option>
			<option value="M" <%if(turno.equals("M")){out.print("selected");} %>><fmt:message key="aca.Matutino" /></option>
			<option value="V" <%if(turno.equals("V")){out.print("selected");} %>><fmt:message key="aca.Vespertino" /></option>
		</select>
	</fieldset>

</form>
	
	<div class="well">
		    <a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
	</div>

</div>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %> 
