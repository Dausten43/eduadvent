<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.lowagie.text.*" %>
<%@ page import = "com.lowagie.text.pdf.*" %>

<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>

<%
	String codigoEmpleado	= "";

	int cantidad			= Integer.parseInt(request.getParameter("cantidad"));
	int extra				= 0;

	Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
	document.setMargins(35,35,20,20);
	try{
		String dir = application.getRealPath("/empleado/credencial/")+"/"+"credencial.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar Exodus");
        document.addSubject("Credencial de Empleado");
        document.open();
        
        for(int i = 1; i <= cantidad; i++){
        	codigoEmpleado = request.getParameter("codigo-"+i);
	    	
	    	empPersonal.mapeaRegId(conElias, codigoEmpleado);
	    	
	    	if(i%2 != 0){
	    		document.newPage();
	    		extra = 0;
	    	}else{
	    		extra = -300;
	    	}
				
			Image jpg = null;			
			jpg = Image.getInstance(application.getRealPath("/empleado/credencial/")+"/frontgreen.jpg");
			jpg.scaleAbsolute(148f, 238f);
			jpg.setAbsolutePosition(100, 420+extra);
			document.add(jpg);
			
			jpg = Image.getInstance(application.getRealPath("/empleado/credencial/")+"/back.jpg");
			jpg.scaleAbsolute(148f, 238f);
			jpg.setAbsolutePosition(250, 450+extra);
			document.add(jpg);
	        
			String dirAlumnos=application.getRealPath("/WEB-INF/fotos/");
			java.io.File f = new java.io.File(dirAlumnos+"/"+codigoEmpleado+".jpg");
			if(f.exists()){
				jpg = Image.getInstance(dirAlumnos+"/"+codigoEmpleado+".jpg");
			}else{
				jpg = Image.getInstance(dirAlumnos+"/noFoto.jpg");
			}
			jpg.scaleAbsolute(71f, 95f);
			jpg.setAbsolutePosition(103, 465+extra);
			document.add(jpg);
			
			float[] columnDefinitionSize = { 100F };
			PdfPTable topTable = new PdfPTable(columnDefinitionSize);
			topTable.getDefaultCell().setBorder(0);
			topTable.setHorizontalAlignment(0);
			topTable.setTotalWidth(148);
			topTable.setLockedWidth(true);
			topTable.setSpacingAfter(10F);
			
			PdfPCell celda = null;
			celda = new PdfPCell(new Phrase("Credencial de Empleado", 
	        		FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new Color(255,255,255))));
			celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			celda.setBorder(0);
			topTable.addCell(celda);
			
			topTable.writeSelectedRows(0, -1, 100, 665+extra, pdf.getDirectContent());
			
			float[] DataColumnDefinitionSize = { 100F };
			PdfPTable dataTable = new PdfPTable(DataColumnDefinitionSize);
			dataTable.getDefaultCell().setBorder(0);
			dataTable.setHorizontalAlignment(0);
			dataTable.setTotalWidth(75);
			dataTable.setLockedWidth(true);
			dataTable.setSpacingAfter(10F);
			
			
			Phrase frase = new Phrase("Nombre:\n", 
	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0,0,0)));
			frase.add(new Phrase(empPersonal.getNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0))));
	        
	        celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			dataTable.addCell(celda);
			
			frase = new Phrase("Apellidos:\n",
	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0,0,0)));
			frase.add(new Phrase(empPersonal.getApaterno()+" "+empPersonal.getAmaterno(), 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0))));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			dataTable.addCell(celda);
			
			frase = new Phrase("Codigo:\n",
	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0,0,0)));
			frase.add(new Phrase(codigoEmpleado, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0))));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			dataTable.addCell(celda);
			
			frase = new Phrase("Puesto:\n",
	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0,0,0)));			
			frase.add(new Phrase("Docente", 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0))));
			celda = new PdfPCell(frase);
			celda = new PdfPCell(frase);			
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			dataTable.addCell(celda);
	        
			dataTable.writeSelectedRows(0, -1, 173, 560+extra, pdf.getDirectContent());
        }
	}catch(IOException ioe) {
		System.err.println("Error credencial en PDF: "+ioe.getMessage());
	}
	
	document.close();
%>
<head>
	<meta http-equiv='REFRESH' content='0; url=credencial.pdf'>
</head>
<%@ include file="../../cierra_elias.jsp" %>