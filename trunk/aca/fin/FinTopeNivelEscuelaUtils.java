package aca.fin;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FinTopeNivelEscuelaUtils {
	
	
	public int guardaTope(Connection con, String escuelaId, Integer nivelSistema, BigDecimal importe) {
		
		FinTopeNivelEscuela finTope = null ;
		
		finTope = traeRegistro(con, escuelaId, nivelSistema);
		
		int salida=0;
		
		if(finTope!=null) {
			try {
				String comando = "UPDATE public.fin_tope_nivel_escuela set importe_tope=" + importe + ", fecha_modificado=now() where fin_tope_id="+ finTope.getFinTopeId();
				PreparedStatement pst = con.prepareStatement(comando);
				salida = pst.executeUpdate();
			}catch(SQLException sqle ) {
				System.err.println("Error en guardaTope " + sqle);
			}
		}else {
			try {
				String comando = "INSERT INTO public.fin_tope_nivel_escuela(escuela_id, nivel_sistema, importe_tope )	VALUES (?, ?, ?)";
				PreparedStatement pst = con.prepareStatement(comando);
				pst.setString(1, escuelaId);
				pst.setInt(2, nivelSistema);
				pst.setBigDecimal(3, importe);
				salida = pst.executeUpdate();
			}catch(SQLException sqle ) {
				System.err.println("Error en guardaTope " + sqle);
			}
		}
		
		return salida;
		
	}
	
	
	
	
	public BigDecimal importeTope(Connection con, String escuelaId, Integer nivelSistema) {
		
		BigDecimal salida = BigDecimal.ZERO;
		
		try {
			
			String comando = "select importe_tope from fin_tope_nivel_escuela where escuela_id='" + escuelaId + "' and nivel_sistema=" + nivelSistema ;
			PreparedStatement pst = con.prepareStatement(comando);
			ResultSet rs = pst.executeQuery();
			if(rs.next()) {
				salida = rs.getBigDecimal("importe_tope");
			}
			rs.close();
			pst.close();
			
		}catch(SQLException sqle) {
			System.err.println("Error en importeTope " + sqle);
		}
		
		
		return salida;
	}
	
	
	public FinTopeNivelEscuela traeRegistro(Connection con,String escuelaId, Integer nivelSistema) {	
		FinTopeNivelEscuela salida = null;
			try {
				
				String comando = "select fin_tope_id, escuela_id, nivel_sistema, importe_tope, fecha_creado, fecha_modificado"
						+ " from fin_tope_nivel_escuela where escuela_id='" + escuelaId + "' and nivel_sistema=" + nivelSistema ;
				PreparedStatement pst = con.prepareStatement(comando);
				ResultSet rs = pst.executeQuery();
				if(rs.next()) {
					salida = new FinTopeNivelEscuela();
					salida.setEscuelaId(rs.getString("escuela_id"));
					salida.setFechaCreado(rs.getDate("fecha_creado"));
					salida.setFechaActualizado(rs.getDate("fecha_modificado"));
					salida.setFinTopeId(rs.getLong("fin_tope_id"));
					salida.setImporteTope(rs.getBigDecimal("importe_tope"));
					salida.setNivelSistema(rs.getInt("nivel_sistema"));
				}
				rs.close();
				pst.close();
				
			}catch(SQLException sqle) {
				System.err.println("Error en traeRegistro " + sqle);
			}
		
		return salida;
	}
	
	public List<FinTopeNivelEscuela> traeRegistroEscuela(Connection con,String escuelaId) {	
			List<FinTopeNivelEscuela> salida = new ArrayList<FinTopeNivelEscuela>();
			try {
				
				String comando = "select fin_tope_id, escuela_id, nivel_sistema, importe_tope, fecha_creado, fecha_modificado"
						+ " from fin_tope_nivel_escuela where escuela_id='" + escuelaId + "' " ;
				PreparedStatement pst = con.prepareStatement(comando);
				ResultSet rs = pst.executeQuery();
				while(rs.next()) {
					FinTopeNivelEscuela dato = new FinTopeNivelEscuela();
					dato.setEscuelaId(rs.getString("escuela_id"));
					dato.setFechaCreado(rs.getDate("fecha_creado"));
					dato.setFechaActualizado(rs.getDate("fecha_modificado"));
					
					dato.setFinTopeId(rs.getLong("fin_tope_id"));
					dato.setImporteTope(rs.getBigDecimal("importe_tope"));
					dato.setNivelSistema(rs.getInt("nivel_sistema"));
					salida.add(dato);
				}
				rs.close();
				pst.close();
				
			}catch(SQLException sqle) {
				System.err.println("Error en traeRegistroEscuela " + sqle);
			}
		
		return salida;
	}
	

}
