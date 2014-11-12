
package aca.util;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;

public class CompararIdiomas {
	
	public static void main(String[] args) {	
		
		try {  
			   
			HashMap<String, String> mapEng = new HashMap<String,String>();  
			File archivo1 = new File("messages.jsp");
			File archivo2 = new File("messages_en.jsp");
			long timeInicio=0, timeFinal = 0;
			  
			timeInicio = System.currentTimeMillis();
		    if (archivo2.exists()){
		    	
		    	BufferedReader archivoEn = new BufferedReader(new FileReader(archivo2));
		    	String linea = "";
		    	String llave = "";
		    	String valor = ""; 
		    	int row = 1;
		    	
		    	
		    	while(archivoEn.ready()){
		    		linea= archivoEn.readLine();
		    		if (linea.indexOf("=")!= -1){
		    			llave = linea.substring(0,linea.indexOf("=")).trim();
		    			valor = linea.substring(linea.indexOf("=")+1,linea.length()).trim();
		    			//System.out.println("Map= "+row+" Llave:"+llave+" Valor:"+valor);
		    			mapEng.put(llave, "Renglón:"+String.valueOf(row)+"|Valor:"+valor);		
		    		}		
		    		row++;		    		
		    	}
		    	archivoEn.close();
		    }	
		    timeFinal = System.currentTimeMillis();
		    
		    
		    
		    
		    //Comparar con el messages en español
		    if(archivo1.exists()){
		    	BufferedReader archivoEsp = new BufferedReader(new FileReader(archivo1));
		    	int row = 1;
		    	while(archivoEsp.ready()){
		    		String linea = archivoEsp.readLine();
		    		if (linea.indexOf("=")!= -1){
			    		linea = linea.substring(0,linea.indexOf("=")).trim();
			    		if(!mapEng.containsKey(linea)){
			    			System.out.println(linea+" no se encuentra en el archivo de inglés. Línea = "+row);
			    		}
			    		
		    		}
		    		row++;
		    	}
		    	archivoEsp.close();
		    }
		    
		    System.out.println("Tiempo:"+(timeFinal-timeInicio)+" milisegundos");
		    
		    /*
		      if(archivo1.exists() && archivo2.exists()){
		          BufferedReader Flee1= new BufferedReader(new FileReader(archivo1));
		          BufferedReader Flee2= new BufferedReader(new FileReader(archivo2));
		          
		          String linea1="", linea2="";  
		          
		          int contador1=0,contador2=0,contador=0;  
		            
		          while(linea1!=null || linea2!=null){  
		              linea1=Flee1.readLine();  
		              linea2=Flee2.readLine();
		              if(linea1!=null){  
		                  contador1++;  
		              }  
		              if(linea2!=null){  
		                  contador2++;  
		              }		              
		              contador++;
		              
		              //si no es la ultima lectura para algun archivo para evitar excepcion por null  
		              if(linea1!=null && linea2!=null) {   
		                  //Si no son iguales las lineas  
		                  if(!linea1.equals (linea2)){		    
		                	  
		                     System.out.println("Lineas diferentes: " + contador1+" "+ linea1 +" " +contador2+ " "+ linea2);
		                  }     
		              }else{  
		                   //si no es la ultima entrada al while donde ambos son null  
		                  if(!(linea1==null && linea2==null)) {   
		                    
		                  }  
		              }  
		          }  
		          System.out.println("Fin Comparacion");
		          Flee1.close();  
		          Flee2.close();
		          
		        }else{  
		          System.out.println("Alguno de los archivos no existe");  
		        }
		          */
		  } catch (Exception ex) {
		       System.out.println(ex.getMessage());  
		  } 
   }
}
