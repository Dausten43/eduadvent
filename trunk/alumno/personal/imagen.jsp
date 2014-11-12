<%
	String dir=application.getRealPath("/WEB-INF/fotos/")+"/";
	String nuevo = request.getParameter("nuevo");
	if(session.getAttribute("mat")!=null){
		java.io.File f = new java.io.File(dir+session.getAttribute("mat")+".jpg");
		byte[] buff;
		java.io.FileInputStream instream;
		if(f.exists() && nuevo.equals("N")){
			buff = new byte[(int)f.length()];
			instream = new java.io.FileInputStream(dir+session.getAttribute("mat")+".jpg");
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
	}
	else
	{
%>
	Sin privilegios...
<%}
%>