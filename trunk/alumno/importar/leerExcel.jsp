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
	ArrayList<aca.alumno.AlumPersonal> lisAlumnos		= new ArrayList<aca.alumno.AlumPersonal>();

/* VALIDACIÓN DE LOS DATOS**/

	// Recorre los archivos que se van a subir
	java.util.Iterator<FileItem> iter = items.iterator();	
	while (iter.hasNext()) {
		
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
			        
			        linea++;
			        
			        // Obtener los datos de las columnas en el renglón actual
			        
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
			    	Cell celular 	= row.getCell(10);
			    	Cell nivelId 	= row.getCell(11);			    
			    	Cell grado 		= row.getCell(12);
			    	Cell grupo 		= row.getCell(13);
			    	
			    	// Si el renglon tiene la bandera de grabar
			    	if ( grabar!=null && grabar.getCellType()==HSSFCell.CELL_TYPE_STRING ){
			    	System.out.println("Entre..."+linea);
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
				    	boolean errorNombre = false, errorGenero = false, errorNivel = false, errorGrado = false, errorGrupo = false, errorApaterno = false, errorCelular = false;
				    	boolean errorAmaterno = false, errorNacimiento = false, errorCorreo = false, errorColonia = false, errorDireccion = false, errorTelefono = false;
				    	
				    	
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
				    	
				    	String strCelular	= "-";			    
				    	if (celular != null){
				    		strCelular = aca.util.Utilerias.removeEmptyDecimalPoints(celular.toString()).trim();
				    	}else{
				    		errorCelular = true;
				    	}
				    	
					    String strNivel		= "0";
					    if (nivelId != null){
				    		strNivel = aca.util.Utilerias.removeEmptyDecimalPoints(nivelId.toString()).trim();
				    		if ( !strNivel.equals("0") && !strNivel.equals("1") && !strNivel.equals("2") && !strNivel.equals("3") && !strNivel.equals("4")) errorNivel = true;
				    	}else{
				    		errorNivel = true;
				    	}
					    
					    String strGrado		= "0";
					    if (grado != null ){
				    		strGrado = aca.util.Utilerias.removeEmptyDecimalPoints(grado.toString()).trim();
				    		if (
				    			!strGrado.equals("1") && !strGrado.equals("2") && !strGrado.equals("3") && !strGrado.equals("4") && !strGrado.equals("5") &&
				    			!strGrado.equals("6") && !strGrado.equals("7") && !strGrado.equals("8") && !strGrado.equals("9") && !strGrado.equals("10") &&
				    			!strGrado.equals("11")&& !strGrado.equals("12")
				    			){
				    			errorGrado = true;
				    		}
				    	}else{
				    		errorGrado = true;
				    	}
					    
					    String strGrupo		= "X";
					    if ( grupo != null){
					    	strGrupo = grupo.toString().trim();
					    	if ( !strGrupo.equals("A") && !strGrupo.equals("B") && !strGrupo.equals("C") && !strGrupo.equals("D") && !strGrupo.equals("E") && !strGrupo.equals("F") && !strGrupo.equals("G")) errorGrupo = true;
					    }else{
					    	errorGrupo = true;
					    }
					    if ( errorNombre || errorFecha || errorGenero || errorNivel || errorGrado || errorGrupo || errorCelular || errorTelefono ||
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
					    	<td><b><%=strCelular%></b></td>
					    	<td <% if (errorNivel) out.print("style='background-color:red;'");%>><b><%=strNivel%></b></td>
					    	<td <% if (errorGrado) out.print("style='background-color:red;'");%>><b><%=strGrado%></b></td>
					    	<td <% if (errorGrupo) out.print("style='background-color:red;'");%>><b><%=strGrupo%></b></td>
					    </tr>	
					    <%
					    }else{
					    	// Instancia del alumno
					    	aca.alumno.AlumPersonal AlumPersonal = new aca.alumno.AlumPersonal();
					    	//System.out.println("Agregar alumno"+linea+":"+strNombre+":"+strPaterno+":"+strMaterno+":"+strGenero+":"+strCorreo+":"+
					    	//strColonia+":"+strDireccion+":"+strTelefono+":"+strCelular+":"+strNivel+":"+strGrado+":"+strGrupo);
					    	AlumPersonal.setNombre(strNombre);
					    	AlumPersonal.setApaterno(strPaterno);
					    	AlumPersonal.setAmaterno(strMaterno);
					    	AlumPersonal.setFNacimiento(fechaNac);
					    	AlumPersonal.setGenero(strGenero);
					    	AlumPersonal.setCorreo(strCorreo);
					    	AlumPersonal.setColonia(strColonia);
					    	AlumPersonal.setDireccion(strDireccion);
					    	AlumPersonal.setTelefono(strTelefono);
					    	AlumPersonal.setCelular(strCelular);
					    	AlumPersonal.setNivelId(strNivel);
					    	AlumPersonal.setGrado(strGrado);
					    	AlumPersonal.setGrupo(strGrupo);
					    	AlumPersonal.setEscuelaId(escuelaId);
					    	AlumPersonal.setCodigoId(codigoId);
					    	lisAlumnos.add(AlumPersonal);
					    	
					    	System.out.println(AlumPersonal.getNombre());
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
	String mensaje="";
	//System.out.println("alumnos a subir " + lisAlumnos.size() + " ");
	if (validaDatos){
		
		List<String>  lsParaClaves = new ArrayList();
		
		int contador= 0;
		for(aca.alumno.AlumPersonal alumno : lisAlumnos){
			
			// Buscar el siguiente numero de codigo del alumno
	   		String codigoId	= alumno.maximoReg(conElias, escuelaId);
			alumno.setCodigoId(codigoId);
			
			// Insert del alumno
			
	    	if ( alumno.insertTraspaso(conElias) ){
	    		System.out.println("no creo clave " + alumno.getCodigoId());
	    		lsParaClaves.add(alumno.getCodigoId());
	    	}else{
	    		System.out.println("no subio " + alumno.getCodigoId());
	    		//out.println("no subio " + alumno.getCodigoId());
	    	}
			
		}
		
		for(String clave :lsParaClaves){
			//out.println(contador + " alumno cread0 " + clave);
    		MessageDigest md5	= MessageDigest.getInstance("MD5");
    		md5.update(clave.getBytes("UTF-8"));
    		byte raw[] = md5.digest();
    		String claveDigest	= (new BASE64Encoder()).encode(raw);
    		
    		aca.usuario.Usuario Clave = new aca.usuario.Usuario();
    		Clave.setCodigoId(clave);
    		Clave.setTipoId("1");
    		Clave.setCuenta(clave);
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
    				contador++;entrre
    				System.out.println();
    				//out.println(contador + " clave creada " + clave);
    			}else{
    				System.out.println("no creo clave " + clave);
    				//out.println("no creo clave " + clave);
    			}	
    		}
		}
		
		mensaje = "Se han registrado: "+lisAlumnos.size()+" alumnos en tu escuela";		
%>
<h3><%= mensaje %></h3>
<%
	}	
%>
</div>
<%@ include file="../../cierra_elias.jsp"%>

