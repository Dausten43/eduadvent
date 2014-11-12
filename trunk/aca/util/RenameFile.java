// Utileria de claves
package aca.util;

import java.io.File;

// Creaci{on de claves de usuarios
public class RenameFile{
	
	public static void main(String[] args){
		
		try{
			String dir = "/home/academico/Documentos/isar";
			File DirFotos 	= new File (dir);
			String[] fotos 	= DirFotos.list();	
			String newName 	= "";	
 
			for (int i = 0; i < fotos.length; i++){				
				File oldFile = new File(dir+"/"+fotos[i]);
				newName = "11"+fotos[i].substring(2,fotos[i].length());
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
