// Utileria para generar datos de alumnos
package aca.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.StringTokenizer;

// Creaci{on de claves de usuarios
public class SeparaNombre{
	
	public static String[] separarApellidos(String apellido){
		StringTokenizer tk = new StringTokenizer(apellido," ");
		String aNombre[] = new String[tk.countTokens()];	
		String apellidoM="";
		String dev[] = new String[2];
		dev[0]="";dev[1]="";
		int i=0;		
		while (tk.hasMoreTokens()) aNombre[i++] = tk.nextToken().toUpperCase(); //Llenamos el array de nombres y apellidos
		if (i>1){
			//Buscamos apellido materno
			i-=2;		
			if ((aNombre[i].equals("LA")||aNombre[i].equals("LAS")||aNombre[i].equals("LOS")) && aNombre[i-1].equals("DE")){
				apellidoM = aNombre[i-1]+" "+aNombre[i]+" "+aNombre[i+1];
				i-=2; //Posicionamos i para buscar apellido paterno
			}else if (aNombre[i].equals("DEL")){
				apellidoM = aNombre[i]+" "+aNombre[i+1];
				i--; //Posicionamos i para buscar apellido paterno
			}else{
				apellidoM = aNombre[i+1];
			}
			//Creamos el array a devolver	
			int j;
			for (j=0;j<=i;j++) dev[0]+=aNombre[j]+" ";
			dev[1] = apellidoM;
		}else{
			dev[0] = aNombre[0];
			dev[1] = " ";
		}
		return dev;
	}
	
	public static void main(String[] args){

		Connection conn = null;
		try{			
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(aca.conecta.Conectar.getConeccion(),aca.conecta.Conectar.getUsuario(),aca.conecta.Conectar.getPassword());
			/*
			String[] apellidos = {" "," "};
			apellidos = separarApellidos("BAUTISTA DE LA CRUZ ");
			System.out.println(apellidos[0]+"|"+apellidos[1]);
			*/
			//--------------
				ArrayList<String> lisApellidos 	= new ArrayList<String>();
				Statement st 	= conn.createStatement();
				ResultSet rs 	= null;
				String comando	= "";
				
				try{
					comando = "SELECT APATERNO FROM ALUM_TEMP";	
					
					rs = st.executeQuery(comando);			
					while (rs.next()){
						lisApellidos.add(rs.getString("APATERNO"));
					}
					
				}catch(Exception ex){
					System.out.println("Error - aca.catalogo.BecAlumnoLista|getListAll|:"+ex);
				}finally{
					if (rs!=null) rs.close();
					if (st!=null) st.close();
				}		
				
				for(Object o: lisApellidos){
					String app = (String)o;
					System.out.println(app);
					String [] nom = separarApellidos(app);
					System.out.println(nom[0]+"*"+nom[1]);
				}
	//--------------

			if (conn!=null) conn.close();
		}catch(Exception ex){
			System.out.println("Error:"+ex);
		}finally{		
		}
	}
		
}
