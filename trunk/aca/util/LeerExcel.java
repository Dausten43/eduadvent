// Utileria de claves
package aca.util;
import java.io.FileInputStream;
import java.io.IOException;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

// Creaci{on de claves de usuarios
public class LeerExcel{
	
	public static void main(String[] args){
		
		java.text.DecimalFormat formato = new java.text.DecimalFormat("####;-####", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		
		try{	
			FileInputStream file = new FileInputStream("C:/Trabajo/Alumno.xls");

		    HSSFWorkbook workbook = new HSSFWorkbook(file);
		    HSSFSheet sheet = workbook.getSheetAt(0);
		    
		    java.util.Iterator<Row> rowIterator = sheet.iterator();
		    while(rowIterator.hasNext()) {//ROWS
		        Row row = rowIterator.next();
		        
		        java.util.Iterator<Cell> cellIterator = row.iterator();
		        while(cellIterator.hasNext()){      	
		    		Cell cell		= cellIterator.next();
		    		
		    		String dato = "";
		            if(cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
		            	if (cell.getCellStyle().getDataFormat()==0){
		            		dato = formato.format(cell.getNumericCellValue());
		            	}else{
		            		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");    	
		    		    	dato = sdf.format(cell.getDateCellValue());
		            	}		            	
		            	System.out.println("Dato:"+dato);
		            }else{
		            	System.out.println("String:"+cell.toString());
		            }		            
		    	}
		    }
		    file.close();

		}catch (IOException e) {
		    e.printStackTrace();
		}finally{
			
		}
	}
}