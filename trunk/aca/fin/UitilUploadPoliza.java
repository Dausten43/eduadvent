package aca.fin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import aca.usuario.Usuario;

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
		
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		
		Usuario usrObj = new Usuario();
		
		String usuario = "x";
		
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		
		
		
		try {
			lsFileItem = upload.parseRequest(request);
		}catch(FileUploadException fue) {
			
		}
		
		String folio = "";

	    List<FinMovimientos> lsMovimientos = new ArrayList<FinMovimientos>();
	    List<FinMovimientos> lsErrores = new ArrayList<FinMovimientos>();
	    FinPoliza poliza = new FinPoliza();
		int error = 0;
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
				    int mov_id =0;
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
				    	
				    
				    	//
				    	
				    	
				    	
				    	if((a!=null && !a.getStringCellValue().trim().isEmpty() )) {
				    		
					    	String ejercicio = a.getStringCellValue().trim() +  "-" + year;
					    	

					    	if(c!=null) {
					    		
						    	if(linea==1) {
						    		//System.out.println(linea + "--->>" + a.getCellType() + " - " +b.getCellType() + " - " +c.getCellType() + " - " +d.getCellType()  );
						    		System.out.println("fecha  + " + b.getStringCellValue());
						    		poliza = new FinPoliza();
						    		folio = a.getStringCellValue().trim() + poliza.maximoReg(con, ejercicio);
						    		
						    		poliza.setPolizaId(folio);
						    		poliza.setEjercicioId(ejercicio);
						    		poliza.setFecha(b.getStringCellValue().trim());
						    		poliza.setUsuario( c.getStringCellValue().length()>8 ? c.getStringCellValue().substring(0,8).toUpperCase() :  c.getStringCellValue().trim().toUpperCase());
						    		poliza.setDescripcion(d.getStringCellValue().trim());
						    		poliza.setTipo("G");
						    		poliza.setEstado("A");
						    		
						    		//poliza.insertReg(con);
						    		
						    	}else {
						    		//System.out.println(linea + "--->>" + a.getCellType() + " - " +b.getCellType() + " - " +c.getCellType() + " - " +d.getCellType() + " - " +e.getCellType() + " - " +f.getCellType() + " - " +g.getCellType() + " - " +h.getCellType() );
						    		if((f.getCellType()==0)) {
						    		mov_id++;
						    		//System.out.println(folio);
						    		FinMovimientos mv = new FinMovimientos();
						    		mv.setEjercicioId(ejercicio);
						    		mv.setPolizaId(folio);
						    		mv.setMovimientoId(mov_id + "" );
						    		mv.setCuentaId(e.getStringCellValue().trim());
						    		mv.setAuxiliar(c.getStringCellValue().trim());
						    		mv.setDescripcion(g.getStringCellValue().trim());
						    		mv.setImporte(f.getNumericCellValue() + "");
						    		mv.setNaturaleza(h.getStringCellValue().trim().toUpperCase().startsWith("C") ? "C" : "D");
						    		mv.setEstado("R");
						    		mv.setFecha(b.getStringCellValue());
						    		mv.setReciboId("0");
						    		mv.setCicloId("00000000");
						    		mv.setPeriodoId("0");
						    		mv.setTipoMovId("0");
						    		
						    		lsMovimientos.add(mv);
						    		}else{
							    		System.out.println("celda vacia");
							    		FinMovimientos errorm = new FinMovimientos();
							    		errorm.setEjercicioId("ERROR EN LA LINEA " + linea) ;
							    		lsErrores.add(errorm);
							    		error++;
							    	}
						    	}
					    	}else {
					    		error++;
					    	}
				    	}else {
				    		System.out.println("celda vacia");
				    		error++;
				    		//FinMovimientos error = new FinMovimientos();
				    		//error.setEjercicioId("ERROR EN LA LINEA " + linea) ;
				    		//lsErrores.add(error);
				    	}
				    	 if(error == 5) {
					        	break;
					        }
				    }
				   	
				    
				    
				   		
		    		}catch(IOException ioe) {
		    			
		    		}catch(SQLException sqle) {
		    			
		    		}
		    	}
		    	
		    }
		}
		System.out.println(error);
		if(poliza!=null && !lsMovimientos.isEmpty() && lsErrores.isEmpty()) {
			
			try {
				
				poliza.insertReg(con);
				
				for(FinMovimientos fm : lsMovimientos) {
					fm.insertReg(con);
				}
			}catch(Exception sqle) {
				
			}
			
		}
		
		
		
		
		if(!lsErrores.isEmpty()) {
			lsMovimientos = new ArrayList<FinMovimientos>();
			lsMovimientos.addAll(lsErrores);
		}
		
				return lsMovimientos;
	}
}
