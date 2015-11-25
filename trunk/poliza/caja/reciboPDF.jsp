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
<jsp:useBean id="finML" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="Coordenada" scope="page" class="aca.fin.FinCoordenada"/>

<%
	String codigoEmpleado 	= (String) session.getAttribute("codigoEmpleado");
	String recibo 			= request.getParameter("Recibo");	
	String ejercicioId 		= (String)session.getAttribute("ejercicioId");	
	String polizaId 		= request.getParameter("polizaId");	
	String day				= "";
	String month			= "";
	String year				= "";
	Coordenada.mapeaRegId(conElias, codigoEmpleado, "R");
	
	String temp = "";
	
	temp="40,330";
	if(Coordenada.getCliente()!=null && !Coordenada.getCliente().equals("") ){temp=Coordenada.getCliente();}
	String [] cl = temp.split(",");		
	float ClienteX = Float.parseFloat(cl[0]);
	float ClienteY = Float.parseFloat(cl[1]);
	
	temp="40,310";
	if(Coordenada.getDomicilio()!=null && !Coordenada.getDomicilio().equals("")){temp=Coordenada.getDomicilio();}
	String [] dom = temp.split(",");
	float DomicilioX = Float.parseFloat(dom[0]);
	float DomicilioY = Float.parseFloat(dom[1]);
	
	temp="40,290";
	if(Coordenada.getRfc()!=null && !Coordenada.getRfc().equals("")){temp=Coordenada.getRfc();}
	String [] rf = temp.split(",");
	float RFCX = Float.parseFloat(rf[0]);
	float RFCY = Float.parseFloat(rf[1]);
	
	temp="40,270"; /* NO APARECEN EN EL PDF */
	if(Coordenada.getObservaciones()!=null && !Coordenada.getObservaciones().equals("")){temp=Coordenada.getObservaciones();}
	String [] obs = temp.split(",");
	float ObservacionesX = Float.parseFloat(obs[0]);
	float ObservacionesY = Float.parseFloat(obs[1]);
	
	temp="40,40";
	if(Coordenada.getLetra()!=null && !Coordenada.getLetra().equals("")){temp=Coordenada.getLetra();}
	String [] let = temp.split(",");
	float LetraX = Float.parseFloat(let[0]);
	float LetraY = Float.parseFloat(let[1]);
	
	temp="550,40";
	if(Coordenada.getTotal()!=null && !Coordenada.getTotal().equals("")){temp=Coordenada.getTotal();}
	String [] tot = temp.split(",");
	float TotalX = Float.parseFloat(tot[0]);
	float TotalY = Float.parseFloat(tot[1]);
	
	temp="40,250";
	if(Coordenada.getCodigo()!=null && !Coordenada.getCodigo().equals("")){temp=Coordenada.getCodigo();}
	String [] cod = temp.split(",");
	float CodigoX = Float.parseFloat(cod[0]);
	float CodigoY = Float.parseFloat(cod[1]);
	
	temp="130,250";
	if(Coordenada.getNombre()!=null && !Coordenada.getNombre().equals("")){temp=Coordenada.getNombre();}
	String [] nom = temp.split(",");
	float NombreX = Float.parseFloat(nom[0]);
	float NombreY = Float.parseFloat(nom[1]);
	
	temp="20,160"; /* NO APARECEN EN EL PDF */
	if(Coordenada.getConcepto()!=null && !Coordenada.getConcepto().equals("")){temp=Coordenada.getConcepto();}
	String [] con = temp.split(",");
	float ConceptoX = Float.parseFloat(con[0]);
	float ConceptoY = Float.parseFloat(con[1]);
	
	temp="550,250";
	if(Coordenada.getImporte()!=null && !Coordenada.getImporte().equals("")){temp=Coordenada.getImporte();}
	String [] imp = temp.split(",");
	float ImporteX = Float.parseFloat(imp[0]);
	float ImporteY = Float.parseFloat(imp[1]);
	
	temp="550,300";
	if(Coordenada.getFecha()!=null && !Coordenada.getFecha().equals("")){temp=Coordenada.getFecha();}
	String [] fec = temp.split(",");
	float FechaX = Float.parseFloat(fec[0]);
	float FechaY = Float.parseFloat(fec[1]);
	
	finRecibo.mapeaRegId(conElias, recibo, ejercicioId);
	day 			= finRecibo.getFecha().substring(0,2);
	month			= finRecibo.getFecha().substring(3,5);
	year 			= finRecibo.getFecha().substring(6,10);
		
	int posX 	= 0; 
	int posY	= 0;
	//int salto 	= 20; 
	Rectangle rec = new Rectangle(595, 396);
	Document document = new Document(rec ); //Crea un objeto para el documento PDF
	document.setMargins(-30,-30,40,20);
	
	try{
		String dir = application.getRealPath("/poliza/caja/")+"/"+"reciboPDF.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar");
        document.addSubject("Recibo de "+codigoEmpleado);       
        document.open(); 
        
        PdfContentByte canvas = pdf.getDirectContentUnder();
        
        Phrase cliente = new Phrase( finRecibo.getCliente(), FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, cliente, posX+ClienteX, posY+ClienteY, 0);
    	
    	Phrase domicilio = new Phrase( finRecibo.getDomicilio(), FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, domicilio, posX+DomicilioX, posY+DomicilioY, 0);
    	
    	Phrase rfc = new Phrase( finRecibo.getRfc(), FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, rfc, posX+RFCX, posY+RFCY, 0);
/*		
    	Phrase abajodomicilio = new Phrase( "DOMICILIO ABAJO", FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, abajodomicilio, posX+(DomicilioX-1.1f), posY+(DomicilioY-.8f), 0);
*/    	
    	    	
    	Phrase dia = new Phrase( day + "/" + month + "/" + year, FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, dia, posX+FechaX, posY+FechaY, 0);
    	
    	ArrayList lista = finML.getMovimientos(conElias,ejercicioId,polizaId,recibo,"");
		for( int i=0; i<lista.size(); i++){
			aca.fin.FinMovimientos movimientos= (aca.fin.FinMovimientos)lista.get(i);
	    	Phrase matricula = new Phrase( movimientos.getAuxiliar(), FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
	    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, matricula, posX+CodigoX, posY+CodigoY -(i*16f), 0);
	    	
	    	Phrase nombre = new Phrase( movimientos.getDescripcion(), FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
	    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, nombre, posX+NombreX, posY+NombreY -(i*16f), 0);
	    	    	
	    	Phrase cantidad = new Phrase( movimientos.getImporte(), FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
	    	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, cantidad, posX+ImporteX, posY+ImporteY -(i*16f), 0);
		}
		
		String totRec	= finRecibo.getImporte();
    	String pesos 	= "0";
    	String centavos	= "00"; 
    	
    	pesos 		= totRec.indexOf(".")>=0?totRec.substring(0,totRec.indexOf(".")):totRec;
    	centavos 	= totRec.indexOf(".")>=0?totRec.substring(totRec.indexOf(".")+1, totRec.length()):"00";
    	
    	Phrase cantidadLetra = new Phrase(  aca.util.NumberToLetter.convertirLetras(Integer.parseInt(pesos))+" pesos. "+centavos+" /100 M.N.", 
    			FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, cantidadLetra, posX+LetraX, posY+LetraY, 0);
    	
    	Phrase total = new Phrase( totRec, FontFactory.getFont(FontFactory.HELVETICA, 12f, Font.NORMAL, new BaseColor(0,0,0)) );   	
    	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, total, posX+TotalX, posY+TotalY, 0);
    	
	}catch(IOException ioe){
		System.err.println("Error al generar el recibo en PDF: "+ioe.getMessage());
	}
	
	document.close();
%>
<head>
	<meta http-equiv="REFRESH" content="0; url=reciboPDF.pdf">
</head>
<%@ include file= "../../cierra_elias.jsp" %>