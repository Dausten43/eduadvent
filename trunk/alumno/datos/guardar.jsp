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
	
	boolean medidas	= false;	
	boolean tamano 	= false;
	
	try{		
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, 150*1024);
	    nombre			= multi.getFilesystemName("archivo");
	    
	    // Leer el archivo en objeto File y FileInputStream
	    File fi = new File(ruta+nombre);
	    
	    java.awt.image.BufferedImage bimg = javax.imageio.ImageIO.read(fi);
	    int width	= widthImage    = bimg.getWidth();
	    int height	= heightImage   = bimg.getHeight();
	    
	    if( width==360 && height==480 ){
			medidas = true;
	    }else if( width==480 && height==640){
	    	medidas = true;
	    }else if( width==600 && height==800 ){
	    	medidas = true;
	    }else if( width==720 && height==960 ){
	    	medidas = true;
	    }else if( width==768 && height==1024 ){
	    	medidas = true;
	    }else{
	    	fi.delete();
	    }	    
	    if(Math.round(Math.ceil(fi.length()/1024.0)) <= 150){
			tamano = true;
		}
	    
	    FileInputStream fis = new FileInputStream(fi);
	    
	    // crear un arreglo de bytes con la longitud del archivo
		byte buf[] = new byte[(int)fi.length()];
		
		// llenar el arreglo de bytes con los bytes del archivo
		fis.read(buf,0,(int)fi.length());
		
		// Graba la imagen en el server
		if (medidas && tamano ){			
			
 
			// Escribir el archivo en el directorio del servidor de aplicaciones con el objeto FileOutputStream 
			FileOutputStream fos = new FileOutputStream(dir);
			fos.write(buf,0,(int)fi.length());		
			fos.flush();
		
			// Cerrar los objetos
			if (fos!=null) fos.close();
		}
		if (fis!=null) fis.close();		
		if (fi.exists()) fi.delete();
		
		if (medidas==false){
		%>
			<div id="content">
				<div class="alert alert-danger">
					<strong><fmt:message key="aca.Error"/></strong>	<fmt:message key="aca.LasDimensionesDeLaImageSon" /> <strong><%=widthImage %>x<%=heightImage %></strong> <fmt:message key="aca.LasCualesSonIncorrectas" />
					<a href="subir.jsp"><fmt:message key="aca.IntentarDeNuevo"/></a>
				</div>	
			</div>
		<%
		}
		if( tamano==false ){
		%>
			<div id="content">
				<div class="alert alert-danger">
					<strong><fmt:message key="aca.Error"/></strong>	<fmt:message key="aca.ErrorGrandeImagen"/>
					<a href="subir.jsp"><fmt:message key="aca.IntentarDeNuevo"/></a>
				</div>	
			</div>
		<%		
		}
		//System.out.println("Datos1:"+medidas+":"+tamano);
	}catch(java.io.IOException e){
		System.out.println("Error:"+e);
	}
	//System.out.println("Datos2:"+medidas+":"+tamano);	
%>
	<meta http-equiv="refresh" content="1; url=alumno.jsp" />

<%@ include file="../../cierra_elias.jsp" %>
