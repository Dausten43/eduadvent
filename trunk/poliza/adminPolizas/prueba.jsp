<!-- 

	YOU NEED THIS JARS IN YOUR JAVA BUILD PATH FOR READING AN EXCEL FILE:
	dom4j-1.6.1.jar
	poi-3.7.jar
	poi-ooxml-3.7.jar
	poi-ooxml-schemas-3.7.jar
	xmlbeans-2.3.0.jar

 -->

<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="java.io.*" %>


<%

	String dir 			= application.getRealPath("/poliza/adminPolizas/")+"/Ledger_Import.xls";
	String dir2 		= application.getRealPath("/poliza/adminPolizas/")+"/Ledger_Import2.xls";

	
	FileInputStream input_document 		= new FileInputStream(new File(dir));	
	HSSFWorkbook my_xls_workbook 		= new HSSFWorkbook(input_document); 
	HSSFSheet my_worksheet 				= my_xls_workbook.getSheetAt(1);
	
	Cell cell = null; 
	cell = my_worksheet.getRow(7).getCell(1);
	cell.setCellValue("JAJAJAJAJAJAJAJA....");

	input_document.close();
	FileOutputStream output_file =new FileOutputStream(new File(dir2));
	my_xls_workbook.write(output_file);
	output_file.close();   
	 


%>