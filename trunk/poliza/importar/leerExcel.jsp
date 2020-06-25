<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<!--
	YOU NEED THIS JARS IN YOUR JAVA BUILD PATH FOR THE FILE UPLOAD:
	commons-fileupload-1.3.jar 
	commons-io-2.4.jar
 -->

<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>

<!--
	YOU NEED THIS JARS IN YOUR JAVA BUILD PATH FOR READING AN EXCEL FILE:
	dom4j-1.6.1.jar
	poi-3.7.jar
	poi-ooxml-3.7.jar
	poi-ooxml-schemas-3.7.jar
	xmlbeans-2.3.0.jar
 -->

<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>

<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>

<div id="content">

  	<div class="well">
		<a href="recibos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("####;-####", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	// APACHE FILE UPLOAD ------------------------------------------>	
	DiskFileItemFactory factory 	= new DiskFileItemFactory();
	ServletFileUpload upload 		= new ServletFileUpload(factory);
	
	String escuelaId				= (String) session.getAttribute("escuela");
	boolean validaDatos				= true;
	String salto 					= "X";
	
	//Parse the request
	java.util.List<FileItem> items 	= upload.parseRequest(request);
	
	// lista para almacenar los datos de los alumnos que se van a grabar
	ArrayList<aca.fin.FinReciboTemp> lisRecibos	= new ArrayList<aca.fin.FinReciboTemp>();

/* VALIDACIÓN DE LOS DATOS**/

	// Recorre los archivos que se van a subir
	java.util.Iterator<FileItem> iter = items.iterator();	
	while (iter.hasNext()) {
		System.out.println("iter:"+items.size());
	    FileItem item = iter.next();
	 	// Get the inputs that have files = <input type="file" />
	    String fieldname 	= item.getFieldName();
	    String filename 	= item.getName();
	    if(fieldname.equals("archivo")){
	    	java.io.InputStream is = item.getInputStream();
	    	
/* ========================= LEYENDO EXCEL ===================================== */
				
		    //Get the workbook instance for XLS file 
		    XSSFWorkbook workbook = new XSSFWorkbook(is);
			//Iterate through each sheet of the excel file
			java.util.Iterator<XSSFSheet> sheetIterator = workbook.iterator();
			int cont = 0;
			
			// Lee las hojas del archivo
			sheetIterator = workbook.iterator();			
		   		XSSFSheet sheet = sheetIterator.next();
		   		
		   		//Codigo temporal
		   		String codigoId	= "X";
	%>			
			<div class="tab-pane fade <%if(cont==0)out.print("in active"); %>" id="<%=cont %>">
				<table class="table table-condensed">
	<%
			   	//Iterate through each rows from first sheet
			   	int linea = 0;
			    java.util.Iterator<Row> rowIterator = sheet.iterator();
			    while(rowIterator.hasNext()) {			    	
			        Row row = rowIterator.next();
			        System.out.println("linea:"+linea);
			        linea++;
			        
			        // Obtener los datos de las columnas en el renglón actual
			        
			        Cell grabar			= row.getCell(0);
			    	Cell reciboId		= row.getCell(1);
			    	Cell fecha		 	= row.getCell(2);
			    	Cell beneficiario	= row.getCell(3);
			    	Cell cliente	  	= row.getCell(4);			    	
			    	Cell cuentaId 		= row.getCell(5);			    	
			    	Cell auxiliar	 	= row.getCell(6);
			    	Cell descripcion 	= row.getCell(7);
			    	Cell importe 		= row.getCell(8);
			    	Cell referencia 	= row.getCell(9);
			    	Cell escuela		= row.getCell(10);
			    	Cell folio 			= row.getCell(11);
			    	Cell pago 			= row.getCell(12);
			    	
			    
			    	
			    	// Si el renglon tiene la bandera de grabar
			    	if ( grabar!=null && grabar.getCellType()==HSSFCell.CELL_TYPE_STRING ){
			    	System.out.println("Entre..."+linea);
			    	
				    	
				    	// Variables boolean para validación
				    	boolean errorRecibo = false, errorCliente = false, errorCuenta = false, errorAuxiliar = false, errorDescripcion = false, errorImporte = false, errorReferencia = false;
				    	boolean errorEscuela = false, errorFFecha = false, errorFolio = false, errorPago = false, errorBeneficiario=false;
				    	
				    	
				    	// Validar los campos
				    	
				    	
				    	
				    	String strRecibo	= "0";
				    	if (reciboId != null && !reciboId.toString().matches("\\D+") && !reciboId.toString().matches("\\s+")){
				    		strRecibo = aca.util.Utilerias.removeEmptyDecimalPoints(reciboId.toString());
				    	}else{
				    		errorRecibo = true;
				    	}
				    	System.out.println(errorRecibo);
				    
				    	boolean errorFecha = false;
				    	
						   
				    	/* Formatear y validar el campo de fecha */
				    	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
				    	String fechaRecibo = "20/12/1950";
				    	if(fecha.getCellType()== HSSFCell.CELL_TYPE_NUMERIC){
				    		System.out.println("Fecha"+fecha.getCellStyle().getDataFormat());
			            	if (fecha.getCellStyle().getDataFormat()==0){
			            		errorFecha = true;
			            		fechaRecibo = formato.format(fecha.getNumericCellValue());
			            	}else{
			            		fechaRecibo = sdf.format(fecha.getDateCellValue());
			            	}
			            }else{
			            	errorFecha=true;
			            }	

				    	
				    	String strBeneficiario	= "-";
				    	if (beneficiario != null && !beneficiario.toString().matches("\\s+")){
				    		strBeneficiario = beneficiario.toString();
				    	}else{
				    		errorBeneficiario = true;
				    	}
				    	
				    	String strCliente	= "-";
				    	if (cliente != null && !cliente.toString().matches("\\s+")){
				    		strCliente = cliente.toString();
				    	}else{
				    		errorCliente = true;
				    	}
				    	
				    	
					    String strCuenta		= "-";
					    if (cuentaId != null && !cuentaId.toString().matches("\\s+")){
					    	strCuenta = cuentaId.toString();
				    	}else{
				    		errorCuenta = true;
				    	}
				    	
					    String strAuxiliar		= "-";
					    if (auxiliar!= null && !auxiliar.toString().matches("\\s+")){
					    	strAuxiliar = auxiliar.toString();
				    	}else{
				    		errorAuxiliar = true;
				    	}
				    	
					    String strDescripcion	= "X";
					    if ( descripcion != null && !descripcion.toString().matches("\\s+")){
					    	strDescripcion = descripcion.toString();
					    }else{
					    	errorDescripcion = true;
					    }
					    
				    	String strImporte	= "0";
				    	if (importe != null && !importe.toString().matches("\\D+") && !importe.toString().matches("\\s+")){
				    		strImporte = importe.toString();
				    	}else{
				    		errorImporte = true;
				    	}
				    	
				    	
				    	
				    	String strReferencia	= "-";			    
				    	if (referencia != null && !referencia.toString().matches("\\s+")){
				    		strReferencia = referencia.toString();
				    	}else{
				    		errorReferencia = true;
				    	}
				    	
				    	
				    	String strEscuela	= "-";		    	
				    	if (escuela != null && !escuela.toString().matches("\\s+")){
				    		strEscuela = escuela.toString();
				    	}else{
				    		errorEscuela = true; 
				    	}
				    	
				    	
				    	String strFolio	= "0";
				    	if (folio != null && !folio.toString().matches("\\D+") !folio.toString().matches("\\s+")){
				    		strFolio= aca.util.Utilerias.removeEmptyDecimalPoints(folio.toString());
				    	}else{
				    		errorFolio = true;
				    	}

				    	String strPago	= "-";
				    	System.out.println("pago: "+pago);
				    	if(pago.equals("")){
				    		System.out.println("hello");
				    	}
				    	if (pago != null && !pago.toString().matches("") && !pago.toString().matches("\\s+")){
				    		strPago=pago.toString();
				    	}else{
				    		errorPago = true;
				    	}
					    

					    

					    if ( errorRecibo || errorFecha || errorCliente || errorCuenta || errorAuxiliar || errorDescripcion || errorReferencia ||
					    	 errorImporte || errorEscuela || errorFolio|| errorPago|| errorBeneficiario){
					    	validaDatos = false;
					    %>
					    <tr>
					    	<td "style='background-color:red;'"><b><%=linea%></b></td>
					    	<td <% if (errorRecibo) out.print("style='background-color:red;'");%>><b><%=reciboId%></b></td>
					    	<td <% if (errorFecha) out.print("style='background-color:red;'");%>><b><%="Formato esperado ("+fechaRecibo+") -- encontro("+ fecha.toString()+")"%></b></td>
					    	<td <% if (errorBeneficiario) out.print("style='background-color:red;'");%>><b><%=strBeneficiario%></td>
					    	<td <% if (errorCliente) out.print("style='background-color:red;'");%>><b><%=strCliente%></td>
					    	<td <% if (errorCuenta) out.print("style='background-color:red;'");%>><b><%=strCuenta%></td>
					    	<td <% if (errorAuxiliar) out.print("style='background-color:red;'");%>><b><%=strAuxiliar%></td>
					    	<td	<% if (errorDescripcion) out.print("style='background-color:red;'");%>><b><%=strDescripcion%></td>
					    	<td <% if (errorImporte) out.print("style='background-color:red;'");%>><b><%=importe%></b></td>
					    	<td <% if (errorReferencia) out.print("style='background-color:red;'");%>><b><%=strReferencia%></b></td>
					    	<td <% if (errorEscuela) out.print("style='background-color:red;'");%>><b><%=strEscuela%></td>
					    	<td <% if (errorFolio) out.print("style='background-color:red;'");%>><b><%=folio%></b></td>
					    	<td <% if (errorPago) out.print("style='background-color:red;'");%>><b><%=pago%></b></td>
					    </tr>	
					    <%
					    }else{
					    	System.out.println(strCuenta);
					    	// Instancia del alumno
					    	aca.fin.FinReciboTemp recibo = new aca.fin.FinReciboTemp();
					    	//System.out.println("Agregar alumno"+linea+":"+strNombre+":"+strPaterno+":"+strMaterno+":"+strGenero+":"+strCorreo+":"+
					    	//strColonia+":"+strDireccion+":"+strTelefono+":"+strCelular+":"+strNivel+":"+strGrado+":"+strGrupo);
					    	System.out.println(strRecibo);
					    	recibo.setReciboId(strRecibo);
							recibo.setFecha(fechaRecibo);
							recibo.setCliente(strCliente);
							recibo.setCuentaId(strCuenta);
							recibo.setAuxiliar(strAuxiliar);
							recibo.setDescripcion(strDescripcion);
							recibo.setImporte(strImporte);
							recibo.setReferencia(strReferencia);
							recibo.setEscuelaId(strEscuela);
							recibo.setFolio(strFolio);
							recibo.setFormaPago(strPago);
							recibo.setBeneficiario(strBeneficiario);
							
					    	if ( recibo.insertReg(conElias) ){
					    		//conElias.commit();
					    	}

					    }		    	
					    
			    	} // si tiene la bandera de grabar
			    	
			    }//End while of rows
			    
			    // Incrementa el numero de hoja
			    cont++;
%>	    
			</table>
		</div>
<%		
		    
	    /* ========================= FIN LEYENDO EXCEL ===================================== */
	    	
	    }
	    
	}
	if(validaDatos){
%>
	
	<script>
	    window.location.assign("recibos.jsp")
	</script>
<%	} 
%>
</div>
<%@ include file="../../cierra_elias.jsp"%>

