<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.lowagie.text.*" %> 
<%@ page import = "com.lowagie.text.pdf.*" %>
<%@ page import = "com.lowagie.text.pdf.PdfTemplate" %>

<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.alumno.AlumPlan"%>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="CatEscuela" scope="page" class="aca.catalogo.CatEscuela"/>

<%
	String escuelaId		= (String)session.getAttribute("escuela");
	String cicloId			= (String)session.getAttribute("cicloId");	
	
	String vigIni 			= request.getParameter("VigIni").equals("")?" ":request.getParameter("VigIni");
	String vigFin 			= request.getParameter("VigFin").equals("")?" ":request.getParameter("VigFin");	
	int cantidad			= Integer.parseInt(request.getParameter("cantidad"));
	int extra				= 0;
	String codigoAlumno		= "";
	
	String cicloEscolar 	= "20"+aca.ciclo.Ciclo.getCicloEscolar(conElias, cicloId).substring(0, 2)+"-20"+aca.ciclo.Ciclo.getCicloEscolar(conElias, cicloId).substring(2,4 );
	
	Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
	document.setMargins(5,5,5,5);
	try{
		String dir = application.getRealPath("/alumno/credencial/")+"/"+"credencial2.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar Exodus");
        document.addSubject("Credencial de alumnos");
        document.open();
        
        for(int i = 1; i <= cantidad; i++){
        	codigoAlumno 		= request.getParameter("matricula-"+i);
	    	int nivelAlumno 	= AlumPlan.getNivelAlumno(conElias, codigoAlumno);
	    	
	    	alumPersonal.mapeaRegId(conElias, codigoAlumno);
	    	
	    	// La posición x=0, y=0 se encuentra ubicada en la esquina inferior izquierda
	    	// Si el valor de "y" aumenta la posición del objeto se desplaza hacia la parte superior de la hoja.
	    	// la variable extra modifica el valor del eje "y"
	    	
	    	if(i%4 == 1){
	    		// Credencial 1
	    		extra = 50;	    	
	    	}else if (i%4 == 2){
	    		//Credencial 2
	    		extra = -120;	    	
	    	}else if (i%4 == 3){
	    		//Credencial 3
	    		extra = -290;	    	
	    	}else{
	    		// Credencial 4
	    		extra = -460;
	    	}
			
	    	CatEscuela.mapeaRegId(conElias, escuelaId);
	    	//PdfContentByte.roundRectangle() ; 
	    	
			Image jpg = null;
			jpg = Image.getInstance(application.getRealPath("/alumno/credencial/fondos/")+"/alumnoFrente2.png");
			
			// El tamaño de la credencia es 250 de ancho y 150 de alto
			jpg.scaleAbsolute(250f, 150f);
			jpg.setAbsolutePosition(30, 560+extra);
			document.add(jpg);
			
			jpg = Image.getInstance(application.getRealPath("/alumno/credencial/fondos/")+"/alumnoReverso2.png");
			jpg.scaleAbsolute(250f, 150f);
			jpg.setAbsolutePosition(310, 560+extra);
			document.add(jpg);
	        
			String dirAlumnos=application.getRealPath("/WEB-INF/fotos/");
			java.io.File f = new java.io.File(dirAlumnos+"/"+codigoAlumno+".jpg");
			if(f.exists()){
				jpg = Image.getInstance(dirAlumnos+"/"+codigoAlumno+".jpg");
			}else{
				jpg = Image.getInstance(dirAlumnos+"/nofoto.jpg");
			}			
		    jpg.scaleAbsolute(50f, 65f);
			jpg.setAbsolutePosition(45, 600+extra);
			document.add(jpg);
			
			String dirLogos=application.getRealPath("/imagenes/logos/");
			java.io.File l = new java.io.File(dirLogos+"/"+aca.catalogo.CatEscuela.getLogo(conElias, escuelaId));
			if(l.exists()){
				jpg = Image.getInstance(dirLogos+"/"+aca.catalogo.CatEscuela.getLogo(conElias, escuelaId));
			}else{
				jpg = Image.getInstance(dirLogos+"/logoIASD.png");
			}
			jpg.scaleAbsolute(30f, 30f);
			jpg.setAbsolutePosition(49, 670+extra);
			document.add(jpg);
			
			boolean tieneFirma = false;
			String nombreFirma = aca.catalogo.CatEscuela.getFirma(conElias, escuelaId);
			//System.out.println("Datos:"+escuelaId+":"+nombreFirma);
			String dirFirmas =application.getRealPath("/imagenes/firmas/");
			java.io.File firma = new java.io.File(dirFirmas+"/"+nombreFirma);
			//System.out.println("Antes de firma"+dirFirmas+"/"+nombreFirma);
			if(firma.exists()){
				tieneFirma = true;
				jpg = Image.getInstance(dirFirmas+"/"+nombreFirma);
			}else{
				tieneFirma = false;
				jpg = Image.getInstance(dirFirmas+"/firma.png");
			}
			
			jpg.scaleAbsolute(50f, 30f);			
			jpg.setAbsolutePosition(475, 650+extra);
			document.add(jpg);			
			
			float[] columnDefinitionSize = { 100F };
			PdfPTable topTable = new PdfPTable(columnDefinitionSize);
			topTable.getDefaultCell().setBorder(0);
			topTable.setHorizontalAlignment(0);
			topTable.setTotalWidth(230);
			topTable.setLockedWidth(true);
			topTable.setSpacingAfter(10F);
			
			PdfPCell celda = null;
			celda = new PdfPCell(new Phrase(aca.catalogo.CatEscuela.getNombre(conElias,escuelaId)  , 
	        		FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new Color(0,0,0))));
			celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			celda.setBorder(0);
			topTable.addCell(celda);
			
			topTable.writeSelectedRows(0, -1, 62, 695+extra, pdf.getDirectContent());
			
			float[] DataColumnDefinitionSize = { 200F };
			PdfPTable dataTable = new PdfPTable(DataColumnDefinitionSize);
			dataTable.getDefaultCell().setBorder(0);
			dataTable.setHorizontalAlignment(0);
			
			dataTable.setTotalWidth(200);
			dataTable.setLockedWidth(true);
			dataTable.setSpacingAfter(10F);
			
			
			Phrase frase = new Phrase(alumPersonal.getNombre()+" "+alumPersonal.getApaterno()+" "+alumPersonal.getAmaterno()
					, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
	        celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(19f);
			dataTable.addCell(celda);
			
			
			
			frase = new Phrase(codigoAlumno, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(19f);
			dataTable.addCell(celda);
			
			frase = new Phrase(alumPersonal.getGrado()+"° "+
					aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, String.valueOf(nivelAlumno)),
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			dataTable.addCell(celda);
	        
			dataTable.writeSelectedRows(0, -1, 113, 665+extra, pdf.getDirectContent());
			
			float[] DatacolumnSize = { 100F };
			PdfPTable cicloTable = new PdfPTable(DatacolumnSize);
			cicloTable.getDefaultCell().setBorder(0);
			cicloTable.setHorizontalAlignment(0);
			cicloTable.setTotalWidth(238);
			cicloTable.setLockedWidth(true);
			cicloTable.setSpacingAfter(10F);
			
			frase = new Phrase(vigIni, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(11f);
			cicloTable.addCell(celda);
			
			frase = new Phrase(vigFin, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(14f);
			cicloTable.addCell(celda);
			
			frase = new Phrase(cicloEscolar, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(19f);
			cicloTable.addCell(celda);
			
			
			String direccion = "";
			String direccion2 = "";
			if(CatEscuela.getDireccion().length()<= 30){
				direccion = CatEscuela.getDireccion();
			}else{
				String dirEscuela[] = CatEscuela.getDireccion().split(" ");
				direccion = dirEscuela[0]+" "+dirEscuela[1]+" "+dirEscuela[2];

				for(int j=3; j<dirEscuela.length;j++){
					direccion2 += dirEscuela[j]+" "; 
				}
			}
			
			String colonia = CatEscuela.getColonia();
			
			if((!colonia.contains("Col.")) && (!colonia.equals(""))){
				colonia	= "Col "+CatEscuela.getColonia();
			}else{
				colonia = CatEscuela.getColonia();
			}
			
			frase = new Phrase(direccion+"\n"+(!direccion2.equals("")?direccion2:"")+"\n"+colonia  , 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			cicloTable.addCell(celda);
			
			cicloTable.writeSelectedRows(0, -1, 322,700+extra, pdf.getDirectContent());
			
			if(tieneFirma == false){
			float[] ColumnSize = { 100F };
				PdfPTable firmaTable = new PdfPTable(ColumnSize);
				firmaTable.getDefaultCell().setBorder(0);
				firmaTable.setHorizontalAlignment(0);
				firmaTable.setTotalWidth(238);
				firmaTable.setLockedWidth(true);
				firmaTable.setSpacingAfter(10F);
				
				frase = new Phrase("Juan Jorge Acuña", 
						FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new Color(0,0,0)));
				celda = new PdfPCell(frase);
				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				firmaTable.addCell(celda);
				
				firmaTable.writeSelectedRows(0, -1, 482,638+extra, pdf.getDirectContent());
			}
			
			// Crea una nueva página
			if(i%4 == 0){
				document.newPage();
			}
			
        }
	}catch(IOException ioe) {
		System.err.println("Error credencial en PDF: "+ioe.getMessage());
	}
	
	document.close();
%>
<head>
	<meta http-equiv='REFRESH' content='0; url=credencial2.pdf'>
</head>
<%@ include file="../../cierra_elias.jsp" %>