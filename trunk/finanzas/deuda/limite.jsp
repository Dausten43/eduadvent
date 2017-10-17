<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>

<%
	String escuela			= (String) session.getAttribute("escuela");
	String accion 			= request.getParameter("Accion")==null ?"0": request.getParameter("Accion");
	String resultado 		= "";
	
	CatParametro.mapeaRegId(conElias, escuela);	
	
	if(accion.equals("1")){		
		CatParametro.setBloqueaPortal(request.getParameter("Deuda"));
		
		if(CatParametro.updateReg(conElias)){				
			resultado = "Modificado";
		}
		else{				
			resultado = "NoModifico";
		}
	}
	
	pageContext.setAttribute("resultado", resultado);
%>
<html>
	<div id="content">
		<% if (!resultado.equals("")){%>
	   		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
	  	<% }%>
		<div class="well" style="overflow:hidden;">
			<h2>L&iacute;mite de deuda</h2>
		</div>
		<form name="frmLimite" action="limite.jsp">
			<input name="escuela" type="hidden" value="<%=escuela%>" />
			<input name="Accion" type="hidden" />
			<fieldset>
				<div class="control-group " style="margin:20px 0px 30px 20px">
					<label for="Límite de Deuda">
						<fmt:message key="aca.limiteDeuda" />:
					</label>
					<input type="text" id="Deuda" name="Deuda" value="<%=CatParametro.getBloqueaPortal() %>" maxlength="9" />
				</div>
			</fieldset>	
			<div class="well" style="overflow:hidden;">
				<button class="btn btn-primary" onclick="javascript:Graba()" ><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></button>
			</div>
		</form>
	</div>
	<script>
		function Graba(){		
			document.frmLimite.Accion.value = "1";
			document.frmLimite.submit();
		}
	</script>
</html>

<%@ include file= "../../cierra_elias.jsp" %>