<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.nio.channels.FileChannel"%>
<%@page import="java.io.File"%>
<%
System.out.println("========================INICIO UPLOAD========================");



	String ruta 			= application.getRealPath("/mensajes/admin/")+"";
	String nombre 			= "";
	String dir				= application.getRealPath("WEB-INF/archivos/mensajes");
	System.out.println("si entra " + ruta + "  " + dir);
	try{
		// Hasta 3 mb de tamaño
		final int megabytes = 3;
		final int LIMIT_SIZE = megabytes * 1024 * 1024;
		com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, LIMIT_SIZE);
	

	
		List<String> parameterNamesList = Collections.list(multi.getParameterNames());
		for(String para : parameterNamesList){
			System.out.println(para + "\t" + multi.getParameter(para));
		}
		
		String salida = multi.getParameter("idmsg");
		nombre	= multi.getFilesystemName("adjunto");
		System.out.println(nombre);
		File carpetaMsgs = new File(dir);
		String [] ext = nombre.split("\\.");			
		File dirFinal = new File(carpetaMsgs+"/"+salida+"."+ext[ext.length-1]);			   
		File dirInicial = new File(ruta+nombre);
		
		if (dirInicial.length() <= LIMIT_SIZE){
			try {
				FileChannel srcChannel = new FileInputStream(dirInicial).getChannel ();
				
				FileChannel dstChannel = new FileOutputStream(dirFinal).getChannel();
				
				dstChannel.transferFrom(srcChannel, 0, srcChannel.size());
				
				srcChannel.close();
				dstChannel.close();
			}catch(Exception ew){
				System.out.println("Error al subir el archivo: "+ew);
			}
			
		}
		dirInicial.delete(); 
	
	}catch(Exception e){
		System.out.println("Error al subir el archivo: "+e);
	}
	System.out.println("========================FIN UPLOAD========================");

%>