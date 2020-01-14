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
<%@ page import = "com.itextpdf.text.pdf.events.*" %>

<%@page import="aca.vista.AlumnoCurso"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.ciclo.CicloGrupoEval"%>
<%@page import="aca.ciclo.CicloBloque"%>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="curso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="cursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="alumnoCurso" scope="page" class="aca.vista.AlumnoCurso"/>
<jsp:useBean id="alumnoCursoLista" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="cursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />

<%
	String escuela		= (String)session.getAttribute("escuela");
	String cicloId 		= (String) session.getAttribute("cicloId");
	
	String cicloGrupoId	= request.getParameter("cicloGrupoId");
	
	String codigoAlumno = "";	
	String plan			= "";
	String nivel		= "";
	String grado		= "";
	String grupo		= "";
	int borde 			= 0; 
	
	int numGrado 			= 0;	
	boolean hayAbiertas = CicloGrupoCurso.hayAbiertas(conElias, cicloGrupoId);
	
	ArrayList<String> lisAlum 			= cursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);	
	ArrayList<CicloBloque> lisBloque	= cicloBloqueL.getListCiclo(conElias, cicloGrupoId.substring(0,8), "ORDER BY BLOQUE_ID");
	
	java.text.DecimalFormat frm = new java.text.DecimalFormat("###,##0.0;(###,##0.0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	if(escala == 100){
		frm = new java.text.DecimalFormat("###,##0;(###,##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	}
	
	CatParametro.setEscuelaId(escuela);
	boolean firmaDirector = false;
	boolean firmaPadre	  = false;
	
	if(CatParametro.existeReg(conElias)){
		CatParametro.mapeaRegId(conElias, escuela);
		
		firmaDirector = CatParametro.getFirmaBoleta().equals("S") ? true : false;
		firmaPadre 	  = CatParametro.getFirmaPadre().equals("S") ? true : false;
		
	}
	
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	String subnivel = aca.catalogo.CatEsquemaLista.getSubNivel(conElias, escuela, Grupo.getNivelId(), Grupo.getGrado());
	if(!subnivel.equals("")){
		subnivel = "Ciclo: ["+subnivel+"] - ";
	}
	
	
	if(hayAbiertas){
%>
<head>
	<script type="text/javascript">
		alert("<fmt:message key="js.BoletasSinDatosFinales" />");
	</script>
</head>
<%
	}
	
	if (lisAlum.size() > 0){		
		
		Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
		// left, Right, top, bottom
		document.setMargins(25,25,20,20);
		
		try{
			//System.out.println(application.getRealPath());
			String dir = application.getRealPath("/maestro/registro/")+"/"+"boleta.pdf";
			PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
			document.addAuthor("Sistema Escolar");
	        document.addSubject("Boleta de "+alumPersonal.getNombre());
			//HeaderFooter footer = new HeaderFooter(new Phrase("Nota: Cr=Creditos; HT=Hrs teóricas; HP=Hrs prácticas; Tipo= de nota[Ext=Extraordinaria; Conv=Convalidacion; TS=Título Suficiencia; CD=Calif. Diferida]; Edo=Estado", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD)), true);
	        //document.setFooter(footer);
	        document.open();
	        
	        for(int i = 0; i < lisAlum.size(); i++){
	        	codigoAlumno = (String) lisAlum.get(i);
	        	
		        alumPersonal.mapeaRegId(conElias, codigoAlumno);
				plan 				= aca.alumno.AlumPlan.getPlanActual(conElias,codigoAlumno);
				nivel 				= String.valueOf(aca.alumno.AlumPlan.getNivelAlumno(conElias, codigoAlumno));
				grado 				= alumPersonal.getGrado();
				grupo 				= alumPersonal.getGrupo();
				
				ArrayList lisCurso 		= new ArrayList();
				lisCurso 			= cursoLista.getListCurso(conElias,plan,"AND GRADO = (SELECT GRADO FROM CICLO_GRUPO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') AND CURSO_ID IN (SELECT CURSO_ID FROM CICLO_GRUPO_CURSO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') ORDER BY GRADO, TIPOCURSO_ID, ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE");
				ArrayList lisAlumnoCurso = alumnoCursoLista.getListAll(conElias, escuela," AND CODIGO_ID = '"+codigoAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
				
				float wrapwidth[] = {100f};
				PdfPTable wrapTable = new PdfPTable(wrapwidth);
				wrapTable.getDefaultCell().setBorder(0);
				wrapTable.setWidthPercentage(100f);
				wrapTable.setKeepTogether(true);
				wrapTable.setSpacingBefore(30f);
				
				float headerwidths[] = {10f, 90f};
				PdfPTable topTable = new PdfPTable(headerwidths);
				topTable.setWidthPercentage(80f);
				topTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				topTable.setSpacingAfter(5f);
	            
	            
	            PdfPCell cell = null;
	            
	            /* 
	             * Agregar el logo de cada boleta
	             */
	            Image jpg = null;
	            
	            String dirFoto = application.getRealPath("/imagenes/")+"/logo"+escuela+".jpg";
	        	java.io.File foto = new java.io.File(dirFoto);
	        	if (foto.exists()){
	        		jpg = Image.getInstance(application.getRealPath("/imagenes/")+"/logo"+escuela+".jpg");	
	        	}else{
	        		jpg = Image.getInstance(application.getRealPath("/imagenes/")+"/logoIASD.png");
	        	}
	            
	            jpg.setAlignment(Image.LEFT | Image.UNDERLYING);
	            jpg.scaleAbsolute(50, 49);
	            
	            
	            cell = new PdfPCell();
            	cell.addElement(jpg);
            	cell.setBorder(borde);
            	cell.setRowspan(3);
				topTable.addCell(cell);
				
				
				/* 
	             * Informacion del encabezado de cada boleta
	             */
	            
	            cell = new PdfPCell(new Phrase(aca.catalogo.CatEscuela.getNombre(conElias, 
	            		escuela), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
 
	            cell = new PdfPCell(new Phrase("Alumno: [ "+codigoAlumno+" ] "+alumPersonal.getNombre()+
	            		" "+alumPersonal.getApaterno()+" "+alumPersonal.getAmaterno(), FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
	            
	            cell = new PdfPCell(new Phrase(subnivel+"Nivel: [ "+
	                    aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivel)+
	                    " ] - Grado: [ "+aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(grado))+
	                    " ] - Grupo: [ "+alumPersonal.getGrupo()+" ]", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
	           
				/*
            	if(hayAbiertas){
            		PdfGState gstate;
    		        gstate = new PdfGState();
    	            gstate.setFillOpacity(0.3f);
    	            gstate.setStrokeOpacity(0.3f);
            		
            		PdfContentByte cb = pdf.getDirectContent();
    	            cb.saveState();
    	            
    	            BaseFont helv;
    	            helv = BaseFont.createFont("Helvetica", BaseFont.WINANSI, false);
    	            
    	            cb.setGState(gstate);
    	            cb.setColorFill(BaseColor.LIGHT_GRAY);
    	            cb.beginText();
    	            cb.setFontAndSize(helv, 48);
    	            cb.showTextAligned(Element.ALIGN_CENTER, "Parcial", document.getPageSize().getWidth() / 2, document.getPageSize().getHeight() / 4, 45);
    	            cb.endText();
    	            cb.restoreState();
    	            
    	            cb.saveState();
    	            cb.setGState(gstate);
    	            cb.setColorFill(BaseColor.LIGHT_GRAY);
    	            cb.beginText();
    	            cb.setFontAndSize(helv, 48);
    	            cb.showTextAligned(Element.ALIGN_CENTER, "Parcial", document.getPageSize().getWidth() / 2, (document.getPageSize().getHeight() / 4)*3, 45);
    	            cb.endText();
    	            cb.restoreState();
            	}*/
	            
            	/* 
	             * Agregar Tabla del encabezado
	             */
            	
	            //document.add(topTable);
            	wrapTable.addCell(topTable);
	            
            	
	            PdfPTable tabla = new PdfPTable(5+(lisBloque.size()*2));
	            
	    		//int colsWidth[] = {3, 12, 25, 3, 3, 3, 3, 3, 5, 7, 5, 7, 3, 3, 3, 3, 3, 6};
	    		int colsWidth[] = new int[5+(lisBloque.size()*2)];
	    		int cont = 0;
	    		colsWidth[cont++] = 3;//0
	    		colsWidth[cont++] = 25;//2
	    		for(int j = 0; j < lisBloque.size(); j++){
	    			colsWidth[cont++] = 42/lisBloque.size();
	    		}
	    		colsWidth[cont++] = 5;
	    		colsWidth[cont++] = 7;
	    		for(int j = 0; j < lisBloque.size(); j++){
	    			colsWidth[cont++] = 30/lisBloque.size();
	    		}
	    		colsWidth[cont] = 6;
	            tabla.setWidths(colsWidth);
	            tabla.setSpacingAfter((float)0);
	            tabla.setSpacingBefore((float)0);
	            
	            
	            PdfPCell celda = null;
	            
	            int[] faltasPorBimestre = new int[10];
	            int[] materiasSinNota = {0,0,0,0,0,0,0,0,0,0};
	            
	    		int cantidadMaterias = 0;
	    		int materias =0;
	    		String oficial = "";
	    		numGrado = 0;
				ArrayList<aca.kardex.KrdxCursoAct> cursosAlumnoAct = cursoActLista.getLisCursosAlumno(conElias,codigoAlumno, cicloGrupoId," ORDER BY 1");
				for (int j=0; j < lisCurso.size(); j++){
	    			curso = (aca.plan.PlanCurso) lisCurso.get(j);
	    			boolean cursoEncontrado = false;
	    			for(aca.kardex.KrdxCursoAct act: cursosAlumnoAct){//VERIFICAR QUE EL CURSO(MATERIA) ESTE EN KRDX_CURSO_ACT
	    				if(act.getCursoId().equals(curso.getCursoId())){
	    					cursoEncontrado=true;
	    				}
	    			}
	    			if(cursoEncontrado){

		    			cantidadMaterias++;
		    			boolean encontro = false;
		    			for(int k = 0; k < lisAlumnoCurso.size(); k++){
		    				alumnoCurso = (AlumnoCurso) lisAlumnoCurso.get(k);
		    				if(alumnoCurso.getCursoId().equals(curso.getCursoId()) && cicloGrupoId.indexOf(alumnoCurso.getCicloId()) != -1){
		    					
		    					if (Integer.parseInt(curso.getGrado()) != numGrado){
		    	    				numGrado = 	Integer.parseInt(curso.getGrado());
		    	    				oficial = "1";
		    	    				cantidadMaterias = 0;
		    	    				
		    	    				faltasPorBimestre[0] = 0;
		    	    				faltasPorBimestre[1] = 0;
		    	    				faltasPorBimestre[2] = 0;
		    	    				faltasPorBimestre[3] = 0;
		    	    				faltasPorBimestre[4] = 0;
		    	    				faltasPorBimestre[5] = 0;
		    	    				faltasPorBimestre[6] = 0;
		    	    				faltasPorBimestre[7] = 0;
		    	    				faltasPorBimestre[8] = 0;
		    	    				faltasPorBimestre[9] = 0;
		    	    				
		    	    				//Esto es para desplegar cuando son notas y cuando faltas
		    	    				celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
	    							celda = new PdfPCell(new Phrase("Notas", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setColspan(lisBloque.size()+2);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("Faltas", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setColspan(lisBloque.size()+1);
		    						tabla.addCell(celda);
		    	    				//Termina indicacion de notas y faltas
		    						
		    						celda = new PdfPCell(new Phrase("#", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("Nombre Materia", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
		    						for(int l = 0; l < lisBloque.size(); l++){
		    							celda = new PdfPCell(new Phrase(String.valueOf(l+1), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    						tabla.addCell(celda);
									}
		    						celda = new PdfPCell(new Phrase("Nota", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("Fecha", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
		    						
		    						for(int l = 0; l < lisBloque.size(); l++){
			    						celda = new PdfPCell(new Phrase(String.valueOf(l+1), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    						tabla.addCell(celda);
									}
		    						celda = new PdfPCell(new Phrase("Tot.", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
		    	    			}	    					
		    						    					
		    									
		    					    					
		    					if(!alumnoCurso.getFalta1().equals("0")){
		    						faltasPorBimestre[0] += Float.parseFloat(alumnoCurso.getFalta1());
		    					}
		    					if(!alumnoCurso.getFalta2().equals("0")){
		    						faltasPorBimestre[1] += Float.parseFloat(alumnoCurso.getFalta2());
		    					}
		    					if(!alumnoCurso.getFalta3().equals("0")){
		    						faltasPorBimestre[2] += Float.parseFloat(alumnoCurso.getFalta3());
		    					}
		    					if(!alumnoCurso.getFalta4().equals("0")){
		    						faltasPorBimestre[3] += Float.parseFloat(alumnoCurso.getFalta4());
		    					}
		    					if(!alumnoCurso.getFalta5().equals("0")){
		    						faltasPorBimestre[4] += Float.parseFloat(alumnoCurso.getFalta5());
		    					}
		    					if(!alumnoCurso.getFalta6().equals("0")){
		    						faltasPorBimestre[5] += Float.parseFloat(alumnoCurso.getFalta5());
		    					}
		    					if(!alumnoCurso.getFalta7().equals("0")){
		    						faltasPorBimestre[6] += Float.parseFloat(alumnoCurso.getFalta5());
		    					}
		    					if(!alumnoCurso.getFalta8().equals("0")){
		    						faltasPorBimestre[7] += Float.parseFloat(alumnoCurso.getFalta5());
		    					}
		    					if(!alumnoCurso.getFalta9().equals("0")){
		    						faltasPorBimestre[8] += Float.parseFloat(alumnoCurso.getFalta5());
		    					}
		    					if(!alumnoCurso.getFalta10().equals("0")){
		    						faltasPorBimestre[9] += Float.parseFloat(alumnoCurso.getFalta5());
		    					}    					
		    					
		    					celda = new PdfPCell(new Phrase(String.valueOf(materias+1), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				tabla.addCell(celda);
			    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			    				tabla.addCell(celda);
			    				materias++;
			    				
			    				//Image img = Image.getInstance(application.getRealPath("/imagenes/")+"/logoIASD.png");
			    				//tabla.addCell(new PdfPCell(img, true));

			    				for(int l = 0; l < lisBloque.size(); l++){
			    					switch(l+1){
			    						case 1:{ 
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal1() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    		    			}break;
			    						case 2:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal2() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 3:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal3() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 4:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal4() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 5:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal5() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 6:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal6() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 7:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal7() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 8:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal8() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 9:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal9() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 10:{
			    							Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( alumnoCurso.getCal10() ) );
			    							img.scaleAbsolute(5,5);
			    							celda = new PdfPCell(img, false);
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
			    		    				tabla.addCell(celda);
			    						}break;
			    						
			    					}
			    				}

		    					String nota = alumnoCurso.getNota();
		    					if(nota!=null){
		    						nota=nota.trim();
		    					}else{
									nota = "-";
		    					}

		    					Image img = Image.getInstance( application.getRealPath("/imagenes/")+aca.catalogo.CatEsquema.getImagen( nota ) );
			    				img.scaleAbsolute(5,5);

		    					celda = new PdfPCell(img, false);
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
				    			tabla.addCell(celda);
			    				
			    		        
		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFNota(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				tabla.addCell(celda);
			    		       

			    		        for(int l = 0; l < lisBloque.size(); l++){
			    		        	switch(l+1){
			    		        		case 1:{
			    		        			if(alumnoCurso.getFalta1().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta1(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 2:{
			    		        			 if(alumnoCurso.getFalta2().equals("0")){
			    			    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				    				tabla.addCell(celda);
			    			    		        }else{
			    			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta2(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				    				tabla.addCell(celda);
			    			    		        }
			    		        		}break;
			    		        		case 3:{
			    		        			if(alumnoCurso.getFalta3().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta3(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 4:{
			    		        			if(alumnoCurso.getFalta4().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta4(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 5:{
			    		        			if(alumnoCurso.getFalta5().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta5(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 6:{
			    		        			if(alumnoCurso.getFalta6().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta6(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 7:{
			    		        			if(alumnoCurso.getFalta7().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta7(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
		
			    		        		case 8:{
			    		        			if(alumnoCurso.getFalta8().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta8(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
		
			    		        		case 9:{
			    		        			if(alumnoCurso.getFalta9().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta9(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
		
			    		        		case 10:{
			    		        			if(alumnoCurso.getFalta10().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta10(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
	
			    		        	}
			    		        }
			    		        if((Integer.parseInt(alumnoCurso.getFalta1()) + 
			    		           Integer.parseInt(alumnoCurso.getFalta2()) + 
			    		           Integer.parseInt(alumnoCurso.getFalta3()) + 
			    		           Integer.parseInt(alumnoCurso.getFalta4()) + 
			    		           Integer.parseInt(alumnoCurso.getFalta5())+
			    		           Integer.parseInt(alumnoCurso.getFalta6())+
			    		           Integer.parseInt(alumnoCurso.getFalta7())+
			    		           Integer.parseInt(alumnoCurso.getFalta8())+
			    		           Integer.parseInt(alumnoCurso.getFalta9())+
			    		           Integer.parseInt(alumnoCurso.getFalta10())) > 0){
				    		 		celda = new PdfPCell(new Phrase(String.valueOf(Integer.parseInt(alumnoCurso.getFalta1()) + 
						    		           Integer.parseInt(alumnoCurso.getFalta2()) + 
						    		           Integer.parseInt(alumnoCurso.getFalta3()) + 
						    		           Integer.parseInt(alumnoCurso.getFalta4()) + 
						    		           Integer.parseInt(alumnoCurso.getFalta5())+
						    		           Integer.parseInt(alumnoCurso.getFalta6())+
						    		           Integer.parseInt(alumnoCurso.getFalta7())+
						    		           Integer.parseInt(alumnoCurso.getFalta8())+
						    		           Integer.parseInt(alumnoCurso.getFalta9())+
						    		           Integer.parseInt(alumnoCurso.getFalta10())
						    		           ), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    		        }
			    		        
		    					k = lisAlumnoCurso.size();
		    					encontro = true;
		    				}
		    			}
		    			if(!encontro){
		    				celda = new PdfPCell(new Phrase(String.valueOf(j), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    				tabla.addCell(celda);
		    				for(int l = 0; l < lisBloque.size(); l++){
		    					celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				tabla.addCell(celda);
		    				}
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    				tabla.addCell(celda);
		    				for(int l = 0; l < lisBloque.size(); l++){
		    					celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				tabla.addCell(celda);
		    				}
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    				tabla.addCell(celda);
		    			}
		    			
		    			
	    			}
	    			
	    		}				
				
				String firma = "";
				int contFirmas = 0;
				boolean tablaVacia = false;
				
				if ((firmaDirector) || (firmaPadre)){					  
					if (firmaDirector){ firma = "Firma Director"; contFirmas++; }
					if (firmaPadre){ firma = "Firma Padre"; contFirmas++; }					  
				}else{
					contFirmas = 1;
					tablaVacia = true;
				}				
				
				PdfPTable t = new PdfPTable(contFirmas);
				
				if(contFirmas == 1 && tablaVacia==false){
					
					celda = new PdfPCell(new Phrase("_______________________________\n" + firma
							, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
					celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					celda.setBorder(0);
					t.addCell(celda);					
					
				}else if(contFirmas == 2){
										    
					    celda = new PdfPCell(new Phrase("_______________________________\nFirma Director"
								, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
					    celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					    celda.setBorder(0);
						t.addCell(celda);
					    
			            PdfPCell celda2 = null;
			            
			            celda2 = new PdfPCell(new Phrase("_______________________________\nFirma Padre"
								, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
			            celda2.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda2.setBorder(0);
						t.addCell(celda2);					
				}else if (tablaVacia){
					celda = new PdfPCell(new Phrase(" " + firma
							, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));					
					celda.setBorder(0);
					t.addCell(celda);
				}
				
				//document.add(tabla);	            	
				//document.add(t);
				wrapTable.addCell(tabla);
				wrapTable.addCell(t);
				document.add(wrapTable);
	    		
	        }
		}catch(IOException ioe) {
			System.err.println("Error boleta en PDF: "+ioe.getMessage());
		}
		
		document.close();
%>
	<head>
		<meta http-equiv='REFRESH' content='0; url=boleta.pdf'>
	</head>
<%
	}else{
%>
<body>
	<table width="100%">
		<tr>
			<td align="center"><font size="3" color="red"><b>No existe ningun alumno inscrito...</b></font></td>
		</tr>
	</table>
</body>
<%
	}
%>
<%@ include file = "../../cierra_elias.jsp"%>