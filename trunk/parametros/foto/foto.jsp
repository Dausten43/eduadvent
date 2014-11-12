<%
	String dir=application.getRealPath("/WEB-INF/fotos/")+"/";
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
		response.getOutputStream().write(buff);
		buff = null;
	}
	else
	{
%>
	Sin privilegios...
<%}
%>