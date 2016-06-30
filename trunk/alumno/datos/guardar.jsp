<%@page import="java.io.IOException"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%	
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	String ruta 			= application.getRealPath("/alumno/datos/")+"/";
	String nombre 			= "";
	String dir				= application.getRealPath("/WEB-INF/fotos/"+codigoAlumno+".jpg");
	int widthImage     		= 0;
	int heightImage			= 0;
	String salto 			= "X";
	
	boolean guardo = false;	
	try{		
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, 150*1024);
	    nombre			= multi.getFilesystemName("archivo");
	    
	    // Leer el archivo en objeto File y FileInputStream
	    File fi = new File(ruta+nombre);
	    
	    java.awt.image.BufferedImage bimg = javax.imageio.ImageIO.read(fi);
	    int width	=  widthImage    = bimg.getWidth();
	    int height	= heightImage     = bimg.getHeight();
	    
	    if( width==360 && height==480 ){
			// correct dimensions
	    }else if( width==480 && height==640){
	    	// correct dimensions
	    }else if( width==600 && height==800 ){
	    	// correct dimensions
	    }else if( width==720 && height==960 ){
	    	// correct dimensions
	    }else if( width==768 && height==1024 ){
	    	// correct dimensions
	    }else{
	    	fi.delete();
	    	throw new IllegalArgumentException();
	    }
	    
	    
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
		
		if(Math.round(Math.ceil(fi.length()/1024.0)) > 150){
			throw new IOException();
		}
		
		fi.delete();		
		guardo 	= true;
		salto	= "alumno.jsp";
		
	    
	}catch(java.io.IOException e){
		//System.out.println("Error al subir el archivo: "+e);
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
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0"; url="<%=salto%>" />
<% 	}%>

<%@ include file="../../cierra_elias.jsp" %>
