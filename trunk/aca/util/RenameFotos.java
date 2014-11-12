// Utileria de claves
package aca.util;

import java.io.File;

// Creaci{on de claves de usuarios
public class RenameFotos{
	
	public static void main(String[] args){
		
		try{
			String dir = "C:/99";
			File DirFotos 	= new File (dir);
			String[] fotos 	= DirFotos.list();	
			String newName 	= "";	
 
			for (int i = 0; i < fotos.length; i++){				
				File oldFile = new File(dir+"/"+fotos[i]);
				newName = "A"+fotos[i];
				File newFile = new File(dir+"/"+newName);
				if (oldFile.renameTo(newFile)){
					System.out.println(i+": Antes="+fotos[i]+" - Ahora="+newName);
				}else{
					System.out.println(i+"No cambio...");
				}				
			}			
		}catch(Exception ex){
			System.out.println("Error:"+ex);
		}
	}		
}
