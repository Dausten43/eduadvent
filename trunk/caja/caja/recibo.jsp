<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.lowagie.text.*" %>
<%@ page import = "com.lowagie.text.pdf.*" %>
<%@ page import="aca.util.NumberToLetter"%>

<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo"/><%
	String reciboId = request.getParameter("reciboId");
	
	Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
	document.setMargins(35,35,20,20);
	
	finRecibo.mapeaRegId(conElias, reciboId);
	
	try{
//		System.out.println(application.getRealPath());
		String dir = application.getRealPath("/caja/caja/")+"/"+"recibo.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar");
        document.addSubject("Recibo No. "+reciboId);
		//HeaderFooter footer = new HeaderFooter(new Phrase("Nota: Cr=Creditos; HT=Hrs teóricas; HP=Hrs prácticas; Tipo= de nota[Ext=Extraordinaria; Conv=Convalidacion; TS=Título Suficiencia; CD=Calif. Diferida]; Edo=Estado", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD)), true);
        //document.setFooter(footer);
        document.open();
        
        float headerwidths[] = {100F};
		PdfPTable table = new PdfPTable(headerwidths);
		table.setTotalWidth(70);
		//table.setSpacingAfter(5f);
		
		PdfPCell cell = null;
		java.util.Locale.setDefault(java.util.Locale.US);
		java.text.DecimalFormat getformato= new java.text.DecimalFormat("#,###,###,##0.00;-#,###,###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		String importe = getformato.format(Float.parseFloat(finRecibo.getImporte()));
		cell = new PdfPCell(new Phrase(importe, FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell.setBorder(2);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 425, 680, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(100);
		
		cell = new PdfPCell(new Phrase(finRecibo.getFecha(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 399, 656, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(384);
		
		cell = new PdfPCell(new Phrase(finRecibo.getCliente(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 165, 631, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(400);
		
		cell = new PdfPCell(new Phrase(finRecibo.getDomicilio(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 150, 613, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(250);
		
		cell = new PdfPCell(new Phrase(finRecibo.getLugar(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 134, 595, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(100);
		
		cell = new PdfPCell(new Phrase(finRecibo.getRfc(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 409, 595, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(197);
		
		cell = new PdfPCell(new Phrase(finRecibo.getConcepto(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 150, 577, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(450);
		
		getformato= new java.text.DecimalFormat("#########0.00;-#########0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		importe = getformato.format(Float.parseFloat(finRecibo.getImporte()));
		//System.out.println(N2t.convertirLetras(Integer.parseInt(importe.substring(0, importe.indexOf("."))))+" Pesos "+importe.substring(importe.indexOf(".")+1, importe.length()-1)+"/100 M.N.");
		cell = new PdfPCell(new Phrase((NumberToLetter.convertirLetras(Integer.parseInt(importe.substring(0, importe.indexOf("."))))).toUpperCase()+" PESOS "+importe.substring(importe.indexOf(".")+1, importe.length())+"/100 M.N.", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 100, 542, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(200);
		
		cell = new PdfPCell(new Phrase(finRecibo.getCheque(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 130, 498, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(150);
		
		cell = new PdfPCell(new Phrase(finRecibo.getBanco(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 400, 498, pdf.getDirectContent());
		
		table = new PdfPTable(headerwidths);
		table.setTotalWidth(375);
		
		cell = new PdfPCell(new Phrase(finRecibo.getObservaciones(), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, new Color(0,0,0))));
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setBorder(0);
		table.addCell(cell);
		
		table.writeSelectedRows(0, -1, 175, 475, pdf.getDirectContent());
		
		
	}catch(IOException ioe) {
		System.err.println("Error recibo en PDF: "+ioe.getMessage());
	}
	
	document.close();
%>
	<head>
		<meta http-equiv="REFRESH" content="0; url=recibo.pdf">
	</head>
<%@ include file = "../../cierra_elias.jsp"%>