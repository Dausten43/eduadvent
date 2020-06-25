package aca.fin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;



import aca.conecta.Conectar;

public class UitilUploadPoliza {
	
	private Connection con;
	
	public UitilUploadPoliza() {
		con = new Conectar().conEliasPostgres();
	}
	
	public void close() {
		try {
			con.close();
		} catch (SQLException sqle) {

		}
	}
	
	
	public List<FinMovimientos> uploadFile(HttpServletRequest request) {
		DiskFileItemFactory factory 	= new DiskFileItemFactory();
		ServletFileUpload upload 		= new ServletFileUpload(factory);
		List<FileItem> lsFileItem = new ArrayList<FileItem>();
		
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		
		
		
		try {
			lsFileItem = upload.parseRequest(request);
		}catch(FileUploadException fue) {
			
		}
		
		String folio = null;

	    List<FinMovimientos> lsMovimientos = new ArrayList<FinMovimientos>();
	    FinPoliza poliza = new FinPoliza();
		
		for(FileItem fi : lsFileItem) {
			String fieldname 	= fi.getFieldName();
		    String filename 	= fi.getName();
		    
		    if(fieldname.equals("archivo")){
		    	java.io.InputStream is = null;
		    	
		    	try {
		    		is = fi.getInputStream();
		    	}catch(IOException ioe) {
		    		
		    	}
		    	
		    	if(is!=null) {
		    		try {
		    		//Get the workbook instance for XLS file 
				    XSSFWorkbook workbook = new XSSFWorkbook(is);
					//Iterate through each sheet of the excel file
					java.util.Iterator<XSSFSheet> sheetIterator = workbook.iterator();
					int cont = 0;
					
					// Lee las hojas del archivo
					sheetIterator = workbook.iterator();			
				    XSSFSheet sheet = sheetIterator.next();
				   	
				    int linea = 0;
				    java.util.Iterator<Row> rowIterator = sheet.iterator();

				    while(rowIterator.hasNext()) {			    	
				        Row row = rowIterator.next();
				        //System.out.println("linea:"+linea);
				        linea++;
				        
				        // Obtener los datos de las columnas en el renglón actual
				        
				        Cell a			= row.getCell(0);
				    	Cell b		= row.getCell(1);
				    	Cell c		 	= row.getCell(2);
				    	Cell d	= row.getCell(3);
				    	Cell e	  	= row.getCell(4);			    	
				    	Cell f 		= row.getCell(5);			    	
				    	Cell g	 	= row.getCell(6);
				    	Cell h 	= row.getCell(7);
				    	Cell i 		= row.getCell(8);
				    	Cell j 	= row.getCell(9);
				    	Cell k		= row.getCell(10);
				    	Cell l 			= row.getCell(11);
				    	Cell m 			= row.getCell(12);
				    	
				    	
				    	
				    	
				    	
				    	
				    	if(linea==1) {
				    		
				    		folio = a.getStringCellValue().substring(0,3) + poliza.maximoReg(con, a.getStringCellValue().trim());
				    	   		
				    		poliza.setPolizaId(folio);
				    		poliza.setEjercicioId(a.getStringCellValue());
				    		poliza.setFecha(sdf.format(b.getDateCellValue()));
				    		poliza.setUsuario(c.getStringCellValue());
				    		poliza.setDescripcion(d.getStringCellValue());
				    		poliza.setTipo("G");
				    		poliza.setEstado("A");
				    		
				    		//poliza.insertReg(con);
				    		
				    	}else {
				    		
				    		
				    		
				    		
				    		
				    		//System.out.println(folio);
				    		FinMovimientos mv = new FinMovimientos();
				    		mv.setEjercicioId(a.getStringCellValue().trim());
				    		mv.setPolizaId(folio);
				    		mv.setMovimientoId((int) b.getNumericCellValue() + "" );
				    		mv.setCuentaId(f.getStringCellValue().trim());
				    		mv.setAuxiliar(d.getStringCellValue().trim());
				    		mv.setDescripcion(h.getStringCellValue().trim());
				    		mv.setImporte(g.getNumericCellValue() + "");
				    		mv.setNaturaleza(i.getStringCellValue().trim().toUpperCase().startsWith("C") ? "C" : "D");
				    		mv.setEstado("R");
				    		mv.setFecha(sdf.format(c.getDateCellValue()));
				    		mv.setReciboId("0");
				    		mv.setCicloId("00000000");
				    		mv.setPeriodoId("0");
				    		mv.setTipoMovId("0");
				    		
				    		lsMovimientos.add(mv);
				    		
				    		
				    	}
				    	
				    }
				   	
				    
				    
				   		
		    		}catch(IOException ioe) {
		    			
		    		}catch(SQLException sqle) {
		    			
		    		}
		    	}
		    	
		    }
		}
		
		try {
			
			poliza.insertReg(con);
			
			for(FinMovimientos fm : lsMovimientos) {
				fm.insertReg(con);
			}
		}catch(SQLException sqle) {
			
		}
		return lsMovimientos;
	}
}
