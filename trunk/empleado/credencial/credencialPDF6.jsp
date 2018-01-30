<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.lowagie.text.*" %>
<%@ page import = "com.lowagie.text.pdf.*" %>

<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>>

<%@page import="aca.ciclo.Ciclo"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="empCredencial" scope="page" class="aca.empleado.EmpCredencial"/>
<jsp:useBean id="CatEscuela" scope="page" class="aca.catalogo.CatEscuela"/>
<jsp:useBean id="CatEscuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="CatAsociacionLista" scope="page" class="aca.catalogo.CatAsociacionLista"/>
<%
	String escuelaId		= (String)session.getAttribute("escuela");
	String codigoEmpleado	= "";
	String cicloId			= Ciclo.getCargaActual(conElias, escuelaId);

	int cantidad			= Integer.parseInt(request.getParameter("cantidad"));
	int extra				= 0;
	
	//Map Escuelas
		java.util.HashMap<String, aca.catalogo.CatEscuela> mapEscuela	= CatEscuelaLista.getMapAll(conElias, "");
		
	//Map Asociacion
	java.util.HashMap<String, aca.catalogo.CatAsociacion> mapAsociacion = CatAsociacionLista.getMapAll(conElias, "");


	String numeroTel = "-";
	String campo	 = "-";
	String campoId	 = "-";
	
	if(mapEscuela.containsKey(escuelaId)){
		numeroTel = mapEscuela.get(escuelaId).getTelefono();
		campoId	  = mapEscuela.get(escuelaId).getAsociacionId();
		if(mapAsociacion.containsKey(campoId))
			
		campo = mapAsociacion.get(campoId).getAsociacionNombre();
	}
	
	String cicloEscolar = " ";
	if(cicloId!=null){
		cicloEscolar 		= "20"+cicloId.substring(3,5)+" - "+"20"+cicloId.substring(5,7);	
	}
	

	Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
	document.setMargins(0,0,20,20);
	try{
		String dir = application.getRealPath("/empleado/credencial/")+"/"+"credencial6.pdf";
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


// 	    	if(i%4 == 1){
// 	    		// Credencial 1
// 	    		extra = 50;	    	
// 	    	}else if (i%4 == 2){
// 	    		//Credencial 2
// 	    		extra = -120;	    	
// 	    	}else if (i%4 == 3){
// 	    		//Credencial 3
// 	    		extra = -290;	    	
// 	    	}else{
// 	    		// Credencial 4
// 	    		extra = -460;
// 	    	}
	    		
	    	cicloGrupo.mapeaRegId(conElias, codigoEmpleado,cicloId);
	    	empCredencial.mapeaRegId(conElias, codigoEmpleado);
	    	CatEscuela.mapeaRegId(conElias, escuelaId);
				
			Image jpg = null;			
			jpg = Image.getInstance(application.getRealPath("/empleado/credencial/fondos/")+"/empleadoFrente6.jpg");
			jpg.scaleAbsolute(250f, 150f);
			jpg.setAbsolutePosition(50, 600+extra);
			document.add(jpg);
			
			jpg = Image.getInstance(application.getRealPath("/empleado/credencial/fondos/")+"/empleadoReverso6.jpg");
			jpg.scaleAbsolute(250f, 150f);
			jpg.setAbsolutePosition(330, 600+extra);
			document.add(jpg);
	        
			String dirAlumnos=application.getRealPath("/WEB-INF/fotos/");
			java.io.File f = new java.io.File(dirAlumnos+"/"+codigoEmpleado+".jpg");
			if(f.exists()){
				jpg = Image.getInstance(dirAlumnos+"/"+codigoEmpleado+".jpg");
			}else{
				jpg = Image.getInstance(dirAlumnos+"/nofoto.jpg");
			}
			jpg.scaleAbsolute(64f, 78f);
			jpg.setAbsolutePosition(206, 642+extra);
			document.add(jpg);
			
/* 			String dirLogos=application.getRealPath("/imagenes/logos/");
			java.io.File l = new java.io.File(dirLogos+"/"+aca.catalogo.CatEscuela.getLogo(conElias, escuelaId));
			if(l.exists()){
				jpg = Image.getInstance(dirLogos+"/"+aca.catalogo.CatEscuela.getLogo(conElias, escuelaId));
			}else{
				jpg = Image.getInstance(dirLogos+"/logoIASD.png");
			}
			jpg.scaleAbsolute(30f, 30f);
			jpg.setAbsolutePosition(69, 710+extra);
			document.add(jpg); */
			
/* 			boolean tieneFirma = false;
			String dirFirmas =application.getRealPath("/imagenes/firmas/");
			java.io.File firma = new java.io.File(dirFirmas+"/"+aca.catalogo.CatEscuela.getFirma(conElias, escuelaId));
			if(firma.exists()){
				jpg = Image.getInstance(dirFirmas+"/"+aca.catalogo.CatEscuela.getFirma(conElias, escuelaId));
				tieneFirma = true;
			}else{
				jpg = Image.getInstance(dirFirmas+"/firma.png");
				tieneFirma = false;
			}
			jpg.scaleAbsolute(50f, 30f);
			jpg.setAbsolutePosition(505, 666+extra);
			document.add(jpg); */
			
			float[] columnDefinitionSize = { 100F };
			PdfPTable topTable = new PdfPTable(columnDefinitionSize);
			topTable.getDefaultCell().setBorder(0);
			topTable.setHorizontalAlignment(0);
			topTable.setTotalWidth(230);
			topTable.setLockedWidth(true);
			topTable.setSpacingAfter(10F);
			
			int ind = 90;
			PdfPCell celda = null;
// 			celda = new PdfPCell(new Phrase(aca.catalogo.CatEscuela.getNombre(conElias,escuelaId)  , 
// 	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0))));
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			topTable.addCell(celda);
			
// 			topTable.writeSelectedRows(0, 1, ind, 720+extra, pdf.getDirectContent());
			
// 			celda = new PdfPCell(new Phrase(campo  , 
// 	        		FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0))));
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			topTable.addCell(celda);
			
			
// 			topTable.writeSelectedRows(1, 2, ind, 710+extra, pdf.getDirectContent());
			
			
			
			
			float[] DataColumnDefinitionSize = { 200F };
			PdfPTable dataTable = new PdfPTable(DataColumnDefinitionSize);
			dataTable.getDefaultCell().setBorder(0);
			dataTable.setHorizontalAlignment(0);
			dataTable.setTotalWidth(200);
			dataTable.setLockedWidth(true);
			dataTable.setSpacingAfter(10F);
			
			
			Phrase frase = new Phrase(empPersonal.getNombre(),
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
	        celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(1f);
			dataTable.addCell(celda);
			
			
			
			frase = new Phrase(empPersonal.getApaterno()+" "+empPersonal.getAmaterno() , 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(10f);
			dataTable.addCell(celda);
			
			dataTable.writeSelectedRows(0, 2, 65, 684+extra, pdf.getDirectContent());
			
			
			float[] ExtraDataColumnDefinitionSize = { 200F };
			PdfPTable extradataTable = new PdfPTable(ExtraDataColumnDefinitionSize);
			extradataTable.getDefaultCell().setBorder(0);
			extradataTable.setHorizontalAlignment(0);
			extradataTable.setTotalWidth(200);
			extradataTable.setLockedWidth(true);
			extradataTable.setSpacingAfter(10F);
			
			String tituloPuesto = empPersonal.getGenero()!=null && empPersonal.getGenero().equals("F") ? "MAESTRA" : "MAESTRO";
			
			 frase = new Phrase(tituloPuesto,
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
	        celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(1f);
			extradataTable.addCell(celda);
        
			extradataTable.writeSelectedRows(0, 2, 90, 653+extra, pdf.getDirectContent());
			
// 			String especialidad = empCredencial.getEspecialidadId();
// 			if(especialidad.equals("")){
// 				especialidad = "0";
// 			}else{
// 				especialidad =empCredencial.getEspecialidadId();
// 			}
			
// /* 			frase = new Phrase(aca.catalogo.CatEspecialidad.getNombre(conElias, Integer.parseInt(especialidad)), 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(9f);
// 			dataTable.addCell(celda);
			
// 			dataTable.writeSelectedRows(2, 3, 155, 640+extra, pdf.getDirectContent()); */
			
			
			
// 			float[] DatacolumnSize = { 100F };
// 			PdfPTable cicloTable = new PdfPTable(DatacolumnSize);
// 			cicloTable.getDefaultCell().setBorder(0);
// 			cicloTable.setHorizontalAlignment(0);
// 			cicloTable.setTotalWidth(238);
// 			cicloTable.setLockedWidth(true);
// 			cicloTable.setSpacingAfter(10F);
			
// /* 			frase = new Phrase(empCredencial.getVigenciaIni().equals("")?" ":empCredencial.getVigenciaIni(),
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 	        celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(12f);
// 			cicloTable.addCell(celda); */
			
// /* 			frase = new Phrase(empCredencial.getVigenciaFin().equals("")?" ":empCredencial.getVigenciaFin(), 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(14f);
// 			cicloTable.addCell(celda); */
			
// /* 			frase = new Phrase(cicloEscolar, 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(10f);
// 			cicloTable.addCell(celda); */
			
// 			String direccion = "";
// 			String direccion2 = "";
// 			if(CatEscuela.getDireccion().length()<= 27){
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
// 				colonia	= "Col. "+CatEscuela.getColonia();
// 			}else{
// 				colonia = CatEscuela.getColonia();; 
// 			}
			
// 			frase = new Phrase(direccion+(!direccion2.equals("")?direccion2:"")+" \n"+colonia, 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(8f);
// 			cicloTable.addCell(celda);
			
// 			frase = new Phrase(numeroTel, 
// 					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
// 			celda = new PdfPCell(frase);
// 			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
// 			celda.setBorder(0);
// 			celda.setPaddingBottom(24f);
// 			cicloTable.addCell(celda);
			
// 			cicloTable.writeSelectedRows(0, 2, 360,688+extra, pdf.getDirectContent());
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

// 			int indent = 463;
// 			int rowH = 628;
// 			cicloTable.writeSelectedRows(2, 3, -114+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(3, 4, -95+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(4, 5, -76+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(5, 6, -56+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(6, 7, -36+indent, rowH+extra, pdf.getDirectContent());
			
// 			cicloTable.writeSelectedRows(2, 3, 7+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(3, 4, 27+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(4, 5, 47+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(5, 6, 65+indent, rowH+extra, pdf.getDirectContent());
// 			cicloTable.writeSelectedRows(6, 7, 84+indent, rowH+extra, pdf.getDirectContent());
			
/* 			if(tieneFirma == false){
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
				
				firmaTable.writeSelectedRows(0, -1, 506,676+extra, pdf.getDirectContent());
			} */

// 			if(i%4 == 0){
// 				document.newPage();
// 			}
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