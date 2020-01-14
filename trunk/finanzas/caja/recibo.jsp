<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="finFolio" scope="page" class="aca.fin.FinFolio"/>
<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo"/>
<jsp:useBean id="finRecDetL" scope="page" class="aca.fin.FinReciboDetLista"/>
<head>
<script type="text/javascript">
		function Guardar(){
			if(document.frmRecibo.fecha.value != "" && document.frmRecibo.cliente.value !="" && document.frmRecibo.domicilio.vale !=""){
				document.frmRecibo.Accion.value="3";
				document.frmRecibo.submit();
			}else{
				alert("Complete el formulario ..!");
			}
		}
</script>
</head>
<%
	java.text.DecimalFormat frmNum = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoId");	
	String tipo			= request.getParameter("Tipo");
	String accion 		= request.getParameter("Accion")==null?"1":request.getParameter("Accion");
 	String folio		= request.getParameter("Folio")==null?"0":request.getParameter("Folio");
 	String tipoNombre 	= tipo.equals("R")?"Recibo":"Factura";
 	
 	String fecha		= "";
 	String sResultado	= "";
 	boolean existe		= false;
	
	//******Buscar el siguiente folio
	if (accion.equals("1")){
		folio = aca.fin.FinFolio.getSigFolio(conElias, codigoId, tipo);
		fecha = aca.util.Fecha.getHoy();  
	//******Consulta el recibo	
	}else if (accion.equals("2")){		
		finFolio.mapeaRegId(conElias, codigoId);
		finRecibo.mapeaRegId(conElias, folio);
		fecha = finRecibo.getFecha();		
		// Para indicar que existe el recibo
		existe = true;
	//***********Grabar un recibo	
	}else if(accion.equals("3")){
		conElias.setAutoCommit(false);		
		finRecibo.setReciboId(folio);
		finRecibo.setImporte("0");
		fecha = request.getParameter("fecha");
		finRecibo.setFecha(fecha);
		finRecibo.setCliente(request.getParameter("cliente"));
		finRecibo.setDomicilio(request.getParameter("domicilio"));
		finRecibo.setCheque(request.getParameter("cheque"));
		finRecibo.setBanco(request.getParameter("banco"));
		finRecibo.setObservaciones(request.getParameter("observaciones"));
		finRecibo.setUsuario(codigoId);
		finRecibo.setRfc(request.getParameter("rfc"));
		finRecibo.setTipo(tipo);
		
		if (finRecibo.existeReg(conElias) == false){
			if (finRecibo.insertReg(conElias)){
				if (aca.fin.FinFolio.aumentarFolio(conElias, codigoId, tipo)){
					sResultado = "Grabado: "+finRecibo.getReciboId();
					conElias.commit();
					// Para indicar que existe el recibo
					existe = true;
				}else{
					conElias.rollback();
					sResultado = "No pudo incrementar el folio: "+tipo;
				}				
			}else{
				sResultado = "No Grabó: "+finRecibo.getReciboId();
			}
		}else{
			if (finRecibo.updateReg(conElias)){
				sResultado = "Modificado: "+finRecibo.getReciboId();
				conElias.commit();
				existe = true;
			}else{
				sResultado = "No Cambió: "+finRecibo.getReciboId();
			}
		}
		conElias.setAutoCommit(true);	
	}
%>
<body>
<div id="content">
	<h2>Tipo de Documento: <%=tipoNombre%></h2>
		<% if (!sResultado.equals("")){%>
   		<div class='alert alert-error'><%=sResultado%></div>
  	<% }%>
  	
  	<div class="well" style="overflow:hidden;">
    <a class="btn btn-primary" href="caja.jsp?Tipo=<%=tipo%>&Fecha=<%=fecha%>"><i  class="icon-arrow-left icon-white"></i> Regresar a Diario</a>
    </div>
  	
<form id="frmRecibo" name="frmRecibo" action="recibo.jsp" method="post" target="_self">
<input type="hidden" name="Accion">
<input type="hidden" name="Tipo" value="<%=tipo%>">
<input type="hidden" name="Folio" value="<%=folio%>">

<fieldset>
		<div class="control-group ">
	    	<label for="EscuelaId">
	        	Recibo:	         
	        </label>
	        <%=folio %> 
	    </div>
	        
	    <div class="control-group ">
	    	<label for="fecha">
	        	*Fecha:
	        </label>
	       <input id="fecha" name="fecha" type="text" value="<%=fecha%>" maxlength="10" size="10" readonly/>
	    </div>
	    
	    <div class="control-group ">
	    	<label for="text">
	        	*Cliente:	         
	        </label>
	        <input type="text" id="cliente" name="cliente" maxlength="100" size="40" value="<%=finRecibo.getCliente() %>"/>
	    </div>
	        
	    <div class="control-group ">
	    	<label for="text">
	        	*Domicilio:
	        </label>
	       <input type="text" id="domicilio" name="domicilio" maxlength="100" size="40" value="<%=finRecibo.getDomicilio() %>" />
	    </div>
	    
	    <div class="control-group ">
	    	<label for="text">
	        	R.F.C.	         
	        </label>
	        <input type="text" id="rfc" name="rfc" maxlength="12" size="12" value="<%=finRecibo.getRfc() %>"/>
	    </div>
	        
	    <div class="control-group ">
	    	<label for="text">
	        	Cheque:
	        </label>
	       <input type="text" id="cheque" name="cheque" value="<%=finRecibo.getCheque() %>"/>
	    </div>
	    
	    <div class="control-group ">
	    	<label for="text">
	        	Banco:	         
	        </label>
	        <input type="text" id="banco" name="banco" maxlength="70" size="40" value="<%=finRecibo.getBanco() %>"/>
	    </div>
	        
	    <div class="control-group ">
	    	<label for="observaciones">
	        	Observaciones:
	        </label>
	        <input id="observaciones" name="observaciones" maxlength="500" size="70" value="<%=finRecibo.getObservaciones() %>"/>
        </div>             
</fieldset>
 
        <div class="well" style="overflow:hidden;">
<%if(folio!=null){ %>
		<tr>
		  <td style="text-align:center" colspan="2"><button class="btn btn-primary" type="button" onclick="Guardar();"><i class="icon-ok icon-white"></i> Guardar</button></td>
		</tr>
<%} %>
	  </div>  	
	
</form>
<%
	if (existe){
		ArrayList lisDetalle = finRecDetL.getListRecibo(conElias, folio, "ORDER BY FOLIO");
%>
<table width="70%" align="center" class="table">
  <tr>
	<td colspan="5">C O N C E P T O S &nbsp; &nbsp; D E L &nbsp; &nbsp; D O C U M E N T O &nbsp; &nbsp; 
	<a class="btn btn-primary" href="detalle.jsp?Tipo=<%=tipo%>&Recibo=<%=folio%>"><i class="icon-plus icon-white"></i> Añadir</a></td>
  </tr>
  <tr>
	<th>#</th>
	<th>Cuenta</th>
	<th>Nombre</th>
	<th>Concepto</th>
	<th>Cantidad</th>
  </tr>
<%
		for (int j=0;j<lisDetalle.size(); j++){
			aca.fin.FinReciboDet detalle = (aca.fin.FinReciboDet)lisDetalle.get(j);
%>			
  <tr>
	<td><%=j+1%></td>
	<td><a href="detalle.jsp?Tipo=<%=tipo%>&Recibo=<%=folio%>&Folio=<%=detalle.getFolio()%>&Accion=2"><%=detalle.getCodigoId() %></a></td>
	<td><%=detalle.getNombre() %></td>
	<td><%=detalle.getConcepto() %></td>
	<td><%=frmNum.format(Double.valueOf(detalle.getImporte()))%></td>
  </tr>
<%			
		}
	}
%> 
  <tr>
    <td colspan="5" style="text-align:center;">
<% 	if (tipo.equals("R") && existe){%> 
      <a href="reciboPDF.jsp?Recibo=<%=folio%>">F o r m a t o &nbsp; &nbsp; R e c i b o</a>
<% 	}else if (existe){%>
	  <a href="facturaPDF.jsp?Recibo=<%=folio%>">F o r m a t o &nbsp; &nbsp; F a c t u r a</a>
<%	}%>      
    </td>
  </tr>
  </div>
</body>
<%@ include file= "../../cierra_elias.jsp"%>