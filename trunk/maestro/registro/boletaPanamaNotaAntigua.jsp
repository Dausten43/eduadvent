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
<%@page import="aca.ciclo.CicloPromedio"%>
<%@page import="aca.kardex.KrdxAlumActitud"%>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="curso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="cursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="alumnoCurso" scope="page" class="aca.vista.AlumnoCurso"/>
<jsp:useBean id="alumnoCursoLista" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="cursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="krdxAlumActitudL" scope="page" class="aca.kardex.KrdxAlumActitudLista"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="catAspectos" scope="page" class="aca.catalogo.CatAspectos"/>
<jsp:useBean id="catAspectosU" scope="page" class="aca.catalogo.CatAspectosLista"/>
<jsp:useBean id="cicloPromedio" scope="page" class="aca.ciclo.CicloPromedio"/>
<jsp:useBean id="cicloPromedioU" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>

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
	ArrayList<CicloPromedio>  cicloPromedioList	= cicloPromedioU.getListCiclo(conElias, cicloId, " ORDER BY ORDEN");
	
	ciclo.mapeaRegId(conElias, cicloId);
	
	java.text.DecimalFormat frm = new java.text.DecimalFormat("###,##0.0;(###,##0.0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frm1 = new java.text.DecimalFormat("###,##0.0;(###,##0.0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frm3 = new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	java.text.DecimalFormat frm4 = new java.text.DecimalFormat("###,##0.0000;(###,##0.0000)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	if(escala == 100){
		frm = new java.text.DecimalFormat("###,##0;(###,##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	}else{
		frm.setRoundingMode(java.math.RoundingMode.DOWN);	
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
	
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);
	

	
	
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
			//HeaderFooter footer = new HeaderFooter(new Phrase("Nota: Cr=Creditos; HT=Hrs te�ricas; HP=Hrs pr�cticas; Tipo= de nota[Ext=Extraordinaria; Conv=Convalidacion; TS=T�tulo Suficiencia; CD=Calif. Diferida]; Edo=Estado", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD)), true);
	        //document.setFooter(footer);
	        document.open();
	        
	        //for(int i = 0; i < lisAlum.size(); i++){
	        for(int i = 0; i < 1; i++){
	        	codigoAlumno = (String) lisAlum.get(i);
	        	
	        	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
       			java.util.HashMap<String, String> mapEvalSuma= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotas(conElias, codigoAlumno);
       			
		        alumPersonal.mapeaRegId(conElias, codigoAlumno);
				plan 				= Grupo.getPlanId();
				nivel 				= Grupo.getNivelId();
				grado 				= Grupo.getGrado();
				grupo 				= Grupo.getGrupo();
				
				ArrayList<aca.plan.PlanCurso> lisCurso;
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
	            String logoEscuela = aca.catalogo.CatEscuela.getLogo(conElias, escuela);
	            
	            String dirFoto = application.getRealPath("/imagenes/")+"/logos/"+ logoEscuela;
				java.io.File foto = new java.io.File(dirFoto);
        		if (foto.exists()){
        			jpg = Image.getInstance(application.getRealPath("/imagenes/")+"/logos/"+ logoEscuela);
        		}else{
        			jpg = Image.getInstance(application.getRealPath("/imagenes/")+"/logos/logoIASD.png");
        		}
	            //System.out.println("Ruta Boleta:"+dirFoto);
	            jpg.setAlignment(Image.LEFT | Image.UNDERLYING);
	            jpg.scaleAbsolute(50, 49);	            
	            
	            cell = new PdfPCell();
            	cell.addElement(jpg);
            	cell.setBorder(borde);
            	//cell.setRowspan(3);
				topTable.addCell(cell);
								
				/* 
	             * Informacion del encabezado de cada boleta
	             */
	            
	            cell = new PdfPCell(new Phrase(aca.catalogo.CatEscuela.getNombre(conElias, 
	            		escuela), FontFactory.getFont(FontFactory.COURIER_OBLIQUE, 12, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
				
				/*cell = new PdfPCell(new Phrase());
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(1);
				cell.setBorderColorBottom(BaseColor.BLACK);
				topTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase());
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(1);
				cell.setBorderColorBottom(BaseColor.BLACK);
				topTable.addCell(cell);*/
	            
            	/* 
	             * Agregar Tabla del encabezado
	             */
            	
	            //document.add(topTable);
            	wrapTable.addCell(topTable);
				
				float alumnoTableWidths[] = {10f, 40f, 16f, 34f};
				PdfPTable alumnoTable = new PdfPTable(alumnoTableWidths);
				alumnoTable.setWidthPercentage(80f);
				alumnoTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				alumnoTable.setSpacingAfter(5f);
 
				cell = new PdfPCell(new Phrase("NOMBRE: ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(1);
 				alumnoTable.addCell(cell);
				
 	            cell = new PdfPCell(new Phrase(" [ "+codigoAlumno+" ] "+alumPersonal.getNombre()+
 	            		" "+alumPersonal.getApaterno()+" "+alumPersonal.getAmaterno(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(1);
 				alumnoTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase("UBICACI�N: ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(1);
 				alumnoTable.addCell(cell);
	            
	            cell = new PdfPCell(new Phrase(subnivel+" "+
	                    aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivel)+
	                    " - Grado: [ "+aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(Grupo.getGrado()))+
	                    " "+Grupo.getGrupo()+" ]", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(1);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase("CEDULA : ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(2);
				cell.setBorderColorTop(BaseColor.BLACK);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(alumPersonal.getCurp(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(2);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase("ESPECIALIDAD : ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(2);
				cell.setBorderColorTop(BaseColor.BLACK);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase("Falta obtenerla de la BD", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(2);
				alumnoTable.addCell(cell);
				
				wrapTable.addCell(alumnoTable);
				
				cell = new PdfPCell(new Phrase());
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(0);
				cell.setBorderColorBottom(BaseColor.BLACK);
				wrapTable.addCell(cell);
	           
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
            	
	            int cantidadTrimestres = 0;
				if(ciclo.getNivelEval().equals("P")){
					cantidadTrimestres = cicloPromedioList.size();
				}else if(ciclo.getNivelEval().equals("E")){
					cantidadTrimestres = lisBloque.size();//Aqui falta poner la cantidad de trimestres basado en la tabla de ciclo_grupo_eval
				}
	            
	    		//int colsWidth[] = {3, 12, 25, 3, 3, 3, 3, 3, 5, 7, 5, 7, 3, 3, 3, 3, 3, 6};
	    		float colsWidth[] = new float[7+(cantidadTrimestres*2)];
	    		int cont = 0;
	    		colsWidth[cont++] = 3;//0
	    		colsWidth[cont++] = 25;//2
	    		for(int j = 0; j < cantidadTrimestres; j++){
	    			colsWidth[cont++] = 42/cantidadTrimestres;
	    		}
	    		colsWidth[cont++] = 5;
	    		colsWidth[cont++] = 7;
	    		colsWidth[cont++] = 5;
	    		colsWidth[cont++] = 7;
	    		for(int j = 0; j < cantidadTrimestres; j++){
	    			colsWidth[cont++] = 30/cantidadTrimestres;
	    		}
	    		colsWidth[cont] = 6;
	    		
	    		//PdfPTable tabla = new PdfPTable(7+(lisBloque.size()*2));
	    		PdfPTable tabla = new PdfPTable(colsWidth);
	            tabla.setWidths(colsWidth);
	            tabla.setSpacingAfter((float)0);
	            tabla.setSpacingBefore((float)0);
	            
	            PdfPCell celda = null;
	            
	            float[] sumaPorBimestre = new float[10];
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
		    				
		    				/* Darle formato a las calificaciones antes de hacer operaciones con ellas */
		    				alumnoCurso.setCal1( alumnoCurso.getCal1().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal1())) );
		    				alumnoCurso.setCal2( alumnoCurso.getCal2().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal2())) );
		    				alumnoCurso.setCal3( alumnoCurso.getCal3().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal3())) );
		    				alumnoCurso.setCal4( alumnoCurso.getCal4().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal4())) );
		    				alumnoCurso.setCal5( alumnoCurso.getCal5().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal5())) );
		    				alumnoCurso.setCal6( alumnoCurso.getCal6().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal6())) );
		    				alumnoCurso.setCal7( alumnoCurso.getCal7().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal7())) );
		    				alumnoCurso.setCal8( alumnoCurso.getCal8().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal8())) );
		    				alumnoCurso.setCal9( alumnoCurso.getCal9().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal9())) );
		    				alumnoCurso.setCal10( alumnoCurso.getCal10().equals("-")?"-":frm.format(Double.parseDouble(alumnoCurso.getCal10())) );
		    				
		    				//System.out.println("Paso 4.1:"+codigoAlumno+":"+curso.getCursoNombre()+":"+);
		    				if(alumnoCurso.getCursoId().equals(curso.getCursoId()) && cicloGrupoId.indexOf(alumnoCurso.getCicloId()) != -1){
		    					
		    					if (Integer.parseInt(curso.getGrado()) != numGrado){
		    	    				numGrado = 	Integer.parseInt(curso.getGrado());
		    	    				oficial = "1";
		    	    				cantidadMaterias = 0;
		    	    				sumaPorBimestre[0] = 0;
		    						sumaPorBimestre[1] = 0;
		    						sumaPorBimestre[2] = 0;
		    						sumaPorBimestre[3] = 0;
		    						sumaPorBimestre[4] = 0;
		    						sumaPorBimestre[5] = 0;
		    						sumaPorBimestre[6] = 0;
		    						sumaPorBimestre[7] = 0;
		    						sumaPorBimestre[8] = 0;
		    						sumaPorBimestre[9] = 0;
		    	    				
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
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
	    							celda = new PdfPCell(new Phrase("Calificaciones Trimestres", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan(cantidadTrimestres);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase());
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan(4);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("Ausencias-Tardanzas", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan(cantidadTrimestres+1);
		    						tabla.addCell(celda);
		    	    				//Termina indicacion de notas y faltas
		    						
		    						celda = new PdfPCell(new Phrase("#", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("Nombre Materia", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						
		    						if(ciclo.getNivelEval().equals("P")){
		    		 					for(CicloPromedio cp: cicloPromedioList){
		    								celda = new PdfPCell(new Phrase(cp.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}else if(ciclo.getNivelEval().equals("E")){
		    							for(CicloBloque cb: lisBloque){
		    								celda = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}
		    						
		    						celda = new PdfPCell(new Phrase("Nota", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("Fecha", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("Ext.", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("Fecha", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						
		    						if(ciclo.getNivelEval().equals("P")){
		    		 					for(CicloPromedio cp: cicloPromedioList){
		    								celda = new PdfPCell(new Phrase(cp.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}else if(ciclo.getNivelEval().equals("E")){
		    							for(CicloBloque cb: lisBloque){
		    								celda = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}
		    						
		    						celda = new PdfPCell(new Phrase("Tot.", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    	    			}	    					
		    						    					
		    	    			if(!oficial.equals(curso.getTipocursoId()) && curso.getTipocursoId().equals("2")){	//Promedios
		    	    				boolean todasTienenCalificacion = true;
		    	    				
		    	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	    				tabla.addCell(celda);
		    	    				celda = new PdfPCell(new Phrase("Promedio Oficial", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	    				tabla.addCell(celda);
		    	    				
		    	    				float[] sumaPorBimestreTmp = new float[10];
		    	    				for(int l = 0; l < lisBloque.size(); l++){
		    	    					float tmp = 0;
		    	    					if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
		    	    						tmp = sumaPorBimestre[l];
		    	    						int cantidadMateriasTmp = cantidadMaterias;
		    	    						cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
			    	    					sumaPorBimestre[l] = new BigDecimal(sumaPorBimestre[l]+"").divide(new BigDecimal(cantidadMateriasTmp+""), 1, RoundingMode.DOWN).floatValue();			    	    					
			    	    					celda = new PdfPCell(new Phrase( sumaPorBimestre[l]+"", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
			    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	        				tabla.addCell(celda);
			    	        				sumaPorBimestreTmp[l] = sumaPorBimestre[l]; 
			    	        				sumaPorBimestre[l]=tmp;
			    	    				}else{ 
			    	    					celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
			    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	        				tabla.addCell(celda);
			    	    					todasTienenCalificacion &= false;
			    	    				}
									}
		    	    		    	if(todasTienenCalificacion ){
		    	    		    		
		    	    		    		float notaDeTodas = 0;
		    	    		    		for(int l=0; l<lisBloque.size(); l++){
		    	    		    		//	System.out.println(sumaPorBimestreTmp[l]);
		    	    		    			notaDeTodas += sumaPorBimestreTmp[l];
		    	    		    		}
		    	    		    		/*System.out.println("Nota: "+notaDeTodas);
		    	    		    		if(lisBloque.size()!=0){
		    	    		    			notaDeTodas = new BigDecimal(notaDeTodas+"").divide(new BigDecimal(lisBloque.size()+""), 1, RoundingMode.DOWN).floatValue();
		    	    		    		}*/
		    	    		    		notaDeTodas = (notaDeTodas/lisBloque.size());
		    	    		    		celda = new PdfPCell(new Phrase( frm3.format(notaDeTodas), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	        				tabla.addCell(celda);
		    	    		    	}else{
		    	    		    		celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	        				tabla.addCell(celda);
		    	    		    	}
		    	    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	    				tabla.addCell(celda);
		    	    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	    				tabla.addCell(celda);
		    	    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	    				tabla.addCell(celda);
		    	   	    	    				
		    	    				for(int l = 0; l < lisBloque.size(); l++){
		    	    					if(faltasPorBimestre[l] > 0){
			    	    		    		celda = new PdfPCell(new Phrase(String.valueOf(faltasPorBimestre[l]), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    	    		    	}else{
			    		    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    	    		    	}
									}
		    	    				
		    	    				float sumaFaltasTodosLosBimestres = faltasPorBimestre[0]+faltasPorBimestre[1]+faltasPorBimestre[2]+faltasPorBimestre[3]+faltasPorBimestre[4]+faltasPorBimestre[5]+faltasPorBimestre[6]+faltasPorBimestre[7]+faltasPorBimestre[8]+faltasPorBimestre[9];
		        					if(sumaFaltasTodosLosBimestres > 0){
		    	    		    		celda = new PdfPCell(new Phrase(String.valueOf((int)sumaFaltasTodosLosBimestres), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    		    				tabla.addCell(celda);
		    	    		    	}else{
		    		    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    		    				tabla.addCell(celda);
		    	    		    	}
		        					oficial = curso.getTipocursoId();
		    	    			}
		    	    			
		    					int cantidadBimestres = 0;
		    					BigDecimal sumaBimestres = new BigDecimal("0");
		    					
		    					if(!alumnoCurso.getCal1().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal1()) );
		    						sumaPorBimestre[0] += Float.parseFloat(alumnoCurso.getCal1());
		    					}else{
		    						materiasSinNota[0] = materiasSinNota[0]+1;
		    					}
		    					if(!alumnoCurso.getCal2().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal2()) );
		    						sumaPorBimestre[1] += Float.parseFloat(alumnoCurso.getCal2());
		    					}else{
		    						materiasSinNota[1] = materiasSinNota[1]+1;
		    					}
		    					if(!alumnoCurso.getCal3().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal3()) );
		    						sumaPorBimestre[2] += Float.parseFloat(alumnoCurso.getCal3());
		    					}else{
		    						materiasSinNota[2] = materiasSinNota[2]+1;
		    					}
		    					if(!alumnoCurso.getCal4().equals("-")){
		    						cantidadBimestres++;
		    						//System.out.println("Datos:"+codigoAlumno+":"+alumnoCurso.getCal4());
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal4()) );
		    						sumaPorBimestre[3] += Float.parseFloat(alumnoCurso.getCal4());
		    					}else{
		    						materiasSinNota[3] = materiasSinNota[3]+1;
		    					}
		    					if(!alumnoCurso.getCal5().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal5()) );
		    						sumaPorBimestre[4] += Float.parseFloat(alumnoCurso.getCal5());
		    					}else{
		    						materiasSinNota[4] = materiasSinNota[4]+1;
		    					}
		    					
		    					if(!alumnoCurso.getCal6().equals("-")){
		    						cantidadBimestres++;	    							    
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal6()) );
		    						sumaPorBimestre[5] += Float.parseFloat(alumnoCurso.getCal6());
		    					}else{
		    						materiasSinNota[5] = materiasSinNota[5]+1;
		    					}
		    					
		    					if(!alumnoCurso.getCal7().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal7()) );
		    						sumaPorBimestre[6] += Float.parseFloat(alumnoCurso.getCal7());
		    					}else{
		    						materiasSinNota[6] = materiasSinNota[6]+1;
		    					}
		    					if(!alumnoCurso.getCal8().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal8()) );
		    						sumaPorBimestre[7] += Float.parseFloat(alumnoCurso.getCal8());
		    					}else{
		    						materiasSinNota[7] = materiasSinNota[7]+1;
		    					}    					
		    					if(!alumnoCurso.getCal9().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal9()) );
		    						sumaPorBimestre[8] += Float.parseFloat(alumnoCurso.getCal9());
		    					}else{
		    						materiasSinNota[8] = materiasSinNota[8]+1;
		    					}    					
		    					if(!alumnoCurso.getCal10().equals("-")){
		    						cantidadBimestres++;
		    						sumaBimestres = sumaBimestres.add( new BigDecimal(alumnoCurso.getCal10()) );
		    						sumaPorBimestre[9] += Float.parseFloat(alumnoCurso.getCal10());
		    					}else{
		    						materiasSinNota[9] = materiasSinNota[9]+1;
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
	    						celda.setBorder(0);
			    				tabla.addCell(celda);
			    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
	    						celda.setBorder(0);
			    				tabla.addCell(celda);
			    				materias++;
			    				//for(int l = 0; l < lisBloque.size(); l++){
			    				for(int l = 0; l < cantidadTrimestres; l++){
			    					
			    					switch(l+1){
			    						case 1:{
			    		    				celda = new PdfPCell(new Phrase(alumnoCurso.getCal1().equals("-")?"--": alumnoCurso.getCal1(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    		    			}break;
			    						case 2:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal2().equals("-")?"--": alumnoCurso.getCal2(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 3:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal3().equals("-")?"--": alumnoCurso.getCal3(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 4:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal4().equals("-")?"--": alumnoCurso.getCal4(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 5:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal5().equals("-")?"--": alumnoCurso.getCal5(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 6:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal6().equals("-")?"--": alumnoCurso.getCal6(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 7:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal7().equals("-")?"--": alumnoCurso.getCal7(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 8:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal8().equals("-")?"--": alumnoCurso.getCal8(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 9:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal9().equals("-")?"--": alumnoCurso.getCal9(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 10:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal10().equals("-")?"--": alumnoCurso.getCal10(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
			    		    				tabla.addCell(celda);
			    						}break;
			    						
			    					}
			    				}
			    				boolean estanTodasCerradas = CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, alumnoCurso.getCursoId());
			    				
			    				if(!estanTodasCerradas){
			    					String nota = "0";			    					
			    					if(cantidadBimestres!=0){
			    						if (mapPromAlumno.containsKey(alumnoCurso.getCodigoId()+alumnoCurso.getCursoId()+"1")){
			    							nota = mapPromAlumno.get( alumnoCurso.getCodigoId()+alumnoCurso.getCursoId()+"1" ).getNota();
			    							System.out.println("Cerradas"+nota);
				    					}			    						
			    					}
			    					
			    					// Colocar formato con una decimal
			    					nota = frm3.format(Double.parseDouble(nota));
			    					celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    				}else{
			    					String nota = mapPromAlumno.get( alumnoCurso.getCodigoId()+alumnoCurso.getCursoId()+"1" ).getNota(); // promedio de materia
			    					nota = nota.toString();
			    					nota = frm3.format(Double.parseDouble(nota));
			    					if(nota!=null){
			    						//nota=nota.trim();
			    					}
			    					System.out.println("Datos 2:"+nota);
			    					celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    				}
			    		        if(!estanTodasCerradas){
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFNota(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }
			    		        if(alumnoCurso.getNotaExtra() == null){//Si no tiene nota de extraordinario
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getNotaExtra().trim(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }
			    		        if(alumnoCurso.getFExtra() == null){//Si no tiene nota de extraordinario
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFExtra(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }
			    		        //for(int l = 0; l < lisBloque.size(); l++){
			    		        for(int l = 0; l < cantidadTrimestres; l++){
			    		        	switch(l+1){
			    		        		case 1:{
			    		        			if(alumnoCurso.getFalta1().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta1(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 2:{
			    		        			 if(alumnoCurso.getFalta2().equals("0")){
			    			    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    						celda.setBorder(0);
			    				    				tabla.addCell(celda);
			    			    		        }else{
			    			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta2(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    						celda.setBorder(0);
			    				    				tabla.addCell(celda);
			    			    		        }
			    		        		}break;
			    		        		case 3:{
			    		        			if(alumnoCurso.getFalta3().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta3(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 4:{
			    		        			if(alumnoCurso.getFalta4().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta4(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 5:{
			    		        			if(alumnoCurso.getFalta5().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta5(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 6:{
			    		        			if(alumnoCurso.getFalta6().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta6(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
			    		        		case 7:{
			    		        			if(alumnoCurso.getFalta7().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta7(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
		
			    		        		case 8:{
			    		        			if(alumnoCurso.getFalta8().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta8(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
		
			    		        		case 9:{
			    		        			if(alumnoCurso.getFalta9().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta9(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
		
			    		        		case 10:{
			    		        			if(alumnoCurso.getFalta10().equals("0")){
			    		    		        	celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }else{
			    		    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFalta10(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    	    						celda.setBorder(0);
			    			    				tabla.addCell(celda);
			    		    		        }
			    		        		}break;
	
			    		        	}
			    		        }
			    		        int sumaFaltas = (Integer.parseInt(alumnoCurso.getFalta1()) + 
					    		           Integer.parseInt(alumnoCurso.getFalta2()) + 
					    		           Integer.parseInt(alumnoCurso.getFalta3()) + 
					    		           Integer.parseInt(alumnoCurso.getFalta4()) + 
					    		           Integer.parseInt(alumnoCurso.getFalta5())+
					    		           Integer.parseInt(alumnoCurso.getFalta6())+
					    		           Integer.parseInt(alumnoCurso.getFalta7())+
					    		           Integer.parseInt(alumnoCurso.getFalta8())+
					    		           Integer.parseInt(alumnoCurso.getFalta9())+
					    		           Integer.parseInt(alumnoCurso.getFalta10()));
			    		        if(sumaFaltas > 0){//Si la suma de faltas es mayor que cero
				    		 		celda = new PdfPCell(new Phrase(String.valueOf(sumaFaltas), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }
			    		        
		    					k = lisAlumnoCurso.size();
		    					encontro = true;
		    				}
		    			}
		    			if(!encontro){
		    				celda = new PdfPCell(new Phrase(String.valueOf(j), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    						celda.setBorder(0);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
    						celda.setBorder(0);
		    				tabla.addCell(celda);
		    				//for(int l = 0; l < lisBloque.size(); l++){
		    				for(int l = 0; l < cantidadTrimestres; l++){
		    					celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    						celda.setBorder(0);
			    				tabla.addCell(celda);
		    				}
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    						celda.setBorder(0);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    						celda.setBorder(0);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    						celda.setBorder(0);
		    				tabla.addCell(celda);
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    						celda.setBorder(0);
		    				tabla.addCell(celda);
		    				//for(int l = 0; l < lisBloque.size(); l++){
		    				for(int l = 0; l < cantidadTrimestres; l++){
		    					celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    						celda.setBorder(0);
			    				tabla.addCell(celda);
		    				}
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    						celda.setBorder(0);
		    				tabla.addCell(celda);
		    			}
		    			
		    			
	    			}
	    			if(j==lisCurso.size()-1){	//Promedios
	    				boolean todasTienenCalificacion = true;
		    			
		    			celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
						celda.setColspan(7+(lisBloque.size()*2));
	    				tabla.addCell(celda);
	    				
	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("Promedio General", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
	    				tabla.addCell(celda);
	    				
	    				//for(int l = 0; l < lisBloque.size(); l++){
	    				for(int l = 0; l < cantidadTrimestres; l++){
	    					
	    					if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){
	    						int materiasTmp = materias;
	    						materiasTmp = materiasTmp-materiasSinNota[l];
	    						
    	    					sumaPorBimestre[l] = new BigDecimal(sumaPorBimestre[l]+"").divide(new BigDecimal(materiasTmp+""), 1, RoundingMode.DOWN).floatValue();
    	    					celda = new PdfPCell(new Phrase( sumaPorBimestre[l]+"", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(0);
    	        				tabla.addCell(celda);
    	    				}else{ 
    	    					celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(0);
    	        				tabla.addCell(celda);
    	    					todasTienenCalificacion &= false;
    	    				}
						}
	    				
	    		    	if(todasTienenCalificacion ){
	    		    		float notaDeTodas = 0;
	    		    		for(int l=0; l<cantidadTrimestres; l++){
	    		    			notaDeTodas += sumaPorBimestre[l];
	    		    		}
	    		    		/*if(lisBloque.size()!=0){
	    		    			notaDeTodas = new BigDecimal(notaDeTodas+"").divide(new BigDecimal(lisBloque.size()+""), 1, RoundingMode.DOWN).floatValue();
	    		    		}*/
	    		    		notaDeTodas = (notaDeTodas/cantidadTrimestres);
	    		    		celda = new PdfPCell(new Phrase( frm3.format(notaDeTodas), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(0);
	        				tabla.addCell(celda);
	    		    	}else{
	    		    		celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(0);
	        				tabla.addCell(celda);
	    		    	}
	    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
	    				tabla.addCell(celda);
	   	    	    				
	    				for(int l = 0; l < cantidadTrimestres; l++){
	    					if(faltasPorBimestre[l] > 0){
    	    		    		celda = new PdfPCell(new Phrase(String.valueOf(faltasPorBimestre[l]), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(0);
    		    				tabla.addCell(celda);
    	    		    	}else{
    		    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(0);
    		    				tabla.addCell(celda);
    	    		    	}
						}
	    				
	    				float sumaFaltasTodosLosBimestres = faltasPorBimestre[0]+faltasPorBimestre[1]+faltasPorBimestre[2]+faltasPorBimestre[3]+faltasPorBimestre[4]+faltasPorBimestre[5]+faltasPorBimestre[6]+faltasPorBimestre[7]+faltasPorBimestre[8]+faltasPorBimestre[9];
    					if(sumaFaltasTodosLosBimestres > 0){
	    		    		celda = new PdfPCell(new Phrase(String.valueOf((int)sumaFaltasTodosLosBimestres), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(0);
		    				tabla.addCell(celda);
	    		    	}else{
		    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(0);
		    				tabla.addCell(celda);
	    		    	}
    					oficial = curso.getTipocursoId();
	    			}
	    			//promedio acumulado
	    			
	    			if(j==lisCurso.size()-1){	//Promedios
	    				boolean todasTienenCalificacion = true;
	    				
	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("Promedio Acumulado", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
	    				tabla.addCell(celda);
	    				
	    				for(int l = 0; l < cantidadTrimestres; l++){
	    					
	    					if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){
	    						int materiasTmp = materias;
	    						materiasTmp = materiasTmp-materiasSinNota[l];
	    						
    	    					sumaPorBimestre[l] = new BigDecimal(sumaPorBimestre[l]+"").divide(new BigDecimal(materiasTmp+""), 1, RoundingMode.DOWN).floatValue();
    	    					celda = new PdfPCell(new Phrase( sumaPorBimestre[l]+"", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(2);
    	        				tabla.addCell(celda);
    	    				}else{ 
    	    					celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(2);
    	        				tabla.addCell(celda);
    	    					todasTienenCalificacion &= false;
    	    				}
						}
	    				
	    		    	if(todasTienenCalificacion ){
	    		    		float notaDeTodas = 0;
	    		    		for(int l=0; l<cantidadTrimestres; l++){
	    		    			notaDeTodas += sumaPorBimestre[l];
	    		    		}
	    		    		/*if(lisBloque.size()!=0){
	    		    			notaDeTodas = new BigDecimal(notaDeTodas+"").divide(new BigDecimal(lisBloque.size()+""), 1, RoundingMode.DOWN).floatValue();
	    		    		}*/
	    		    		notaDeTodas = (notaDeTodas/cantidadTrimestres);
	    		    		celda = new PdfPCell(new Phrase( frm4.format(notaDeTodas), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(2);
	        				tabla.addCell(celda);
	    		    	}else{
	    		    		celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(2);
	        				tabla.addCell(celda);
	    		    	}
	    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
	    				tabla.addCell(celda);
	   	    	    				
	    				for(int l = 0; l < cantidadTrimestres; l++){
	    					if(faltasPorBimestre[l] > 0){
    	    		    		celda = new PdfPCell(new Phrase(String.valueOf(faltasPorBimestre[l]), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(2);
    		    				tabla.addCell(celda);
    	    		    	}else{
    		    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(2);
    		    				tabla.addCell(celda);
    	    		    	}
						}
	    				
	    				float sumaFaltasTodosLosBimestres = faltasPorBimestre[0]+faltasPorBimestre[1]+faltasPorBimestre[2]+faltasPorBimestre[3]+faltasPorBimestre[4]+faltasPorBimestre[5]+faltasPorBimestre[6]+faltasPorBimestre[7]+faltasPorBimestre[8]+faltasPorBimestre[9];
    					if(sumaFaltasTodosLosBimestres > 0){
	    		    		celda = new PdfPCell(new Phrase(String.valueOf((int)sumaFaltasTodosLosBimestres), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(2);
		    				tabla.addCell(celda);
	    		    	}else{
		    		    	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							celda.setBorder(2);
		    				tabla.addCell(celda);
	    		    	}
    					oficial = curso.getTipocursoId();
	    			}
	    			
	    			
	    		}
				
				celda = new PdfPCell(new Phrase("Promedio Acumulado", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				tabla.addCell(celda);
				

				wrapTable.addCell(tabla);
				
				
				/*
				*	Inicia secci�n de Aspectos de Habitos y Actitudes
				*
				*/
				cantidadTrimestres = 0;
				if(ciclo.getNivelEval().equals("P")){
					cantidadTrimestres = cicloPromedioList.size();
				}else if(ciclo.getNivelEval().equals("E")){
					cantidadTrimestres = lisBloque.size();//Aqui falta poner la cantidad de trimestres basado en la tabla de ciclo_grupo_eval
				}
				
				float colsAspectosWidth[] = new float[2+(cantidadTrimestres)];
	    		cont = 0;
	    		colsAspectosWidth[cont++] = 30;//0
	    		for(int j = 0; j < cantidadTrimestres; j++){
	    			colsAspectosWidth[cont++] = 30/cantidadTrimestres;
	    		}
	    		colsAspectosWidth[cont++] = 40;
				
				PdfPTable aspectosTable = new PdfPTable(colsAspectosWidth);
				aspectosTable.setWidthPercentage(80f);
				aspectosTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				aspectosTable.setSpacingAfter(5f);
				
				cell = new PdfPCell(new Phrase("ASPECTOS DE HABITOS Y APTITUDES", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(0);
 				aspectosTable.addCell(cell);
 				
 				if(ciclo.getNivelEval().equals("P")){
 					System.out.println("ciclo.getNiveEval() = P");
 					for(int k = 0; k < cicloPromedioList.size(); k++){
						cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
						
						cell = new PdfPCell(new Phrase(cicloPromedio.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
		 				cell.setBorder(0);
		 				aspectosTable.addCell(cell);
					}
				}else if(ciclo.getNivelEval().equals("E")){
					System.out.println("ciclo.getNiveEval() = E");
					for(CicloBloque cb: lisBloque){
						cell = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
		 				cell.setBorder(0);
		 				aspectosTable.addCell(cell);
					}
				}
 				
	 				
 				
 				cell = new PdfPCell(new Phrase("OBSERVACIONES", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(0);
 				aspectosTable.addCell(cell);
 				
 				/*Vamos a buscar cuantas materias califican aspectos*/
 				int materiasConAspectos = 0;
 				ArrayList <aca.plan.PlanCurso> cursos = new ArrayList(); 
 				for(aca.plan.PlanCurso c: lisCurso){
 					if(c.getAspectos().equals("S")){
 						materiasConAspectos++;
 						curso = c;
 						cursos.add(c);
 					}
 				}
 				//System.out.println("krdxAlumActitudL.getListAspectosAlumno(conElias, "+codigoAlumno+", "+cicloGrupoId+", );");
				
 				ArrayList <aca.kardex.KrdxAlumActitud>listaKrdxAlumActitud = krdxAlumActitudL.getListAspectosAlumno(conElias, codigoAlumno, cicloGrupoId, "");
				ArrayList<aca.catalogo.CatAspectos> aspectosList	= catAspectosU.getListAspectos(conElias, escuela, nivel, "ORDER BY ORDEN");
				
				for(int j = 0; j < aspectosList.size(); j++){
					catAspectos = (aca.catalogo.CatAspectos) aspectosList.get(j);
					
					cell = new PdfPCell(new Phrase(catAspectos.getNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
	 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
	 				cell.setBorder(0);
	 				aspectosTable.addCell(cell);
					
					
						
						if(materiasConAspectos == 1){//Una sola materia
							System.out.println("una materia - materiasConAspectos = "+materiasConAspectos);
							if(ciclo.getNivelEval().equals("P")){
			 					for(int k = 0; k < cicloPromedioList.size(); k++){
									cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
									String valor = "-";
									for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
										//System.out.println(krdxAlumActitud.getAspectos());
										if(krdxAlumActitud.getCursoId().equals(curso.getCursoId()) && 
												krdxAlumActitud.getPromedioId().equals(cicloPromedio.getPromedioId()) &&
												krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
											valor = krdxAlumActitud.getNota();
											valor = valor.equals("1")?"X":valor;
											valor = valor.equals("2")?"R":valor;
											valor = valor.equals("3")?"S":valor;
											break;
										}
									}
									
									cell = new PdfPCell(new Phrase(valor, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}else if(ciclo.getNivelEval().equals("E")){
								//Aqui va el for para ciclo_grupo_eval ciclo_grupo_eval
								for(CicloBloque cb: lisBloque){
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
									String valor = "-";
									for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
										//System.out.println(krdxAlumActitud.getAspectos());
										if(krdxAlumActitud.getCursoId().equals(curso.getCursoId()) && 
												krdxAlumActitud.getPromedioId().equals(cb.getPromedioId()) &&
												krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
											valor = krdxAlumActitud.getNota();
											valor = valor.equals("1")?"X":valor;
											valor = valor.equals("2")?"R":valor;
											valor = valor.equals("3")?"S":valor;
											break;
										}
									}
									
									cell = new PdfPCell(new Phrase("-", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}
							
							
						}else if(materiasConAspectos > 1){//Mas de una materia para promediar
							System.out.println("muchas materias - materiasConAspectos = "+materiasConAspectos);
							if(ciclo.getNivelEval().equals("P")){
								for(int k = 0; k < cicloPromedioList.size(); k++){
									cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
									float valor = 0f;
									
									for(aca.plan.PlanCurso c: cursos){
										for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
											//System.out.println(krdxAlumActitud.getAspectos());
											if(krdxAlumActitud.getCursoId().equals(c.getCursoId()) && 
													krdxAlumActitud.getPromedioId().equals(cicloPromedio.getPromedioId()) &&
													krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
												valor += Float.parseFloat(krdxAlumActitud.getNota());
												break;
											}
										}
									}
									valor = valor/(float)cursos.size();
									
									cell = new PdfPCell(new Phrase(String.valueOf(valor), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}else if(ciclo.getNivelEval().equals("E")){
								//Aqui va el for para ciclo_grupo_eval ciclo_grupo_eval
								for(CicloBloque cb: lisBloque){
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
									float valor = 0f;
									
									for(aca.plan.PlanCurso c: cursos){
										for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
											//System.out.println(krdxAlumActitud.getAspectos());
											if(krdxAlumActitud.getCursoId().equals(c.getCursoId()) && 
													krdxAlumActitud.getPromedioId().equals(cb.getPromedioId()) &&
													krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
												valor += Float.parseFloat(krdxAlumActitud.getNota());
												break;
											}
										}
									}
									valor = valor/(float)cursos.size();
									
									cell = new PdfPCell(new Phrase(String.valueOf(valor), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}
						}else{//No hay ninguna materia con aspectos materiasConASpectos = 0
							System.out.println("sin materias - materiasConAspectos = "+materiasConAspectos);
							if(ciclo.getNivelEval().equals("P")){
								for(int k = 0; k < cicloPromedioList.size(); k++){
									cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
																		
									cell = new PdfPCell(new Phrase("-", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}else if(ciclo.getNivelEval().equals("E")){
								for(CicloBloque cb: lisBloque){
									cell = new PdfPCell(new Phrase("-", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}
						}
					
					
					cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
	 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
					cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
	 				cell.setBorder(0);
	 				aspectosTable.addCell(cell);
				}
				
				wrapTable.addCell(aspectosTable);
				
				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(2);
 				wrapTable.addCell(cell);
 				
 				/*
				*	Inicia nota al fondo de la boleta
				*
				*/
 				
 				float notesWidths[] = {50f, 50f};
				PdfPTable notesTable = new PdfPTable(notesWidths);
				notesTable.setWidthPercentage(80f);
				notesTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				notesTable.setSpacingAfter(5f);
				
				cell = new PdfPCell(new Phrase("La escala de calificaciones utilizada:"+
						"es de 1.0 a 5.0 que indica el progreso no apreciable o satisfactorio del estudiante", 
						FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_TOP);
 				cell.setBorder(0);
 				notesTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase("H�bitos y Aptitudes se califican as�\n"+
 						"S = Satisfactorio\n"+
 						"R = Regular\n"+
 						"X = No Satisfactorio", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_TOP);
 				cell.setBorder(0);
 				notesTable.addCell(cell);
				
				wrapTable.addCell(notesTable);
				
				/*
				*	Inicia secci�n de Firmas
				*
				*/
				
				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(0);
 				wrapTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(0);
 				wrapTable.addCell(cell);
				
				String firma = "";
				int contFirmas = 0;
				boolean tablaVacia = false;
				
				if ((firmaDirector) || (firmaPadre)){					  
					if (firmaDirector){ 
						firma = "Firma Director"; 
						contFirmas++; 
					}
					if (firmaPadre){
						firma = "Firma Padre";
						contFirmas++; 
					}
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