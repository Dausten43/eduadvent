<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.itextpdf.text.*" %>
<%@ page import = "com.itextpdf.text.pdf.*" %>

<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo"/>
<jsp:useBean id="finRecDetL" scope="page" class="aca.fin.FinReciboDetLista"/>
<jsp:useBean id="Coordenada" scope="page" class="aca.fin.FinCoordenada"/>

<%
	java.text.DecimalFormat frmNum = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String codigoAlumno = (String) session.getAttribute("codigoAlumno");
	String recibo 		= request.getParameter("Recibo");	
	String day			= "";
	String month		= "";
	String year			= "";
	Coordenada.mapeaRegId(conElias, codigoAlumno, "F");
	
	String temp = "";
	
	temp = "3.5,12.1";
	if(Coordenada.getCliente()!=null && !Coordenada.getCliente().equals("") ){temp=Coordenada.getCliente();}
	String [] cl = temp.split(",");		
	float ClienteX = Float.parseFloat(cl[0]); 
	float ClienteY = Float.parseFloat(cl[1]);
	
	temp = "3.5,11.5";
	if(Coordenada.getDomicilio()!=null && !Coordenada.getDomicilio().equals("")){temp=Coordenada.getDomicilio();}
	String [] dom = temp.split(",");
	float DomicilioX = Float.parseFloat(dom[0]);
	float DomicilioY = Float.parseFloat(dom[1]);
	
	temp = "8.5,10.9";
	if(Coordenada.getRfc()!=null && !Coordenada.getRfc().equals("")){temp=Coordenada.getRfc();}
	String [] rf = temp.split(",");
	float RFCX = Float.parseFloat(rf[0]);
	float RFCY = Float.parseFloat(rf[1]);
	
	temp = "4.5,4.1";
	if(Coordenada.getObservaciones()!=null && !Coordenada.getObservaciones().equals("")){temp=Coordenada.getObservaciones();}
	String [] obs = temp.split(",");
	float ObservacionesX = Float.parseFloat(obs[0]);
	float ObservacionesY = Float.parseFloat(obs[1]);
	
	temp = "1.3,1.5";
	if(Coordenada.getLetra()!=null && !Coordenada.getLetra().equals("")){temp=Coordenada.getLetra();}
	String [] let = temp.split(",");
	float LetraX = Float.parseFloat(let[0]);
	float LetraY = Float.parseFloat(let[1]);
	
	temp = "19.4,1.2";
	if(Coordenada.getTotal()!=null && !Coordenada.getTotal().equals("")){temp=Coordenada.getTotal();}
	String [] tot = temp.split(",");
	float TotalX = Float.parseFloat(tot[0]);
	float TotalY = Float.parseFloat(tot[1]);
	
	temp = "1.3,9.2";
	if(Coordenada.getCodigo()!=null && !Coordenada.getCodigo().equals("")){temp=Coordenada.getCodigo();}
	String [] cod = temp.split(",");
	float CodigoX = Float.parseFloat(cod[0]);
	float CodigoY = Float.parseFloat(cod[1]);
	
	temp = "4.6,9.2";
	if(Coordenada.getNombre()!=null && !Coordenada.getNombre().equals("")){temp=Coordenada.getNombre();}
	String [] nom = temp.split(",");
	float NombreX = Float.parseFloat(nom[0]);
	float NombreY = Float.parseFloat(nom[1]);
	
	temp = "13.7,9.2";
	if(Coordenada.getConcepto()!=null && !Coordenada.getConcepto().equals("")){temp=Coordenada.getConcepto();}
	String [] con = temp.split(",");
	float ConceptoX = Float.parseFloat(con[0]);
	float ConceptoY = Float.parseFloat(con[1]);
	
	temp = "19.4,9.2";
	if(Coordenada.getImporte()!=null && !Coordenada.getImporte().equals("")){temp=Coordenada.getImporte();}
	String [] imp = temp.split(",");
	float ImporteX = Float.parseFloat(imp[0]);
	float ImporteY = Float.parseFloat(imp[1]);
	
	temp = "15.1,10.9";
	if(Coordenada.getFecha()!=null && !Coordenada.getFecha().equals("")){temp=Coordenada.getFecha();}
	String [] fec = temp.split(",");
	float FechaX = Float.parseFloat(fec[0]);
	float FechaY = Float.parseFloat(fec[1]);
	
	finRecibo.mapeaRegId(conElias, recibo);
	day 			= finRecibo.getFecha().substring(0,2);
	month			= finRecibo.getFecha().substring(3,5);
	year 			= finRecibo.getFecha().substring(6,10);
	
	double importe 	= 0;
	double iva		= 0;
	double subTotal	= 0;
	
	int posX 	= 0; 
	int posY	= 0;
	//int salto 	= 20; 
	Rectangle rec = new Rectangle(21.8f , 16.8f);
	Document document = new Document(rec ); //Crea un objeto para el documento PDF
	document.setMargins(-30,-30,40,20);
	
	try{
		String dir = application.getRealPath("/finanza/caja/")+"/"+"facturaPDF.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar");
        document.addSubject("Factura de "+codigoAlumno);
        document.open(); 
        
        PdfContentByte canvas = pdf.getDirectContentUnder();
        
        Phrase cliente = new Phrase( finRecibo.getCliente(), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, cliente, posX+ClienteX, posY+ClienteY, 0);
    	
    	Phrase domicilio = new Phrase( finRecibo.getDomicilio(), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, domicilio, posX+DomicilioX, posY+DomicilioY, 0);
/*		
    	Phrase abajodomicilio = new Phrase( "CCC", FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, abajodomicilio, posX+(DomicilioX-2f), posY+(DomicilioY-.6f), 0);
*/    	
    	Phrase rfc = new Phrase( finRecibo.getRfc(), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, rfc, posX+RFCX, posY+RFCY, 0);
    	
    	Phrase dia = new Phrase( day, FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, dia, posX+FechaX, posY+FechaY, 0);
    	
    	Phrase mes = new Phrase( month, FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, mes, posX+(FechaX+1.1f), posY+FechaY, 0);
    	
    	Phrase año = new Phrase( year, FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, año, posX+(FechaX+2.3f), posY+FechaY, 0);
    	
    	/******Recorre la lista de detalles****/
    	ArrayList lisDetalle = finRecDetL.getListRecibo(conElias, recibo, "ORDER BY FOLIO"); 	    	
		for( int i=0; i<lisDetalle.size(); i++){
			aca.fin.FinReciboDet detalle = (aca.fin.FinReciboDet)lisDetalle.get(i);
			
			iva = iva + Double.valueOf(detalle.getImporte())*.16; 
			importe = Double.valueOf(detalle.getImporte())-iva;
			subTotal = subTotal + importe;
			
			Phrase matricula = new Phrase( detalle.getCodigoId(), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
	    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, matricula, posX+CodigoX, posY+CodigoY-(i*.9f), 0);
	    	
	    	Phrase nombre = new Phrase( detalle.getNombre(), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
	    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, nombre, posX+NombreX, posY+NombreY-(i*.9f), 0);
	    	
	    	Phrase concepto = new Phrase( detalle.getConcepto(), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
	    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, concepto, posX+ConceptoX, posY+ConceptoY-(i* 0.9f), 0);
	    	
	    	Phrase cantidad = new Phrase( frmNum.format(importe), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
	    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER , cantidad, posX+ImporteX, posY+ImporteY-(i*.9f), 0);
		} 	
    	
    	Phrase observaciones = new Phrase( finRecibo.getObservaciones(), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, observaciones, posX+ObservacionesX, posY+ObservacionesY, 0);
    	
    	Phrase total = new Phrase( frmNum.format(subTotal), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, total, posX+TotalX, posY+(TotalY+2.7f), 0);
    	
    	Phrase iva2 = new Phrase( frmNum.format(iva), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, iva2, posX+TotalX, posY+(TotalY+2f), 0);
    	
    	Phrase total2 = new Phrase( frmNum.format(Double.valueOf(finRecibo.getImporte())), FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, total2, posX+TotalX, posY+TotalY, 0);
    	
    	String totRec	= finRecibo.getImporte(); 
    	String pesos 	= "0";
    	String centavos	= "00"; 
    	
    	pesos 		= totRec.indexOf(".")>=0?totRec.substring(0,totRec.indexOf(".")):totRec;
    	centavos 	= totRec.indexOf(".")>=0?totRec.substring(totRec.indexOf(".")+1, totRec.length()):"00";
    	System.out.println("Pesos:"+pesos);
    	
    	Phrase cantidadLetra = new Phrase( aca.util.NumberToLetter.convertirLetras(Integer.parseInt(pesos))+" pesos. "+centavos+"/100 M.N.", 
    			FontFactory.getFont(FontFactory.HELVETICA, .4f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, cantidadLetra, posX+LetraX, posY+LetraY, 0);
    	
	}catch(IOException ioe){
		System.err.println("Error al generar la factura en PDF: "+ioe.getMessage());
	}
	
	document.close();
%>
<head>
	<meta http-equiv="REFRESH" content="0; url=facturaPDF.pdf">
</head>
<%@ include file= "../../cierra_elias.jsp" %>