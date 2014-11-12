<%
	String codigoEmpleado	= (String) session.getAttribute("codigoEmpleado");
	String dir				= application.getRealPath("/WEB-INF/fotos/")+"/";
	
	if(session.getAttribute("codigoEmpleado")!=null){
		java.io.File f = new java.io.File(dir+codigoEmpleado+".jpg");
		byte[] buff;
		java.io.FileInputStream instream;
		if(f.exists()){			
			buff = new byte[(int)f.length()];
			instream = new java.io.FileInputStream(dir+codigoEmpleado+".jpg");
		}
		else{
			f = new java.io.File(dir+"nofoto.jpg");
			buff = new byte[(int)f.length()];
			instream = new java.io.FileInputStream(dir+"nofoto.jpg");
		}
		instream.read(buff,0,(int)f.length());
		response.setContentType("image/jpeg");
		response.getOutputStream().write(buff);
		response.flushBuffer();
	}else{ 
		out.print("Sin privilegios...");
	}
%>