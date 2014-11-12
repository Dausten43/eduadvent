// Utileria de fecha
package aca.util;

public class Texto{
	
	// Corta la frase en la posición inmediata inferior a máximo en donde encuentre un espacio en blanco 
	public static String getCortaFrase( String frase, int maximo){
		String fraseCorta 	= frase;
		int pos = 0, letra = 0;		
		if (frase.length() > maximo){
			while ( letra <= maximo){	 
				if (frase.substring(letra, letra+1).equals(" ")){	 
					pos = letra;				
				}
				letra++;
			}
			fraseCorta 	= frase.substring(0, pos)+"...";
		}		
		return fraseCorta;
	}
/*	
	public static void main(String[] args){
		System.out.println(aca.util.Texto.getCortaFrase("Proyecto integrador de Tecnologías",25));
	}
*/			
}
