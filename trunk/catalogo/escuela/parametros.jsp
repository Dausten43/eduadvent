<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="CatEscuela" scope="page" class="aca.catalogo.CatEscuela"/>

<html>
<%
	String escuelaSesion	= (String) session.getAttribute("escuela");
	String escuela 			= request.getParameter("escuela");
	String unionId 			= request.getParameter("unionId");
	String accion 			= request.getParameter("Accion")==null ?"0": request.getParameter("Accion");
	String resultado 		= "";

	if(accion.equals("1")){		
		CatParametro.setEscuelaId(escuela);
		CatParametro.setFirmaBoleta(request.getParameter("FirmaDirector"));
		CatParametro.setFirmaPadre(request.getParameter("FirmaPadre"));
		CatParametro.setSunPlus(request.getParameter("SunPlus"));
		CatParametro.setIpServer(request.getParameter("IpServer"));
		CatParametro.setBaseDatos(request.getParameter("BaseDatos"));
		CatParametro.setPuerto(request.getParameter("Puerto"));
		CatParametro.setCaja(request.getParameter("Caja"));
		CatParametro.setTipoBoleta(request.getParameter("tipoBoleta"));
		CatParametro.setBloqueaPortal(request.getParameter("Deuda"));
		
		if(!CatParametro.existeReg(conElias)){
			if(CatParametro.insertReg(conElias)){						
				resultado = "Grabado";
			}
			else{			
				resultado = "NoGrabo";
			}
		}
		else{
			if(CatParametro.updateReg(conElias)){				
				resultado = "Modificado";
			}
			else{				
				resultado = "NoModifico";
			}
		}
	}
	
	pageContext.setAttribute("resultado", resultado);

	CatParametro.mapeaRegId(conElias, escuela);	
	CatEscuela.mapeaRegId(conElias, escuela);
%>
<div id="content">
	<h2><fmt:message key="aca.Parametros" /></h2>
	<% if (!resultado.equals("")){%>
   		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
  	<% }%>
	<div class="well" style="overflow:hidden;">
		<a href="escuela.jsp?unionId=<%=unionId %>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i>&nbsp; <fmt:message key="boton.Regresar" /></a>
	</div>
	<form name="frmParametro" action="parametros.jsp">
		<input name="escuela" type="hidden" value="<%=escuela%>" />
		<input name="unionId" type="hidden" value="<%=unionId%>" />
		<input name="Accion" type="hidden" />
		<fieldset>
		<div class="control-group ">
	    	<label for="FirmaDirector">
	        	<fmt:message key="aca.FirmaDirector" />:
	         
	        </label>
	       <select id="FirmaDirector" name="FirmaDirector">
		   		<option value="N"<%=CatParametro.getFirmaBoleta().equals("N")?" Selected":""%>><fmt:message key="aca.Negacion" /></option>
				<option value="S"<%=CatParametro.getFirmaBoleta().equals("S")?" Selected":""%>><fmt:message key="aca.Si" /></option>					  
		   </select>
	    </div>
	        
	    <div class="control-group ">
	    	<label for="FirmaPadre">
	        	<fmt:message key="aca.FirmaPadre" />:
	        </label>
	       <select id="FirmaPadre" name="FirmaPadre">
				<option value="N"<%=CatParametro.getFirmaPadre().equals("N")?" Selected":""%>><fmt:message key="aca.Negacion" /></option>
				<option value="S"<%=CatParametro.getFirmaPadre().equals("S")?" Selected":""%>><fmt:message key="aca.Si" /></option>					  
		   </select>	   
	    </div>
	    <div class="control-group ">
	    	<label for="SunPlus">
	        	<fmt:message key="aca.SunPlus" />:
	        </label>
	       <select id="SunPlus" name="SunPlus">
				<option value="N"<%=CatParametro.getSunPlus().equals("N")?" Selected":""%>><fmt:message key="aca.Negacion" /></option>
				<option value="S"<%=CatParametro.getSunPlus().equals("S")?" Selected":""%>><fmt:message key="aca.Si" /></option>					  
		   </select>	   
	    </div>	    
	    
	    <div class="control-group ">
	    	<label for="IpServer">
	        	<fmt:message key="aca.Servidor" />:
	        </label>
	       <input type="text" id="IpServer" name="IpServer" value="<%=CatParametro.getIpServer()%>" maxlength="15" />		
	    </div>	        
	    
	    <div class="control-group ">
	    	<label for="BaseDatos">
	        	<fmt:message key="aca.BaseDatos" />:
	        </label>
	       <input type="text" id="BaseDatos" name="BaseDatos" value="<%=CatParametro.getBaseDatos()%>" maxlength="20" />		
	    </div>	    
	    
	    <div class="control-group ">
	    	<label for="Puerto">
	        	<fmt:message key="aca.Puerto" />:
	        </label>
	       <input type="text" id="Puerto" name="Puerto" value="<%=CatParametro.getPuerto()%>" maxlength="4" />	       	
	    </div>
	    
	    <div class="control-group ">
	    	<label for="Caja">
	        	<fmt:message key="aca.Caja" />:
	        </label>
	       <input type="text" id="Caja" name="Caja" value="<%=CatParametro.getCaja()%>" maxlength="10" />    	
	    </div>
	    
	    <div class="control-group ">
	    	<label for="Boleta">
	        	<fmt:message key="aca.Boleta" />:
	        </label>
	        <select id="boleta" name="tipoBoleta">
				<option value="1"<%=CatParametro.getTipoBoleta().equals("1")?" Selected":""%>><fmt:message key="aca.BoletaMex" /></option>
				<option value="2"<%=CatParametro.getTipoBoleta().equals("2")?" Selected":""%>><fmt:message key="aca.BoletaDom" /></option>	
				<option value="3"<%=CatParametro.getTipoBoleta().equals("3")?" Selected":""%>><fmt:message key="aca.BoletaPan" /></option>
				<option value="4"<%=CatParametro.getTipoBoleta().equals("4")?" Selected":""%>><fmt:message key="aca.BoletaSal" /></option>					  
		   </select>
	    </div>
	    
	    <div class="control-group ">
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
		document.frmParametro.Accion.value = "1";
		document.frmParametro.submit();
	}
</script>
</html>
<%@ include file= "../../cierra_elias.jsp" %>