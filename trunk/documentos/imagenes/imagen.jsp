<%
	String codigoId		= session.getAttribute("codigoId").toString()==null?"-":session.getAttribute("codigoId").toString();
	String escuela		= session.getAttribute("escuela").toString();	
	String dir			= application.getRealPath("/WEB-INF/"+escuela+"/");	
	String archivo		= request.getParameter("NombreArchivo");
	
	//Si tiene una sesión activa
	if ( codigoId.indexOf("E")!= -1 || codigoId.indexOf("P") != -1){
		if(archivo!=null){
			
			java.io.File f = new java.io.File(dir+"/"+archivo);
			
			byte[] buff = null;
			java.io.FileInputStream instream = null;
			if(f.exists()){				
				buff = new byte[(int)f.length()];				
				instream = new java.io.FileInputStream(dir+"/"+archivo);
			}
			/*
			else{
				f = new java.io.File(dir+"nofoto.png");
				buff = new byte[(int)f.length()];
				instream = new java.io.FileInputStream(dir+"nofoto.png");
			}
			*/
			instream.read(buff,0,(int)f.length());
			response.setContentType("image/jpeg");
			response.getOutputStream().write(buff);
			response.flushBuffer();
			instream.close();
		}else{
			out.print("Sin privilegios");
		}
	}else{
		out.print("Sin privilegios");
	}
%>