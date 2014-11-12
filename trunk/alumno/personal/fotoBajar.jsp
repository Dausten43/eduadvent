<%
	String dir=application.getRealPath("/WEB-INF/fotos/")+"/";
	//String mat = (String) session.getAttribute("codigoAlumno");
	String mat = request.getParameter("mat");
	
	if(mat!=null){
		java.io.File f = new java.io.File(dir+mat+".jpg");
		byte[] buff;
		java.io.FileInputStream instream;
		if(f.exists()){
			buff = new byte[(int)f.length()];
			instream = new java.io.FileInputStream(dir+mat+".jpg");
		}
		else{
			f = new java.io.File(dir+"nofoto.jpg");
			buff = new byte[(int)f.length()];
			instream = new java.io.FileInputStream(dir+"nofoto.jpg");
		}
		instream.read(buff,0,(int)f.length());
		response.setContentType("image/jpeg");
		response.setHeader("Content-Disposition","attachment; filename=\""+ mat+".jpg"+ "\"");	
		response.getOutputStream().write(buff);
		response.flushBuffer();
	}
	else
	{
%>
	Sin privilegios...
<%}
%>