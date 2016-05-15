// Utileria de fecha
package aca.util;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.ArrayList;

public class Fecha{
	
	public String getFecha( String Formato ){
		String s_fecha = "";
		Calendar fecha = new GregorianCalendar();
		String dia = null;
		String mes = null;
		if (Formato.equals("1")){
			dia = Integer.toString(fecha.get(Calendar.DAY_OF_MONTH));
			if (dia.length() == 1) dia = "0" + dia;
			mes = Integer.toString(fecha.get(Calendar.MONTH)+1);
			if (mes.length() == 1) mes = "0" + mes;
			
			s_fecha = dia+"/"+mes+"/"+Integer.toString(fecha.get(Calendar.YEAR));
		}else{			
		
			switch(fecha.get(Calendar.DAY_OF_WEEK)) {
			case Calendar.SUNDAY: 		dia = "Domingo";	break;
			case Calendar.MONDAY: 		dia = "Lunes";		break;
			case Calendar.TUESDAY:		dia = "Martes";		break;
			case Calendar.WEDNESDAY:	dia = "Miercoles";	break;
			case Calendar.THURSDAY:		dia = "Jueves";		break;
			case Calendar.FRIDAY:		dia = "Viernes";	break;
			case Calendar.SATURDAY:		dia = "S�bado";		break;
			}
			
			switch(fecha.get(Calendar.MONTH)) {
			case Calendar.JANUARY:		mes = "Enero";		break;
			case Calendar.FEBRUARY:		mes = "Febrero";	break;
			case Calendar.MARCH:		mes = "Marzo";		break;
			case Calendar.APRIL:		mes = "Abril";		break;
			case Calendar.MAY:			mes = "Mayo";		break;
			case Calendar.JUNE:			mes = "Junio";		break;
			case Calendar.JULY:			mes = "Julio";		break;
			case Calendar.AUGUST:		mes = "Agosto";		break;
			case Calendar.SEPTEMBER:	mes = "Setiembre";	break;
			case Calendar.OCTOBER:		mes = "Octubre";	break;
			case Calendar.NOVEMBER:		mes = "Noviembre";	break;
			case Calendar.DECEMBER:		mes = "Diciembre";	break;
			}
		
			s_fecha = dia + ", "+Integer.toString(fecha.get(Calendar.DAY_OF_MONTH))+"/ "+mes+"/ "+
				Integer.toString(fecha.get(Calendar.YEAR));
		}	
		return s_fecha;
	}
	
	public String getDia( String Fecha ){
		String s_dia = "";
		
		s_dia = Fecha.substring(0,2);
		
		return s_dia;
	}
	
	public String getMesNombre( String Fecha ){		
		int nmes = Integer.parseInt(Fecha.substring(3,5));
		String mes = "";
		switch(nmes) {
			case 1:		mes = "enero";		break;
			case 2:		mes = "febrero";	break;
			case 3:		mes = "marzo";		break;
			case 4:		mes = "abril";		break;
			case 5:		mes = "mayo";		break;
			case 6:		mes = "junio";		break;
			case 7:		mes = "julio";		break;
			case 8:		mes = "agosto";		break;
			case 9:		mes = "septiembre";	break;
			case 10:	mes = "octubre";	break;
			case 11:	mes = "noviembre";	break;
			case 12:	mes = "diciembre";	break;
		}		
		return mes;
	}
	
	public static String getMesNombre( int nMes ){		
		String mes = "";
		switch(nMes) {
			case 1:		mes = "Enero";		break;
			case 2:		mes = "Febrero";	break;
			case 3:		mes = "Marzo";		break;
			case 4:		mes = "Abril";		break;
			case 5:		mes = "Mayo";		break;
			case 6:		mes = "Junio";		break;
			case 7:		mes = "Julio";		break;
			case 8:		mes = "Agosto";		break;
			case 9:		mes = "Septiembre";	break;
			case 10:	mes = "Octubre";	break;
			case 11:	mes = "Noviembre";	break;
			case 12:	mes = "Diciembre";	break;
		}		
		return mes;
	}
	
	public static String getFechaCorta( String Fecha ){		
		String dia = Fecha.substring(0,2);
		String mes = "";
		String year = Fecha.substring(8,10);
		int nmes = Integer.parseInt(Fecha.substring(3,5));
		switch(nmes) {
			case 1:		mes = "Ene";		break;
			case 2:		mes = "Feb";	break;
			case 3:		mes = "Mar";		break;
			case 4:		mes = "Abr";		break;
			case 5:		mes = "May";		break;
			case 6:		mes = "Jun";		break;
			case 7:		mes = "Jul";		break;
			case 8:		mes = "Ago";		break;
			case 9:		mes = "Sep";	break;
			case 10:	mes = "Oct";	break;
			case 11:	mes = "Nov";	break;
			case 12:	mes = "Dic";	break;
		}		
		return dia+"/"+mes+"/"+year;
	}

	public String getMes( String Fecha ){		
		String s_mes = "";
		
		s_mes = Fecha.substring(3,5);
		
		return s_mes;
	}	
	
	public String getYear( String Fecha ){
		String s_Year = "";
		
		s_Year = Fecha.substring(6,10);
		
		return s_Year;
	}
	
	
	public static String getDateTime(){
		
		String time = aca.util.Fecha.getHoraDelDia() + ":" + aca.util.Fecha.getMinutos() + ":" + aca.util.Fecha.getSegundos();
		String date = aca.util.Fecha.getHoy(); 
		
		return date + " " + time;
	}
	
	public static String getHoy( ){
		String s_fecha = "";
		Calendar fecha = new GregorianCalendar();		
		String dia = null;
		String mes = null;		
		
		dia = Integer.toString(fecha.get(Calendar.DAY_OF_MONTH));
		if (dia.length() == 1) dia = "0" + dia;
		mes = Integer.toString(fecha.get(Calendar.MONTH)+1);
		if (mes.length() == 1) mes = "0" + mes;
		
		s_fecha = dia+"/"+mes+"/"+Integer.toString(fecha.get(Calendar.YEAR));
		
		return s_fecha;
	}
	
	public static String getInicioMes( ){
		String s_fecha = "";
		Calendar fecha = new GregorianCalendar();
		String dia = "01";
		String mes = Integer.toString(fecha.get(Calendar.MONTH)+1);
		if (mes.length() == 1) mes = "0" + mes;
		
		s_fecha = dia+"/"+mes+"/"+Integer.toString(fecha.get(Calendar.YEAR));
		
		return s_fecha;
	}
	
	public static int getYearNum(){
		Calendar fecha = new GregorianCalendar();
		
		return fecha.get(Calendar.YEAR);
	}
	
	public String getNombreDia(String fecha)throws Exception{
		String dia = "";
		Calendar calendario = new GregorianCalendar();
		java.text.DateFormat datef = java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT,new Locale("es","SPANISH"));
		calendario.setTime(datef.parse(fecha));
		switch(calendario.get(Calendar.DAY_OF_WEEK)) {
			case Calendar.SUNDAY: 		dia = "Domingo";	break;
			case Calendar.MONDAY: 		dia = "Lunes";		break;
			case Calendar.TUESDAY:		dia = "Martes";		break;
			case Calendar.WEDNESDAY:	dia = "Miercoles";	break;
			case Calendar.THURSDAY:		dia = "Jueves";		break;
			case Calendar.FRIDAY:		dia = "Viernes";	break;
			case Calendar.SATURDAY:		dia = "Sabado";		break;
		}
		return dia;
	}
	public String getStringFecha(Calendar calendario){
		String fecha = "", dia="",mes="";		
		dia = String.valueOf(calendario.get(Calendar.DAY_OF_MONTH));
		if (dia.length() == 1) dia = "0" + dia;
		mes = Integer.toString(calendario.get(Calendar.MONTH)+1);
		if (mes.length() == 1) mes = "0" + mes;
		fecha = dia+"/"+mes+"/"+String.valueOf(calendario.get(Calendar.YEAR));
		return fecha;
		
	}
	public ArrayList<String> getSemana(String fechaActual)throws Exception{
		GregorianCalendar calendario = new GregorianCalendar();
		java.text.DateFormat datef = java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT,new Locale("es","SPANISH"));
		calendario.setTime(datef.parse(fechaActual));
		ArrayList<String> listor	= new ArrayList<String>();
		listor.add(getStringFecha(calendario));
		for (int i=1;i<7;i++){
			calendario.add(Calendar.DATE,1);
			listor.add(getStringFecha(calendario));
		}
		return listor;
	}
	public ArrayList<String> getSemanaActual()throws SQLException{
		GregorianCalendar calendario = new GregorianCalendar();
		//java.text.DateFormat datef = java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT,new Locale("es","SPANISH"));
		ArrayList<String> listor	= new ArrayList<String>();
		listor.add(getStringFecha(calendario));
		for (int i=1;i<7;i++){
			calendario.add(Calendar.DATE,1);
			listor.add(getStringFecha(calendario));
		}
		return listor;
	}
	public String getSemanaAnterior(String fechaInicio)throws Exception{
		GregorianCalendar calendario = new GregorianCalendar();
		java.text.DateFormat datef = java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT,new Locale("es","SPANISH"));
		calendario.setTime(datef.parse(fechaInicio));
		calendario.add(Calendar.DATE,-7);
		return getStringFecha(calendario);
	}
	public String getSemanaSiguiente(String fechaInicio)throws Exception{
		GregorianCalendar calendario = new GregorianCalendar();
		java.text.DateFormat datef = java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT,new Locale("es","SPANISH"));
		calendario.setTime(datef.parse(fechaInicio));
		calendario.add(Calendar.DATE,7);
		
		return getStringFecha(calendario);
	}
	
	public String getFechaTexto(String fecha){
		String texto = "";
		texto = fecha.substring(0,2)+" de "+ getMesNombre(fecha)+" del "+fecha.substring(6);
		return texto;
	}
	
	public static String getPeriodoActual(){
		String hoy = getHoy();
		Fecha fecha = new Fecha();
		String texto="";
		
		if(Integer.parseInt(fecha.getMes(hoy)) < 8){
			texto = (Integer.parseInt(fecha.getYear(hoy))-1) + "-" +fecha.getYear(hoy);
		}
		if(Integer.parseInt(fecha.getMes(hoy)) == 8){
			if(Integer.parseInt(fecha.getDia(hoy)) < 20){
				texto = (Integer.parseInt(fecha.getYear(hoy))-1) + "-" +fecha.getYear(hoy);
			}else{
				texto =  fecha.getYear(hoy) + "-" + (Integer.parseInt(fecha.getYear(hoy))+1);
			}
		}
		if(Integer.parseInt(fecha.getMes(hoy)) > 8){
			texto =  fecha.getYear(hoy) + "-" + (Integer.parseInt(fecha.getYear(hoy))+1);
		}
		
		return texto;
	}
	
	public static String getPeriodoMes(String fecha){
		Fecha date = new Fecha();
		String texto="";
		
		if(Integer.parseInt(date.getMes(fecha)) >= 1 && Integer.parseInt(date.getMes(fecha)) <= 6){
			if(Integer.parseInt(date.getMes(fecha)) == 6){
				if(Integer.parseInt(date.getDia(fecha)) < 10){
					texto = "enero a mayo";
				}
			}else{
				texto = "enero a mayo";
			}
		}
		
		if(Integer.parseInt(date.getMes(fecha)) >= 6 && Integer.parseInt(date.getMes(fecha)) <= 8){
			if(Integer.parseInt(date.getMes(fecha)) == 6){
				if(Integer.parseInt(date.getDia(fecha)) >= 10){
					texto = "junio a agosto";
				}
			}
			if(Integer.parseInt(date.getMes(fecha)) == 8){
				if(Integer.parseInt(date.getDia(fecha)) <= 15){
					texto = "junio a agosto";
				}
			}else{
				texto = "junio a agosto";
			}
		}
		
		if(Integer.parseInt(date.getMes(fecha)) >= 8 && Integer.parseInt(date.getMes(fecha)) <= 12){
			if(Integer.parseInt(date.getMes(fecha)) == 8){
				if(Integer.parseInt(date.getDia(fecha)) > 15){
					texto = "agosto a diciembre";
				}
			}else{
				texto = "agosto a diciembre";
			}
		}
		
		return texto;
	}
	
	public static String getTime( ){
		int hora=0,minuto=0,segundo=0,milisegundo;
		String time = "";
		
		Calendar fecha = new GregorianCalendar();		
		hora 		= fecha.get(Calendar.HOUR);
		minuto		= fecha.get(Calendar.MINUTE);
		segundo		= fecha.get(Calendar.SECOND);
		milisegundo = fecha.get(Calendar.MILLISECOND);
		time = String.valueOf(hora)+":"+String.valueOf(minuto)+":"+String.valueOf(segundo)+"."+String.valueOf(milisegundo)+" "+fecha.get(Calendar.AM_PM);
		
		return time;
	}
	
	public static String getHora(){	
		return String.valueOf(new GregorianCalendar().get(Calendar.HOUR));
	}
	
	public static String getHoraDelDia(){	
		return String.valueOf(new GregorianCalendar().get(Calendar.HOUR_OF_DAY));
	}
	
	public static String getMinutos(){	
		return String.valueOf(new GregorianCalendar().get(Calendar.MINUTE));
	}
	
	public static String getSegundos(){	
		return String.valueOf(new GregorianCalendar().get(Calendar.SECOND));
	}
	
	public static int getAMPM(){
		return new GregorianCalendar().get(Calendar.AM_PM);
	}
	
	public static String getNextFecha( String fecha, int meses){
		String dia 			= fecha.substring(0,2);
		String mes			= fecha.substring(3,5);
		int numMes 			= Integer.parseInt(mes);
		int year 			= Integer.parseInt(fecha.substring(6,10));
		
		numMes = numMes+meses;
		if (numMes>12){
			year = year+1;
			numMes=numMes-12;
		}
		
		mes = String.valueOf(numMes);
		if (mes.length()==1) mes = "0" + mes;
		
		String nuevaFecha	= dia+"/"+mes+"/"+String.valueOf(year);
		
		return nuevaFecha;
	}
	
	public static boolean getFechaBetween(String fechaInicio, String fechaFinal){
		
		boolean respuesta	= false;
		Date hoy 			= new Date();
		try{
			
			java.text.SimpleDateFormat formatoFecha = new java.text.SimpleDateFormat("dd/MM/yyyy");
			Date fechaIni 	= formatoFecha.parse(fechaInicio);
			Date fechaFin 	= formatoFecha.parse(fechaFinal);

			if (hoy.compareTo(fechaIni)>= 0 && hoy.compareTo(fechaFin) <= 0)
				respuesta = true;
		
		}catch (java.text.ParseException ex){
			System.out.println("Error en formato de fecha:"+ex);
		}		
			
		return respuesta;
	}
	
	public static boolean getFechaMayorQueHoy(String fechaInicio){
		
		boolean respuesta	= false;
		Date hoy 			= new Date();
		try{
			
			java.text.SimpleDateFormat formatoFecha = new java.text.SimpleDateFormat("dd/MM/yyyy");
			Date fechaIni 	= formatoFecha.parse(fechaInicio);

			if (fechaIni.compareTo(hoy)>= 0)
				respuesta = true;
		
		}catch (java.text.ParseException ex){
			System.out.println("Error en formato de fecha:"+ex);
		}		
			
		return respuesta;
	}
	
	public static int getDiaSemana(){
		java.util.Date hoy 	= new java.util.Date();
	    int numeroDia		= 0;
	    Calendar cal		= Calendar.getInstance();
	    
	    cal.setTime(hoy);
	    numeroDia = cal.get(Calendar.DAY_OF_WEEK);
	    
	    return numeroDia;
	}
	
	public static int getDiaSemana(String fecha){
		
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
		int numeroDia		= 0;
		
		try{
			java.util.Date hoy 	= sdf.parse(fecha);
			
			Calendar cal		= Calendar.getInstance();	    
			cal.setTime(hoy);
			numeroDia = cal.get(Calendar.DAY_OF_WEEK);
		} catch (java.text.ParseException e) {
			e.printStackTrace();
		}
		
	    return numeroDia;
	}
		
}
