<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%	

	String escuelaId		= (String) session.getAttribute("escuela");
	System.out.println(escuelaId);
	java.io.File file = new File("/Users/davidblanco/eclipse/workspace/escuela/WEB-INF/"+escuelaId);
	if(!file.exists())
	    file.mkdirs();
	
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	System.out.println(request.getParameter("nombreArchivo"));
	String nombreArchivo	= request.getParameter("nombreArchivo")==null?"":request.getParameter("nombreArchivo");
	System.out.println(nombreArchivo);
	String ruta 			= application.getRealPath("/documentos/imagenes/")+"/";
	String nombre 			= "";

	
	
	String dir				= application.getRealPath("/WEB-INF/"+escuelaId+"/"+nombreArchivo+".jpg");
	int widthImage     		= 0;
	int heightImage			= 0;
	
	boolean guardo = false;	
	try{		
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, 5*1024*1024);
	    nombre			= multi.getFilesystemName("archivo");
	    
	    // Leer el archivo en objeto File y FileInputStream
	    File fi = new File(ruta+nombre);
	      
	    
	    FileInputStream fis = new FileInputStream(fi);
	    
	    // crear un arreglo de bytes con la longitud del archivo 
		byte buf[] = new byte[(int)fi.length()];
		
		// llenar el arreglo de bytes con los bytes del archivo
		fis.read(buf,0,(int)fi.length());
		
		// Escribir el archivo en el directorio del servidor de aplicaciones con el objeto FileOutputStream 
		FileOutputStream fos = new FileOutputStream(dir);
		fos.write(buf,0,(int)fi.length());		
		fos.flush();	
		
		// Cerrar los objetos
		if (fos!=null) fos.close();
		if (fis!=null) fis.close();
		fi.delete();
		
		guardo = true;
	    
	}catch(java.io.IOException e){
		System.out.println("Error al subir el archivo: "+e);
%>
		<div id="content">
			<div class="alert alert-danger">
				<strong><fmt:message key="aca.Error"/></strong>	<fmt:message key="aca.ErrorGrandeImagen"/>
				<a href="subir.jsp"><fmt:message key="aca.IntentarDeNuevo"/></a>
			</div>
		</div>
<%
	}catch(IllegalArgumentException e){
		//System.out.println("Error de dimensiones");
%>
		<div id="content">
			<div class="alert alert-danger">
				<strong><fmt:message key="aca.Error"/></strong>	<fmt:message key="aca.LasDimensionesDeLaImageSon" /> <strong><%=widthImage %>x<%=heightImage %></strong> <fmt:message key="aca.LasCualesSonIncorrectas" />
				<a href="subir.jsp"><fmt:message key="aca.IntentarDeNuevo"/></a>
			</div>	
		</div>
<%		
	}
	
	
	if (guardo){ 
		System.gc();
		response.sendRedirect("alumno.jsp");
	}
%>
<%@ include file="../../cierra_elias.jsp" %>