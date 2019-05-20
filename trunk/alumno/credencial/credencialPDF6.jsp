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
<jsp:useBean id="CatEscuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="CatAsociacionLista" scope="page" class="aca.catalogo.CatAsociacionLista"/>

<%
	String escuelaId		= (String)session.getAttribute("escuela");

	String codigoAlumno		= "";
	String cicloId			= (String)session.getAttribute("cicloId");
	//String cicloId			= Ciclo.getCargaActual(conElias, escuelaId);
	
	String vigIni 			= request.getParameter("VigIni").equals("")?" ":request.getParameter("VigIni");
	String vigFin 			= request.getParameter("VigFin").equals("")?" ":request.getParameter("VigFin");
	
	
	//Map Escuelas
	java.util.HashMap<String, aca.catalogo.CatEscuela> mapEscuela	= CatEscuelaLista.getMapAll(conElias, "");
	
	//Map Asociacion
	java.util.HashMap<String, aca.catalogo.CatAsociacion> mapAsociacion = CatAsociacionLista.getMapAll(conElias, "");
	
	int cantidad			= Integer.parseInt(request.getParameter("cantidad"));
	int extra				= 0;
	
	String cicloEscolar 	= "20"+cicloId.substring(3,5)+" - "+"20"+cicloId.substring(5,7);
	
	Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
	document.setMargins(5,5,5,5);
	try{
		String dir = application.getRealPath("/alumno/credencial/")+"/"+"credencial6.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar Exodus");
        document.addSubject("Credencial de alumnos");
        document.open();
        
        for(int i = 1; i <= cantidad; i++){
        	codigoAlumno = request.getParameter("matricula-"+i);
	    	
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
			jpg = Image.getInstance(application.getRealPath("/alumno/credencial/fondos/")+"/alumnoFrente6.jpg");
			
			// El tamaño de la credencia es 250 de ancho y 150 de alto
			jpg.scaleAbsolute(250f, 150f);
			jpg.setAbsolutePosition(30, 560+extra);
			document.add(jpg);
			
			jpg = Image.getInstance(application.getRealPath("/alumno/credencial/fondos/")+"/alumnoReverso6.jpg");
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
		    jpg.scaleAbsolute(64f, 78f);
			jpg.setAbsolutePosition(185, 601+extra);
			document.add(jpg);
			
			String numeroTel = "-";
			String campo	 = "-";
			String campoId	 = "-";
			
			if(mapEscuela.containsKey(escuelaId)){
				numeroTel = mapEscuela.get(escuelaId).getTelefono();
				campoId	  = mapEscuela.get(escuelaId).getAsociacionId();
				if(mapAsociacion.containsKey(campoId))
					
				campo = mapAsociacion.get(campoId).getAsociacionNombre();
			}
/*
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
*/			
			boolean tieneFirma = false;
/*
			String dirFirmas =application.getRealPath("/imagenes/firmas/");
			java.io.File firma = new java.io.File(dirFirmas+"/"+aca.catalogo.CatEscuela.getFirma(conElias, escuelaId));
			if(firma.exists()){
				tieneFirma = true;
				jpg = Image.getInstance(dirFirmas+"/"+aca.catalogo.CatEscuela.getFirma(conElias, escuelaId));
			}else{
				tieneFirma = false;
				jpg = Image.getInstance(dirFirmas+"/firma.png");
			}
			jpg.scaleAbsolute(50f, 30f);
			jpg.setAbsolutePosition(485, 625+extra);
			document.add(jpg);
*/			
			
			float[] columnDefinitionSize = { 100F };
			PdfPTable topTable = new PdfPTable(1);
			topTable.getDefaultCell().setBorder(0);
			topTable.setHorizontalAlignment(0);
			topTable.setTotalWidth(230);
			topTable.setLockedWidth(true);
			topTable.setSpacingAfter(10F);
			
			
			PdfPCell celda = null;
// 			celda = new PdfPCell(new Phrase(aca.catalogo.CatEscuela.getNombre(conElias,escuelaId)  , 
// 	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0,0,0))));
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
			//topTable.addCell(celda);
			

			
// 			topTable.writeSelectedRows(0, 1, 70, 670+extra, pdf.getDirectContent());
			
			
// 			celda = new PdfPCell(new Phrase(campo  , 
// 	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0,0,0))));
// 			celda.setHorizontalAlignment(Element.ALIGN_CENTER);
// 			celda.setBorder(0);
			//topTable.addCell(celda);
			
			
// 			topTable.writeSelectedRows(1, 2, 85, 663+extra, pdf.getDirectContent());

			
			
			
			float[] DataColumnDefinitionSize = { 700f };
			PdfPTable dataTable = new PdfPTable(DataColumnDefinitionSize);
			dataTable.getDefaultCell().setBorder(0);
			dataTable.setHorizontalAlignment(0);
			
			dataTable.setTotalWidth(200);
			dataTable.setLockedWidth(true);
			dataTable.setSpacingAfter(10F);
			
			
			Phrase frase = new Phrase(alumPersonal.getNombre()
					, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
	        celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(1f);
			dataTable.addCell(celda);
			
			
			
			frase = new Phrase(alumPersonal.getApaterno()+" "+alumPersonal.getAmaterno()
					, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
	        celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(2.5f);
			dataTable.addCell(celda);
	
			
			frase = new Phrase(aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), AlumPlan.getNivelAlumno(conElias, codigoAlumno)+""),
					FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingTop(7f);
			celda.setPaddingBottom(0f);
			dataTable.addCell(celda);
		
			frase = new Phrase(" "
				, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			
			if(!alumPersonal.getCurp().equals("")){
				frase = new Phrase("CURP: "+alumPersonal.getCurp()
				, FontFactory.getFont(FontFactory.HELVETICA, 5, Font.NORMAL, new Color(0,0,0)));
			}
			
		    celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setPaddingTop(1f);
			celda.setBorder(0);
			celda.setPaddingBottom(2.5f);
			dataTable.addCell(celda);
			
			
			
			
			
// 			frase = new Phrase(codigoAlumno, 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			dataTable.addCell(celda);
			

	        
			dataTable.writeSelectedRows(0, -1, 47, 643+extra, pdf.getDirectContent());
			
			float[] DatacolumnSize = { 100F };
			PdfPTable cicloTable = new PdfPTable(DatacolumnSize);
			cicloTable.getDefaultCell().setBorder(0);
			cicloTable.setHorizontalAlignment(0);
			cicloTable.setTotalWidth(238);
			cicloTable.setLockedWidth(true);
			cicloTable.setSpacingAfter(10F);
			

			
/* 			frase = new Phrase(vigFin, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(14f);
			cicloTable.addCell(celda); */
			
			
// 			String direccion = "";
// 			String direccion2 = "";
// 			if(CatEscuela.getDireccion().length()<= 30){
// 				direccion = CatEscuela.getDireccion();
// 			}else{
// 				String dirEscuela[] = CatEscuela.getDireccion().split(" ");
// 				direccion = dirEscuela[0]+" "+dirEscuela[1]+" "+dirEscuela[2];

// 				for(int j=3; j<dirEscuela.length;j++){
// 					direccion2 += dirEscuela[j]+" "; 
// 				}
// 			}
			
// 			String colonia = CatEscuela.getColonia();
			
// 			if((!colonia.contains("Col.")) && (!colonia.equals(""))){
// 				colonia	= "Col "+CatEscuela.getColonia();
// 			}else{
// 				colonia = CatEscuela.getColonia();
// 			}
			
// 			frase = new Phrase(direccion+"\n"+(!direccion2.equals("")?direccion2:"")+colonia  , 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(10f);
// 			cicloTable.addCell(celda);
			
			
// 			frase = new Phrase(numeroTel, 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(24f);
// 			cicloTable.addCell(celda);
			
// /* 			frase = new Phrase(vigIni, 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(11f);
// 			cicloTable.addCell(celda); */
			
// 			int f1;
// 			int f2 = 0;
// 			int f3 = 0;
// 			int f4 = 0;
// 			int f5 = 0;
			
			
// 				f1 = Integer.parseInt(20+cicloId.substring(3,5));
// 				f2 = f1+1; 
// 				f3 = f2+1;
// 				f4 = f3+1;
// 				f5 = f4+1;
			
				
// 			frase = new Phrase(Integer.toString(f1), 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(11f);
// 			cicloTable.addCell(celda);
			
				
				
// 			frase = new Phrase(Integer.toString(f2), 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(11f);
// 			cicloTable.addCell(celda);
			
// 			frase = new Phrase(Integer.toString(f3), 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(11f);
// 			cicloTable.addCell(celda);
			
// 			frase = new Phrase(Integer.toString(f4), 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(11f);
// 			cicloTable.addCell(celda);
			
// 			frase = new Phrase(Integer.toString(f5), 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(11f);
// 			cicloTable.addCell(celda);

			
			
// 			cicloTable.writeSelectedRows(0, 2, 340, 648+extra, pdf.getDirectContent());
			
				
// 			cicloTable.writeSelectedRows(2, 3, 320, 607+extra, pdf.getDirectContent());	
// 			cicloTable.writeSelectedRows(3, 4, 336, 607+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(4, 5, 354, 607+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(5, 6, 371, 607+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(6, 7, 389, 607+extra, pdf.getDirectContent());
			
// 			cicloTable.writeSelectedRows(2, 3, 320, 588+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(3, 4, 336, 588+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(4, 5, 354, 588+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(5, 6, 371, 588+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(6, 7, 389, 588+extra, pdf.getDirectContent());
			

			
			
			
			
// 			if(tieneFirma == false){
// 			float[] ColumnSize = { 100F };
// 				PdfPTable firmaTable = new PdfPTable(ColumnSize);
// 				firmaTable.getDefaultCell().setBorder(0);
// 				firmaTable.setHorizontalAlignment(0);
// 				firmaTable.setTotalWidth(238);
// 				firmaTable.setLockedWidth(true);
// 				firmaTable.setSpacingAfter(10F);
				
// 				frase = new Phrase("Juan Jorge Acuña", 
// 						FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new Color(0,0,0)));
// 				celda = new PdfPCell(frase);
// 				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 				celda.setBorder(0);
// 				firmaTable.addCell(celda);
				
// 				firmaTable.writeSelectedRows(0, -1, 482,638+extra, pdf.getDirectContent());
// 			}
			
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
	<meta http-equiv='REFRESH' content='0; url=credencial6.pdf'>
</head>
<%@ include file="../../cierra_elias.jsp" %>