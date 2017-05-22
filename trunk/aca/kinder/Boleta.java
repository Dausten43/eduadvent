package aca.kinder;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import aca.conecta.Conectar;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Boleta {
	
	
	
	
    public static final String DEST = "/Users/Daniel/Downloads/colored_border.pdf";

 
    public static void main(String[] args) throws IOException,
            DocumentException {
        File file = new File(DEST);
        file.getParentFile().mkdirs();
        new Boleta().createPdf(DEST);
    }
    
    
    
    public void createPdf(String dest) throws IOException, DocumentException {
        Document document = new Document(PageSize.LETTER, 25, 25, 20, 20);
        PdfWriter.getInstance(document, new FileOutputStream(dest));
        
        document.open();
        
        PdfPTable tabla = new PdfPTable(8);
        tabla.setWidths(new float[] { 1, 1, 13, 1, 1, 1, 3, 3 });
        tabla.setSplitLate(false);
        tabla.setWidthPercentage(100);
        
	    Image foto = Image.getInstance("aca/kinder/pingui.png");
	    foto.scaleToFit(80, 80);
	    Paragraph img = new Paragraph();
	    img.add(foto);
	    
	    //** CAMBIAR NOMBRE DE LOS FONTS PARA IDENTIFICARLOS MEJOR
	    //** O INCLUSO HAYAR LA FORMA DE NO TENER QUE CREAR TANTOS
        Font font = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
        Font font2 = new Font(FontFamily.HELVETICA, 8, Font.BOLD);
        Font font3 = new Font(FontFamily.HELVETICA, 6, Font.BOLD);
        Font font4 = new Font(FontFamily.HELVETICA, 10, Font.BOLD);
        
        Font fontTitleArea = new Font(FontFamily.HELVETICA, 8, Font.BOLD);
        Font fontCriterios = new Font(FontFamily.HELVETICA, 7);
        
        
        
        Paragraph para = new Paragraph("Colegio Adventista Bilingüe de Changuinola", font);
        para.setLeading(0, 1);
       	para.setAlignment(Element.ALIGN_CENTER);
       	para.setExtraParagraphSpace(5);
       	Paragraph para1 = new Paragraph("Boletín de Calificaciones", font);
       	para1.setAlignment(Element.ALIGN_CENTER);
       	para1.setExtraParagraphSpace(5);
       	Paragraph para2 = new Paragraph("2017", font);
       	para2.setAlignment(Element.ALIGN_CENTER);
       	para2.setExtraParagraphSpace(5);
   
       	
        PdfPCell cel = new PdfPCell();
        cel = new PdfPCell(img);
        cel.setPadding(5);
        cel.setColspan(2);
        cel.setBorderColorLeft(BaseColor.WHITE);
        tabla.addCell(cel);
        
        cel = new PdfPCell();
        cel.addElement(para);
        cel.addElement(para1);
        cel.addElement(para2);
        cel.setPaddingTop(13);
        cel.setColspan(6);
        cel.setBorderColorRight(BaseColor.WHITE);
        tabla.addCell(cel);
        
        PdfPCell cell1 = new PdfPCell(new Phrase("Estudiante:", font4));
        cell1.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell1.setColspan(3);
        tabla.addCell(cell1);
        
        PdfPCell cell2 = new PdfPCell(new Phrase("Consejera:", font4));
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell2.setColspan(5);
        tabla.addCell(cell2);
        
        PdfPCell cell3 = new PdfPCell(new Phrase("No. de cédula:", font4));
        cell3.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell3.setColspan(3);
        tabla.addCell(cell3);
        
        PdfPCell cell4 = new PdfPCell(new Phrase("Nivel:", font4));
        cell4.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell4.setColspan(5);
        tabla.addCell(cell4);
        
        //**********************Code Priscila ************************************************
        
        PdfPCell areas =new PdfPCell(new Phrase(String.format("Áreas")));
        areas.setRotation(90);
        areas.setVerticalAlignment(Element.ALIGN_MIDDLE);
        areas.setRowspan(3);
        tabla.addCell(areas);
        
        PdfPCell a1 =new PdfPCell(new Phrase(String.format("N°")));
        a1.setRowspan(3);
        tabla.addCell(a1);
        
        PdfPCell a2 =new PdfPCell(new Phrase(String.format("Criterios")));
        a2.setRowspan(3);
        tabla.addCell(a2);
       
        PdfPCell a3 =new PdfPCell(new Phrase(String.format("Calificaciones"), font4));
        a3.setColspan(3);
        tabla.addCell(a3);
       
        PdfPCell observaciones =new PdfPCell(new Phrase(String.format("Observaciones por Trimestre"), font4));
        observaciones.setRowspan(2);
        observaciones.setColspan(2);
        tabla.addCell(observaciones);
       
        PdfPCell a3_2 =new PdfPCell(new Phrase(String.format("Trimestres"), font4));
        a3_2.setColspan(3);
        tabla.addCell(a3_2);
       
     	PdfPCell a3_3_1 =new PdfPCell(new Phrase(String.format("I")));
     	a3_3_1.setHorizontalAlignment(Element.ALIGN_CENTER);
    	tabla.addCell(a3_3_1);
    	PdfPCell a3_3_2 =new PdfPCell(new Phrase(String.format("II")));
    	a3_3_2.setHorizontalAlignment(Element.ALIGN_CENTER);
      	tabla.addCell(a3_3_2);
        PdfPCell a3_3_3 =new PdfPCell(new Phrase(String.format("III")));
        a3_3_3.setHorizontalAlignment(Element.ALIGN_CENTER);
        tabla.addCell(a3_3_3);
            
       
        PdfPCell trimestre1 =new PdfPCell(new Phrase(String.format("Primer Trimestre"), font4));
       	//trimestre1.setRowspan(2);
       	trimestre1.setColspan(2);
       	tabla.addCell(trimestre1);
        
        //*****************************************************************
        
        
        PdfPCell cell;
        PdfPTable table = new PdfPTable(6);
        
        table.setWidths(new float[] {1, 1, 13, 1, 1, 1});
        table.setSplitLate(false);
        int cont = 1;
        int altura = 0;
        Map<String, List<Criterios>> mapAC = new LinkedHashMap<String, List<Criterios>>();
        mapAC.putAll(cosa());
        
        for(String g : mapAC.keySet()){
        	altura += mapAC.get(g).size();
        }
        System.out.println(altura);
        for(String g : mapAC.keySet()){
            cell = new PdfPCell(new Phrase(g, font4));
            cell.setRowspan(mapAC.get(g).size());
            if(altura < 35){
            	
            }else{
            	
            }
            
            cell.setRotation(90);
            cell.setPaddingBottom(20);
            cell.setHorizontalAlignment(Element.ALIGN_MIDDLE);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);
            for(Criterios d : mapAC.get(g)){
                cell = new PdfPCell(new Phrase(String.valueOf(cont), font2)); 
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell);
                table.addCell(new PdfPCell(new Phrase(d.getCriterio(),font2)));
                table.addCell("");
                table.addCell("");
                table.addCell("");
                cont++;
            }
        }
        PdfPCell blankspace = new PdfPCell();
        blankspace.setColspan(6);
        table.addCell(blankspace);
 
        PdfPCell sdfs = new PdfPCell(table);
        sdfs.setColspan(6);
        sdfs.setFixedHeight(560f);
        tabla.addCell(sdfs);
        
      //****************************************************************
        
        PdfPTable tableRight = new PdfPTable(2);
        tableRight.setSplitLate(false);
        Paragraph frase = new Paragraph("Fortalezas", font3);
        frase.setAlignment(Element.ALIGN_MIDDLE);
        PdfPCell fortalezas = new PdfPCell(frase);
        fortalezas.setFixedHeight(16f);
        PdfPCell ayudar = new PdfPCell(new Phrase("Así me pueden ayudar", font3));
        ayudar.setFixedHeight(16);
        
        PdfPCell espacio = new PdfPCell();
        espacio.setColspan(2);
        espacio.setFixedHeight(16f);
        PdfPCell espacio2 = new PdfPCell();
        espacio2.setFixedHeight(64f);
        
        tableRight.addCell(fortalezas);
        tableRight.addCell(ayudar);
        tableRight.addCell(espacio2);
        tableRight.addCell(espacio2);
        tableRight.addCell(espacio);
        tableRight.addCell(fortalezas);
        tableRight.addCell(ayudar);
        tableRight.addCell(espacio2);
        tableRight.addCell(espacio2);
        tableRight.addCell(espacio);
        tableRight.addCell(fortalezas);
        tableRight.addCell(ayudar);
        tableRight.addCell(espacio2);
        tableRight.addCell(espacio2);
        
        PdfPCell right = new PdfPCell(tableRight);
        right.setColspan(2);
        tabla.addCell(right);
        
        // ************************************************************
       	
       	PdfPTable tablaAsis = new PdfPTable(4);
       	tablaAsis.setWidths(new float[] {2, 1, 1, 1});
       	PdfPCell celda = new PdfPCell(new Phrase("Asistencias", font2));
       	//celda.setFixedHeight(16f);
       	celda.setColspan(4);
       	tablaAsis.addCell(celda);
       	for(int i = 0; i<4; i++){
       		PdfPCell zelda = new PdfPCell();
       		if(i==0){
       			zelda = new PdfPCell(new Phrase("Trimestre", font2));
       		}	
       		if(i==1){
       			zelda = new PdfPCell(new Phrase("I", font2));
       		}
       		if(i==2){
       			zelda = new PdfPCell(new Phrase("II", font2));
       		}
       		if(i==3){
       			zelda = new PdfPCell(new Phrase("III", font2));
       		}
       		zelda.setFixedHeight(16f);
       		tablaAsis.addCell(zelda);
       	}
       	celda = new PdfPCell(new Phrase("Ausencias", font2));
       	celda.setFixedHeight(16f);
       	tablaAsis.addCell(celda);
       	for(int i = 0; i<3; i++){
       		tablaAsis.addCell("");
       	}
       	celda = new PdfPCell(new Phrase("Tardanzas", font2));
       	celda.setFixedHeight(16f);
       	tablaAsis.addCell(celda);
       	for(int i = 0; i<3; i++){
       		tablaAsis.addCell("");
       	}
       	
       	PdfPCell asistencias = new PdfPCell(tablaAsis); 
       	
       	//******************************************************************
       	
       	Paragraph maestra = new Paragraph("Maestra", font);
        maestra.setAlignment(Element.ALIGN_CENTER);
        maestra.setExtraParagraphSpace(5);
       	Paragraph directora = new Paragraph("Directora", font);
       	directora.setAlignment(Element.ALIGN_CENTER);
       	directora.setExtraParagraphSpace(5);
       	Paragraph criteriosEvalTitle = new Paragraph("Criterio de Evaluación", font2);
       	criteriosEvalTitle.setAlignment(Element.ALIGN_CENTER);
       	criteriosEvalTitle.setExtraParagraphSpace(5);
       	Paragraph criteriosEval1 = new Paragraph("LHL Lo he logrado :D", font3);
       	//criteriosEval1.setAlignment(Element.ALIGN_CENTER);
       	Paragraph criteriosEval2 = new Paragraph("LEL Lo estoy logrando ;)", font3);
       	//criteriosEval2.setAlignment(Element.ALIGN_CENTER);
       	Paragraph criteriosEval3 = new Paragraph("LVL Lo voy a lograr :T", font3);
       	//criteriosEval3.setAlignment(Element.ALIGN_CENTER);
       	
       	PdfPTable tablaDin = new PdfPTable(1);
       	PdfPCell firmas = new PdfPCell();
       	PdfPCell criteriosEval = new PdfPCell();
       	//firmas.setFixedHeight(176f);
       	
       	asistencias.setColspan(2);
       	criteriosEval.setColspan(2);
       	
       	firmas.setPadding(5);
       	firmas.addElement(maestra);
        firmas.addElement(directora);
       		
        criteriosEval.addElement(criteriosEvalTitle);
        criteriosEval.addElement(criteriosEval1);
        criteriosEval.addElement(criteriosEval2);
        criteriosEval.addElement(criteriosEval3);
        
        tablaDin.addCell(asistencias);
        tablaDin.addCell(firmas);
       	tablaDin.addCell(criteriosEval);
       	
       	PdfPCell cellDin = new PdfPCell(tablaDin);
       	cellDin.setColspan(2);
       	tableRight.addCell(cellDin);
       	tabla.addCell("");
       	tabla.addCell("");
       	
       	//**************************************************************
       	
        document.add(tabla);
        document.close();
        System.out.println("*Document ready*");
    }
    
    public Map<String, List<Criterios>> cosa(){
    	Connection con = new Conectar().conEliasPostgres();
    	UtilAreas ua = new UtilAreas(con);
    	UtilCriterios uc = new UtilCriterios(con);
    	List<Areas> lsAreas = new ArrayList<Areas>();
    	List<Criterios> lsCriterios = new ArrayList<Criterios>();
    	try{
	    	lsAreas.addAll(ua.getLsAreas(0L, "", "H101717C", 1)); 
	    	lsCriterios.addAll(uc.getLsCriterios(0L, "", "H101717C", 0L, 1));
	    	con.close();
    	}catch(SQLException sqle ){
    		
    	}
    	
    	
        Map<String, List<Criterios>> salida = new LinkedHashMap<String, List<Criterios>>();
        for(Areas a : lsAreas){
        	List<Criterios> da = new ArrayList<Criterios>();
        	for(Criterios c : lsCriterios){
        		if(c.getArea_id().equals(a.getId()) && c.getEstado().equals(1)){
        			da.add(c);
        		}
        	}
        	salida.put(a.getArea(), da);
        }
        System.out.println(salida.size());
        
        
//        List<String> da = new ArrayList<String>();
//        da.add("g 1 d 1");
//        da.add("g 1 d 2");
//        da.add("g 1 d 3");
//        da.add("g 1 d 4");
//        da.add("g 1 d 5");
//        da.add("g 1 d 6");
//        salida.put("grupo 1", da);
//        
//        da = new ArrayList<String>();
//        da.add("g 2 d 1");
//        da.add("g 2 d 2");
//        da.add("g 2 d 3");
//        da.add("g 2 d 4");
//        da.add("g 2 d 5");
//        da.add("g 2 d 6");
//        da.add("g 2 d 7");
//        da.add("g 2 d 8");
//        da.add("g 2 d 3");
//        da.add("g 2 d 4");
//        da.add("g 2 d 5");
//        da.add("g 2 d 6");
//        da.add("g 2 d 7");
//        da.add("g 2 d 8");
//        da.add("g 2 d 3");
//        da.add("g 2 d 4");
//        da.add("g 2 d 5");
//        da.add("g 2 d 6");
//        da.add("g 2 d 7");
//        da.add("g 2 d 8");
//        salida.put("grupo 2", da);
//        
//        da = new ArrayList<String>();
//        da.add("g 3 d 1");
//        da.add("g 3 d 2");
//        da.add("g 3 d 3");
//        da.add("g 3 d 4");
//        da.add("g 3 d 5");
//        da.add("g 3 d 6");
//        da.add("g 3 d 7");
//        da.add("g 3 d 8");
//        da.add("g 3 d 9");
//        da.add("g 3 d 10");
//        da.add("g 3 d 11");
//        da.add("g 3 d 12");
//        da.add("g 3 d 13");
//        da.add("g 3 d 14");
//        da.add("g 3 d 15");
//        
//        salida.put("grupo 3", da);
//        
        return salida;
    }
}