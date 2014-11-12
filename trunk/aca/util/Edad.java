package aca.util;
import java.util.*;

public class Edad{
	
	public static void main(String[] args){
		
		// Opcion # 1
		 
	    long inicio = System.currentTimeMillis();
	    
	    Calendar dateOfBirth = new GregorianCalendar(2006, Calendar.MARCH, 07);
	    Calendar today = Calendar.getInstance();
	    int age = today.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR);
	    dateOfBirth.add(Calendar.YEAR, age);
	    if (today.before(dateOfBirth))
	        age--;
	    long fin = System.currentTimeMillis();    
	    System.out.println("Opcion # 1---> Edad:"+age+" Time:"+(fin-inicio));
		
		// Opcion # 2 ----> 1 año = 365.2475 días
		
		long inicio2 = System.currentTimeMillis();
		long diferencia = 0;
		int edad	= 0;
		java.util.Date fecha1 = new java.util.Date();
		java.util.Date fecha2 = new java.util.Date();
		
		try{		
		    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
		    fecha1 		= sdf.parse("08/03/1977");
		    fecha2		= sdf.parse("07/03/2012");
		    diferencia 	= fecha2.getTime()-fecha1.getTime();
		    edad 		= (int)Math.floor(diferencia / (1000 * 60 * 60 * 24 * 365.2475));
		}catch (java.text.ParseException ex){
			System.out.println("Error en formato de fecha:"+ex);
		}
		long fin2 = System.currentTimeMillis();
	    System.out.println("Opcion # 2---> Edad:"+edad+" Time:"+(fin2-inicio2));	
	    
	    
	}
	
	public static int getEdad(String fecha){// FORMATO -> 01/12/2011 ("dia/mes/a�o")
		
		
		
		int year	=0;
		int month	=0;
		int day		=0;
		
		String[]  arrFecha = fecha.split("/");
		year	= Integer.parseInt(arrFecha[2]);
		month	= Integer.parseInt(arrFecha[1])-1;
		day		= Integer.parseInt(arrFecha[0]);
		
		if(!fecha.contains("/"))System.out.println(fecha);
		
		//long inicio = System.currentTimeMillis();
	    Calendar dateOfBirth = new GregorianCalendar(year, month, day);
	    Calendar today = Calendar.getInstance();
	    int age = today.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR);
	    dateOfBirth.add(Calendar.YEAR, age);
	    if (today.before(dateOfBirth))
	        age--;
	    //long fin = System.currentTimeMillis();    
	    
	    return age;
	}
}