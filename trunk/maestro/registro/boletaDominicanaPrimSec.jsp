<%@page import="aca.ciclo.CicloExtra"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TreeMap"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
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
<%@page import="aca.kardex.KrdxAlumFalta"%>
<%@page import="aca.catalogo.CatEscuela"%>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="planClase" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="curso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="cursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="alumnoCurso" scope="page" class="aca.vista.AlumnoCurso"/>
<jsp:useBean id="alumnoCursoLista" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="cursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="krdxAlumActitudL" scope="page" class="aca.kardex.KrdxAlumActitudLista"/>
<jsp:useBean id="krdxAlumFaltaL" scope="page" class="aca.kardex.KrdxAlumFaltaLista"/>
<jsp:useBean id="krdxAlumEvalL" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="catAspectos" scope="page" class="aca.catalogo.CatAspectos"/>
<jsp:useBean id="catAspectosU" scope="page" class="aca.catalogo.CatAspectosLista"/>
<jsp:useBean id="cicloPromedio" scope="page" class="aca.ciclo.CicloPromedio"/>
<jsp:useBean id="cicloPromedioU" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloExtra" scope="page" class="aca.ciclo.CicloExtra" />
<jsp:useBean id="cicloExtraL" scope="page" class="aca.ciclo.CicloExtraLista" />

<%

	String escuela		= (String)session.getAttribute("escuela");
	String cicloId 		= (String) session.getAttribute("cicloId");
	
	String cicloGrupoId	= request.getParameter("cicloGrupoId");
	
	String codigoAlumno = "";
	String plan			= "";
	String nivel		= "";
	String grado		= "";
	String grupo		= "";
	String fecha 		= new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
	String nombreDirector = aca.empleado.EmpPersonal.getDirectorEscuela(conElias, escuela);
	int borde 			= 0; 
	int numGrado 			= 0;	
	boolean hayAbiertas = CicloGrupoCurso.hayAbiertas(conElias, cicloGrupoId);
	
	ArrayList<String> lisAlum 			= cursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);	
	ArrayList<CicloBloque> lisBloque	= cicloBloqueL.getListCiclo(conElias, cicloGrupoId.substring(0,8), "ORDER BY BLOQUE_ID");
	ArrayList<CicloPromedio>  cicloPromedioList	= cicloPromedioU.getListCiclo(conElias, cicloId, " ORDER BY ORDEN");
	ArrayList <KrdxAlumFalta> listaKrdxAlumFalta = krdxAlumFaltaL.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'");
	ArrayList <CicloGrupoEval> listaCicloGrupoEval = cicloGrupoEvalLista.getEvalGrupo(conElias, cicloGrupoId, "ORDER BY CICLO_GRUPO_ID, ORDEN");
	ArrayList <CicloExtra> listaCicloExtra = cicloExtraL.getListCiclo(conElias, cicloId, "ORDER BY OPORTUNIDAD");
	
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
	TreeMap<String,KrdxAlumEval> treeEvalAlumno = krdxAlumEvalL.getTreeMateria(conElias, cicloGrupoId, "");
	

	
	
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
		
		Document document = new Document(PageSize.LETTER.rotate()); //Crea un objeto para el documento PDF
		// left, Right, top, bottom
		document.setMargins(25,25,20,20);
		
		try{
			//System.out.println(application.getRealPath());
			String dir = application.getRealPath("/maestro/registro/")+"/"+"boleta"+cicloGrupoId+".pdf";
			PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
			document.addAuthor("Sistema Escolar");
	        document.addSubject("Boleta de "+alumPersonal.getNombre());
			//HeaderFooter footer = new HeaderFooter(new Phrase("Nota: Cr=Creditos; HT=Hrs teóricas; HP=Hrs prácticas; Tipo= de nota[Ext=Extraordinaria; Conv=Convalidacion; TS=Título Suficiencia; CD=Calif. Diferida]; Edo=Estado", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD)), true);
	        //document.setFooter(footer);
	        document.open();
	        
	        for(int i = 0; i < lisAlum.size(); i++){
	        //for(int i = 0; i < 1; i++){
	        	codigoAlumno = (String) lisAlum.get(i);
	        	
	        	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
       			//java.util.HashMap<String, String> mapEvalSuma= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotas(conElias, codigoAlumno);
       			
		        alumPersonal.mapeaRegId(conElias, codigoAlumno);
				plan 				= Grupo.getPlanId();
				nivel 				= Grupo.getNivelId();
				grado 				= Grupo.getGrado();
				grupo 				= Grupo.getGrupo();
				
				planClase.mapeaRegId(conElias, plan);
				
				//System.out.println(plan);
				ArrayList<aca.plan.PlanCurso> lisCurso;
				lisCurso 			= cursoLista.getListCurso(conElias,plan,"AND GRADO = (SELECT GRADO FROM CICLO_GRUPO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') AND CURSO_ID IN (SELECT CURSO_ID FROM CICLO_GRUPO_CURSO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') ORDER BY GRADO, ORDEN");
				ArrayList lisAlumnoCurso = alumnoCursoLista.getListAll(conElias, escuela," AND CODIGO_ID = '"+codigoAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
				float wrapwidth[] = {100f};
				PdfPTable wrapTable = new PdfPTable(wrapwidth);
				wrapTable.getDefaultCell().setBorder(0);
				wrapTable.setWidthPercentage(100f);
				wrapTable.setKeepTogether(true);
				wrapTable.setSpacingBefore(30f);
				wrapTable.setSplitLate(false);
				
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
	            jpg.scaleAbsolute(60, 59);	            
	            
	            cell = new PdfPCell();
            	cell.addElement(jpg);
            	cell.setBorder(borde);
            	cell.setRowspan(5);
				topTable.addCell(cell);
								
				/* 
	             * Informacion del encabezado de cada boleta
	             */
					
				CatEscuela ce = new CatEscuela();
				ce.mapeaRegId(conElias, escuela);
	            
	            cell = new PdfPCell(new Phrase(ce.getEscuelaNombre().toUpperCase(), FontFactory.getFont(FontFactory.HELVETICA, 20, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setPaddingLeft(-60f);
				cell.setBorder(borde);
				topTable.addCell(cell);
				
				/*cell = new PdfPCell(new Phrase(ce.getDireccion()+", "+
									ce.getColonia()+", "+
									aca.catalogo.CatCiudad.getCiudad(conElias, ce.getPaisId(), ce.getEstadoId(), ce.getCiudadId())+ ", " +
									ce.getTelefono(), 
									FontFactory.getFont(FontFactory.COURIER_OBLIQUE, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(0);
				topTable.addCell(cell);*/
				
				cell = new PdfPCell(new Phrase(" ", 
						FontFactory.getFont(FontFactory.COURIER_OBLIQUE, 8, Font.NORMAL, new BaseColor(0,0,0))));
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setBorder(0);
	topTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase("RECORD DE NOTAS", FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setPaddingLeft(-60f);
				cell.setBorder(0);
				cell.setBorderColorBottom(BaseColor.BLACK);
				topTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(ciclo.getCicloNombre(), 
						FontFactory.getFont(FontFactory.COURIER_OBLIQUE, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setPaddingLeft(-60f);
				cell.setBorder(0);
				cell.setBorderColorBottom(BaseColor.BLACK);
				topTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(fecha, 
						FontFactory.getFont(FontFactory.COURIER_OBLIQUE, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell.setBorder(0);
				cell.setBorderColorBottom(BaseColor.BLACK);
				topTable.addCell(cell);
	            
            	/* 
	             * Agregar Tabla del encabezado
	             */
            	
	            //document.add(topTable);
            	wrapTable.addCell(topTable);
				
				float alumnoTableWidths[] = {33f, 34f, 33f};
				PdfPTable alumnoTable = new PdfPTable(alumnoTableWidths);
				alumnoTable.setWidthPercentage(80f);
				alumnoTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				alumnoTable.setSpacingAfter(5f);
				
 	            cell = new PdfPCell(new Phrase(" [ "+codigoAlumno+" ] "+alumPersonal.getNombre()+
 	            		" "+alumPersonal.getApaterno()+" "+alumPersonal.getAmaterno(), FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setColspan(3);
 				cell.setBorder(0);
 				alumnoTable.addCell(cell);
	            
	            cell = new PdfPCell(new Phrase(aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivel), 
	            		FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(0);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(Grupo.getGrado())), 
				                    FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(0);
				cell.setBorderColorTop(BaseColor.BLACK);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(Grupo.getGrupo(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(0);
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
            	
	            int cantidadTrimestres = lisBloque.size();
				
	            
	    		//int colsWidth[] = {3, 12, 25, 3, 3, 3, 3, 3, 5, 7, 5, 7, 3, 3, 3, 3, 3, 6};
	    		float colsWidth[] = new float[2+(cantidadTrimestres)+cicloPromedioList.size()+2];
	    		int cont = 0;
	    		colsWidth[cont++] = 3;//0
	    		colsWidth[cont++] = 43;//2
	    		for(int j = 0; j < cantidadTrimestres+cicloPromedioList.size(); j++){
	    			colsWidth[cont++] = 30/cantidadTrimestres;
	    		}
	    		colsWidth[cont++] = 9;
	    		colsWidth[cont++] = 9;
	    		/*for(int j = 0; j < cantidadTrimestres*2; j++){
	    			colsWidth[cont++] = 30/(cantidadTrimestres*2);
	    		}
	    		colsWidth[cont++] = 3;
	    		colsWidth[cont] = 3;*/
	    		
	    		//PdfPTable tabla = new PdfPTable(7+(lisBloque.size()*2));
	    		PdfPTable tabla = new PdfPTable(colsWidth);
	            tabla.setWidths(colsWidth);
	            tabla.setSpacingAfter((float)0);
	            tabla.setSpacingBefore((float)0);
	            
	            PdfPCell celda = null;
	            
	            int[] faltasPorEvaluacion = new int[cantidadTrimestres];
	            for(int j = 0; j < cantidadTrimestres; j++){
	            	faltasPorEvaluacion[j] = 0;
	            }
	            
	            int[] materiasSinNota = {0,0,0,0,0,0,0,0,0,0};
	            int[] materiasSinNotaIngles = {0,0,0,0,0,0,0,0,0,0};
	            
	    		int cantidadMaterias = 0;
	    		int materias =0;
	    		int materiasIngles =0;
	    		String oficial = "";
	    		numGrado = 0;
	    		
	    		//float[] sumaPorTrimestre = new float[cantidadTrimestres];
	    		//for(int j = 0; j < cantidadTrimestres; j++)
	    		//	sumaPorTrimestre[j]=0;
	    		
	    		float[] sumaPorTrimestreIngles = new float[cantidadTrimestres];
	    		for(int j = 0; j < cantidadTrimestres; j++)
	    			sumaPorTrimestreIngles[j]=0;
	    		
				ArrayList<aca.kardex.KrdxCursoAct> cursosAlumnoAct = cursoActLista.getLisCursosAlumno(conElias,codigoAlumno, cicloGrupoId," ORDER BY 1");
				for (int j=0; j < lisCurso.size(); j++){
	    			curso = (aca.plan.PlanCurso) lisCurso.get(j);
	    			boolean cursoEncontrado = false;
	    			for(aca.kardex.KrdxCursoAct act: cursosAlumnoAct){//VERIFICAR QUE EL CURSO(MATERIA) ESTE EN KRDX_CURSO_ACT
	    				if(act.getCursoId().equals(curso.getCursoId())){
	    					cursoEncontrado=true;
	    				}
	    			}
 			
	    			if(cursoEncontrado && curso.getBoleta().equals("S")){
						
	    				
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
		    				//if(alumnoCurso.getCursoId().equals(curso.getCursoId()) && cicloGrupoId.indexOf(alumnoCurso.getCicloId()) != -1){
		    				if(cicloGrupoId.indexOf(alumnoCurso.getCicloId()) != -1){
		    					
		    					if (Integer.parseInt(curso.getGrado()) != numGrado){
		    	    				numGrado = 	Integer.parseInt(curso.getGrado());
		    	    				oficial = "1";
		    	    				cantidadMaterias = 0;
		    	    				
		    	    				
		    	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
	    		 					for(CicloPromedio cp: cicloPromedioList){
	    								celda = new PdfPCell(new Phrase(cp.getNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
	    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    								celda.setColspan(cantidadTrimestres/2+1);
			    						celda.setBorder(Rectangle.BOX);
			    						tabla.addCell(celda);
	    							}
		    						
		    						celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("#", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(Rectangle.BOX);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("ASIGNATURAS", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(Rectangle.BOX);
		    						tabla.addCell(celda);
		    						
		    						for(CicloPromedio cp: cicloPromedioList){
		    							for(CicloBloque cb: lisBloque){
		    								if(cb.getPromedioId().equals(cp.getPromedioId())){
			    								celda = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					    						celda.setBorder(Rectangle.BOX);
					    						tabla.addCell(celda);
		    								}
		    							}
		    							celda = new PdfPCell(new Phrase("Final", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
	    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    						celda.setBorder(Rectangle.BOX);
			    						tabla.addCell(celda);
		    						}
		    						
		    						celda = new PdfPCell(new Phrase("Fin de Año", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(Rectangle.BOX);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("COMPLETIVA", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(Rectangle.BOX);
		    						tabla.addCell(celda);
		    						
		    						
		    						
		    						
		    	    			}
		    	    			
		    					
		    						   
		    					//---- Inician Materias ----
		    					
		    					celda = new PdfPCell(new Phrase(String.valueOf(materias+1), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    						celda.setBorder(2);
			    				tabla.addCell(celda);
			    				
			    				if(curso.getCursoBase().equals("-")){
				    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    						celda.setBorder(2);
				    				tabla.addCell(celda);
			    				}else{//Si es materia hija
			    					celda = new PdfPCell(new Phrase("   "+curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    						celda.setBorder(2);
				    				tabla.addCell(celda);
			    				}
			    				materias++;
			    				if(curso.getTipocursoId().equals("3"))
			    					materiasIngles++;
			    				
			    				
			    				float sumaFinales = 0f;
			    				int contEvaluaciones = 0;
			    				for(CicloPromedio cp: cicloPromedioList){
			    					float sumaNotas = 0f;
				    				int trimestresConNota = 0;
									int contador = 0;
									for(CicloGrupoEval cge: listaCicloGrupoEval){
										if(cge.getCicloGrupoId().equals(cicloGrupoId) &&
												cge.getCursoId().equals(curso.getCursoId()) &&
												cge.getPromedioId().equals(cp.getPromedioId())){
											
											String valor = "--";
											if(treeEvalAlumno.containsKey(cicloGrupoId+curso.getCursoId()+cge.getEvaluacionId()+codigoAlumno)){
												valor = treeEvalAlumno.get(cicloGrupoId+curso.getCursoId()+cge.getEvaluacionId()+codigoAlumno).getNota();
												sumaNotas += Float.parseFloat(valor);
												//sumaPorTrimestre[contador] += Float.parseFloat(valor);
												if(curso.getTipocursoId().equals("3"))
													sumaPorTrimestreIngles[contador] += Float.parseFloat(valor);
												valor = String.valueOf(frm.format(Double.parseDouble(valor)));
												if(Float.parseFloat(valor) == 0){
													valor ="--";
													materiasSinNota[contador]++;
													if(curso.getTipocursoId().equals("3")){
														materiasSinNotaIngles[contador]++;
													}
												}else{
													trimestresConNota++;
												}
											}else{
												materiasSinNota[contador]++;
												if(curso.getTipocursoId().equals("3")){
													materiasSinNotaIngles[contador]++;
												}
											}
											
											celda = new PdfPCell(new Phrase(valor, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
											celda.setHorizontalAlignment(Element.ALIGN_CENTER);
											celda.setBorder(2);
							 				tabla.addCell(celda);
							 				contador++;
							 				
							 				//Ciclo para faltas
							 				for(KrdxAlumFalta kaf: listaKrdxAlumFalta){
												if(kaf.getCodigoId().equals(codigoAlumno) && 
														kaf.getCursoId().equals(curso.getCursoId()) &&
														kaf.getEvaluacionId().equals(cge.getEvaluacionId())){
													faltasPorEvaluacion[contEvaluaciones] += Integer.valueOf(kaf.getFalta());
												}
											}
							 				contEvaluaciones++;
										}
									}
									
									String nota = "0";
			    					//System.out.println("float calculo = "+sumaNotas+"/"+trimestresConNota+";");
			    					float calculo = sumaNotas>0?sumaNotas/contador:0f;
			    					nota = String.valueOf(calculo);
			    					nota = frm.format(Double.parseDouble(nota));
									sumaFinales += Float.parseFloat(nota);
			    					
									celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD, new BaseColor(0,0,0))));
									celda.setHorizontalAlignment(Element.ALIGN_CENTER);
									celda.setBorder(2);
					 				tabla.addCell(celda);
			    				}
			    				
			    				/*boolean estanTodasCerradas = CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, alumnoCurso.getCursoId());
			    				
			    				if(!estanTodasCerradas){*/
			    					String nota = "0";
			    					//System.out.println("float calculo = "+sumaNotas+"/"+trimestresConNota+";");
			    					float calculo = sumaFinales>0?sumaFinales/2:0f;
			    					nota = String.valueOf(calculo);
			    					// Colocar formato con una decimal
			    					nota = frm.format(Double.parseDouble(nota));
			    					
			    					celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
				    				tabla.addCell(celda);
			    				/*}else{
			    					String nota = "0a";
			    					float calculo = sumaNotas>0?sumaNotas/cantidadTrimestres:0f;
			    					nota = String.valueOf(calculo);
			    					nota = frm3.format(Double.parseDouble(nota));
			    					celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
				    				tabla.addCell(celda);
			    				}*/
			    				
			    				celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    						celda.setBorder(2);
			    				tabla.addCell(celda);
			    		        
			    		        
			    		        /*if(ciclo.getNivelEval().equals("P")){
				 					for(int l = 0; l < cicloPromedioList.size(); l++){
										cicloPromedio = (CicloPromedio) cicloPromedioList.get(l);
										int faltas = 0, tardanzas = 0;
										//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
										for(KrdxAlumFalta kaf: listaKrdxAlumFalta){
											if(kaf.getCodigoId().equals(codigoAlumno) && 
													kaf.getCursoId().equals(curso.getCursoId()) &&
													kaf.getPromedioId().equals(cicloPromedio.getPromedioId())){
												faltas += Integer.valueOf(kaf.getFalta());
												tardanzas += Integer.valueOf(kaf.getTardanza());
											}
										}
										
										celda = new PdfPCell(new Phrase(String.valueOf(faltas), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
										celda.setHorizontalAlignment(Element.ALIGN_CENTER);
										celda.setBorder(0);
						 				tabla.addCell(celda);
						 				
						 				celda = new PdfPCell(new Phrase(String.valueOf(tardanzas), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
										celda.setHorizontalAlignment(Element.ALIGN_CENTER);
										celda.setBorder(0);
						 				tabla.addCell(celda);
									}
								}else if(ciclo.getNivelEval().equals("E")){
									//Aqui va el for para ciclo_grupo_eval ciclo_grupo_eval
									for(CicloGrupoEval cge: listaCicloGrupoEval){
										if(cge.getCicloGrupoId().equals(cicloGrupoId) &&
												cge.getCursoId().equals(curso.getCursoId())){
											int faltas = 0, tardanzas = 0;
											
											for(KrdxAlumFalta kaf: listaKrdxAlumFalta){
												if(kaf.getCodigoId().equals(codigoAlumno) && 
														kaf.getCursoId().equals(curso.getCursoId()) &&
														kaf.getEvaluacionId().equals(cge.getEvaluacionId())){
													faltas += Integer.valueOf(kaf.getFalta());
													tardanzas += Integer.valueOf(kaf.getTardanza());
												}
											}
											
											celda = new PdfPCell(new Phrase(String.valueOf(faltas), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
											celda.setHorizontalAlignment(Element.ALIGN_CENTER);
											celda.setBorder(0);
							 				tabla.addCell(celda);
							 				
							 				celda = new PdfPCell(new Phrase(String.valueOf(tardanzas), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
											celda.setHorizontalAlignment(Element.ALIGN_CENTER);
											celda.setBorder(0);
							 				tabla.addCell(celda);
										}
									}
								}
			    		        
			    		        int sumaFaltas = 0, sumaTardanzas = 0;
			    		        for(KrdxAlumFalta kaf: listaKrdxAlumFalta){
									if(kaf.getCodigoId().equals(codigoAlumno) && 
											kaf.getCursoId().equals(curso.getCursoId())){
										sumaFaltas += Integer.valueOf(kaf.getFalta());
										sumaTardanzas += Integer.valueOf(kaf.getTardanza());
									}
								}
			    		        if(sumaFaltas > 0){//Si la suma de faltas es mayor que cero
				    		 		celda = new PdfPCell(new Phrase(String.valueOf(sumaFaltas), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }
			    		        
			    		        if(sumaTardanzas > 0){//Si la suma de tardanzas es mayor que cero
				    		 		celda = new PdfPCell(new Phrase(String.valueOf(sumaTardanzas), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    		        }*/
			    		        
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
		    				/*celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
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
		    				tabla.addCell(celda);*/
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
	    			
	    			
	    			
	    			
	    		}
				
				/*celda = new PdfPCell(new Phrase("Promedio Acumulado", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				tabla.addCell(celda);*/
				

				wrapTable.addCell(tabla);
				
				
				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(0);
 				wrapTable.addCell(cell);
 				
 				
 				
 				float colsFaltasWidth[] = new float[1+cantidadTrimestres+4];
	    		int contFaltasWidth = 0;
	    		colsFaltasWidth[contFaltasWidth++] = 15f;
	    		for(int j = 0; j < cantidadTrimestres; j++){
	    			colsFaltasWidth[contFaltasWidth++] = 46/cantidadTrimestres;
	    		}
	    		colsFaltasWidth[contFaltasWidth++] = 8;
	    		colsFaltasWidth[contFaltasWidth++] = 8;
	    		colsFaltasWidth[contFaltasWidth++] = 8;
	    		colsFaltasWidth[contFaltasWidth++] = 15f;
	    		/*for(int j = 0; j < cantidadTrimestres*2; j++){
	    			colsWidth[cont++] = 30/(cantidadTrimestres*2);
	    		}
	    		colsWidth[cont++] = 3;
	    		colsWidth[cont] = 3;*/
	    		
	    		//PdfPTable tabla = new PdfPTable(7+(lisBloque.size()*2));
	    		PdfPTable tablaFaltas = new PdfPTable(colsFaltasWidth);
	    		//tablaFaltas.setWidths(colsFaltasWidth);
	    		tablaFaltas.setWidthPercentage(80f);
	    		tablaFaltas.setHorizontalAlignment(Element.ALIGN_CENTER);
	    		tablaFaltas.setSpacingAfter((float)0);
	    		tablaFaltas.setSpacingBefore((float)0);
	    		
	    		//Inicia la cabecera de faltas
	    		
	    		celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				tablaFaltas.addCell(celda);
				
				String meses[] = {"Sept.", "Oct.", "Nov.", "Dic.", "Ene.", "Febr.", "Marz.", "Abr.", "May.", "Jun." };
	    		
	    		for(int j = 0; j < cantidadTrimestres; j++){
	    			celda = new PdfPCell(new Phrase(meses[j], FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD, new BaseColor(0,0,0))));
    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					celda.setBorder(Rectangle.BOX);
					tablaFaltas.addCell(celda);
	    		}
 				
	    		celda = new PdfPCell(new Phrase("Total Aus.", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(Rectangle.BOX);
				tablaFaltas.addCell(celda);
 				
	    		celda = new PdfPCell(new Phrase("Total Asist.", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(Rectangle.BOX);
				tablaFaltas.addCell(celda);
 				
	    		celda = new PdfPCell(new Phrase("% Asistencias", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(Rectangle.BOX);
				tablaFaltas.addCell(celda);
 				
	    		celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				tablaFaltas.addCell(celda);
				
				//Inician los valores de las faltas
	    		
	    		celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				tablaFaltas.addCell(celda);
	    		
				int sumaFaltas = 0;
	    		for(int j = 0; j < cantidadTrimestres; j++){
	    			celda = new PdfPCell(new Phrase(String.valueOf(faltasPorEvaluacion[j]), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					celda.setBorder(Rectangle.BOX);
					tablaFaltas.addCell(celda);
					sumaFaltas += faltasPorEvaluacion[j];
	    		}
 				
	    		celda = new PdfPCell(new Phrase(String.valueOf(sumaFaltas), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(Rectangle.BOX);
				tablaFaltas.addCell(celda);
 				
				int asistencias = 199-sumaFaltas;
	    		celda = new PdfPCell(new Phrase(String.valueOf(asistencias), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(Rectangle.BOX);
				tablaFaltas.addCell(celda);
 				
	    		celda = new PdfPCell(new Phrase(String.valueOf((asistencias*100)/199)+"%", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(Rectangle.BOX);
				tablaFaltas.addCell(celda);
 				
	    		celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				tablaFaltas.addCell(celda);
				
				wrapTable.addCell(tablaFaltas);
 				
 				
 				/*
				*	Inicia nota al fondo de la boleta
				*
				*/
 				
 				float notesWidths[] = {100f};
				PdfPTable notesTable = new PdfPTable(notesWidths);
				notesTable.setWidthPercentage(80f);
				notesTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				notesTable.setSpacingAfter(5f);
				
				cell = new PdfPCell(new Phrase("OBSERVACIONES", 
						FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_TOP);
 				cell.setBorder(0);
 				notesTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_TOP);
 				cell.setBorder(2);
 				notesTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_TOP);
 				cell.setBorder(2);
 				notesTable.addCell(cell);
				
				wrapTable.addCell(notesTable);
				
				/*
				*	Inicia sección de Firmas
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
				
				
								

				float firmasWidths[] = {15f, 35f, 35f, 15f};
				PdfPTable t = new PdfPTable(firmasWidths);
				t.setWidthPercentage(80f);
				t.setHorizontalAlignment(Element.ALIGN_CENTER);
				t.setSpacingAfter(5f);
				

				celda = new PdfPCell(new Phrase("FIRMA DEL PADRE"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
	            celda.setRowspan(4);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("1era. _______________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("1era. _______________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("2da. ________________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("2da. ________________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("3era. _______________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("3era. _______________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("4ta. ________________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
	            
	            celda = new PdfPCell(new Phrase("4ta. ________________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	            celda.setColspan(4);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	            celda.setColspan(4);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	            celda.setColspan(4);
				celda.setBorder(0);
				t.addCell(celda);
										    
			    celda = new PdfPCell(new Phrase("_____________________________________________"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
			    celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    celda.setColspan(2);
			    celda.setBorder(0);
				t.addCell(celda);
			    
				celda = new PdfPCell(new Phrase("_____________________________________________"
				, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    celda.setColspan(2);
				celda.setBorder(0);
				t.addCell(celda);
										    
			    celda = new PdfPCell(new Phrase(aca.empleado.EmpPersonal.getNombre(conElias,Grupo.getEmpleadoId(),"NOMBRE")
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
			    celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    celda.setColspan(2);
			    celda.setBorder(0);
				t.addCell(celda);
			    
				
				celda = new PdfPCell(new Phrase(nombreDirector
				, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    celda.setColspan(2);
				celda.setBorder(0);
				t.addCell(celda);
				
				
				wrapTable.addCell(t);
				document.add(wrapTable);
	    		
	        }
		}catch(IOException ioe) {
			System.err.println("Error boleta en PDF: "+ioe.getMessage());
		}
			
		document.close();
%>
	<!--  head>
		<meta http-equiv='REFRESH' content='0; url=boleta<%=cicloGrupoId %>.pdf'>
	</head -->
	<iframe src="boleta<%=cicloGrupoId %>.pdf" style="position: absolute; top: 50px; width: 99%; height:93%;"></iframe>
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