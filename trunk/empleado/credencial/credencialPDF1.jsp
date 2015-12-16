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

<%
	String escuelaId		= (String)session.getAttribute("escuela");
	String codigoEmpleado	= "";
	String cicloId			= Ciclo.getCargaActual(conElias, escuelaId);

	int cantidad			= Integer.parseInt(request.getParameter("cantidad"));
	int extra				= 0;
	
	String cicloEscolar = " ";
	if(cicloId!=null){
		cicloEscolar 	= "20"+aca.ciclo.Ciclo.getCicloEscolar(conElias, cicloId).substring(0, 2)+"-20"+aca.ciclo.Ciclo.getCicloEscolar(conElias, cicloId).substring(2,4 );
	}
	

	Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
	document.setMargins(35,35,20,20);
	try{
		String dir = application.getRealPath("/empleado/credencial/")+"/"+"credencial1.pdf";
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
	    	
	    	cicloGrupo.mapeaRegId(conElias, codigoEmpleado,cicloId);
	    	empCredencial.mapeaRegId(conElias, codigoEmpleado);
	    	CatEscuela.mapeaRegId(conElias, escuelaId);
				
			Image jpg = null;			
			jpg = Image.getInstance(application.getRealPath("/empleado/credencial/fondos/")+"/empleadoFrente1.jpg");
			jpg.scaleAbsolute(250f, 150f);
			jpg.setAbsolutePosition(50, 600+extra);
			document.add(jpg);
			
			jpg = Image.getInstance(application.getRealPath("/empleado/credencial/fondos/")+"/empleadoReverso1.jpg");
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
			jpg.scaleAbsolute(51f, 70f);
			jpg.setAbsolutePosition(68, 625+extra);
			document.add(jpg);
			
			String dirLogos=application.getRealPath("/imagenes/logos/");
			java.io.File l = new java.io.File(dirLogos+"/"+aca.catalogo.CatEscuela.getLogo(conElias, escuelaId));
			if(l.exists()){
				jpg = Image.getInstance(dirLogos+"/"+aca.catalogo.CatEscuela.getLogo(conElias, escuelaId));
			}else{
				jpg = Image.getInstance(dirLogos+"/logoIASD.png");
			}
			jpg.scaleAbsolute(30f, 30f);
			jpg.setAbsolutePosition(69, 710+extra);
			document.add(jpg);
			
			boolean tieneFirma = false;
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
			
			topTable.writeSelectedRows(0, -1, 82, 735+extra, pdf.getDirectContent());
			
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
			celda.setPaddingBottom(3f);
			dataTable.addCell(celda);
			
			frase = new Phrase(empPersonal.getApaterno()+" "+empPersonal.getAmaterno(), 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(10f);
			dataTable.addCell(celda);
			
			String especialidad = empCredencial.getEspecialidadId();
			if(especialidad.equals("")){
				especialidad = "0";
			}else{
				especialidad =empCredencial.getEspecialidadId();
			}
			
			frase = new Phrase(aca.catalogo.CatEspecialidad.getNombre(conElias, Integer.parseInt(especialidad)), 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(9f);
			dataTable.addCell(celda);
		
			frase = new Phrase( empCredencial.getNivel()+" "+empCredencial.getGrado() , 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			dataTable.addCell(celda);
	        
			dataTable.writeSelectedRows(0, -1, 161, 688+extra, pdf.getDirectContent());
			
			float[] DatacolumnSize = { 100F };
			PdfPTable cicloTable = new PdfPTable(DatacolumnSize);
			cicloTable.getDefaultCell().setBorder(0);
			cicloTable.setHorizontalAlignment(0);
			cicloTable.setTotalWidth(238);
			cicloTable.setLockedWidth(true);
			cicloTable.setSpacingAfter(10F);
			
			frase = new Phrase(empCredencial.getVigenciaIni().equals("")?" ":empCredencial.getVigenciaIni(),
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
	        celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(12f);
			cicloTable.addCell(celda);
			
			frase = new Phrase(empCredencial.getVigenciaFin().equals("")?" ":empCredencial.getVigenciaFin(), 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(20f);
			cicloTable.addCell(celda);
			
			frase = new Phrase(cicloEscolar, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			celda.setPaddingBottom(10f);
			cicloTable.addCell(celda);
			
			String direccion = "";
			String direccion2 = "";
			if(CatEscuela.getDireccion().length()<= 40){
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
				colonia	= "Col. "+CatEscuela.getColonia();
			}else{
				colonia = CatEscuela.getColonia();; 
			}
			
			String ciudad 	= aca.catalogo.CatCiudad.getCiudad(conElias, CatEscuela.getPaisId(), CatEscuela.getEstadoId(), CatEscuela.getCiudadId());
			String estado 	= aca.catalogo.CatEstado.getEstado(conElias, CatEscuela.getPaisId(), CatEscuela.getEstadoId());
			String telefono = CatEscuela.getTelefono();
			
			frase = new Phrase(direccion+"\n"+(!direccion2.equals("")?direccion2:"")+colonia+"\n"+ciudad+", "+estado+"\n"+telefono, 
					FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new Color(0,0,0)));
			celda = new PdfPCell(frase);
			celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			celda.setBorder(0);
			cicloTable.addCell(celda);
			
			cicloTable.writeSelectedRows(0, -1, 342,705+extra, pdf.getDirectContent());
			
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
				
				firmaTable.writeSelectedRows(0, -1, 506,676+extra, pdf.getDirectContent());
			}
        }
	}catch(IOException ioe) {
		System.err.println("Error credencial en PDF: "+ioe.getMessage());
	}
	
	document.close();
%>
<head>
	<meta http-equiv='REFRESH' content='0; url=credencial1.pdf'>
</head>
<%@ include file="../../cierra_elias.jsp" %>