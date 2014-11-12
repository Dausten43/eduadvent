<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.itextpdf.text.*" %>
<%@ page import = "com.itextpdf.text.pdf.*" %>
<%
	String codigoAlumno = (String) session.getAttribute("codigoAlumno");	
	int posX 	= 0; 
	int posY	= 0;
	//int salto 	= 20; 
	Rectangle rec = new Rectangle(21.8f , 16.8f);
	Document document = new Document(rec ); //Crea un objeto para el documento PDF
	document.setMargins(-30,-30,40,20);
	
	try{
		String dir = application.getRealPath("/finanza/cuenta/")+"/"+"reciboPDF.pdf";
		System.out.println("Dir:"+dir);
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar");
        document.addSubject("Recibo de "+codigoAlumno);       
        document.open(); 
        
        PdfContentByte canvas = pdf.getDirectContentUnder();
        
        Phrase cliente = new Phrase( "AAA", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, cliente, posX+3.5f, posY+12.1f, 0);
    	
    	Phrase domicilio = new Phrase( "BBB", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, domicilio, posX+3.5f, posY+11.5f, 0);
		
    	Phrase abajodomicilio = new Phrase( "CCC", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, abajodomicilio, posX+1.5f, posY+10.9f, 0);
    	
    	Phrase rfc = new Phrase( "DDD", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, rfc, posX+8.5f, posY+10.9f, 0);
    	
    	Phrase dia = new Phrase( "30", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, dia, posX+15.2f, posY+10.9f, 0);
    	
    	Phrase mes = new Phrase( "10", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, mes, posX+16.2f, posY+10.9f, 0);
    	
    	Phrase año = new Phrase( "10", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, año, posX+17.4f, posY+10.9f, 0);
    	
    	Phrase matricula = new Phrase( "1060867", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, matricula, posX+1.3f, posY+9.2f, 0);
    	
    	Phrase nombre = new Phrase( "Cynthia karelly garica etc..", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, nombre, posX+4.6f, posY+9.2f, 0);
    	
    	Phrase concepto = new Phrase( "KKK", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, concepto, posX+13.7f, posY+9.2f, 0);
    	
    	Phrase cantidad = new Phrase( "500", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, cantidad, posX+19.4f, posY+9.2f, 0);
    	
    	Phrase observaciones = new Phrase( "Observaciones", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, observaciones, posX+4.5f, posY+4.1f, 0);
    	
    	Phrase total = new Phrase( "300", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, total, posX+19.4f, posY+3.5f, 0);
    	
    	Phrase total2 = new Phrase( "300", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, total2, posX+19.4f, posY+1.5f, 0);
    	
    	Phrase cantidadLetra = new Phrase( "Trecientos Pesos", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, cantidadLetra, posX+1.3f, posY+1.5f, 0);
    	
	}catch(IOException ioe){
		System.err.println("Error al generar el recibo en PDF: "+ioe.getMessage());
	}
	
	document.close();
%>
<head>
	<meta http-equiv="REFRESH" content="0; url=reciboPDF.pdf">
</head>
<%@ include file= "../../cierra_elias.jsp" %>