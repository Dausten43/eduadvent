<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.io.File"%>
<%	
	String codigoEmpleado		= (String) session.getAttribute("codigoEmpleado");
	String nombre 				= "";
	String dir					= application.getRealPath("/WEB-INF/fotos/")+"/";
	String salto				= "X";
	int widthImage     		= 0;
	int heightImage			= 0;
	
	String dirFoto = dir+codigoEmpleado+".jpg";
	
	boolean guardo = false;	
	try{	
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, dir, 5*1024*1024);	        
	    nombre				= multi.getFilesystemName("archivo");
	    
	    File fi 			= new File(dir+nombre);
	    
	    
	    
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
	    
	    
	    
		fi.renameTo(new File(dirFoto));
		
		guardo = true;
	    
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
	}finally{
	}
	if (guardo){ 
		salto = "empleado.jsp?CodigoEmpleado="+codigoEmpleado+"&tipo=Empleado&ref=0";
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp" %>