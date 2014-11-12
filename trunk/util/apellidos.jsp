<%@ include file= "con_elias.jsp" %>
<%@ page import="java.util.*" %>
<%! 
	private String[] separarApellidos(String apellido){
		StringTokenizer tk = new StringTokenizer(apellido," ");
		String aNombre[] = new String[tk.countTokens()];	
		String apellidoP="",apellidoM="";
		String dev[] = new String[3];
		dev[0]="";dev[1]="";dev[2]="";
		int i=0;
		boolean salir = false;		
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
			
			dev[2] = apellidoM;
			
			if((i-2) > 0){
				if((aNombre[i-1].equals("LA")||aNombre[i-1].equals("LAS")||aNombre[i-1].equals("LOS")) && aNombre[i-2].equals("DE")){
					apellidoP = aNombre[i-2]+" "+aNombre[i-1]+" "+aNombre[i];
					i-=2; //Posicionamos i para buscar el nombre
				}else if (aNombre[i-1].equals("DEL")){
					apellidoP = aNombre[i-1]+" "+aNombre[i];
					i--; //Posicionamos i para buscar el nombre
				}else{
					apellidoP = aNombre[i];
				}
				dev[1] = apellidoP;
				for(int j = 0; j < i; j++) dev[0] += aNombre[j]+" ";
			}else{
				if((i-1) > 0){
					if (aNombre[i-1].equals("DEL")){
						apellidoP = aNombre[i-1]+" "+aNombre[i];
						i--; //Posicionamos i para buscar el nombre
					}else{
						apellidoP = aNombre[i];
					}
					dev[1] = apellidoP;
					for(int j = 0; j < i; j++) dev[0] += aNombre[j]+" ";
				}else{
					dev[0] = aNombre[0];
					dev[1] = aNombre[1];
				}
			}
		}else{
			dev[0] = aNombre[0];
			dev[1] = " ";
			dev[2] = " ";
		}
		return dev;
	}
%>
<%! 
	private String[] separarNombre(String nombre){
		StringTokenizer tk = new StringTokenizer(nombre, " ");
		String aNombre[] = new String[tk.countTokens()];	
		String apellidoP="",apellidoM="";
		String dev[] = new String[3];
		dev[0]="";dev[1]="";dev[2]="";
		int i=0;
		boolean salir = false;		
		while (tk.hasMoreTokens()) aNombre[i++] = tk.nextToken().toUpperCase(); //Llenamos el array de nombres y apellidos
		int tkSize = i;
		i = 0;
		if (aNombre[i].equals("DE") && (aNombre[i+1].equals("LA")||aNombre[i+1].equals("LAS")||aNombre[i+1].equals("LOS"))){
			apellidoP = aNombre[i]+" "+aNombre[i+1]+" "+aNombre[i+2];
			i+=3; //Posicionamos i para buscar apellido paterno
		}else if (aNombre[i].equals("DEL")){
			apellidoP = aNombre[i]+" "+aNombre[i+1];
			i+=2; //Posicionamos i para buscar apellido paterno
		}else{
			apellidoP = aNombre[i];
			i++;
		}
		if((i+1) < tkSize){
			if (aNombre[i].equals("DE") && (aNombre[i+1].equals("LA")||aNombre[i+1].equals("LAS")||aNombre[i+1].equals("LOS"))){
				apellidoM = aNombre[i]+" "+aNombre[i+1]+" "+aNombre[i+2];
				i+=3; //Posicionamos i para buscar apellido paterno
			}else if (aNombre[i].equals("DEL")){
				apellidoM = aNombre[i]+" "+aNombre[i+1];
				i+=2; //Posicionamos i para buscar apellido paterno
			}else{
				apellidoM = aNombre[i];
				i++;
			}
		}else{
			apellidoM = "-";
		}
		
		dev[1] = apellidoP;
		dev[2] = apellidoM;
		for(int j = i; j < tkSize; j++) dev[0] += aNombre[j]+" ";
		
		return dev;
	}
%>
<!-- inicio de estructura -->
<%	
	Statement stmt 	= conElias.createStatement();
	ResultSet rs 	= null;
	String comando 	= "";
	
	comando	=	"select CODIGO_PERSONAL, NOMBRE from tras_alumno where apellido_materno is null ORDER BY CODIGO_PERSONAL";
	rs = stmt.executeQuery( comando );	
	while(rs.next() ){ 
		String codigo = rs.getString("CODIGO_PERSONAL");
		String nombre =  rs.getString("NOMBRE");
		String datoApellido[] = separarNombre(nombre);
		System.out.println("Codigo: "+codigo);
		System.out.println("Nombre: "+datoApellido[0]);
		System.out.println("aPaterno: "+datoApellido[1]);
		System.out.println("aMaterno: "+datoApellido[2]);
		/*try{
			PreparedStatement ps = conElias.prepareStatement("UPDATE TRAS_ALUMNO"+
			" SET APELLIDO_PATERNO = '"+datoApellido[1]+"',"+
			" APELLIDO_MATERNO = '"+datoApellido[2]+"',"+
			" NOMBRE = '"+datoApellido[0]+"'"+
			" WHERE CODIGO_PERSONAL = '"+codigo+"'");
			System.out.println("renglones modificados: "+ps.executeUpdate());
		}catch(Exception e){
			System.out.println("Error alumno "+codigo+": "+e);
		}*/
		//stmt2.execute("UPDATE EMP_DATOS SET appaterno='"+datoApellido[0]+"', apmaterno='"+datoApellido[1]+"' where ID_EMPLEADO='"+nomina+"'");
		//System.out.println(" - OK!");
		System.out.println("------------------------------------------------------");
	}
%>
ok.. terminado.
<!-- fin de estructura -->
<%
	if (rs!=null){ rs.close();}
	if (stmt!=null){ stmt.close();}
%>
<%@ include file= "cierra_elias.jsp" %>