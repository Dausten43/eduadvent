<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="finReciboDet" scope="page" class="aca.fin.FinReciboDet"/>

<head>
<script type="text/javascript">
	function Guarda(){
		if(document.frmDetalle.CodigoId.value != "" && document.frmDetalle.Nombre.value !="" && document.frmDetalle.Concepto.vale !=""){
			document.frmDetalle.Accion.value="3";
			document.frmDetalle.submit();
		}else{
			alert("Complete el formulario ..!");
		}
	}
	
	function Borra(){		
		document.frmDetalle.Accion.value="4";
		document.frmDetalle.submit();		
	}
	
</script>
</head>
<%	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String codigoId 	= (String) session.getAttribute("codigoId");
	
	String tipo			= request.getParameter("Tipo");
	String accion 		= request.getParameter("Accion")==null?"1":request.getParameter("Accion");
 	String recibo		= request.getParameter("Recibo")==null?"0":request.getParameter("Recibo");
 	String folio 		= request.getParameter("Folio")==null?"0":request.getParameter("Folio");
 	
 	String tipoNombre 	= tipo.equals("R")?"Recibo":"Factura";
 	String sResultado	= "";
 	String sumaImp 		= "0";
	
	//******Buscar el siguiente folio
	if (accion.equals("1")){		
		finReciboDet.setReciboId(recibo);
		finReciboDet.setFolio(finReciboDet.maxReg(conElias, recibo));
	//******Consulta el recibo	
	}else if (accion.equals("2")){		 
		finReciboDet.mapeaRegId(conElias, recibo, folio);		
	//***********Grabar un recibo	
	}else if(accion.equals("3")){		
		conElias.setAutoCommit(false);
		finReciboDet.setReciboId(recibo);		
		finReciboDet.setFolio(folio);
		finReciboDet.setCodigoId(request.getParameter("CodigoId"));
		finReciboDet.setNombre(request.getParameter("Nombre"));
		finReciboDet.setConcepto(request.getParameter("Concepto"));
		finReciboDet.setImporte(request.getParameter("Importe"));
		
		if (finReciboDet.existeReg(conElias) == false){
			if (finReciboDet.insertReg(conElias)){
				sumaImp = aca.fin.FinRecibo.sumaConceptos(conElias, finReciboDet.getReciboId(), ejercicioId );
				if (aca.fin.FinRecibo.updateImporte(conElias, finReciboDet.getReciboId(), ejercicioId, sumaImp)){
					sResultado = "Grabado: "+finReciboDet.getReciboId()+"-"+folio;
					conElias.commit();
				}else{
					conElias.rollback();
					sResultado = "No Grabó el importe del recibo"+recibo+"-"+folio;
				}
			}else{			
				sResultado = "No grabó"+recibo+"-"+folio;
			}			
		}else{
			if (finReciboDet.updateReg(conElias)){
				sumaImp = aca.fin.FinRecibo.sumaConceptos(conElias, finReciboDet.getReciboId(), ejercicioId);
				if (aca.fin.FinRecibo.updateImporte(conElias, finReciboDet.getReciboId(), ejercicioId, sumaImp)){
					sResultado = "Modificado: "+finReciboDet.getReciboId()+"-"+folio;
					conElias.commit();
				}else{
					conElias.rollback();
					sResultado = "No actualizó el importe del recibo"+recibo+"-"+folio;
				}
					
			}else{
				sResultado = "No Cambió: "+finReciboDet.getReciboId();
			}
		}
		conElias.setAutoCommit(true);	
	}else if(accion.equals("4")){
		
		conElias.setAutoCommit(false);
		finReciboDet.setReciboId(recibo);		
		finReciboDet.setFolio(folio);		
		
		if (finReciboDet.existeReg(conElias)){
			if (finReciboDet.deleteReg(conElias)){
				sumaImp = aca.fin.FinRecibo.sumaConceptos(conElias, finReciboDet.getReciboId(), ejercicioId);
				if (aca.fin.FinRecibo.updateImporte(conElias, finReciboDet.getReciboId(), ejercicioId, sumaImp)){
					sResultado = "Borrado: "+finReciboDet.getReciboId()+"-"+folio;
					conElias.commit();
				}else{
					conElias.rollback();
					sResultado = "No actualizó el importe del recibo: "+recibo+"-"+folio;
				}			
			}else{
				sResultado = "No Borró: "+recibo+"-"+folio;
			}			
		}else{
			sResultado = "No existe: "+finReciboDet.getReciboId()+"-"+folio;		
		}
		conElias.setAutoCommit(true);
	}
%>
<body>
<form id="frmDetalle" name="frmDetalle" action="detalle.jsp" method="post" target="_self">
<input type="hidden" name="Accion">
<input type="hidden" name="Tipo" value="<%=tipo%>">
<input type="hidden" name="Recibo" value="<%=recibo%>">
<table align="center" width="70%" class="table table-condensed">
  <tr ><td class="titulo" colspan="2"></td></tr>
  <tr ><td style="text-align:center;" class="titulo" colspan="2">Tipo de Documento: <%=tipoNombre%></td></tr>
  <tr>
    <td style="text-align:center;"><a class="btn" href="recibo.jsp?Tipo=<%=tipo%>&Folio=<%=recibo%>&Accion=2">Regresar a Recibo</a></td>
  </tr>
  <tr>
	<td align="center" style="border: dotted 1px gray;">
	  <table width="100%">
		<tr>
		  <td>Folio: </td>
		  <td><input type="text" id="Folio" name="Folio" maxlength="7" size="7" value="<%=finReciboDet.getFolio()%>" readonly/></td>
		</tr>		
		<tr>
		  <td>Codigo:</td>
		  <td colspan="3"><input type="text" id="CodigoId" name="CodigoId" maxlength="7" size="7" value="<%=finReciboDet.getCodigoId() %>"/></td>
		</tr>
		<tr>
		  <td>Nombre</td>
		  <td colspan="3"><input type="text" id="Nombre" name="Nombre" maxlength="50" size="40" value="<%=finReciboDet.getNombre() %>" /></td>
		</tr>
		<tr>
		  <td>Concepto</td>
		  <td colspan="3"><input type="text" id="Concepto" name="Concepto" maxlength="50" size="40" value="<%=finReciboDet.getConcepto()%>" /></td>
		</tr>		
		<tr>
		  <td>Importe</td>
		  <td colspan="3"><input type="text" id="Importe" name="Importe" maxlength="70" size="40" value="<%=finReciboDet.getImporte()%>"/></td>
		</tr>		
		<tr> 
         	  <td colspan="2" style="text-align:center;"><%=sResultado%></td>
       	</tr>
		<tr>
		  <td style="text-align:center;" colspan="2">
		    <input class="btn" type="button" value="Guardar" onclick="Guarda();" />
<% 		if (!accion.equals("1")){%>
		    <input class="btn" type="button" value="Borrar" onclick="Borra();" />
<%		}%>
		  </td>
		</tr>
	  </table>
	</td>
</tr>
</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp"%>