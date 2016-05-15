package aca.portal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Alumno{

	public Alumno(){ 
	}
	public String dibujaTab(int numTab, String tab, String Nombre){
		String ret="",sOn="";
		if (Integer.parseInt(tab)==numTab){ 
			sOn="on";
		}
		else sOn="off";
		ret = 
		"<table onclick=\"CambiaTab("+String.valueOf(numTab)+")\" style=\"cursor:pointer;\" border='0' cellspacing='0' cellpadding='0' align='left'>"+
			"<tr>"+ 
				"<td><img src='img/tab_"+sOn+"_left.gif' height='24' width='16'></td>"+
				"<td ONSELECTSTART='return false' background='img/tab_"+sOn+"_middle.gif'>"+
					"<font color=\"#000000\" size=\"1\" face=\"Arial, Helvetica, sans-serif\">"+Nombre+"</font>"+
				"</td>"+
				"<td><img src='img/tab_"+sOn+"_right.gif' height='24' width='16'></td>"+
			"</tr>"+
		"</table>";		
		return ret;
	}
	public String dibujaTab2(int num, int ac, String pagina, String nombre){
		String script= "<li onClick=\"cambia("+num+",'"+pagina+"');\"";
		if(ac==num)script+=" id='current'";
		script+="><a ";
		if(ac==num)script+="style=\"font-size:11px;\" ";
		script+="onmouseover=\"this.style.color='#765'\" onMouseOut=\"this.style.color=''\">"+nombre+"</a></li>";
		return script;
	}
	
	public void guardaColor(Connection conn, String matricula, String color) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs			= null;
		
		try{
			String sql="select color from alum_color where codigo_personal=?";
		    ps = conn.prepareStatement(sql);
			ps.setString(1,matricula);
			rs = ps.executeQuery();
			if(rs.next()){
			    ps = conn.prepareStatement("UPDATE ALUM_COLOR SET COLOR = ? WHERE CODIGO_PERSONAL = ?");
			    ps.setString(1,color);
			    ps.setString(2,matricula);
			    if (ps.executeUpdate()==1){
			    	
			    }			    	
			}else{
			    ps = conn.prepareStatement("INSERT INTO ALUM_COLOR VALUES( ?, ?)");
			    ps.setString(1,matricula);
			    ps.setString(2,color);
			    if (ps.executeUpdate()==1){
			    	
			    }		    
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.portal.Alumno|guardaColor|:"+ex);
		}finally{			
			if(rs!=null)rs.close();
			if(ps!=null)ps.close();
		}
	}
	
	public String obtenColor(Connection conn, String matricula) throws SQLException{
	    String color="";
		try{
		    String sql="select color from alum_color where codigo_personal=?";
		    PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1,matricula);
			ResultSet rs = ps.executeQuery();
			if(rs.next())color=rs.getString(1);
			if(color.equals("P"))color="";
		}catch(Exception ex){
			System.out.println("Error - aca.portal.Alumno|obtenColor|:"+ex);
		}
		return color;
	}
public String modificarColor(String color, int cambio){
		
		if(color.length()==7) color = color.substring(1);
		
		int r = Integer.parseInt(color.substring(0,2), 16);
		int g = Integer.parseInt(color.substring(2,4), 16);
		int b = Integer.parseInt(color.substring(4,6), 16);
		
		if((String.valueOf(cambio)).charAt(0)=='-'){
			cambio = cambio*-1;
			if((r-cambio)<0){
				r=0;
			}else{
				r = r-cambio;
			}			
			if((g-cambio)<0){
				g=0;
			}else{
				g = g-cambio;
			}
			if((b-cambio)<0){
				b=0;
			}else{
				b = b-cambio;
			}
			
			String tmpColor = "#";
			String Sr = Integer.toHexString(r);
			String Sg = Integer.toHexString(g);
			String Sb = Integer.toHexString(b);
			
			if(Sr.length()==1) tmpColor+=("0"+Sr);
			else tmpColor+=Sr;
				
			if(Sg.length()==1) tmpColor+=("0"+Sg);
			else tmpColor+=Sg; 
			
			if(Sb.length()==1) tmpColor+=("0"+Sb);
			else tmpColor+=Sb;
			
			return tmpColor;
		}
		else{		
			if((r+cambio)>255){
				r=255;
			}else{
				r+=cambio;
			}
			if((g+cambio)>255){
				g=255;
			}else{
				g+=cambio;
			}		
			if((b+cambio)>255){
				b=255;
			}else{
				b+=cambio;
			}
		}
		
		return "#"+Integer.toHexString(r)+Integer.toHexString(g)+Integer.toHexString(b);
	}
}