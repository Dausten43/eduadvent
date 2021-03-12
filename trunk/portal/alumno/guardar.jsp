<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.nio.channels.FileChannel"%>
<%@page import="aca.util.Fecha"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>


<jsp:useBean id="archivo" scope="page" class="aca.kardex.KrdxAlumArchivo"/>

<%	
	
	String fechaTarea 		= request.getParameter("fechaTarea");
	String horaActual 	= Fecha.getHora().length()==1 ? "0"+Fecha.getHora() : Fecha.getHora();
	String minActual 	= Fecha.getMinutos().length()==1 ? "0"+Fecha.getMinutos() : Fecha.getMinutos();
	String tiempoActual = Fecha.getHoy()+" "+horaActual+":"+minActual+" "+(Fecha.getAMPM()==0 ? "AM" : "PM");
	
	int yearTar = Integer.parseInt(fechaTarea.substring(6,10));
	int mesTar 	= Integer.parseInt(fechaTarea.substring(3,5));
	int diaTar 	= Integer.parseInt(fechaTarea.substring(0,2));
	int horaTar = Integer.parseInt(fechaTarea.substring(11,13));
	if(fechaTarea.substring(17,19).equals("PM")&&Integer.parseInt(fechaTarea.substring(11,13))!=12) horaTar += 12;
	if(fechaTarea.substring(17,19).equals("AM")&&Integer.parseInt(fechaTarea.substring(11,13))==12) horaTar = 0;
	int minTar 	= Integer.parseInt(fechaTarea.substring(14,16));
	
	int yearAct = Integer.parseInt(tiempoActual.substring(6,10));
	int mesAct 	= Integer.parseInt(tiempoActual.substring(3,5));
	int diaAct 	= Integer.parseInt(tiempoActual.substring(0,2));
	int horaAct = Integer.parseInt(tiempoActual.substring(11,13));
	if(tiempoActual.substring(17,19).equals("PM")&&Integer.parseInt(tiempoActual.substring(11,13))!=12) horaAct += 12;
	if(tiempoActual.substring(17,19).equals("AM")&&Integer.parseInt(tiempoActual.substring(11,13))==12) horaTar = 0;
	int minAct 	= Integer.parseInt(tiempoActual.substring(14,16));
	
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	String ruta 			= application.getRealPath("/portal/alumno/")+"/";
	String nombre 			= "";
	String dir				= application.getRealPath("/WEB-INF/archivos");
	
	String cicloGrupoId		= request.getParameter("cicloGrupoId");
	String cursoId			= request.getParameter("cursoId");
	String evaluacionId		= request.getParameter("evaluacionId");
	String actividadId 		= request.getParameter("actividadId");
	
	String folio			= archivo.maximoReg(conElias, codigoAlumno);	
	
	if(!new Date(yearTar, mesTar, diaTar, horaTar, minTar).before(new Date(yearAct, mesAct, diaAct, horaAct, minAct))){
			
		boolean guardo = false;	
		try{
			// Hasta 3 mb de tamaño
			final int megabytes = 3;
			final int LIMIT_SIZE = megabytes * 1024 * 1024;
			
			
			com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, ruta, LIMIT_SIZE);
			
			nombre	= multi.getFilesystemName("archivo");
			
			if(nombre==null) response.sendRedirect("subir.jsp?cicloGrupoId="+cicloGrupoId+"&cursoId="+cursoId+"&evaluacionId="+evaluacionId+"&actividadId="+actividadId+"&fechaTarea="+fechaTarea+"&Regresar="+request.getParameter("Regresar"));
			
			File carpetaAlumno 	= new File(dir+"/"+String.valueOf(session.getAttribute("escuela")+"/"+codigoAlumno));			
			if(!carpetaAlumno.exists()) carpetaAlumno.mkdirs();
			
			String [] ext = nombre.split("\\.");			
			File dirFinal = new File(carpetaAlumno+"/"+codigoAlumno+"-"+folio+"."+ext[ext.length-1]);			   
			File dirInicial = new File(ruta+nombre);
			if (dirInicial.length() <= LIMIT_SIZE){
				boolean isImage = ext[ext.length-1].matches("(?i)jpeg|jpg|png");
				
				if(isImage){
					try {
						BufferedImage image = ImageIO.read(dirInicial);
						if(image.getWidth() > 1280 && image.getHeight() > 720){
		           			Process process = Runtime.getRuntime().exec("cmd /c magick " + dirInicial + " -resize 1280x720 " + dirInicial);
		           			BufferedReader br = new BufferedReader(new InputStreamReader(process.getInputStream()));
		           			String resultOfExecution = null;
	           				while((resultOfExecution = br.readLine()) != null){
	               				System.out.println(resultOfExecution);
	           				}
           				}
       				} catch (IOException e) {
       					guardo = false;
       				}
				}
				
				try {
					FileChannel srcChannel = new FileInputStream(dirInicial).getChannel ();
					
					FileChannel dstChannel = new FileOutputStream(dirFinal).getChannel();
					
					dstChannel.transferFrom(srcChannel, 0, srcChannel.size());
					
					srcChannel.close();
					dstChannel.close();
					
					archivo.setCodigoId(codigoAlumno);
					archivo.setFolio(folio);
					archivo.setCicloGrupoId(cicloGrupoId);
					archivo.setCursoId(cursoId);
					archivo.setEvaluacionId(evaluacionId);
					archivo.setActividadId(actividadId);
					archivo.setArchivo(nombre);
					if(archivo.insertReg(conElias)) guardo = true;
				} catch (Exception e) {
					guardo = false;
				}
			}else{
	%>
				<a href="subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=fechaTarea%>">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar"/></a><br><br><br>
				<font size="4" color="black"><b><fmt:message key="aca.ErrorGrande"/></b></font>
	<%			
				
			}			
			dirInicial.delete();
			
		}catch(Exception e){
			System.out.println("Error al subir el archivo: "+e);
	%>
			<a href="subir.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=fechaTarea%>">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar"/></a><br><br><br>
			<font size="4" color="black"><b><fmt:message key="aca.ErrorGrande"/></b></font>
	<%
		}
		if (guardo){
			System.gc();
%>
		<script type="text/javascript">
			alert("¡ El archivo ha sido enviado !")
		</script>
<%					
			response.sendRedirect("subir.jsp?cicloGrupoId="+cicloGrupoId+"&cursoId="+cursoId+"&evaluacionId="+evaluacionId+"&actividadId="+actividadId+"&fechaTarea="+fechaTarea+"&Regresar="+request.getParameter("Regresar"));
		}
	}
	else{%>
		<script type="text/javascript">
			alert("Lo sentimos, la tarea ha sido cerrada")
		</script>
		<meta http-equiv="refresh" content="1;url=datos.jsp?Accion=2" />
		<%
	}
%>
<%@ include file="../../cierra_elias.jsp" %>