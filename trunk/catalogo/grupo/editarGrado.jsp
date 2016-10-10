<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Grupo" scope="page" class="aca.catalogo.CatGrupo"/>
<jsp:useBean id="GrupoLista" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="CatNivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<jsp:useBean id="CatEsquema" scope="page" class="aca.catalogo.CatEsquema"/>

<script>
	function Grabar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");	
	String nivelId 			= request.getParameter("nivelId");
	String grado 			= request.getParameter("grado");
	
	CatNivel.mapeaRegId(conElias, nivelId, escuelaId);
	
	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String sResultado 		= "";
	
	if(accion.equals("1")){
		conElias.setAutoCommit(false);
		CatEsquema.setEscuelaId(escuelaId);
		CatEsquema.setEsquemaEvaluacion(request.getParameter("esquema"));
		CatEsquema.setNivelId(nivelId);
		CatEsquema.setGrado(grado);
		CatEsquema.setSubNivel(request.getParameter("subnivel"));
		System.out.println(request.getParameter("nombreGrado"));
		CatEsquema.setGradoNombre(request.getParameter("nombreGrado")==""?aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grado))+" "+request.getParameter("titulo").toUpperCase():request.getParameter("nombreGrado"));
		CatEsquema.setSemestreNombre(request.getParameter("nombreSemestre"));
		
		if(CatEsquema.existeReg(conElias)==false){
			
			if(CatEsquema.insertReg(conElias)){
				conElias.commit();
				sResultado = "Guardado";
			}else{
				sResultado = "NoGuardo";
			}
			
			
		}else{//Modifica
			
			if(CatEsquema.updateReg(conElias)){
				conElias.commit();
				sResultado = "Modificado";
			}else{
				sResultado = "NoModifico";
			}
			
		}
		conElias.setAutoCommit(true);
	}
	
	
	pageContext.setAttribute("resultado", sResultado);
	
%>

<div id="content">
	<h2>
		<fmt:message key="catalogo.EditarGrado" />  <small><%=grado%> | <%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId) %></small>
	</h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
  	<div class="alert alert-info">
  		<fmt:message key="aca.ComoSaleReportes" />: <strong><%=aca.catalogo.CatEsquemaLista.getGradoYGrupo(conElias, escuelaId, nivelId, grado) %></strong>
  	</div>
  	
	<div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="grupo.jsp?nivelId=<%=nivelId %>&grado=<%=grado %>&titulo=<%=request.getParameter("titulo")%>"><i class="icon-arrow-left icon-white"></i>&nbsp;<fmt:message key="boton.Regresar" /></a>
	</div>		
	
	<form action="editarGrado.jsp" method="get" name="forma" target="_self">
		<input type="hidden" name="Accion">
		<input type="hidden" name="nivelId" id="nivelId" value="<%=nivelId %>">
		<input type="hidden" name="grado" id='grado' value="<%=grado %>">
		<input type="hidden" name="titulo" id='grado' value="<%=request.getParameter("titulo") %>">
		
		
		<fieldset>
			<label for="nombreGrado"><fmt:message key="aca.NombreGrado" /></label>
			<input type="text" name="nombreGrado" value="<%=aca.catalogo.CatEsquemaLista.getNombreGrado(conElias, escuelaId, nivelId, grado, false) %>" required/>
		</fieldset>
		
		<fieldset>
			<label for="nombreSemestre"><fmt:message key="aca.NombreSemestre" /></label>
			<input type="text" name="nombreSemestre" value="<%=aca.catalogo.CatEsquemaLista.getNombreSemestre(conElias, escuelaId, nivelId, grado) %>"/>
		</fieldset>
		
		<fieldset>
			<label for="esquema"><fmt:message key="aca.EsquemaEvaluacion" /></label>
			<select  id="esquema" name="esquema" >										
				<option value="N" <%if(aca.catalogo.CatEsquemaLista.getEsquemaEvaluacionNivel(conElias, escuelaId, nivelId, grado).equals("N"))out.print("selected"); %>><fmt:message key="aca.Numerico" /></option>
				<option value="C" <%if(aca.catalogo.CatEsquemaLista.getEsquemaEvaluacionNivel(conElias, escuelaId, nivelId, grado).equals("C"))out.print("selected"); %>><fmt:message key="aca.PorCompetencias" /></option>
			</select>
		</fieldset>	
		
		<fieldset>
			<label for="subnivel"><fmt:message key="aca.Subnivel" /></label>
			<select  id="subnivel" class="input-medium" name="subnivel">
				<option value="-1" <%if(aca.catalogo.CatEsquemaLista.getSubNivel(conElias, escuelaId, nivelId, grado).equals(""))out.print("selected"); %>><fmt:message key="aca.NoEspecificado" /></option>
				<option value="1" <%if(aca.catalogo.CatEsquemaLista.getSubNivel(conElias, escuelaId, nivelId, grado).equals("1"))out.print("selected"); %>>1</option>
				<option value="2" <%if(aca.catalogo.CatEsquemaLista.getSubNivel(conElias, escuelaId, nivelId, grado).equals("2"))out.print("selected"); %>>2</option>
				<option value="3" <%if(aca.catalogo.CatEsquemaLista.getSubNivel(conElias, escuelaId, nivelId, grado).equals("3"))out.print("selected"); %>>3</option>
			</select>
		</fieldset>
		
		<div class="well">
		    <a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		</div>
		
  	
	</form>
	

</div>


<%@ include file= "../../cierra_elias.jsp" %> 
