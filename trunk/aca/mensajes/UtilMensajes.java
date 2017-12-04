package aca.mensajes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class UtilMensajes {

	public Map<Long, Mensajeria> getMensaje(
			Connection con,
			Long id, 
			String usr_envia, 
			String tipo_destino, 
			String tipo_destinoIN, 
			String destino, 
			String destinoIN,
			Integer es_respuesta, 
			Long id_mensaje_original, 
			Integer estado, String estadoIN, String orden){
		
		Map<Long, Mensajeria> salida = new LinkedHashMap<Long, Mensajeria>();
		
		String sql = "SELECT "
				+ "id, usr_envia, tipo_destino, destino, "
				+ "to_char(fecha,'dd-mm-yyyy HH24:MI') as fechatxt, es_respuesta, id_mensaje_original, mensaje, estado, asunto   "
				+ "FROM mensajeria where id is not null ";
		
		if(id!=0L){
			sql += " and id="+id;
		}
		if(!usr_envia.equals("")){
			sql+= " and usr_envia='"+usr_envia+"'";
		}
		if(!tipo_destino.equals("")){
			sql+= " and tipo_destino='"+tipo_destino+"' ";
		}
		if(!tipo_destinoIN.equals("")){
			sql+= " and tipo_destino in ("+tipo_destinoIN+") ";
		}
		
		if(!destino.equals("")){
			sql+= " and destino='"+ destino +"'";
		}
		if(!destinoIN.equals("")){
			sql+= " and destino in ("+ destinoIN +") ";
		}
		if(es_respuesta!=-1){
			sql+=" and es_respuesta="+es_respuesta;
		}
		if(id_mensaje_original!=0L){
			sql+=" and id_mensaje_original="+id_mensaje_original;
		}
		if(estado!=-1){
			sql+=" and estado="+estado;
		}
		
		if(!estadoIN.equals("")){
			sql+=" and estado in ("+estadoIN+") ";
		}
		
		sql += " "+ orden;
		
		System.out.println("mm " + sql);
		
		try{
			PreparedStatement pst = con.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			while(rs.next()){
				Mensajeria m = new Mensajeria(rs.getLong("id"), 
						rs.getString("usr_envia"), 
						rs.getString("tipo_destino"), 
						rs.getString("destino"), 
						rs.getString("fechatxt"), 
						rs.getInt("es_respuesta"), 
						rs.getLong("id_mensaje_original"), 
						rs.getString("asunto"),
						rs.getString("mensaje"), rs.getInt("estado"));
				salida.put(m.getId(), m);
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilMensajes || getMensaje " + sqle);
		}catch(Exception ex){
			System.err.println("Error en UtilMensajes || getMensaje " + ex);
		}
		
		return salida;
	}

	
	public void guardaMensaje(Connection con, Mensajeria msg)throws SQLException{
		String sql = "INSERT INTO mensajeria"
				+ "(usr_envia, tipo_destino, destino, es_respuesta, id_mensaje_original,"
				+ "              mensaje, estado, asunto)     "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		
		try{
			PreparedStatement pst = con.prepareStatement(sql);
			pst.setString(1, msg.getUsr_envia());
			pst.setString(2, msg.getTipo_destino());
			pst.setString(3, msg.getDestino());
			pst.setInt(4, msg.getEs_respuesta());
			pst.setLong(5, msg.getId_mensaje_original());
			pst.setString(6, msg.getMensaje());
			pst.setInt(7, msg.getEstado());
			pst.setString(8, msg.getAsunto());
			
			pst.executeUpdate();
			
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilMensajes || getMensaje " + sqle);
			
		}
		
	}
	
	public int guardaMensajeFile(Connection con, Mensajeria msg)throws SQLException{
		String sql = "INSERT INTO mensajeria"
				+ "(usr_envia, tipo_destino, destino, es_respuesta, id_mensaje_original,"
				+ "              mensaje, estado, asunto)     "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?) returning id";
		int salida= 0;
		try{
			PreparedStatement pst = con.prepareStatement(sql);
			pst.setString(1, msg.getUsr_envia());
			pst.setString(2, msg.getTipo_destino());
			pst.setString(3, msg.getDestino());
			pst.setInt(4, msg.getEs_respuesta());
			pst.setLong(5, msg.getId_mensaje_original());
			pst.setString(6, msg.getMensaje());
			pst.setInt(7, msg.getEstado());
			pst.setString(8, msg.getAsunto());
			
			ResultSet rs = pst.executeQuery();
			if(rs.next()){
				salida = rs.getInt(1);
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en UtilMensajes || guardaMensajeFile " + sqle);
			
		}
		
		return salida;
		
	}
	
	public void guardaMensaje(Connection con, Integer estado, Long id){
		String sql = "update mensajeria set estado=? where id=?";
		
		try{
			PreparedStatement pst = con.prepareStatement(sql);
		    pst.setInt(1, estado);
		    pst.setLong(2, id);
			
			pst.executeUpdate();
			pst.close();
		}catch(SQLException sqle){
			System.err.println("Error en UtilMensajes || getMensaje " + sqle);
			
		}
		
	}
	
	public List<String> getMsgsLeidos(Connection con, Long idmsg){
		List<String >salida = new ArrayList();
		String sql ="select * from msg_leidos where id="+idmsg;
		System.out.println(sql);
		try{
			PreparedStatement pst = con.prepareStatement(sql);
		    
			ResultSet rs = pst.executeQuery();
			
			while(rs.next()){
				salida.add(rs.getString("destinatario") + "-" + rs.getString("id_mensaje"));
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en getMsgsLeidos || getMensaje " + sqle);
			
		}
		return salida;
	}
	
	public List<String> getMsgsLeidos(Connection con, String lector){
		List<String >salida = new ArrayList();
		String sql ="select * from msg_leidos where destinatario in("+lector+")";
		System.out.println(sql);
		try{
			PreparedStatement pst = con.prepareStatement(sql);
		    
			ResultSet rs = pst.executeQuery();
			
			while(rs.next()){
				salida.add(rs.getString("id_mensaje"));
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en getMsgsLeidos || getMensaje " + sqle);
			
		}
		return salida;
	}
	
	public void setMensajeLeido(Connection con, String lector, Long idmsg){
		String sql ="insert into msg_leidos (destinatario, id_mensaje) values(?,?)";
		
		try{
			PreparedStatement pst = con.prepareStatement(sql);
		    pst.setString(1, lector);
		    pst.setLong(2, idmsg);
			
			pst.executeUpdate();
			
			pst.close();
			
		}catch(SQLException sqle){
			System.err.println("Error en setMensajeLeido || getMensaje " + sqle);
			
		}
		
	}
	
	
}
