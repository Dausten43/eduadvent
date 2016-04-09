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
<jsp:useBean id="cicloGrupoActLista" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="cicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="cicloBloqueActividadL" scope="page" class="aca.ciclo.CicloBloqueActividadLista"/>
<jsp:useBean id="CatParametro" scope="page" class="aca.catalogo.CatParametro"/>
<jsp:useBean id="ActEtiquetalista" scope="page" class="aca.catalogo.CatActividadEtiquetaLista"/>
<jsp:useBean id="CatActividadEtiquetaLista" scope="page" class="aca.catalogo.CatActividadEtiquetaLista"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />

<%
	String escuela		= (String)session.getAttribute("escuela");
	String codigoAlumno = "";
	String cicloGrupoId	= request.getParameter("cicloGrupoId");
	String cicloId 		= (String) session.getAttribute("cicloId");

	String plan			= "";
	String nivel		= "";
	String grado		= "";
	String grupo		= "";
	int borde 			= 0; 
	
	int numGrado 			= 0;	
	boolean hayAbiertas = CicloGrupoCurso.hayAbiertas(conElias, cicloGrupoId);
	
	ArrayList<String> lisAlum 			= cursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);	
	ArrayList<CicloBloque> lisBloque	= cicloBloqueL.getListCiclo(conElias, cicloGrupoId.substring(0,8), "ORDER BY BLOQUE_ID");
	
	
	java.text.DecimalFormat frm = new java.text.DecimalFormat("###,##0.0;(###,##0.0)");
	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	if(escala == 100){
		frm = new java.text.DecimalFormat("###,##0;(###,##0)");
	}
	
	frm.setRoundingMode(java.math.RoundingMode.DOWN);
	
	
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	String subnivel = aca.catalogo.CatEsquemaLista.getSubNivel(conElias, escuela, Grupo.getNivelId(), Grupo.getGrado());
	if(!subnivel.equals("")){
		subnivel = "Ciclo: ["+subnivel+"] - ";
	}
	
	
	java.util.HashMap<String, String> mapNotaActividades = aca.ciclo.CicloGrupoActividadLista.getMapNotaActividadCursos(conElias, cicloGrupoId);	
	
	int totalActividades = 0;
	java.util.HashMap<String, String> mapActividades = new java.util.HashMap<String, String>();
	
	int totalEtiquetas = 0;
	java.util.HashMap<String, String> mapEtiquetas = new java.util.HashMap<String, String>();
	
	for(aca.ciclo.CicloBloque bloque : lisBloque){
		
		ArrayList<aca.ciclo.CicloBloqueActividad> actividades = cicloBloqueActividadL.getListBloque(conElias, cicloId, bloque.getBloqueId(), " ORDER BY ETIQUETA_ID, ACTIVIDAD_ID ");
		/* ***** ACTIVIDADES DE CADA EVALUACION (BLOQUE) ***** */
		String strActividades 	= "";
		for(aca.ciclo.CicloBloqueActividad actividad : actividades){
			totalActividades++;	
			strActividades += actividad.getActividadId()+"&&"+actividad.getActividadNombre()+"@";
		}
		System.out.println(strActividades);
		
		if(!strActividades.equals("")){
			strActividades = strActividades.substring(0, strActividades.length()-1);
			mapActividades.put(bloque.getBloqueId(), strActividades);
		}
		/* ***** END ACTIVIDADES DE CADA EVALUACION (BLOQUE) ***** */	
		
		
		
		ArrayList<aca.catalogo.CatActividadEtiqueta> etiquetas = CatActividadEtiquetaLista.getListBloque(conElias, aca.catalogo.CatEscuela.getUnionId(conElias, (String)session.getAttribute("escuela")), cicloId, bloque.getBloqueId(), "ORDER BY ORDEN");
		/* ***** ACTIVIDADES DE CADA EVALUACION (BLOQUE) ***** */
		String strEtiquetas 	= "";
		for(aca.catalogo.CatActividadEtiqueta etiq : etiquetas){
			if(!etiq.getEtiquetaId().equals("0")){
				totalEtiquetas++;
			}
			
			strEtiquetas += etiq.getEtiquetaId()+"&&"+etiq.getEtiquetaNombre()+"@";
		}
		
		if(!strEtiquetas.equals("")){
			strEtiquetas = strEtiquetas.substring(0, strEtiquetas.length()-1);
			mapEtiquetas.put(bloque.getBloqueId(), strEtiquetas);
		}
		/* ***** END ACTIVIDADES DE CADA EVALUACION (BLOQUE) ***** */
		
	}
	
	java.util.HashMap<String, String> etiquetas = aca.ciclo.CicloBloqueActividadLista.getMapEtiquetas(conElias, cicloId);	
	
	
	CatParametro.setEscuelaId(escuela);
	boolean firmaDirector = false;
	boolean firmaPadre	  = false;	
	
	if(CatParametro.existeReg(conElias)){
		CatParametro.mapeaRegId(conElias, escuela);
		
		firmaDirector = CatParametro.getFirmaBoleta().equals("S") ? true : false;
		firmaPadre 	  = CatParametro.getFirmaPadre().equals("S") ? true : false;
		
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
			String dir = application.getRealPath("/maestro/registro/")+"/"+"boletaActividades.pdf";
			PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
			document.addAuthor("Sistema Escolar");
	        document.addSubject("Boleta de "+alumPersonal.getNombre());
			//HeaderFooter footer = new HeaderFooter(new Phrase("Nota: Cr=Creditos; HT=Hrs teóricas; HP=Hrs prácticas; Tipo= de nota[Ext=Extraordinaria; Conv=Convalidacion; TS=Título Suficiencia; CD=Calif. Diferida]; Edo=Estado", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.BOLD)), true);
	        //document.setFooter(footer);
	        document.open();
	        
	        for(int i = 0; i < lisAlum.size(); i++){
	        	codigoAlumno = (String) lisAlum.get(i);
		        alumPersonal.mapeaRegId(conElias, codigoAlumno);
		        plan 				= Grupo.getPlanId();
				nivel 				= Grupo.getNivelId();
				grado 				= Grupo.getGrado();
				grupo 				= Grupo.getGrupo();
				
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
	            
	            String dirFoto = application.getRealPath("/imagenes/")+"/logos/"+ aca.catalogo.CatEscuela.getLogo(conElias, escuela);
				java.io.File foto = new java.io.File(dirFoto);
        		if (foto.exists()){
        			jpg = Image.getInstance(application.getRealPath("/imagenes/")+"/logos/"+ aca.catalogo.CatEscuela.getLogo(conElias, escuela));
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
			            " ] - Grado: [ "+aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(Grupo.getGrado()))+
		                " ] - Grupo: [ "+Grupo.getGrupo()+" ]", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, new BaseColor(0,0,0))));
				cell.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell.setBorder(borde);
				topTable.addCell(cell);
	          
            	wrapTable.addCell(topTable);
	            
            	
	            PdfPTable tabla = new PdfPTable(6+lisBloque.size()+totalActividades+totalEtiquetas);
	            
	    		int colsWidth[] = new int[6+lisBloque.size()+totalActividades+totalEtiquetas];
	    		int cont = 0;
	    		colsWidth[cont++] = 3;//0
	    		colsWidth[cont++] = 10;//2
	    		int cantidadTotal = lisBloque.size() + totalActividades + totalEtiquetas;
	    		for(int j = 0; j < cantidadTotal; j++){
	    			colsWidth[cont++] = 80/cantidadTotal;
	    		}
	    		colsWidth[cont++] = 4;
	    		colsWidth[cont++] = 5;
	    		colsWidth[cont++] = 3;
	    		colsWidth[cont++] = 5;
	    	
	            tabla.setWidths(colsWidth);
	            tabla.setSpacingAfter((float)0);
	            tabla.setSpacingBefore((float)0);
	            
	            
	            PdfPCell celda = null;
	            
	            float[] sumaPorBimestre = new float[10];
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
		    	    				
		    	    				//Esto es para desplegar cuando son notas y cuando faltas
		    	    				celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						tabla.addCell(celda);
	    							celda = new PdfPCell(new Phrase("Notas", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setColspan(lisBloque.size()+4+totalActividades+totalEtiquetas);
		    						tabla.addCell(celda);
		    						
		    						
		    	    				//Termina indicacion de notas y faltas
		    						
		    						celda = new PdfPCell(new Phrase("#", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setRowspan(2);
		    						tabla.addCell(celda);
		    						celda = new PdfPCell(new Phrase("Nombre Materia", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setRowspan(2);
		    						tabla.addCell(celda);
		    						
		    						
		    						
		    						for(int l = 0; l < lisBloque.size(); l++){
		    							/* ACTIVIDADES */
		    							String [] arr = {};
		    							if(mapActividades.containsKey( lisBloque.get(l).getBloqueId() )){
		    								arr = mapActividades.get( lisBloque.get(l).getBloqueId() ).split("@");
		    							}
		    							
		    							/* ETIQUETAS */
		    							int length = 0;
		    							if(mapEtiquetas.containsKey( lisBloque.get(l).getBloqueId() )){
		    								String [] arr2 = mapEtiquetas.get( lisBloque.get(l).getBloqueId() ).split("@");
		    								for(String etiq : arr2){
		    									if(!etiq.split("&&")[0].equals("0")){
		    										length++;
		    									}
		    								}
		    							}
		    							
		    								
		    							/* EVALUACION */
		    							celda = new PdfPCell(new Phrase( lisBloque.get(l).getBloqueNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    						celda.setColspan(arr.length+1+length);
			    						tabla.addCell(celda);
									}
		    						
		    						
		    						
		    						celda = new PdfPCell(new Phrase("Nota", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setRowspan(2);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("Fecha", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setRowspan(2);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("Ext.", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setRowspan(2);
		    						tabla.addCell(celda);
		    						
		    						celda = new PdfPCell(new Phrase("Fecha", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    						celda.setRowspan(2);
		    						tabla.addCell(celda);
		    					
		    						
		    						for(int l = 0; l < lisBloque.size(); l++){
		    							
		    							/* ACTIVIDADES */
		    							String [] arr = {};
		    							if(mapActividades.containsKey( lisBloque.get(l).getBloqueId() )){
		    								arr = mapActividades.get( lisBloque.get(l).getBloqueId() ).split("@");
		    							}
		    							
		    							/* ETIQUETAS */
		    							String [] arr2 = {};
		    							if(mapEtiquetas.containsKey( lisBloque.get(l).getBloqueId() )){
		    								arr2 = mapEtiquetas.get( lisBloque.get(l).getBloqueId() ).split("@");
		    							}
		    							
		    							for(String etiq : arr2){
		    								String nombreEtiq =  etiq.split("&&").length>1?etiq.split("&&")[1]:"";
		    								etiq =  etiq.split("&&")[0];
		    								
		    								for(String actividadId : arr){
		    									String nombreAct =  actividadId.split("&&").length>1?actividadId.split("&&")[1]:"";
		    									actividadId =  actividadId.split("&&")[0];
		    									
		    									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";

		    									if(etiq.equals(etiqAct)){
		    									
				    								celda = new PdfPCell(new Phrase(nombreAct, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
						    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						    						tabla.addCell(celda);
						    						
		    									}
			    							}
		    								
		    								if(!etiq.equals("0")){//La etiqueta 0 es la de "no aplica" por lo tanto no se despliega
		    									celda = new PdfPCell(new Phrase(nombreEtiq, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
				    							celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    							tabla.addCell(celda);
		    								}
		    							}
		    							
		    							/* SI NO TIENE ETIQUETAS ENTONCES SOLO LAS ACTIVIDADES */
		    							if(arr2.length == 0){
		    								for(String actividadId : arr){
		    									String nombreAct =  actividadId.split("&&").length>1?actividadId.split("&&")[1]:"";
		    									actividadId =  actividadId.split("&&")[0];
		    									
		    									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";

			    								celda = new PdfPCell(new Phrase(nombreAct, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
					    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					    						tabla.addCell(celda);
			    							}
		    							}
		    							
		    							
		    							/* EVALUACION */
		    							celda = new PdfPCell(new Phrase("P", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    						tabla.addCell(celda);
									}
		    						
		    						
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
		    	    					
		    	    					/* ACTIVIDADES */
		    							String [] arr = {};
		    							if(mapActividades.containsKey( lisBloque.get(l).getBloqueId() )){
		    								arr = mapActividades.get( lisBloque.get(l).getBloqueId() ).split("@");
		    							}
		    							
		    							/* ETIQUETAS */
		    							String [] arr2 = {};
		    							if(mapEtiquetas.containsKey( lisBloque.get(l).getBloqueId() )){
		    								arr2 = mapEtiquetas.get( lisBloque.get(l).getBloqueId() ).split("@");
		    							}
		    							
		    							for(String etiq : arr2){
		    								etiq =  etiq.split("&&")[0];
		    								
		    								for(String actividadId : arr){
		    									actividadId =  actividadId.split("&&")[0];
		    									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";

		    									if(etiq.equals(etiqAct)){
		    										
		    										celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
					    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					    	        				tabla.addCell(celda);
		    			    						
		    									}
		        							}
		    								
		    								if(!etiq.equals("0")){//La etiqueta 0 es la de "no aplica" por lo tanto no se despliega
		    									celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
		    	    							celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	    							tabla.addCell(celda);
		    								}
		    							}
		    							
		    							/* SI NO TIENE ETIQUETAS ENTONCES SOLO LAS ACTIVIDADES */
		    							if(arr2.length == 0){
		    								for(String actividadId : arr){
		    									actividadId =  actividadId.split("&&")[0];
		    									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";
		    										
	    										celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
				    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    	        				tabla.addCell(celda);
		    			    					
		        							}
		    							}
		    							
		    							
		    	    					
		    	    					float tmp = 0;
		    	    					if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
		    	    						tmp = sumaPorBimestre[l];
		    	    						int cantidadMateriasTmp = cantidadMaterias;
		    	    						cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
			    	    					sumaPorBimestre[l] = new BigDecimal(sumaPorBimestre[l]+"").divide(new BigDecimal(cantidadMateriasTmp+""), 1, RoundingMode.DOWN).floatValue();
			    	    					celda = new PdfPCell(new Phrase(sumaPorBimestre[l]+"", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
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
		    	    		    			notaDeTodas += sumaPorBimestreTmp[l];
		    	    		    		}
		    	    		    		if(lisBloque.size()!=0){
		    	    		    			notaDeTodas = new BigDecimal(notaDeTodas+"").divide(new BigDecimal(lisBloque.size()+""), 1, RoundingMode.DOWN).floatValue();
		    	    		    		}
		    	    		    		celda = new PdfPCell(new Phrase(frm.format(notaDeTodas), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
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
		    				
		    					celda = new PdfPCell(new Phrase(String.valueOf(materias+1), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    				tabla.addCell(celda);
			    				celda = new PdfPCell(new Phrase(curso.getCursoNombre(), FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(0,0,0))));
			    				celda.setHorizontalAlignment(Element.ALIGN_LEFT);
			    				tabla.addCell(celda);
			    				materias++;
			    				for(int l = 0; l < lisBloque.size(); l++){
			    					
			    					/* ACTIVIDADES */
	    							String [] arr = {};
	    							if(mapActividades.containsKey( lisBloque.get(l).getBloqueId() )){
	    								arr = mapActividades.get( lisBloque.get(l).getBloqueId() ).split("@");
	    							}
	    							
	    							/* ETIQUETAS */
	    							String [] arr2 = {};
	    							if(mapEtiquetas.containsKey( lisBloque.get(l).getBloqueId() )){
	    								arr2 = mapEtiquetas.get( lisBloque.get(l).getBloqueId() ).split("@");
	    							}
	    							
	    							for(String etiq : arr2){
	    								etiq =  etiq.split("&&")[0];
	    								
	    								float totalEtiqueta 	= 0;
	    								float numActividades 	= 0;
	    								
	    								for(String actividadId : arr){
	    									actividadId =  actividadId.split("&&")[0];
	    									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";

	    									if(etiq.equals(etiqAct)){
	    										
	    										String notaAct = "-";
	    	    								if( mapNotaActividades.containsKey( curso.getCursoId()+"@"+codigoAlumno+"@"+lisBloque.get(l).getBloqueId()+"@"+(actividadId) ) ){
	    	    									notaAct = mapNotaActividades.get( curso.getCursoId()+"@"+codigoAlumno+"@"+lisBloque.get(l).getBloqueId()+"@"+(actividadId) );
	    	    								}
	    	    								
	    	    								if(!notaAct.equals("-")){
	    	    									totalEtiqueta += Float.parseFloat(notaAct);
	    	    									numActividades++;
	    	    								}
	    	    								
	    			    						celda = new PdfPCell(new Phrase(notaAct, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
	    		    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    		    		    				tabla.addCell(celda);
					    						
	    									}
		    							}
	    								
	    								if(!etiq.equals("0")){//La etiqueta 0 es la de "no aplica" por lo tanto no se despliega
	    									
	    									String strTotalEtiqueta = "-";
	    									if(numActividades>0){
	    										strTotalEtiqueta = new BigDecimal(totalEtiqueta+"").divide(new BigDecimal(numActividades+""), 1, RoundingMode.DOWN)+"";
	    									}
	    									
	    									celda = new PdfPCell(new Phrase( strTotalEtiqueta, FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
			    							celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    							tabla.addCell(celda);
	    								}
	    							}
	    							
	    							/* SI NO TIENE ETIQUETAS ENTONCES SOLO LAS ACTIVIDADES */
	    							if(arr2.length == 0){
	    								for(String actividadId : arr){
	    									actividadId =  actividadId.split("&&")[0];
	    									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";

    										String notaAct = "-";
    	    								if( mapNotaActividades.containsKey( curso.getCursoId()+"@"+codigoAlumno+"@"+lisBloque.get(l).getBloqueId()+"@"+(actividadId) ) ){
    	    									notaAct = mapNotaActividades.get( curso.getCursoId()+"@"+codigoAlumno+"@"+lisBloque.get(l).getBloqueId()+"@"+(actividadId) );
    	    								}
    	    								
    			    						celda = new PdfPCell(new Phrase(notaAct, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
    		    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    		    		    				tabla.addCell(celda);
					    					
		    							}
	    							}
	    							
			    					
			    					switch(l+1){
			    						case 1:{
			    		    				celda = new PdfPCell(new Phrase( alumnoCurso.getCal1().equals("-")?"--": alumnoCurso.getCal1() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    		    			}break;
			    						case 2:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal2().equals("-")?"--": alumnoCurso.getCal2() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 3:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal3().equals("-")?"--": alumnoCurso.getCal3() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 4:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal4().equals("-")?"--": alumnoCurso.getCal4() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 5:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal5().equals("-")?"--": alumnoCurso.getCal5() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 6:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal6().equals("-")?"--": alumnoCurso.getCal6() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 7:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal7().equals("-")?"--": alumnoCurso.getCal7() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 8:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal8().equals("-")?"--": alumnoCurso.getCal8() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 9:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal9().equals("-")?"--": alumnoCurso.getCal9() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						case 10:{
			    							celda = new PdfPCell(new Phrase(alumnoCurso.getCal10().equals("-")?"--": alumnoCurso.getCal10() , FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
			    		    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
			    		    				tabla.addCell(celda);
			    						}break;
			    						
			    					}
			    				}
			    				boolean estanTodasCerradas = CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, alumnoCurso.getCursoId());
			    				//System.out.println("Cerradas:"+estanTodasCerradas);
			    				if(!estanTodasCerradas){
			    					String nota = "";
			    					if(cantidadBimestres!=0){
			    						nota = sumaBimestres.divide(new BigDecimal(cantidadBimestres+""), 1, RoundingMode.DOWN)+"";
			    					}
			    					celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    				}else{
			    					String nota = alumnoCurso.getNota();
			    					//System.out.println("Datos:"+alumnoCurso.getCodigoId()+":"+alumnoCurso.getCicloGrupoId() +":"+alumnoCurso.getCursoId()+":"+alumnoCurso.getNota());
			    					if(nota!=null){
			    						nota=frm.format(Float.parseFloat(nota.trim()));
			    					}
			    					celda = new PdfPCell(new Phrase(nota, FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    				}
			    		        if(!estanTodasCerradas){
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFNota(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    		        }
			    		        if(alumnoCurso.getNotaExtra() == null){
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getNotaExtra().trim(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    		        }
			    		        if(alumnoCurso.getFExtra() == null){
			    		        	celda = new PdfPCell(new Phrase("---", FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
				    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
				    				tabla.addCell(celda);
			    		        }else{
			    		        	celda = new PdfPCell(new Phrase(alumnoCurso.getFExtra(), FontFactory.getFont(FontFactory.HELVETICA, 6, Font.NORMAL, new BaseColor(0,0,0))));
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
	    			
	    			if(j==lisCurso.size()-1){	//Promedios
	    				boolean todasTienenCalificacion = true;
	    				
	    				celda = new PdfPCell(new Phrase(" ", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    				tabla.addCell(celda);
	    				celda = new PdfPCell(new Phrase("Promedio General", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    				tabla.addCell(celda);
	    				
	    				for(int l = 0; l < lisBloque.size(); l++){
	    					
	    					/* ACTIVIDADES */
							String [] arr = {};
							if(mapActividades.containsKey( lisBloque.get(l).getBloqueId() )){
								arr = mapActividades.get( lisBloque.get(l).getBloqueId() ).split("@");
							}
							
							
							/* ETIQUETAS */
							String [] arr2 = {};
							if(mapEtiquetas.containsKey( lisBloque.get(l).getBloqueId() )){
								arr2 = mapEtiquetas.get( lisBloque.get(l).getBloqueId() ).split("@");
							}
							
							for(String etiq : arr2){
								etiq =  etiq.split("&&")[0];
								
								for(String actividadId : arr){
									actividadId =  actividadId.split("&&")[0];
									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";

									if(etiq.equals(etiqAct)){
										
										celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
		    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
		    	        				tabla.addCell(celda);
			    						
									}
    							}
								
								if(!etiq.equals("0")){//La etiqueta 0 es la de "no aplica" por lo tanto no se despliega
									celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, new BaseColor(0,0,0))));
	    							celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    							tabla.addCell(celda);
								}
							}
							
							/* SI NO TIENE ETIQUETAS ENTONCES SOLO LAS ACTIVIDADES */
							if(arr2.length == 0){
								for(String actividadId : arr){
									actividadId =  actividadId.split("&&")[0];
									String etiqAct =  etiquetas.containsKey(lisBloque.get(l).getBloqueId()+"@@"+actividadId)==true ? etiquetas.get(lisBloque.get(l).getBloqueId()+"@@"+actividadId) : "";
										
									celda = new PdfPCell(new Phrase("", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
	    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
	    	        				tabla.addCell(celda);
			    					
    							}
							}
							
	    					
	    					if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){
	    						int materiasTmp = materias;
	    						materiasTmp = materiasTmp-materiasSinNota[l];
	    						
    	    					sumaPorBimestre[l] = new BigDecimal(sumaPorBimestre[l]+"").divide(new BigDecimal(materiasTmp+""), 1, RoundingMode.DOWN).floatValue();
    	    					celda = new PdfPCell(new Phrase( sumaPorBimestre[l]+"", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
    	        				celda.setHorizontalAlignment(Element.ALIGN_CENTER);
    	        				tabla.addCell(celda);
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
	    		    			notaDeTodas += sumaPorBimestre[l];
	    		    		}
	    		    		if(lisBloque.size()!=0){
	    		    			notaDeTodas = new BigDecimal(notaDeTodas+"").divide(new BigDecimal(lisBloque.size()+""), 1, RoundingMode.DOWN).floatValue();
	    		    		}
	    		    		celda = new PdfPCell(new Phrase( notaDeTodas+"", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, new BaseColor(0,0,0))));
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
	   	    	    	
	    				oficial = curso.getTipocursoId();
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
		<meta http-equiv='REFRESH' content='0; url=boletaActividades.pdf'>
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