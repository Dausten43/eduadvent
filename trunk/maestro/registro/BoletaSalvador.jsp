<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
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
<%@page import="aca.ciclo.CicloBloque"%>
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
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>

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
	ArrayList<CicloBloque> lisBloque	= cicloBloqueL.getListCiclo(conElias, cicloGrupoId.substring(0,8), "ORDER BY ORDEN");
	TreeMap<String, CicloBloque> lisBloqueAlum 	= new TreeMap<String, CicloBloque>();
	for(CicloBloque bloque: lisBloque){
		lisBloqueAlum.put(bloque.getPromedioId()+bloque.getBloqueId(), bloque);
	}
	ArrayList<CicloPromedio>  cicloPromedioList	= cicloPromedioU.getListCiclo(conElias, cicloId, " ORDER BY ORDEN");
	ArrayList <CicloGrupoEval> listaCicloGrupoEval = cicloGrupoEvalLista.getEvalGrupo(conElias, cicloGrupoId, "ORDER BY CICLO_GRUPO_ID, ORDEN");

	ciclo.mapeaRegId(conElias, cicloId);
	
	java.text.DecimalFormat frmEval = null;
	java.text.DecimalFormat frmProm = null;
	java.text.DecimalFormat frmCiclo = null;
	if(ciclo.getDecimales().equals("1")){
		frmCiclo = new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	}else{
		frmCiclo = new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	}
	java.math.MathContext mc = new java.math.MathContext(4, RoundingMode.HALF_EVEN);
	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	if(escala == 100){
		frmEval = new java.text.DecimalFormat("###,##0;(###,##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	}
	if(ciclo.getRedondeo().equals("T")){
		frmCiclo.setRoundingMode(java.math.RoundingMode.DOWN);
	}else{
		frmCiclo.setRoundingMode(java.math.RoundingMode.HALF_UP);
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
	String year = ciclo.getCicloEscolar();
	String nombreTutor   = aca.empleado.EmpPersonal.getNombre(conElias,Grupo.getEmpleadoId(),"NOMBRE");
	nivel = aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId());
	String subnivel = aca.catalogo.CatEsquemaLista.getSubNivel(conElias, escuela, Grupo.getNivelId(), Grupo.getGrado());
	if(!subnivel.equals("")){
		subnivel = "Ciclo: ["+subnivel+"] - ";
	}

	//Map de promedios del alumno en cada materia
	java.util.Map<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);
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
			String dir = application.getRealPath("/maestro/registro/")+"/"+"boleta"+cicloGrupoId+".pdf";
			PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
			document.addAuthor("Sistema Escolar");
	        document.addSubject("Boleta de "+alumPersonal.getNombre());
	        document.open();
			
	        for(int i = 0; i < lisAlum.size(); i++){
	        	codigoAlumno = (String) lisAlum.get(i);
		        alumPersonal.mapeaRegId(conElias, codigoAlumno);
				plan 				= Grupo.getPlanId();
				grado 				= Grupo.getGrado();
				grupo 				= Grupo.getGrupo();
				
				ArrayList<aca.plan.PlanCurso> lisCurso;
				lisCurso 			= cursoLista.getListCurso(conElias,plan,"AND GRADO = (SELECT GRADO FROM CICLO_GRUPO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') AND CURSO_ID IN (SELECT CURSO_ID FROM CICLO_GRUPO_CURSO WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"') ORDER BY GRADO, ORDEN");
				ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso = alumnoCursoLista.getListAll(conElias, escuela," AND CODIGO_ID = '"+codigoAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
				float wrapwidth[] = {100f};
				PdfPTable wrapTable = new PdfPTable(wrapwidth);
				wrapTable.getDefaultCell().setBorder(0);
				wrapTable.setWidthPercentage(100f);
				wrapTable.setKeepTogether(true);
				wrapTable.setSpacingBefore(30f);
				wrapTable.setSplitLate(false);
				
				float headerwidths[] = {80f, 20f};
				PdfPTable topTable = new PdfPTable(headerwidths);
				topTable.setWidthPercentage(80f);
				topTable.setHorizontalAlignment(Element.ALIGN_CENTER);
				topTable.setSpacingAfter(5f);
				
	            PdfPCell cell = null;
	            
				
				/* 
	             * Nombre del colegio de cada boleta
	             */
	            
	            CatEscuela ce = new CatEscuela();
				ce.mapeaRegId(conElias, escuela);
				
		        cell = new PdfPCell(new Phrase(ce.getEscuelaNombre().toUpperCase(), FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setColspan(2);
				topTable.addCell(cell);
				
		        cell = new PdfPCell(new Phrase("Reporte de Notas "+year, FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
				cell.setBorderWidthRight(1);
				topTable.addCell(cell);
	            /* 
	             * Agregar el logo de cada boleta
	             */
	            Image jpg = null;
	            	            
        		jpg = Image.getInstance(application.getRealPath("/imagenes/")+"/logos/SEAS.png");
	            
	            jpg.setAlignment(Image.RIGHT | Image.UNDERLYING);
	            jpg.scaleAbsolute(60, 59);	            
	            
	            cell = new PdfPCell();
            	cell.addElement(jpg);
            	cell.setBorderWidthLeft(borde);
				topTable.addCell(cell);
		            
				/* 
	             * Informacion del encabezado de cada boleta
	             */
 
				cell = new PdfPCell(new Phrase(nivel + "     " +
												"Grado: "+aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(Grupo.getGrado())),
                					FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setColspan(2);
				topTable.addCell(cell);
				
	            cell = new PdfPCell(new Phrase("Alumno: ["+codigoAlumno+"] "+alumPersonal.getNombre()+
	            					" "+alumPersonal.getApaterno()+" "+alumPersonal.getAmaterno()
	            					+"     NIE: "+alumPersonal.getCurp(), 
	            					FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setColspan(2);
				topTable.addCell(cell);
				//Se agrega la topTable a la wrapTable
            	wrapTable.addCell(topTable);
            	
            	//Content
            	float cantidadEval = lisBloque.size();
            	float cantidadProm = cicloPromedioList.size();
            	double numCol = (cantidadProm*((cantidadEval/cantidadProm)+1.0))+2.0;
            	//if(numCol%2 != 0)
            		//numCol+=1;
            	float colsWidth[] = new float[(int)numCol];
	    		colsWidth[0] = 30;//0
	    		for(int j = 1; j < (int)(numCol); j++){
	    			colsWidth[j] = ((cantidadProm+1)*10)/cantidadEval;
	    		}
	    		colsWidth[(int)numCol-1] = 9;
	    		
	    		PdfPTable tabla = new PdfPTable(colsWidth);
	            tabla.setWidths(colsWidth);
	            tabla.setSpacingAfter((float)0);
	            tabla.setSpacingBefore((float)0);
				
	            PdfPCell celda = null;
				
	    		int cantidadMaterias 	= 0;
	    		int materias 			= 0;
	    		int materiasIngles 		= 0;
	    		String oficial 			= "";
	    		numGrado 				= 0;
				BigDecimal promNotaGralAc 	= new BigDecimal(0, mc);
	    		
	    		float[] sumaPorTrimestreIngles = new float[(int)cantidadEval];
	    		for(int j = 0; j < cantidadEval; j++)
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
		    				alumnoCurso.setCal1( alumnoCurso.getCal1().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal1())) );
		    				alumnoCurso.setCal2( alumnoCurso.getCal2().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal2())) );
		    				alumnoCurso.setCal3( alumnoCurso.getCal3().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal3())) );
		    				alumnoCurso.setCal4( alumnoCurso.getCal4().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal4())) );
		    				alumnoCurso.setCal5( alumnoCurso.getCal5().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal5())) );
		    				alumnoCurso.setCal6( alumnoCurso.getCal6().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal6())) );
		    				alumnoCurso.setCal7( alumnoCurso.getCal7().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal7())) );
		    				alumnoCurso.setCal8( alumnoCurso.getCal8().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal8())) );
		    				alumnoCurso.setCal9( alumnoCurso.getCal9().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal9())) );
		    				alumnoCurso.setCal10( alumnoCurso.getCal10().equals("-")?"-":frmCiclo.format(Double.parseDouble(alumnoCurso.getCal10())) );
		    				
		    				if(alumnoCurso.getCursoId().equals(curso.getCursoId()) && cicloGrupoId.indexOf(alumnoCurso.getCicloId()) != -1){
		    					if (Integer.parseInt(curso.getGrado()) != numGrado){
		    	    				numGrado = 	Integer.parseInt(curso.getGrado());
		    	    				oficial = "1";
		    	    				
		    	    				celda = new PdfPCell(new Phrase(" Materias ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    	    				tabla.addCell(celda);
		    	    				
	    		 					for(CicloPromedio cp: cicloPromedioList){
	    		 						int temp = 0;
	    								celda = new PdfPCell(new Phrase(cp.getNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
	    								celda.setHorizontalAlignment(Element.ALIGN_LEFT);
	    								for(CicloBloque cb : lisBloque)
		    	     						if(cp.getPromedioId().equals(cb.getPromedioId()))
			    	     						temp++;
	    								celda.setColspan(temp+1);
			    						tabla.addCell(celda);
	    							}
	    		 					
	    		 					celda = new PdfPCell(new Phrase(" T ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    	    				tabla.addCell(celda);
		    	    				
		    	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	    				celda.setVerticalAlignment(Element.ALIGN_BOTTOM);
		    	     				tabla.addCell(celda);
		    	     				
		    	     				for(CicloPromedio cp: cicloPromedioList){
		    	     					for(CicloBloque cb : lisBloque){
		    	     						if(cp.getPromedioId().equals(cb.getPromedioId())){
			    	     						celda = new PdfPCell(new Phrase(cb.getCorto(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    								celda.setHorizontalAlignment(Element.ALIGN_LEFT);
					    						tabla.addCell(celda);
		    	     						}
		    	     					}
		    	     					celda = new PdfPCell(new Phrase(" PM ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    	    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			    	    				tabla.addCell(celda);
		    	     				}
		    	     				
		    	     				celda = new PdfPCell(new Phrase(" PM ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    	    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    	    				tabla.addCell(celda);
		    	    				
		    					}
		    	    				
		    	    				//---- Inician Materias ----
				    				
			    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			    				tabla.addCell(celda);
			    			
			    				materias++;
			    				
			    				BigDecimal sumaFinales = new BigDecimal(0,mc);
			    				BigDecimal valorAlumPorcentajeProm = new BigDecimal(0, mc);
		    					BigDecimal valorTotalPorcentajeProm = new BigDecimal(0, mc);
			    				int trimestresConNota = 0, x = 0;
			    				for(CicloPromedio cp: cicloPromedioList){
			    					// Inicializa el formato para los decimales
			    					if(cp.getDecimales().equals("1")){
			    						frmProm = new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
			    					}else if(cp.getDecimales().equals("2")){
			    						frmProm = new java.text.DecimalFormat("##0.00;-##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
			    					}else{
			    						frmProm = new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
			    					}
			    					if(cp.getRedondeo().equals("T")){
										frmProm.setRoundingMode(RoundingMode.DOWN);
									}else{
										frmProm.setRoundingMode(RoundingMode.HALF_UP);
									}
			    					
			    					BigDecimal sumaNotas = new BigDecimal(0, mc);
			    					BigDecimal valorAlumPorcentajeEval = new BigDecimal(0, mc);
			    					BigDecimal valorTotalPorcentajeEval = new BigDecimal(0, mc);
									int contador = 0;
									int evalConNota = 0;
									String tmpDecimales="";
			    					for(CicloGrupoEval cge: listaCicloGrupoEval){
			    						tmpDecimales = lisBloqueAlum.get(cge.getPromedioId()+cge.getEvaluacionId()).getDecimales();
			    						if(tmpDecimales.equals("1")){
				    						frmEval = new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
				    					}else if(tmpDecimales.equals("2")){
				    						frmEval = new java.text.DecimalFormat("##0.00;-##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
				    					}else{
				    						frmEval = new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
				    					}
				    					if(lisBloqueAlum.get(cge.getPromedioId()+cge.getEvaluacionId()).getRedondeo().equals("T")){
				    						frmEval.setRoundingMode(RoundingMode.DOWN);
										}else{
											frmEval.setRoundingMode(RoundingMode.HALF_UP);
										}
			    						
										if(cge.getCicloGrupoId().equals(cicloGrupoId) &&
												cge.getCursoId().equals(curso.getCursoId()) &&
												cge.getPromedioId().equals(cp.getPromedioId())){
											String valor = "--";
											if(treeEvalAlumno.containsKey(cicloGrupoId+curso.getCursoId()+cge.getEvaluacionId()+codigoAlumno)){
												KrdxAlumEval alumno = treeEvalAlumno.get(cicloGrupoId+curso.getCursoId()+cge.getEvaluacionId()+codigoAlumno);
												valor = alumno.getNota();
												sumaNotas.add(new BigDecimal(valor));
												if(curso.getTipocursoId().equals("3"))
													sumaPorTrimestreIngles[contador] += Float.parseFloat(valor);
												valor = String.valueOf(frmEval.format(Double.parseDouble(valor)));
												
												evalConNota++;
												BigDecimal porcentajeCalf = new BigDecimal(cge.getValor(), mc);
												porcentajeCalf = porcentajeCalf.multiply(new BigDecimal(alumno.getNota()), mc);
												
												valorAlumPorcentajeEval	= valorAlumPorcentajeEval.add(porcentajeCalf, mc);
												valorTotalPorcentajeEval = valorTotalPorcentajeEval.add(new BigDecimal(cge.getValor(), mc), mc);
											}
											
											celda = new PdfPCell(new Phrase(valor, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
											celda.setHorizontalAlignment(Element.ALIGN_CENTER);
							 				tabla.addCell(celda);
							 				contador++;
											
										}
			    					}
			    					
			    					String nota = "0";
			    					
			    					String key = codigoAlumno+curso.getCursoId()+cp.getPromedioId();
			    					aca.kardex.KrdxAlumProm notaPromedio = mapPromAlumno.get(key);
			    					
			    					BigDecimal prom =  new BigDecimal(nota, mc);
			    					if(notaPromedio!=null && Double.parseDouble(notaPromedio.getNota())>0.0){
			    						BigDecimal porcentajeCalf = new BigDecimal(cp.getValor(), mc);
			    						
			    						if(Double.parseDouble(notaPromedio.getNota()) > 0){
			    							prom = valorAlumPorcentajeEval;
			    							prom = prom.divide(valorTotalPorcentajeEval, mc);
			    						}
			    						porcentajeCalf = porcentajeCalf.multiply(prom, mc);
										valorAlumPorcentajeProm = valorAlumPorcentajeProm.add(porcentajeCalf, mc);
			    						valorTotalPorcentajeProm  = valorTotalPorcentajeProm.add(new BigDecimal(cp.getValor(), mc), mc); 
			    					}

			    					nota = frmProm.format(prom);
			    					
									celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD, new BaseColor(0,0,0))));
									celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					 				tabla.addCell(celda);
			    				}
			    				
			    				
			    				String nota = "0";
			    				// El siguiente código comentado se puede ocupar para sacar el promedio únicamente con las evaluaciones calificadas
			    				// BigDecimal promFinal = valorAlumPorcentajeProm.doubleValue() <= 0d?new BigDecimal(0, mc):valorAlumPorcentajeProm.divide(valorTotalPorcentajeProm, mc);
		    					BigDecimal promFinal = valorAlumPorcentajeProm.doubleValue() <= 0d?new BigDecimal(0, mc):valorAlumPorcentajeProm.divide(new BigDecimal("100", mc), mc);
		    					if(promFinal.compareTo(new BigDecimal(0, mc)) != 0){
		    						frmProm.setRoundingMode(RoundingMode.HALF_UP);
									promFinal = new BigDecimal(frmProm.format(promFinal), mc);
		    					}
		    					promNotaGralAc = promNotaGralAc.add(promFinal);

		    					nota = frmCiclo.format(promFinal);
		    					
		    					celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				tabla.addCell(celda);
			    				
			    				k = lisAlumnoCurso.size();
		    					encontro = true;
			    				
		    				}
			    			
		    			}
		    			
		    			if(!encontro){
		    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
		    				tabla.addCell(celda);

		    				for(int l = 0; l < cantidadEval; l++){
		    					celda = new PdfPCell(new Phrase("--", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				tabla.addCell(celda);
		    				}
		    				celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    				tabla.addCell(celda);

		    				for(int l = 0; l < cantidadEval; l++){
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
	            
				//String nota = "0";
				BigDecimal nota = promNotaGralAc.toString().equals("0")?new BigDecimal(0, mc):promNotaGralAc.divide(new BigDecimal(cantidadMaterias, mc), mc);
				//nota = String.valueOf(calculo);
				// Colocar formato con una decimal
				//nota = frm.format(nota);
				
				celda = new PdfPCell(new Phrase("Promedio de Nota General Acumulada: "+frmCiclo.format(nota), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
				celda.setColspan(colsWidth.length);
				tabla.addCell(celda);
				
	          	//Se agrega la tabla el contenido a la wrapTable
	            wrapTable.addCell(tabla);
				
	          	PdfPTable bottomTable = new PdfPTable(new float[]{2,1, 1});
 				
 				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setColspan(2);
 				cell.setBorderWidthBottom(0);
 				bottomTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase("sello", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
				cell.setRowspan(3);
 				bottomTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setColspan(2);
 				cell.setBorderWidthTop(0);
 				cell.setBorderWidthBottom(0);
 				bottomTable.addCell(cell);
 				cell = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				cell.setColspan(2);
 				cell.setBorderWidthTop(0);
 				bottomTable.addCell(cell);
	          	
 				cell = new PdfPCell(new Phrase("F.", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				bottomTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase("F.", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setColspan(2);
 				bottomTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase("Orientador: "+nombreTutor, FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
 				bottomTable.addCell(cell);
 				
 				cell = new PdfPCell(new Phrase("Director: "+aca.empleado.EmpPersonal.getNombre(conElias, Nivel.getDirector(conElias, escuela, Grupo.getNivelId()), "NOMBRE"), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
 				
 				cell.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
				cell.setColspan(2);
 				bottomTable.addCell(cell);
 				
 				wrapTable.addCell(bottomTable);
            	//Se agrega la wrapTable al documento
            	document.add(wrapTable);
	        }

		}catch(IOException ioe) {
			System.err.println("Error boleta en PDF: "+ioe.getMessage());
		}
			
		document.close();

%>
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