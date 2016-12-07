/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aca.fin;

/**
 *
 * @author Daniel
 */
public class Test {
    
    
    public static void main(String[] a){
        
        String codigoid= "12345, 54321, 56789, 98765";
        String comando= "";
        
        if (!codigoid.equals("")) {
            
                String alumno = codigoid;
                
                if (alumno.indexOf(",")!=0) {
                    
                    String[] arrAlumnos = alumno.split(",");
                    
                    String al = "";
                    for (int i = 0; i < arrAlumnos.length; i++) {
                        if (i < (arrAlumnos.length - 1)) {
                            al += "'" +arrAlumnos[i].trim() + "',";
                        }
                        if (i == (arrAlumnos.length - 1)) {
                            al += "'" + arrAlumnos[i].trim() + "'";
                        }
                    }
                    alumno = al;
                    
                }
                comando += " AND CODIGO_ID IN (" + alumno + ") ";
            }
        System.out.println(comando);
    }
}
