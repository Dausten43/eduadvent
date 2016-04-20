<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatPais"%>
<%@page import="com.lowagie.text.*" %>
<%@page import="com.lowagie.text.Document" %>
<%@page import="com.lowagie.text.pdf.*" %>
<%@page import="java.io.IOException" %>
<%@page import="java.io.FileOutputStream" %>
<%@page import="java.awt.Color" %>
<%@page import="aca.catalogo.CatPais"%>
<jsp:useBean id="empCurriculum" class="aca.empleado.EmpCurriculum" scope="page"/>
<jsp:useBean id="Maestros" class="aca.empleado.EmpPersonal" scope="page"/>
<jsp:useBean id="catPais" class="aca.catalogo.CatPais" scope="page"/>
<jsp:useBean id="catPaisU" class="aca.catalogo.CatPaisLista" scope="page"/>
<%	
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoPersonal 	= request.getParameter("codigoPersonal");
	String respuesta 		= "";
	int accion 				= Integer.parseInt(request.getParameter("Accion")==null?"0":request.getParameter("Accion"));
	boolean error 			= false;

	ArrayList<CatPais> listPais = catPaisU.getListAll(conElias, "ORDER BY PAIS_NOMBRE");
	
	empCurriculum.mapeaRegId(conElias, codigoPersonal);
	
	Maestros.mapeaRegId(conElias, codigoPersonal);
	
	Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
	document.setMargins(30,30,60,20);
	
	try{
		String dir = application.getRealPath("/empleado/vercurriculum/")+"/"+"curriculum.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Direccion de Sistemas");
        document.addSubject("Curriculum de "+codigoPersonal);
        document.open();
        //---------------- Imagenes --------------------------------
        
        //*
        String escuela = escuelaId +"";
           	
        String strLogo	= "";
        String d		= application.getRealPath("/imagenes/")+"/";
		java.io.File fi 	= new java.io.File(d+"logo"+escuela.trim()+".jpg");
		if (fi.exists()){
			strLogo = "/logo"+escuela.trim()+".jpg";
		}else{
			strLogo = "/logoIASD.png";
		}	
        Image jpg = Image.getInstance(application.getRealPath("/imagenes/")+strLogo);

        jpg.setAlignment(Image.LEFT | Image.UNDERLYING);
        jpg.scaleAbsolute(63, 63);
        jpg.setAbsolutePosition(23, 695);
        document.add(jpg);
        
        jpg = null;
        
        String dirFotos = application.getRealPath("/WEB-INF/fotos/");
		java.io.File f = new java.io.File(dirFotos+"/"+codigoPersonal+".jpg");
		f.exists();
		if(f.exists()){
			jpg = Image.getInstance(dirFotos+"/"+codigoPersonal+".jpg");

			jpg.scaleAbsolute(71f, 95f);
			jpg.setAbsolutePosition(500, 650);
			document.add(jpg);
		}//else{
		//	jpg = Image.getInstance(dirFotos+"/nofoto.jpg");
		//}
		
		
        //----------------------------------------------------------
        
        PdfPTable cuerpo = new PdfPTable(1);
        int cuerpoWidths[] = {100};
        cuerpo.setWidths(cuerpoWidths);
        //cuerpo.setTotalWidth(document.getPageSize().width() - 60);
        
        PdfPCell cell = new PdfPCell(new Phrase(aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) , FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        cuerpo.addCell(cell);
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        cuerpo.addCell(cell);
        
        cell = new PdfPCell(new Phrase("CURRICULUM VITAE", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        cuerpo.addCell(cell);
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        cuerpo.addCell(cell);
        
        document.add(cuerpo);
        
        PdfPTable datosPersonalesTit = new PdfPTable(1);
        int datosPersonalesTitWidths[] = {100};
        datosPersonalesTit.setWidths(datosPersonalesTitWidths);
        datosPersonalesTit.KEEPTOGETHER = true;
        
        cell = new PdfPCell(new Phrase("DATOS PERSONALES", FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonalesTit.addCell(cell);
        
//---------- Tabla de datos personales -----------------

        PdfPTable datosPersonales = new PdfPTable(1);
        int datosPersonalesWidths[] = {100};
        datosPersonales.setWidths(datosPersonalesWidths);
        datosPersonales.setHeaderRows(1);
        
        cell = new PdfPCell(new Phrase("Nombre completo:", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.TOP);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase(Maestros.getNombre()+" "+Maestros.getApaterno()+" "+Maestros.getAmaterno(),
        		FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase("Fecha y lugar de Nacimiento:", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase(empCurriculum.getFNacimiento(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase(empCurriculum.getLugarNac(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
       
        cell = new PdfPCell(new Phrase("Nacionalidad:", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase(CatPais.getPais(conElias, empCurriculum.getNacionalidad()) , FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
        
        cell = new PdfPCell(new Phrase("Título profesional (último grado obtenido):", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        datosPersonales.addCell(cell);
       
        cell = new PdfPCell(new Phrase(empCurriculum.getTProfesional(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.RECTANGLE);
        datosPersonales.addCell(cell);
        
        //---------- Termina tabla de datos personales ---------
        
        cell = new PdfPCell(datosPersonales);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.RECTANGLE);
        datosPersonalesTit.addCell(cell);
        
        document.add(datosPersonalesTit);
        //--------------------------------------------
        
        PdfPTable formacionAcademicaTit = new PdfPTable(1);
        int formacionAcademicaTitWidths[] = {100};
        formacionAcademicaTit.setWidths(formacionAcademicaTitWidths);
        formacionAcademicaTit.KEEPTOGETHER = true;
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        formacionAcademicaTit.addCell(cell);
     
        cell = new PdfPCell(new Phrase("FORMACIÓN ACADÉMICA", FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.BOTTOM);
        formacionAcademicaTit.addCell(cell);
        
		//---------- Tabla de formacion academica -----------------
        
        PdfPTable formacionAcademica = new PdfPTable(1);
        int formacionAcademicaWidths[] = {100};
        formacionAcademica.setWidths(formacionAcademicaWidths);
        
        cell = new PdfPCell(new Phrase("Grado de posgrado:", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        formacionAcademica.addCell(cell);
        
        cell = new PdfPCell(new Phrase(empCurriculum.getGPosgrado(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        formacionAcademica.addCell(cell);
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        formacionAcademica.addCell(cell);
     
        cell = new PdfPCell(new Phrase("Título universitario (licenciatura):", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        formacionAcademica.addCell(cell);
        
        cell = new PdfPCell(new Phrase(empCurriculum.getTUniversitario(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        formacionAcademica.addCell(cell);
        
        //---------- Termina tabla de datos personales ---------
        
        cell = new PdfPCell(formacionAcademica);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.RECTANGLE);
        formacionAcademicaTit.addCell(cell);
        
        document.add(formacionAcademicaTit);
        
        //------------------------------------------------
        
        PdfPTable experienciaProfesionalTit = new PdfPTable(1);
        int experienciaProfesionalTitWidths[] = {100};
        experienciaProfesionalTit.setWidths(experienciaProfesionalTitWidths);
        experienciaProfesionalTit.KEEPTOGETHER = true;
       
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesionalTit.addCell(cell);
        
        cell = new PdfPCell(new Phrase("EXPERIENCIA PROFESIONAL", FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.BOTTOM);
        experienciaProfesionalTit.addCell(cell);
        
		//---------- Tabla de experiencia profesional -----------------
        
        PdfPTable experienciaProfesional = new PdfPTable(1);
        int experienciaProfesionalWidths[] = {100};
        experienciaProfesional.setWidths(experienciaProfesionalWidths);
        
        cell = new PdfPCell(new Phrase("Responsabilidad actual:", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
        
        cell = new PdfPCell(new Phrase(empCurriculum.getRespActual(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
      
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
        
        cell = new PdfPCell(new Phrase("Responsabilidad anterior:", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
        
        cell = new PdfPCell(new Phrase(empCurriculum.getRespAnterior(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
        
        cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
        
        cell = new PdfPCell(new Phrase("Experiencia docente:", FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.BOLD)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
        
        cell = new PdfPCell(new Phrase(empCurriculum.getExpDocente(), FontFactory.getFont(FontFactory.TIMES_ROMAN, 12, Font.NORMAL)));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.NO_BORDER);
        experienciaProfesional.addCell(cell);
        
        //---------- Termina tabla de datos personales ---------
        
        cell = new PdfPCell(experienciaProfesional);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(Rectangle.RECTANGLE);
        experienciaProfesionalTit.addCell(cell);
        
        document.add(experienciaProfesionalTit);

	}catch(IOException ioe) {
		System.err.println("Error kardex en PDF: "+ioe.getMessage());
	}

	document.close();
%>
<head>
	<meta http-equiv='REFRESH' content='0; url=curriculum.pdf'>
</head>
<%@ include file= "../../cierra_elias.jsp" %>