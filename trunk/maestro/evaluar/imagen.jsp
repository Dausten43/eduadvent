<%
	String dir=application.getRealPath("/WEB-INF/fotos/")+"/";
	if(request.getParameter("mat")!=null){
		java.io.File f = new java.io.File(dir+request.getParameter("mat")+".jpg");
		byte[] buff;
		java.io.FileInputStream instream;
		if(f.exists()){
			buff = new byte[(int)f.length()];
			instream = new java.io.FileInputStream(dir+request.getParameter("mat")+".jpg");
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