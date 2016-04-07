<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%	

	String escuelaId	= (String) session.getAttribute("escuela");
	String salto		= "X";

	// Carpeta donde quedará almacenada la imagen 
	String carpeta		= application.getRealPath("/WEB-INF"+"/"+escuelaId+"/");
	
	// Crea la carpeta de la escuela si no existe
	java.io.File file = new File(carpeta);
	if(!file.exists()){	
		file.mkdirs();		
	}
	
	// Carpeta de almacenamiento temporal de la imagen 
	String ruta			= application.getRealPath("/documentos/imagenes/")+"/";	
	
	boolean guardo = false;	
	try{		
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, 5*1024*1024);
	    String nombre			= multi.getFilesystemName("archivo");	    
	    
	    // Leer el archivo en objeto File y FileInputStream
	    File archivo = new File(ruta+nombre);
	    
	    FileInputStream fis = new FileInputStream(archivo);
	    
	    // crear un arreglo de bytes con la longitud del archivo 
		byte buf[] = new byte[(int)archivo.length()];
		
		// llenar el arreglo de bytes con los bytes del archivo
		fis.read(buf,0,(int)archivo.length());
		
		// Escribir el archivo en el directorio del servidor de aplicaciones con el objeto FileOutputStream		
		FileOutputStream fos = new FileOutputStream(carpeta+"/"+nombre);
		fos.write(buf,0,(int)archivo.length());
		fos.flush();
		
		// Cerrar los objetos
		if (fos!=null) fos.close();
		if (fis!=null) fis.close();		
		archivo.delete();
		
		guardo = true;
	    
	}catch(java.io.IOException e){
		System.out.println("Error al subir el archivo: "+e);
%>
		<div id="content">
			<div class="alert alert-danger">
				<strong><fmt:message key="aca.Error"/></strong>¡ Error !
				<a href="subir.jsp"><fmt:message key="aca.IntentarDeNuevo"/></a>
			</div>
		</div>
<%
	}
	
	if (guardo){ 
		System.gc();
		salto = "catalogo.jsp";
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp" %>