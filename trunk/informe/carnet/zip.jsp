<%@page import="aca.alumno.AlumPersonalLista"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<jsp:useBean id="alumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>


<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.sql.*" %>

<%
	boolean error 		= false;

	String dir				= application.getRealPath("/alumno/respaldo")+"/";
	String fechaIni			= request.getParameter("fechaIni");
	String fechaFin			= request.getParameter("fechaFin");
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= request.getParameter("Ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("Ciclo");
	
	ArrayList<aca.alumno.AlumPersonal> lisAlumnos = alumPersonalL.getListAlumnosInscritos(conElias, escuelaId, cicloId, "");
	
	Connection  conn2 				= null;
	Statement   stmt2 				= null;
	ResultSet   rset2 				= null;
	String COMANDO 					= "";
	int cont						= 0;
	org.postgresql.largeobject.LargeObject obj			= null;
	org.postgresql.largeobject.LargeObjectManager lobj	= null;
	

	
	/* --- PONER EN UN ARCHIVO .ZIP LAS IMAGENES --- */
	try{ 
		System.out.println("Respaldando...");
		
		String zipFile = dir+"respaldo.zip";
		FileOutputStream fout	= new FileOutputStream(zipFile);
		ZipOutputStream zout	= new ZipOutputStream(new BufferedOutputStream(fout));
		
		for(aca.alumno.AlumPersonal listaAl : lisAlumnos){
		
		String dirAlumnos=application.getRealPath("/WEB-INF/fotos/");
		java.io.File f = new java.io.File(dirAlumnos+"/"+listaAl.getCodigoId()+".jpg");
			if(f.exists()){
			
				String NombreArch 		= listaAl.getCodigoId()+".jpg";
				System.out.println(NombreArch);
				//System.out.println("Nombre de Archivo:"+NombreArch);
			    zout.putNextEntry(new ZipEntry(NombreArch));
				 FileInputStream fis = new FileInputStream(f);
				 
				 byte[] buffer = new byte[4092];
			        int byteCount = 0;
			        while ((byteCount = fis.read(buffer)) != -1)
			        {
			            zout.write(buffer, 0, byteCount);
			            System.out.print('.');
			            System.out.flush();
			        }
			        cont++;
			        fis.close();
				    zout.closeEntry();
			}			
		    
			
		 }
		
		
		zout.close();
		fout.close();
		
		
		 System.out.println("OK... "+String.valueOf(cont) + " archivos respaldados...");	
	}catch (Exception ex){
		ex.printStackTrace();
		error = true;
	}
	
	
	if(error){
		out.print("<div class='error'>Error</div>");
		new File(dir+"respaldo.zip").delete();
	}
%>

<%@ include file="../../cierra_elias.jsp"%>