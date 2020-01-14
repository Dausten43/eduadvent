<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>

<%@ page import = "com.itextpdf.text.*" %>
<%@ page import = "com.itextpdf.text.pdf.*" %>

<%@ page import="aca.catalogo.CatNivel"%>
<%@ page import="aca.alumno.AlumPlan"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumnoCursoLista" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>

<head>	
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId 			= (String)session.getAttribute("cicloId");	
	String codigoAlumno		= (String)session.getAttribute("codigoAlumno");	
	String planId 			= aca.alumno.AlumPlan.getPlanActual(conElias, codigoAlumno);
	
	String materias			= request.getParameter("Materias")==null?"N":request.getParameter("Materias");
	String bimestre1		= request.getParameter("Bimestre1")==null?"N":request.getParameter("Bimestre1");
	String bimestre2		= request.getParameter("Bimestre2")==null?"N":request.getParameter("Bimestre2");
	String bimestre3		= request.getParameter("Bimestre3")==null?"N":request.getParameter("Bimestre3");
	String bimestre4		= request.getParameter("Bimestre4")==null?"N":request.getParameter("Bimestre4");
	String bimestre5		= request.getParameter("Bimestre5")==null?"N":request.getParameter("Bimestre5");
	String promedio			= request.getParameter("Promedio")==null?"N":request.getParameter("Promedio");
	
	String nivel			= "0";
	String grado 			= "0";
	String grupo 			= "0";
	String cicloGrupoId		= "X";
	
	int posX 	= 450;
	int posY 	= 515;
	int salto	= 31;
	
	
	if (alumPersonal.existeReg(conElias, codigoAlumno)){
		alumPersonal.mapeaRegId(conElias,codigoAlumno);
		nivel 			= alumPersonal.getNivelId();
		grado 			= alumPersonal.getGrado();
		grupo 			= alumPersonal.getGrupo();
		cicloGrupoId	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias, nivel, grado, grupo, cicloId, planId);
	}	
	
	alumPersonal.mapeaRegId(conElias, codigoAlumno);
	ArrayList<aca.vista.AlumnoCurso> lisMaterias      = alumnoCursoLista.getListAlumCurso(conElias, codigoAlumno, cicloGrupoId,"ORDER BY ORDEN_CURSO_ID(CURSO_ID)");

	int extra				= 0;

	Document document = new Document(PageSize.LETTER.rotate()); //Crea un objeto para el documento PDF
	document.setMargins(35,35,20,20);

	
	
    
	try{
		String dir = application.getRealPath("/alumno/nota/")+"/"+"boleta.pdf";
		PdfWriter pdf = PdfWriter.getInstance(document, new FileOutputStream(dir));
		document.addAuthor("Sistema Escolar");
        document.addSubject("Boleta de Calificaciones");
        document.open();
        
        
        alumPersonal.mapeaRegId(conElias, codigoAlumno);      
       
	    for(int i=0; i<lisMaterias.size() ;i++ ){
	    	aca.vista.AlumnoCurso mat = (aca.vista.AlumnoCurso) lisMaterias.get(i);
	        PdfContentByte canvas = pdf.getDirectContentUnder();
	        
	        
	        
	     	// Despliega el nombre de las Materias  
	        if (materias.equals("S")){
	        	//System.out.println("Materia:"+mat.getCursoId()+":"+aca.plan.PlanCurso.getCursoCorto(conElias, mat.getCursoId()));
	        	
	        	Phrase asi = new Phrase(aca.plan.PlanCurso.getCursoCorto(conElias, mat.getCursoId()), FontFactory.getFont(FontFactory.HELVETICA, BaseFont.CP1252, 6, Font.BOLD, new BaseColor(0,0,0)) );
	        	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, asi, posX, posY-(salto*i), 0);
	        }
	        
	     	// Despliega las notas del primer bimestre
	        if (bimestre1.equals("S")){
	        	Phrase asi = new Phrase( mat.getCal1().equals("0")?"0":mat.getCal1() );	        	
	        	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, asi, posX+75, posY-(salto*i), 0);
	        }
	     	
	     	// Despliega las notas del Segundo bimestre
	        if (bimestre2.equals("S")){
	        	Phrase asi = new Phrase( mat.getCal2().equals("0")?"0":mat.getCal2() );
	        	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, asi, posX+110, posY-(salto*i), 0);
	        }
	     	
	     	// Despliega las notas del tercer bimestre
	        if (bimestre3.equals("S")){
	        	Phrase asi = new Phrase( mat.getCal3().equals("0")?"0":mat.getCal3() );
	        	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, asi, posX+150, posY-(salto*i), 0);
	        }
	     	
	     	// Despliega las notas del Cuarto bimestre
	        if (bimestre4.equals("S")){
	        	Phrase asi = new Phrase( mat.getCal4().equals("0")?"0":mat.getCal4() );
	        	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, asi, posX+190, posY-(salto*i), 0);
	        }
	     	
	     	// Despliega las notas del Quinto bimestre
	        if (bimestre5.equals("S")){
	        	Phrase asi = new Phrase( mat.getCal5().equals("0")?"0":mat.getCal5() );
	        	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, asi, posX+230, posY-(salto*i), 0);
	        }
	     	// Despliega El promedio
	     	float uno = Float.parseFloat(mat.getCal1());
	     	float dos = Float.parseFloat(mat.getCal2());
	     	float tres = Float.parseFloat(mat.getCal3());
	     	float cuatro = Float.parseFloat(mat.getCal4());
	     	float cinco = Float.parseFloat(mat.getCal5());
	     	
	     	System.out.println("Bimestres: "+uno+", "+dos+", "+", "+tres+", "+cuatro+", "+cinco);
	     	int divisor=5;
	     	if(uno==0){
	     		divisor--;
	     	}
	     	if(dos==0){
	     		divisor--;
	     	}
	     	if(tres==0){
	     		divisor--;
	     	}
	     	if(cuatro==0){
	     		divisor--;
	     	}
	     	if(cinco==0){
	     		divisor--;
	     	}
	     	
	     	
	     	float sum= uno+dos+tres+cuatro+cinco;
	     	System.out.println(sum);
     		double prom = (double)sum/(double)divisor;
	     	System.out.println(prom);
	     	DecimalFormat decimal = new DecimalFormat("0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	     	
	     	String n = String.valueOf(decimal.format(prom));
	     	
	        if (promedio.equals("S")){
	        	Phrase asi = new Phrase(n);
	        	ColumnText.showTextAligned(canvas, Element.ALIGN_RIGHT, asi, posX+270, posY-(salto*i), 0);
	        }
	     	
		}
       
	}catch(IOException ioe) {
		System.err.println("Error credencial en PDF: "+ioe.getMessage());
	}
			
	document.close();
%>
<head>
	<meta http-equiv='REFRESH' content='0; url=boleta.pdf'>	
</head>
<%@ include file="../../cierra_elias.jsp" %>