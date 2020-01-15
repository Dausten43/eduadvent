<%-- <%@page import="javafx.scene.layout.Border"%> --%>
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
<%@page import="aca.kardex.UtilKrdxAlumObs"%>
<%@page import="aca.kardex.KrdxAlumObs"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
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

<%

	String escuela		= (String)session.getAttribute("escuela");
	String cicloId 		= (String) session.getAttribute("cicloId");
	
	String cicloGrupoId	= request.getParameter("cicloGrupoId");
	String unAlumno		= request.getParameter("unAlumno")==null?"":request.getParameter("unAlumno");
	
	String codigoAlumno = "";
	String plan			= "";
	String nivel		= "";
	String grado		= "";
	String grupo		= "";
	int borde 			= 0; 
	int numGrado 			= 0;	
	boolean hayAbiertas = CicloGrupoCurso.hayAbiertas(conElias, cicloGrupoId);
	
	ArrayList<String> lisAlum;
	if(unAlumno.equals("")){
		lisAlum 			= cursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);
	}else{
		lisAlum = new ArrayList<String>();
		lisAlum.add(unAlumno);
	}
	ArrayList<CicloBloque> lisBloque	= cicloBloqueL.getListCiclo(conElias, cicloGrupoId.substring(0,8), "ORDER BY BLOQUE_ID");
	ArrayList<CicloPromedio>  cicloPromedioList	= cicloPromedioU.getListCiclo(conElias, cicloId, " ORDER BY ORDEN");
	ArrayList <KrdxAlumFalta> listaKrdxAlumFalta = krdxAlumFaltaL.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'");
	ArrayList <CicloGrupoEval> listaCicloGrupoEval = cicloGrupoEvalLista.getEvalGrupo(conElias, cicloGrupoId, "ORDER BY CICLO_GRUPO_ID, ORDEN");
	ciclo.mapeaRegId(conElias, cicloId);
	
	//Traemos todas las observaciones del grupo
	UtilKrdxAlumObs uk = new UtilKrdxAlumObs(conElias);
	Map<String, KrdxAlumObs> mapObservaciones = new HashMap<String, KrdxAlumObs>();
	mapObservaciones.putAll(uk.getObservacionesComplexKey(0L, cicloGrupoId, "", 0));
	
	
	
	java.text.DecimalFormat frm = new java.text.DecimalFormat("###,##0.0;(###,##0.0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frm1 = new java.text.DecimalFormat("###,##0.0;(###,##0.0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frm3 = new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	java.text.DecimalFormat frm4 = new java.text.DecimalFormat("###,##0.0000;(###,##0.0000)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	java.math.MathContext mc = new java.math.MathContext(8,RoundingMode.HALF_UP);
	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	if(escala == 100){
		frm = new java.text.DecimalFormat("###,##0;(###,##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	}else{
		frm.setRoundingMode(java.math.RoundingMode.DOWN);	
	}
	if(ciclo.getRedondeo().equals("T")){//Si se trunca
		frm1.setRoundingMode(java.math.RoundingMode.DOWN);
		frm3.setRoundingMode(java.math.RoundingMode.DOWN);
		frm4.setRoundingMode(java.math.RoundingMode.DOWN);
	}else{//Si se redondea
		frm1.setRoundingMode(java.math.RoundingMode.HALF_UP);
		frm3.setRoundingMode(java.math.RoundingMode.HALF_UP);
		frm4.setRoundingMode(java.math.RoundingMode.HALF_UP);
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
		
		Document document = new Document(PageSize.LETTER); //Crea un objeto para el documento PDF
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
				ArrayList<aca.plan.PlanCurso> lisCurso 			= cursoLista.getListCurso(conElias,plan,"AND GRADO = (SELECT GRADO FROM CICLO_GRUPO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') AND CURSO_ID IN (SELECT CURSO_ID FROM CICLO_GRUPO_CURSO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') ORDER BY GRADO, ORDEN");
				ArrayList lisAlumnoCurso = alumnoCursoLista.getListAll(conElias, escuela," AND CODIGO_ID = '"+codigoAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
				float wrapwidth[] = {100f};
				PdfPTable wrapTable = new PdfPTable(wrapwidth);
				wrapTable.getDefaultCell().setBorder(0);
				wrapTable.setWidthPercentage(100f);
				wrapTable.setKeepTogether(true);
				wrapTable.setSpacingBefore(30f);
				wrapTable.setSplitLate(false);
				
				float headerwidths[] = {15f, 70f, 15f};
				PdfPTable topTable = new PdfPTable(headerwidths);
				topTable.setWidthPercentage(100f);
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
	            jpg.setAlignment(Element.ALIGN_CENTER);
	            jpg.scaleToFit(100f,62f);
	            
	            cell = new PdfPCell();
            	cell.setBorder(borde);
            	cell.setRowspan(4);
            	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            	cell.addElement(jpg);
				topTable.addCell(cell);
								
				/* 
	             * Informacion del pais del encabezado de cada boleta
	             */
	            
	            cell = new PdfPCell(new Phrase("REPÚBLICA DE PANAMÁ", FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
				
				/* 
	             * Agregar el logo de MEDUCA a cada boleta
	             */
	            jpg = null;
				jpg = Image.getInstance(application.getRealPath("/imagenes/")+"/logos/MEDUCA.png");
        		
	            jpg.setAlignment(Element.ALIGN_CENTER);
	            jpg.scaleAbsolute(60f, 60f);            
	            
	            cell = new PdfPCell();
            	cell.addElement(jpg);
            	cell.setBorder(borde);
            	cell.setRowspan(4);
            	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
				topTable.addCell(cell);

	            cell = new PdfPCell(new Phrase("MINISTERIO DE EDUCACIÓN", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
				
				/* 
	             * Informacion de la escuela del encabezado de cada boleta
	             */
					
				CatEscuela ce = new CatEscuela();
				ce.mapeaRegId(conElias, escuela);
				
	            cell = new PdfPCell(new Phrase(ce.getEscuelaNombre(), FontFactory.getFont(FontFactory.HELVETICA, 16, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(ce.getDireccion()+", "+
									ce.getColonia()+", "+
									aca.catalogo.CatCiudad.getCiudad(conElias, ce.getPaisId(), ce.getEstadoId(), ce.getCiudadId())+ ", " +
									ce.getTelefono(), 
									FontFactory.getFont(FontFactory.COURIER_OBLIQUE, 10, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
				
				/*cell = new PdfPCell(new Phrase("Informa Trimestral\t\t\t\t\t\t\t Año lec", FontFactory.getFont(FontFactory.HELVETICA, 16, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(1);
				cell.setBorderColorBottom(BaseColor.BLACK);
				cell.setColspan(3);
				topTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase());
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(1);
				cell.setBorderColorBottom(BaseColor.BLACK);
				cell.setColspan(3);
				topTable.addCell(cell);*/
	            
            	/* 
	             * Agregar Tabla del encabezado
	             */
            	
	            //document.add(topTable);
            	wrapTable.addCell(topTable);
				
				float alumnoTableWidths[] = {10f, 42f, 16f, 32f};
				PdfPTable alumnoTable = new PdfPTable(alumnoTableWidths);
				alumnoTable.setWidthPercentage(80f);
				alumnoTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				alumnoTable.setSpacingAfter(5f);
				
				cell = new PdfPCell(new Phrase("Informe Trimestral ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(0);
				cell.setColspan(2);
 				alumnoTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase("Año Lectivo: "+ciclo.getCicloEscolar(), FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(0);
				cell.setColspan(2);
 				alumnoTable.addCell(cell);
 
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
 				
 				cell = new PdfPCell(new Phrase("UBICACIÓN: ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(1);
 				alumnoTable.addCell(cell);
	            //System.out.println("Grado: " + Integer.parseInt(Grupo.getGrado()));
 				
	            cell = new PdfPCell(new Phrase(subnivel+" "+
	                    aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivel)+
	                    " - Grado: [ "+aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(Grupo.getGrado()))+
	                    " "+Grupo.getGrupo()+" ]", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(1);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase("CÉDULA : ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(2);
				cell.setBorderColorTop(BaseColor.BLACK);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(alumPersonal.getCurp(), FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(2);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase("ESPECIALIDAD : ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setBorder(2);
				cell.setBorderColorTop(BaseColor.BLACK);
				alumnoTable.addCell(cell);
				
				cell = new PdfPCell(new Phrase(planClase.getPlanNombre(), FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
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
	    		float colsWidth[] = new float[5+(cantidadTrimestres*3)];
	    		int cont = 0;
	    		colsWidth[cont++] = 3;//0
	    		colsWidth[cont++] = 27;//2
	    		for(int j = 0; j < cantidadTrimestres; j++){
	    			colsWidth[cont++] = 30/cantidadTrimestres;
	    		}
	    		colsWidth[cont++] = 8;
	    		for(int j = 0; j < cantidadTrimestres*2; j++){
	    			colsWidth[cont++] = 26/(cantidadTrimestres*2);
	    		}
	    		colsWidth[cont++] = 3;
	    		colsWidth[cont] = 3;
	    		
	    		//PdfPTable tabla = new PdfPTable(7+(lisBloque.size()*2));
	    		PdfPTable tabla = new PdfPTable(colsWidth);
	            tabla.setWidths(colsWidth);
	            tabla.setSpacingAfter((float)0);
	            tabla.setSpacingBefore((float)0);
	            
	            PdfPCell celda = null;
	            
	            BigDecimal[] sumaPorBimestre = new BigDecimal[10];
	            int[] faltasPorBimestre = new int[10];
	            int[] materiasSinNota = {0,0,0,0,0,0,0,0,0,0};
	            int[] materiasSinNotaIngles = {0,0,0,0,0,0,0,0,0,0};
	            
	    		int cantidadMaterias = 0;
	    		int materias =0;
	    		int materiasIngles =0;
	    		String oficial = "";
	    		numGrado = 0;
	    		
	    		BigDecimal[] sumaPorTrimestre = new BigDecimal[cantidadTrimestres];
	    		for(int j = 0; j < cantidadTrimestres; j++)
	    			sumaPorTrimestre[j]=new BigDecimal("0", mc);
	    		
	    		BigDecimal[] sumaPorTrimestreIngles = new BigDecimal[cantidadTrimestres];
	    		for(int j = 0; j < cantidadTrimestres; j++)
	    			sumaPorTrimestreIngles[j]= new BigDecimal("0", mc);
	    		
	    		BigDecimal[] sumaPorTrimestreInglesMadre = new BigDecimal[cantidadTrimestres];
	    		for(int j = 0; j < cantidadTrimestres; j++)
	    			sumaPorTrimestreInglesMadre[j]= new BigDecimal("0", mc);
	    		
				ArrayList<aca.kardex.KrdxCursoAct> cursosAlumnoAct = cursoActLista.getLisCursosAlumno(conElias,codigoAlumno, cicloGrupoId," ORDER BY 1");
	    		
	    		BigDecimal[] promedioPorMateria = new BigDecimal[lisCurso.size()];
	    		for (int j=0; j < lisCurso.size(); j++){
	    			promedioPorMateria[j] = new BigDecimal("0", mc);
	    		}
	    		
	    		String promedioDeIngles = "";
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
		    				
		    				if(cicloGrupoId.indexOf(alumnoCurso.getCicloId()) != -1){
		    					
		    					if (Integer.parseInt(curso.getGrado()) != numGrado){
		    	    				numGrado = 	Integer.parseInt(curso.getGrado());
		    	    				oficial = "1";
		    	    				cantidadMaterias = 0;
		    	    				sumaPorBimestre[0] = new BigDecimal("0", mc);
		    						sumaPorBimestre[1] = new BigDecimal("0", mc);
		    						sumaPorBimestre[2] = new BigDecimal("0", mc);
		    						sumaPorBimestre[3] = new BigDecimal("0", mc);
		    						sumaPorBimestre[4] = new BigDecimal("0", mc);
		    						sumaPorBimestre[5] = new BigDecimal("0", mc);
		    						sumaPorBimestre[6] = new BigDecimal("0", mc);
		    						sumaPorBimestre[7] = new BigDecimal("0", mc);
		    						sumaPorBimestre[8] = new BigDecimal("0", mc);
		    						sumaPorBimestre[9] = new BigDecimal("0", mc);
		    	    				
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
		    						
	    							celda = new PdfPCell(new Phrase("CALIFICACIONES", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan(cantidadTrimestres);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase());
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						//celda.setColspan(4);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("AUSENCIAS-TARDANZAS", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan((cantidadTrimestres*2));
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan(2);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
	    							celda = new PdfPCell(new Phrase("TRIMESTRES", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan(cantidadTrimestres);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("Prom", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						tabla.addCell(celda);
		    						
		    						if(ciclo.getNivelEval().equals("P")){
		    		 					for(CicloPromedio cp: cicloPromedioList){
		    								celda = new PdfPCell(new Phrase(cp.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    								celda.setColspan(2);
				    						celda.setBorder(0);
				    						tabla.addCell(celda);
		    							}
		    						}else if(ciclo.getNivelEval().equals("E")){
		    							for(CicloBloque cb: lisBloque){
		    								celda = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    								celda.setColspan(2);
				    						celda.setBorder(0);
				    						tabla.addCell(celda);
		    							}
		    						}
		    						
		    						celda = new PdfPCell(new Phrase("TOTAL", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
		    						celda.setColspan(2);
		    						tabla.addCell(celda);
		    	    				//Termina indicacion de notas y faltas
		    						
		    						celda = new PdfPCell(new Phrase("#", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("ASIGNATURAS", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						
		    						if(ciclo.getNivelEval().equals("P")){
		    		 					for(CicloPromedio cp: cicloPromedioList){
		    								celda = new PdfPCell(new Phrase(cp.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}else if(ciclo.getNivelEval().equals("E")){
		    							for(CicloBloque cb: lisBloque){
		    								celda = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}
		    						
		    						celda = new PdfPCell(new Phrase("Acum", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						
		    						if(ciclo.getNivelEval().equals("P")){
		    		 					for(CicloPromedio cp: cicloPromedioList){
		    								celda = new PdfPCell(new Phrase("A", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    								celda.setBorder(2);
				    						tabla.addCell(celda);
				    						
				    						celda = new PdfPCell(new Phrase("T", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    								celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}else if(ciclo.getNivelEval().equals("E")){
		    							for(CicloBloque cb: lisBloque){
		    								celda = new PdfPCell(new Phrase("A", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    								celda.setBorder(2);
				    						tabla.addCell(celda);
				    						
				    						celda = new PdfPCell(new Phrase("T", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    								celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    								celda.setBorder(2);
				    						tabla.addCell(celda);
		    							}
		    						}
		    						
		    						celda = new PdfPCell(new Phrase("A", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(2);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("T", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
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
		    	    				
		    	    				BigDecimal[] sumaPorBimestreTmp = new BigDecimal[10];
		    	    				for(int l = 0; l < lisBloque.size(); l++){
		    	    					BigDecimal tmp = new BigDecimal("0", mc);
		    	    					if(sumaPorBimestre[l].compareTo(BigDecimal.ZERO) > 0 && cantidadMaterias > 0){
		    	    						tmp = sumaPorBimestre[l];
		    	    						int cantidadMateriasTmp = cantidadMaterias;
		    	    						cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
			    	    					sumaPorBimestre[l] = sumaPorBimestre[l].divide(new BigDecimal(cantidadMateriasTmp+"", mc), 1, RoundingMode.DOWN);			    	    					
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
		    	    		    		
		    	    		    		BigDecimal notaDeTodas = new BigDecimal("0", mc);
		    	    		    		for(int l=0; l<lisBloque.size(); l++){
		    	    		    			notaDeTodas = notaDeTodas.add(sumaPorBimestreTmp[l], mc);
		    	    		    		}
		    	    		    		notaDeTodas = (notaDeTodas.divide(new BigDecimal(lisBloque.size(), mc), mc));
		    	    		    		celda = new PdfPCell(new Phrase( frm3.format(notaDeTodas), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	        				tabla.addCell(celda);
		    	    		    	}else{
		    	    		    		celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	        				tabla.addCell(celda);
		    	    		    	}
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
		    					BigDecimal sumaBimestres = new BigDecimal("0", mc);
		    					
		    									
		    						    					
		    					
			    				String espacioHija = "";
			    				if(curso.getCursoBase().equals("-")){
			    					celda = new PdfPCell(new Phrase(String.valueOf(materias+1), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    					
			    					materias++;
			    					
			    					celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    				}else{//Si es materia hija
			    					celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    					
				    				espacioHija = "";
			    					celda = new PdfPCell(new Phrase("   "+curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
			    				}
			    				
			    				if(curso.getTipocursoId().equals("3"))
			    					materiasIngles++;
			    				BigDecimal sumaNotas = new BigDecimal("0", mc);
			    				int trimestresConNota = 0;
			    				boolean esMateriaMadreDeIngles = aca.plan.PlanCursoLista.esMateriaMadreDeIngles(conElias, curso.getCursoId());
			    				if(ciclo.getNivelEval().equals("P")){
				 					for(int l = 0; l < cicloPromedioList.size(); l++){
										cicloPromedio = (CicloPromedio) cicloPromedioList.get(l);
										String valor = "--";
										
										boolean show = cicloPromedio.getPromedioId().equals(request.getParameter(cicloPromedio.getNombre()));

										if(mapPromAlumno.containsKey(codigoAlumno+curso.getCursoId()+cicloPromedio.getPromedioId()) && show){
											valor = mapPromAlumno.get(codigoAlumno+curso.getCursoId()+cicloPromedio.getPromedioId()).getNota();
											if(curso.getCursoBase().equals("-")){//Si es materia madre o materia sin hijas
												sumaPorTrimestre[l] = sumaPorTrimestre[l].add(new BigDecimal(valor, mc), mc);
												if(curso.getTipocursoId().equals("3"))//si es materia madre y es de Ingles
													sumaPorTrimestreInglesMadre[l] = new BigDecimal(valor, mc);
											}
											if(curso.getTipocursoId().equals("3"))
												sumaPorTrimestreIngles[l] = sumaPorTrimestreIngles[l].add(new BigDecimal(valor, mc), mc);
											valor = String.valueOf(frm.format(Double.parseDouble(valor)));
											sumaNotas = sumaNotas.add(new BigDecimal(valor, mc), mc);
											//System.out.println("Trimestre "+l+"; nota = "+valor);
											if(Float.parseFloat(valor) == 0){
												valor ="--";
												materiasSinNota[l]++;
												if(curso.getTipocursoId().equals("3")){
													materiasSinNotaIngles[l]++;
												}
												if(show)//si la nota es 0 pero se pidió que se calculara incluyendo este trimestre
													trimestresConNota++;
											}else{
												trimestresConNota++;
											}
										}else{
											materiasSinNota[l]++;
											if(curso.getTipocursoId().equals("3"))
												materiasSinNotaIngles[l]++;
										}
										

											celda = new PdfPCell(new Phrase(espacioHija+valor, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
											celda.setHorizontalAlignment(Element.ALIGN_CENTER);
											celda.setBorder(0);
							 				tabla.addCell(celda);

									}
								}else if(ciclo.getNivelEval().equals("E")){
									//Aqui va el for para ciclo_grupo_eval ciclo_grupo_eval
									int contador = 0;
									for(CicloGrupoEval cge: listaCicloGrupoEval){
										if(cge.getCicloGrupoId().equals(cicloGrupoId) &&
												cge.getCursoId().equals(curso.getCursoId())){
											String valor = "--";
											
											boolean show = cge.getEvaluacionId().equals(request.getParameter(cge.getEvaluacionNombre()));
											
											if(treeEvalAlumno.containsKey(cicloGrupoId+curso.getCursoId()+cge.getEvaluacionId()+codigoAlumno) && show){
												valor = treeEvalAlumno.get(cicloGrupoId+curso.getCursoId()+cge.getEvaluacionId()+codigoAlumno).getNota();
												if(curso.getCursoBase().equals("-")){//Si es materia madre o materia sin hijas
													sumaPorTrimestre[contador] = sumaPorTrimestre[contador].add(new BigDecimal(valor, mc), mc);
													if(curso.getTipocursoId().equals("3"))//si es materia madre y es de Ingles
														sumaPorTrimestreInglesMadre[contador] = new BigDecimal(valor, mc);
												}
												if(curso.getTipocursoId().equals("3"))
													sumaPorTrimestreIngles[contador] = sumaPorTrimestreIngles[contador].add(new BigDecimal(valor, mc), mc);
												valor = String.valueOf(frm.format(Double.parseDouble(valor)));
												sumaNotas = sumaNotas.add(new BigDecimal(valor, mc), mc);
												
												if(Float.parseFloat(valor) == 0){
													valor ="--";
													materiasSinNota[contador]++;
													if(curso.getTipocursoId().equals("3")){
														materiasSinNotaIngles[contador]++;
													}
													if(show)//si la nota es 0 pero se pidió que se calculara incluyendo este trimestre
														trimestresConNota++;
												}else{
													trimestresConNota++;
												}
											}else{
												materiasSinNota[contador]++;
												if(curso.getTipocursoId().equals("3")){
													materiasSinNotaIngles[contador]++;
												}
											}
											

												celda = new PdfPCell(new Phrase(espacioHija+valor, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
												celda.setHorizontalAlignment(Element.ALIGN_CENTER);
												celda.setBorder(0);
								 				tabla.addCell(celda);

											
											
							 				contador++;
										}
									}
								}
			    				
			    				
			    				String nota;
			    				
			    					nota = "0";
			    					BigDecimal calculo = new BigDecimal("0", mc);
			    					if(sumaNotas.compareTo(BigDecimal.ZERO) > 0){
			    						calculo = sumaNotas.divide(new BigDecimal(trimestresConNota, mc),mc);
			    					}
			    					nota = frm4.format(calculo);

			    				if(curso.getCursoBase().equals("-"))
			    					promedioPorMateria[j] = new BigDecimal(nota, mc);
			    				
			    				if(!curso.getCursoBase().equals("-")){//Si es materia hija
			    					celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
								}else{//Si es materia madre
									celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setBorder(0);
				    				tabla.addCell(celda);
				    				//si es materia madre de Ingles, guardamos su promedio acumulado para el promedio de Ingles
				    				if(curso.getTipocursoId().equals("3"))
				    					promedioDeIngles = nota;
								}
			    				
			    				int sumaFaltas = 0, sumaTardanzas = 0;
			    				int nivelAcademico = Integer.valueOf(ciclo.getNivelAcademicoSistema() == null ? "-1" : ciclo.getNivelAcademicoSistema());
			    				boolean desplegarPorMateria = nivelAcademico != 3; // Cualquiera menos primaria
			    				
			    		        if(ciclo.getNivelEval().equals("P")){
				 					for(int l = 0; l < cicloPromedioList.size(); l++){
										cicloPromedio = (CicloPromedio) cicloPromedioList.get(l);
										boolean show = cicloPromedio.getPromedioId().equals(request.getParameter(cicloPromedio.getNombre()));
																				
										if(show){
											celda = new PdfPCell();
						    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
										
											String faltas = "";
						    		        String tardanzas = "";
						    		        
						    		        if(desplegarPorMateria){
						    		        	faltas = faltas.equals("") ? "0" : faltas;
												tardanzas = tardanzas.equals("") ? "0" : tardanzas;
												for(KrdxAlumFalta kaf: listaKrdxAlumFalta){
													if(kaf.getCodigoId().equals(codigoAlumno) && 
															kaf.getCursoId().equals(curso.getCursoId()) &&
															kaf.getPromedioId().equals(cicloPromedio.getPromedioId())){
														faltas = String.valueOf(Integer.valueOf(faltas) + Integer.valueOf(kaf.getFalta()));
														tardanzas = String.valueOf(Integer.valueOf(tardanzas) + Integer.valueOf(kaf.getTardanza()));
														sumaFaltas += Integer.valueOf(kaf.getFalta());
														sumaTardanzas += Integer.valueOf(kaf.getTardanza());
													}
												}
											} else if(cantidadMaterias == 0){
												faltas = KrdxAlumFalta.faltasPorPromedioId(conElias, codigoAlumno, cicloGrupoId, cicloPromedio.getPromedioId());
							    		        tardanzas = KrdxAlumFalta.tardanzasPorPromedioId(conElias, codigoAlumno, cicloGrupoId, cicloPromedio.getPromedioId());
											}
											
											celda.setPhrase(new Phrase(faltas.equals("0") && desplegarPorMateria ? "---" : faltas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
						    				tabla.addCell(celda);
						    				
						    				celda.setPhrase(new Phrase(tardanzas.equals("0") && desplegarPorMateria ? "---" : tardanzas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
						    				tabla.addCell(celda);
										}else {
					    		        	celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
						    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    						celda.setBorder(0);
						    				tabla.addCell(celda);
						    				tabla.addCell(celda);
				    		        	}
									}
				 					
				 					String totalFaltas = "";
				    		        String totalTardanzas = "";
				    		        
				    		        if(desplegarPorMateria){
				    		        	totalFaltas = String.valueOf(sumaFaltas);
				    		        	totalTardanzas = String.valueOf(sumaTardanzas);
				    		        
						    		 	celda.setPhrase(new Phrase(totalFaltas.equals("0") ? "---" : totalFaltas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
						    			tabla.addCell(celda);
						    		 	
						    			celda.setPhrase(new Phrase(totalTardanzas.equals("0") ? "---" : totalTardanzas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
										
					    		        tabla.addCell(celda);
				    		        } else if(cantidadMaterias == 0){
				    		        	totalFaltas = KrdxAlumFalta.totalfaltasPromedio(conElias, codigoAlumno, cicloGrupoId);
					    		        totalTardanzas = KrdxAlumFalta.totalTardanzasPromedio(conElias, codigoAlumno, cicloGrupoId);
			    						
			    						celda.setPhrase(new Phrase(totalFaltas == null ? "---" : totalFaltas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					    				tabla.addCell(celda);
					    				
					    				celda.setPhrase(new Phrase(totalTardanzas == null ? "---" : totalTardanzas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					    				tabla.addCell(celda);
				    		        }else {
				    		        	celda.setPhrase(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					    				tabla.addCell(celda);
					    				tabla.addCell(celda);
				    		        }
								}else if(ciclo.getNivelEval().equals("E")){
									//Aqui va el for para ciclo_grupo_eval ciclo_grupo_eval
									for(CicloGrupoEval cge: listaCicloGrupoEval){
										if(cge.getCicloGrupoId().equals(cicloGrupoId) &&
												cge.getCursoId().equals(curso.getCursoId())){
											
											boolean show = cge.getEvaluacionId().equals(request.getParameter(cge.getEvaluacionNombre()));
											
											if(show){
												celda = new PdfPCell();
							    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					    						celda.setBorder(0);
											
												String faltas = "";
							    		        String tardanzas = "";
											
							    		        if(desplegarPorMateria){
							    		        	faltas = faltas.equals("") ? "0" : faltas;
													tardanzas = tardanzas.equals("") ? "0" : tardanzas;
													for(KrdxAlumFalta kaf: listaKrdxAlumFalta){
														if(kaf.getCodigoId().equals(codigoAlumno) && 
																kaf.getCursoId().equals(curso.getCursoId()) &&
																kaf.getEvaluacionId().equals(cge.getEvaluacionId())){
															faltas = String.valueOf(Integer.valueOf(faltas) + Integer.valueOf(kaf.getFalta()));
															tardanzas = String.valueOf(Integer.valueOf(tardanzas) + Integer.valueOf(kaf.getTardanza()));
															sumaFaltas += Integer.valueOf(kaf.getFalta());
															sumaTardanzas += Integer.valueOf(kaf.getTardanza());
														}
													}
												} else if(cantidadMaterias == 0){
													faltas = KrdxAlumFalta.faltasPorCiclo(conElias, codigoAlumno, cicloGrupoId, cge.getEvaluacionId());
								    		        tardanzas = KrdxAlumFalta.tardanzasPorCiclo(conElias, codigoAlumno, cicloGrupoId, cge.getEvaluacionId());
												}
												
												celda.setPhrase(new Phrase(faltas.equals("0") && desplegarPorMateria ? "---" : faltas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
							    				tabla.addCell(celda);
							    				
							    				celda.setPhrase(new Phrase(tardanzas.equals("0") && desplegarPorMateria ? "---" : tardanzas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
							    				tabla.addCell(celda);
											}else {
						    		        	celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
							    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					    						celda.setBorder(0);
							    				tabla.addCell(celda);
							    				tabla.addCell(celda);
					    		        	}
										}
									}
									
									String totalFaltas = "";
				    		        String totalTardanzas = "";
				    		        
				    		        if(desplegarPorMateria){
				    		        	totalFaltas = String.valueOf(sumaFaltas);
				    		        	totalTardanzas = String.valueOf(sumaTardanzas);
				    		        
						    		 	celda.setPhrase(new Phrase(totalFaltas.equals("0") ? "---" : totalFaltas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
						    			tabla.addCell(celda);
						    		 	
						    			celda.setPhrase(new Phrase(totalTardanzas.equals("0") ? "---" : totalTardanzas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
										
					    		        tabla.addCell(celda);
				    		        } else if(cantidadMaterias == 0){
				    		        	totalFaltas = KrdxAlumFalta.totalfaltasEvaluacion(conElias, codigoAlumno, cicloGrupoId);
					    		        totalTardanzas = KrdxAlumFalta.totalTardanzasEvaluacion(conElias, codigoAlumno, cicloGrupoId);
			    						
			    						celda.setPhrase(new Phrase(totalFaltas == null ? "---" : totalFaltas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					    				tabla.addCell(celda);
					    				
					    				celda.setPhrase(new Phrase(totalTardanzas == null ? "---" : totalTardanzas, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					    				tabla.addCell(celda);
				    		        }else {
				    		        	celda.setPhrase(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					    				tabla.addCell(celda);
					    				tabla.addCell(celda);
				    		        }
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
						boolean todasTienenCalificacionIngles = true;
	    				
	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("Promedio de Inglés", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLDITALIC, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
	    				tabla.addCell(celda);
	    				
	    				
	    				for(int l = 0; l < cantidadTrimestres; l++){
	    					if(sumaPorTrimestreInglesMadre[l].compareTo(BigDecimal.ZERO) > 0 && cantidadMaterias > 0){
    	    					celda = new PdfPCell(new Phrase( frm.format(sumaPorTrimestreInglesMadre[l]), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLDITALIC, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(0);
    	        				tabla.addCell(celda);
    	        				
    	    				}else{ 
    	    					celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLDITALIC, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(0);
    	        				tabla.addCell(celda);
    	    					todasTienenCalificacionIngles &= false;
    	    				}
						}
	    				
    		    		BigDecimal notaDeTodas = new BigDecimal("0", mc);
    		    		celda = new PdfPCell(new Phrase( promedioDeIngles, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLDITALIC, new BaseColor(0,0,0))));
        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
        				tabla.addCell(celda);
	    		    	celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(0);
						celda.setColspan(2+(cantidadTrimestres*2));
	    				tabla.addCell(celda);
	    				
	    				boolean todasTienenCalificacion = true;
	    				
	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("Promedio Acumulado", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
	    				tabla.addCell(celda);
	    				
	    				int trimestresConNota = 0;
	    				for(int l = 0; l < cantidadTrimestres; l++){
	    					
	    					if(sumaPorTrimestre[l].compareTo(BigDecimal.ZERO) > 0 && materias > materiasSinNota[l]){
	    						int materiasTmp = materias;
	    						materiasTmp = materiasTmp-materiasSinNota[l];
	    						trimestresConNota++;
	    						
	    						//System.out.println("sumaPorTrimestre["+l+"] = "+sumaPorTrimestre[l]+";  materias = "+materias+"; materiasSinNota[l] = "+materiasSinNota[l]+"; materiasTmp"+materiasTmp);
	    						sumaPorTrimestre[l] = sumaPorTrimestre[l].divide(new BigDecimal(materiasTmp+"", mc), mc);
    	    					//celda = new PdfPCell(new Phrase( frm1.format(sumaPorTrimestre[l]), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    	    					celda = new PdfPCell(new Phrase( "---", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(2);
    	        				tabla.addCell(celda);
    	    				}else{ 
    	    					celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    							celda.setBorder(2);
    	        				tabla.addCell(celda);
    	    					todasTienenCalificacion &= false;
    	    				}
						}
	    				
    		    		notaDeTodas = new BigDecimal("0", mc);
    		    		
    		    		for (int h=0; h < lisCurso.size(); h++){
    		    			notaDeTodas = notaDeTodas.add(promedioPorMateria[h], mc);
    		    		}
    		    		BigDecimal promedioTrimestres = BigDecimal.ZERO;
    		    		if(notaDeTodas.compareTo(BigDecimal.ZERO) > 0 && trimestresConNota > 0)
    		    			promedioTrimestres = notaDeTodas.divide(new BigDecimal(materias+"", mc), mc);
    		    		
    		    		celda = new PdfPCell(new Phrase( frm4.format(promedioTrimestres), FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
        				tabla.addCell(celda);
	    		    	celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setBorder(2);
						celda.setColspan(2+(cantidadTrimestres*2));
	    				tabla.addCell(celda);
	    				
    					oficial = curso.getTipocursoId();
	    			}
	    			
	    			
	    		}
				celda = new PdfPCell(new Phrase("Promedio Acumulado", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				tabla.addCell(celda);
				

				wrapTable.addCell(tabla);
				
				
				/*
				*	Inicia sección de Aspectos de Habitos y Actitudes
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
	    			colsAspectosWidth[cont++] = 32/cantidadTrimestres;
	    		}
	    		colsAspectosWidth[cont++] = 38;
				
				PdfPTable aspectosTable = new PdfPTable(colsAspectosWidth);
				aspectosTable.setWidthPercentage(80f);
				aspectosTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				aspectosTable.setSpacingAfter(5f);
				
				cell = new PdfPCell(new Phrase("ASPECTOS DE HÁBITOS Y ACTITUDES", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(0);
 				aspectosTable.addCell(cell);
 				
 				if(ciclo.getNivelEval().equals("P")){
 					//System.out.println("ciclo.getNiveEval() = P");
 					for(int k = 0; k < cicloPromedioList.size(); k++){
						cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
						
						cell = new PdfPCell(new Phrase(cicloPromedio.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
		 				cell.setBorder(0);
		 				aspectosTable.addCell(cell);
					}
				}else if(ciclo.getNivelEval().equals("E")){
					//System.out.println("ciclo.getNiveEval() = E");
					for(CicloBloque cb: lisBloque){
						cell = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
		 				cell.setBorder(0);
		 				aspectosTable.addCell(cell);
					}
				}
 				
	 				
 				
 				cell = new PdfPCell(new Phrase("OBSERVACIONES", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
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
					
					cell = new PdfPCell(new Phrase(catAspectos.getNombre(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
	 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
	 				cell.setBorder(0);
	 				aspectosTable.addCell(cell);
					
					
						
						if(materiasConAspectos == 1){//Una sola materia
							//System.out.println("una materia - materiasConAspectos = "+materiasConAspectos);
							if(ciclo.getNivelEval().equals("P")){
			 					//System.out.println("P");
								for(int k = 0; k < cicloPromedioList.size(); k++){
									cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
									float valor = 0f;
									String resultado = "-";
									
									boolean show = cicloPromedio.getPromedioId().equals(request.getParameter(cicloPromedio.getNombre()));
									if(show){
										for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
											//System.out.println(krdxAlumActitud.getAspectos());
											if(krdxAlumActitud.getCursoId().equals(curso.getCursoId()) && 
													krdxAlumActitud.getPromedioId().equals(cicloPromedio.getPromedioId()) &&
													krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
												valor = Float.parseFloat(krdxAlumActitud.getNota());
												resultado = valor==1?"X":resultado;
												resultado = valor==2?"R":resultado;
												resultado = valor==3?"S":resultado;
												break;
											}
										}
									}
									cell = new PdfPCell(new Phrase(resultado, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}else if(ciclo.getNivelEval().equals("E")){
								//System.out.println("E");
								//Aqui va el for para ciclo_grupo_eval ciclo_grupo_eval
								//for(CicloBloque cb: lisBloque){
								for(CicloGrupoEval cge: listaCicloGrupoEval){
									if(cge.getCicloGrupoId().equals(cicloGrupoId) &&
											cge.getCursoId().equals(curso.getCursoId())){
										//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
										float valor = 0f;
										String resultado = "-";
										
										boolean show = cge.getEvaluacionId().equals(request.getParameter(cge.getEvaluacionNombre()));
										if(show){
											for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
												//System.out.println(krdxAlumActitud.getAspectos());
												if(krdxAlumActitud.getCursoId().equals(curso.getCursoId()) && 
														krdxAlumActitud.getEvaluacionId().equals(cge.getEvaluacionId()) &&
														krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
													valor = Float.parseFloat(krdxAlumActitud.getNota());
													resultado = valor==1?"X":resultado;
													resultado = valor==2?"R":resultado;
													resultado = valor==3?"S":resultado;
													break;
												}
											}
										}
									
										cell = new PdfPCell(new Phrase(resultado, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
						 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
										cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
						 				cell.setBorder(0);
						 				aspectosTable.addCell(cell);
									}
								}
							}
							
							
						}else if(materiasConAspectos > 1){//Mas de una materia para promediar
							//System.out.println("muchas materias - materiasConAspectos = "+materiasConAspectos);
							if(ciclo.getNivelEval().equals("P")){
								//System.out.println("muchas materias - P");
								for(int k = 0; k < cicloPromedioList.size(); k++){
									cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
									BigDecimal valor = new BigDecimal("0", mc);
									
									for(aca.plan.PlanCurso c: cursos){
										for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
											//System.out.println(krdxAlumActitud.getAspectos());
											if(krdxAlumActitud.getCursoId().equals(c.getCursoId()) && 
													krdxAlumActitud.getPromedioId().equals(cicloPromedio.getPromedioId()) &&
													krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
												valor = valor.add(new BigDecimal(krdxAlumActitud.getNota(), mc), mc);
												break;
											}
										}
									}
									valor = valor.divide(new BigDecimal(cursos.size(), mc), mc);
									valor = valor.setScale(0, RoundingMode.HALF_UP);
									int valor2 = valor.intValueExact();
									String resultado = "-";
									resultado = valor2==1?"X":resultado;
									resultado = valor2==2?"R":resultado;
									resultado = valor2==3?"S":resultado;
									
									cell = new PdfPCell(new Phrase(resultado, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}else if(ciclo.getNivelEval().equals("E")){
								//System.out.println("muchas materias - E");
								//Aqui va el for para ciclo_grupo_eval ciclo_grupo_eval
								//for(CicloBloque cb: lisBloque){
								for(CicloGrupoEval cge: listaCicloGrupoEval){
									if(cge.getCicloGrupoId().equals(cicloGrupoId) &&
											cge.getCursoId().equals(curso.getCursoId())){
										//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
										BigDecimal valor = new BigDecimal("0", mc);
										
										for(aca.plan.PlanCurso c: cursos){
											for(KrdxAlumActitud krdxAlumActitud: listaKrdxAlumActitud){
												//System.out.println(krdxAlumActitud.getAspectos());
												if(krdxAlumActitud.getCursoId().equals(c.getCursoId()) && 
														krdxAlumActitud.getEvaluacionId().equals(cge.getEvaluacionId()) &&
														krdxAlumActitud.getAspectosId().equals(catAspectos.getAspectosId())){
													valor = valor.add(new BigDecimal(krdxAlumActitud.getNota(), mc), mc);
													//System.out.println(krdxAlumActitud.getNota());
													break;
												}
											}
										}
										valor = valor.divide(new BigDecimal(cursos.size(), mc), mc);
										valor = valor.setScale(0, RoundingMode.HALF_UP);
										int valor2 = valor.intValueExact();
										//System.out.println("Aspectos: "+valor);
										String resultado = "-";
										resultado = valor2==1?"X":resultado;
										resultado = valor2==2?"R":resultado;
										resultado = valor2==3?"S":resultado;
										
										cell = new PdfPCell(new Phrase(resultado, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
						 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
										cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
						 				cell.setBorder(0);
						 				aspectosTable.addCell(cell);
									}
								}
							}
						}else{//No hay ninguna materia con aspectos materiasConASpectos = 0
							//System.out.println("sin materias - materiasConAspectos = "+materiasConAspectos);
							if(ciclo.getNivelEval().equals("P")){
								for(int k = 0; k < cicloPromedioList.size(); k++){
									cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
									//System.out.println("listaActitud: "+listaKrdxAlumActitud.size());
																		
									cell = new PdfPCell(new Phrase("-", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}else if(ciclo.getNivelEval().equals("E")){
								for(CicloBloque cb: lisBloque){
									cell = new PdfPCell(new Phrase("-", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
					 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
									cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
					 				cell.setBorder(0);
					 				aspectosTable.addCell(cell);
								}
							}
						}
					// Se muestra la observación del último trimestre desplegado
					if(j == 0){
						String trimestreId = "", observacion = "";
						if(ciclo.getNivelEval().equals("P")){
		 					for(int k = 0; k < cicloPromedioList.size(); k++){
								cicloPromedio = (CicloPromedio) cicloPromedioList.get(k);
								//Si se solicitó mostrar el trimestre 
								if(cicloPromedio.getPromedioId().equals(request.getParameter(cicloPromedio.getNombre()))){
									trimestreId = cicloPromedio.getPromedioId();
									if(mapObservaciones.containsKey(codigoAlumno+"-"+trimestreId)){
										observacion = mapObservaciones.get(codigoAlumno+"-"+trimestreId).getObservacion_1()==null?"":mapObservaciones.get(codigoAlumno+"-"+trimestreId).getObservacion_1();
									}
								}
							}
						}else if(ciclo.getNivelEval().equals("E")){
							for(CicloBloque cb: lisBloque){
								//Si se solicitó mostrar el trimestre 
								//System.out.println(cb.getBloqueId()+".equals("+request.getParameter(cb.getBloqueNombre())+")");
								if(cb.getBloqueId().equals(request.getParameter(cb.getBloqueNombre()))){
									//System.out.println("Entro............................................" + cb.getPromedioId());
									trimestreId = cb.getBloqueId();
									if(mapObservaciones.containsKey(codigoAlumno+"-"+trimestreId)){
										observacion = mapObservaciones.get(codigoAlumno+"-"+trimestreId).getObservacion_1()==null?"":mapObservaciones.get(codigoAlumno+"-"+trimestreId).getObservacion_1();
									}
								}
							}
						}
						//System.out.println(" observaciones "+ mapObservaciones.containsKey(codigoAlumno+"-"+trimestreId));
						//String observacion = "";
						if(mapObservaciones.containsKey(codigoAlumno+"-"+trimestreId))
							observacion = mapObservaciones.get(codigoAlumno+"-"+trimestreId).getObservacion_1()==null?"":mapObservaciones.get(codigoAlumno+"-"+trimestreId).getObservacion_1();
						
						cell = new PdfPCell(new Phrase(observacion, FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, new BaseColor(0,0,0))));
		 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell.setVerticalAlignment(Element.ALIGN_TOP);
		 				cell.setBorder(0);
		 				cell.setRowspan(aspectosList.size());
		 				aspectosTable.addCell(cell);
					}
				}
				
				wrapTable.addCell(aspectosTable);
				
				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
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
 				
 				cell = new PdfPCell(new Phrase("Hábitos y Actitudes se califican así\n"+
 						"S = Satisfactorio\n"+
 						"R = Regular\n"+
 						"X = No Satisfactorio", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_TOP);
 				cell.setBorder(0);
 				notesTable.addCell(cell);
				
				wrapTable.addCell(notesTable);
				
				/*
				*	Inicia sección de Firmas
				*
				*/
				
				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setBorder(0);
 				wrapTable.addCell(cell);
				
				String firma = "";
				int contFirmas = 2;
				boolean tablaVacia = false;
								
				
				PdfPTable t = new PdfPTable(contFirmas);
				
				

	            
	            celda = new PdfPCell(new Phrase("CONSEJERO(A):_______________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);	
										    
			    celda = new PdfPCell(new Phrase("DIRECTOR(A):_______________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));
			    celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			    celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				celda.setColspan(2);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				celda.setColspan(2);
				t.addCell(celda);			
				
				celda = new PdfPCell(new Phrase("ACUDIENTE:__________________________________\n"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);	
				
				String fecha = new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
				celda = new PdfPCell(new Phrase("FECHA: "+fecha
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setBorder(0);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase(" "
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				celda.setColspan(2);
				t.addCell(celda);
				
				celda = new PdfPCell(new Phrase("Cristo Viene Pronto... !Prepárate!"
						, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, new BaseColor(0,0,0))));            
	            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				celda.setBorder(0);
				celda.setColspan(2);
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