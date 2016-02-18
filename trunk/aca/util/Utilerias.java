package aca.util;

public class Utilerias {
	
	public static String removeEmptyDecimalPoints(String str){
		
		String rs = str.trim();
		if (rs.length()>0){
			//Check how many instances of a decimal point there is
			int instances = 0;
			for(int i=0; i<rs.length(); i++){
				char c = rs.charAt(i);
				if(c == '.' && i!=rs.length()-1){
					instances ++;
				}
			}
			
			//if it is only one
			if(instances == 1){
				
				String decimal = rs.split("\\.")[1];
				if(isInteger(decimal) && Integer.parseInt(decimal)==0){
					return rs.split("\\.")[0];
				}
				
			}
		}else{
			rs = "";
		}	
		
		return rs;
	}
	
	public static boolean isInteger(String str){
		try{

			Integer.parseInt(str);
			
		}catch(Exception ex){
			return false;
		}
		
		
		return true;
	}
	
	public static boolean isNumeric(String str){
		try{

			Double.parseDouble(str);
			
		}catch(Exception ex){
			return false;
		}
		
		
		return true;
	} 
	
}
