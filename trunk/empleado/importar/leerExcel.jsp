<%@page import="java.util.List"%>
<%@page import="sun.misc.BASE64Encoder"%>
<%@page import="java.security.MessageDigest"%>
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
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>


<div id="content">

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("####;-####", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	// APACHE FILE UPLOAD ------------------------------------------>	
	DiskFileItemFactory factory 	= new DiskFileItemFactory();
	ServletFileUpload upload 		= new ServletFileUpload(factory);
	
	String escuelaId				= (String) session.getAttribute("escuela");
	boolean validaDatos				= true;
	
	//Parse the request
	java.util.List<FileItem> items 	= upload.parseRequest(request);
	
	ArrayList<aca.empleado.EmpPersonal> lisEmpleados		= new ArrayList<aca.empleado.EmpPersonal>();
	
	// Process the uploaded items
	java.util.Iterator<FileItem> iter = items.iterator();
	while (iter.hasNext()) {//ITERATE ALL THE HTML INPUTS IN THE FORM
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
		    while(rowIterator.hasNext()) {//ROWS
		        Row row = rowIterator.next();
		    	linea++;
		    			    	
		        Cell grabar		= row.getCell(0);
		    	Cell nombre		= row.getCell(1);
		    	Cell apaterno 	= row.getCell(2);
		    	Cell amaterno  	= row.getCell(3);			    	
		    	Cell nacimiento = row.getCell(4);			    	
		    	Cell genero 	= row.getCell(5);
		    	Cell correo 	= row.getCell(6);
		    	Cell colonia 	= row.getCell(7);
		    	Cell direccion 	= row.getCell(8);
		    	Cell telefono 	= row.getCell(9);
		    	Cell ocupacion 	= row.getCell(10);
		    	Cell estado 	= row.getCell(11);			    
		    	
		    	// Si el renglon tiene la bandera de grabar
		    	if (grabar!=null && grabar.getCellType()==HSSFCell.CELL_TYPE_STRING ){
		    	//System.out.println("Entre..."+linea);
			    	boolean errorFecha = false;
			   
			    	/* Formatear y validar el campo de fecha */
			    	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
			    	String fechaNac = "01/01/1950";
			    	if(nacimiento.getCellType()== HSSFCell.CELL_TYPE_NUMERIC){
		            	if (nacimiento.getCellStyle().getDataFormat()==0){
		            		errorFecha = true;
		            		fechaNac = formato.format(nacimiento.getNumericCellValue());
		            	}else{
		            		fechaNac = sdf.format(nacimiento.getDateCellValue());
		            	}
		            }else{
		            	errorFecha=true;
		            }			    	
			    	
			    	// Variables boolean para validación
			    	boolean errorNombre = false, errorApaterno = false, errorAmaterno = false, errorNacimiento = false, errorGenero = false;
			    	boolean errorCorreo = false, errorColonia = false, errorDireccion = false, errorTelefono = false, errorOcupacion = false, errorEstado = false;
			    	
			    	
			    	// Validar los campos
			    	
			    	String strNombre	= "-";
			    	if (nombre != null){
			    		strNombre = nombre.toString();
			    	}else{
			    		errorNombre = true;
			    	}
			    	
			    	String strPaterno	= "-";
			    	if (apaterno != null){
			    		strPaterno = apaterno.toString();
			    		if (strPaterno.equals("*")) strPaterno = " ";
			    	}else{
			    		errorApaterno = true;
			    	}
			    	
			    	String strMaterno	= "-";		    	
			    	if (amaterno != null){
			    		strMaterno = amaterno.toString().trim();
			    		if (strMaterno.equals("*")) strMaterno = " ";
			    	}else{
			    		errorAmaterno = true; 
			    	}
			    	
			    	String strGenero	= "M";
			    	if (genero != null){
			    		strGenero = genero.toString().trim();
			    		if (!strGenero.equals("M") && !strGenero.equals("F")) errorGenero = true;
			    	}else{
			    		errorGenero = true;
			    	}
			    	
			    	String strCorreo	= "@";
			    	if (correo != null){
			    		strCorreo = correo.toString();
			    	}else{
			    		errorCorreo = true;
			    	}
			    	
			    	String strColonia	= "-";
			    	if (colonia != null){
			    		strColonia = colonia.toString();
			    	}else{
			    		errorColonia = true;
			    	}
			    	
			    	String strDireccion	= "-";
			    	if (direccion != null){
			    		strDireccion = direccion.toString();
			    	}else{
			    		errorDireccion = true;
			    	}
			    				    	
			    	String strTelefono	= "-";
			    	if (telefono != null ){
			    		if(telefono.getCellType() == XSSFCell.CELL_TYPE_NUMERIC ){
				    		strTelefono = aca.util.Utilerias.removeEmptyDecimalPoints( ((long) telefono.getNumericCellValue()) + "").trim();
			    		}else if(telefono.getCellType() == XSSFCell.CELL_TYPE_STRING ){
				    		strTelefono = telefono.toString()==null?"-":telefono.toString();
				    	}else{
				    		errorTelefono = true;
				    	}
			    	}
			    	
			    	String strOcupacion	= "-";		    	
			    	if (ocupacion != null){
			    		strOcupacion = ocupacion.toString().trim();
			    		if (strOcupacion.equals("*")) strOcupacion = " ";
			    	}else{
			    		errorOcupacion = true; 
			    	}
			    	
			    	String strEstado	= "A";
			    	if (estado != null){
			    		strEstado = estado.toString().trim();
			    		if (!strEstado.equals("A") && !strEstado.equals("I")) errorEstado = true;
			    	}else{
			    		errorEstado = true;
			    	}
		    	
			    	if ( errorNombre || errorFecha || errorGenero || errorTelefono ||
					    	 errorApaterno || errorAmaterno || errorCorreo || errorColonia || errorColonia || errorDireccion){
					    	validaDatos = false;
					    %>
					    <tr>
					    	<td "style='background-color:red;'"><b><%=linea%></b></td>
					    	<td <% if (errorNombre) out.print("style='background-color:red;'");%>><b><%=strNombre%></b></td>
					    	<td><b><%=strPaterno%></b></td>
					    	<td><b><%=strMaterno%></b></td>
					    	<td <% if (errorFecha) out.print("style='background-color:red;'");%>><b><%=fechaNac%></b></td>
					    	<td <% if (errorGenero) out.print("style='background-color:red;'");%>><b><%=strGenero%></b></td>
					    	<td><b><%=strCorreo%></b></td>
					    	<td><b><%=strColonia%></b></td>
					    	<td><b><%=strDireccion%></b></td>
					    	<td><b><%=strTelefono%></b></td>
					    	<td><b><%=strEstado%></b></td>
					    	<td><b><%=strOcupacion%></b></td>
					    </tr>	
					    <%
					    }else{
					    	// Instancia del alumno
					    	aca.empleado.EmpPersonal EmpPersonal = new aca.empleado.EmpPersonal();
					    	EmpPersonal.setNombre(strNombre);
					    	EmpPersonal.setApaterno(strPaterno);
					    	EmpPersonal.setAmaterno(strMaterno);
					    	EmpPersonal.setFNacimiento(fechaNac);
					    	EmpPersonal.setGenero(strGenero);
					    	EmpPersonal.setEmail(strCorreo);
					    	EmpPersonal.setColonia(strColonia);
					    	EmpPersonal.setDireccion(strDireccion);
					    	EmpPersonal.setTelefono(strTelefono);
					    	EmpPersonal.setEscuelaId(escuelaId);
					    	EmpPersonal.setCodigoId(codigoId);
					    	EmpPersonal.setEstado(strEstado);
					    	EmpPersonal.setOcupacion(strOcupacion);
					    	lisEmpleados.add(EmpPersonal);
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

if (validaDatos){
	
	List<String>  lsParaClaves = new ArrayList();
	
	for(aca.empleado.EmpPersonal empleado : lisEmpleados){
		
		// Buscar el siguiente numero de codigo del alumno
   		String codigoId	= empleado.maximoRegEmp(conElias, escuelaId);
		empleado.setCodigoId(codigoId);
		
		// Insert del alumno
		
    	if ( empleado.insertTraspaso(conElias) ){
    		
    		lsParaClaves.add(empleado.getCodigoId());
    		
    		//conElias.commit();
    	}
		
	}
	
	for(String codigo : lsParaClaves){
		MessageDigest md5	= MessageDigest.getInstance("MD5");
		md5.update(codigo.getBytes("UTF-8"));
		byte raw[] = md5.digest();
		String claveDigest	= (new BASE64Encoder()).encode(raw);
		
		aca.usuario.Usuario Clave = new aca.usuario.Usuario();
		Clave.setCodigoId(codigo);
		Clave.setTipoId("2");
		Clave.setCuenta(codigo);
		Clave.setClave(claveDigest);
		Clave.setAdministrador("N");
		Clave.setCotejador("N");
		Clave.setContable("N");
		Clave.setNivel("-");
		Clave.setEscuela("-"+escuelaId+"-");
		Clave.setPlan("x");
		Clave.setAsociacion("-");
		Clave.setIdioma("es");
		
		if(Clave.existeReg(conElias) == false){
			if (Clave.insertReg(conElias)){
				//conElias.commit();
				System.out.println("clave creada " + codigo);
			}else{
				//conElias.rollback();
			}	
		}
	}
	
	
	String mensaje = "Se han registrado: "+lisEmpleados.size()+" empleados en tu escuela";
	%>
	<h3><%= mensaje %></h3>
	<%
}	
%>

</div>


<%@ include file="../../cierra_elias.jsp"%>