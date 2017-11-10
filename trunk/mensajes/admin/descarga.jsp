<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.io.FilenameFilter"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>

<%
try{
	String ruta = application.getRealPath("WEB-INF/archivos/mensajes");
	
	File f = new File(ruta);
	final String idmsg = request.getParameter("idmsg");
	File[] matchingFiles = f.listFiles(new FilenameFilter() {
	    public boolean accept(File dir, String name) {
	        return name.startsWith(idmsg);
	    }
	});
	
	
	
    FileInputStream archivo = new FileInputStream(matchingFiles[0]); 
    int longitud = archivo.available();
    byte[] datos = new byte[longitud];
    archivo.read(datos);
    archivo.close();
    
    response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition","attachment;filename=" + FilenameUtils.getName(matchingFiles[0].toString()));    
    
    ServletOutputStream ouputStream = response.getOutputStream();
    ouputStream.write(datos);
    ouputStream.flush();
    ouputStream.close();    	
}
catch(Exception e){ 
    e.printStackTrace();
}  
%>