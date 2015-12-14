package aca.ciclo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CicloGpoModulo {

		private String cicloGrupoId;
		private String moduloId;
		private String moduloNombre;
		private String descripcion;
		private String cursoId;
		private String orden;
		
		public CicloGpoModulo(){
			cicloGrupoId	= "";
			moduloId		= "";
			moduloNombre	= "";
			descripcion		= "";
			cursoId			= "";
			orden			= "";
		}

		public String getCursoId() {
			return cursoId;
		}

		public void setCursoId(String cursoId) {
			this.cursoId = cursoId;
		}		
		
		public String getCicloGrupoId() {
			return cicloGrupoId;
		}

		public void setCicloGrupoId(String cicloGrupoId) {
			this.cicloGrupoId = cicloGrupoId;
		}

		public String getModuloId() {
			return moduloId;
		}

		public void setModuloId(String moduloId) {
			this.moduloId = moduloId;
		}

		public String getModuloNombre() {
			return moduloNombre;
		}

		public void setModuloNombre(String moduloNombre) {
			this.moduloNombre = moduloNombre;
		}

		public String getDescripcion() {
			return descripcion;
		}

		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}	

		public String getOrden() {
			return orden;
		}

		public void setOrden(String orden) {
			this.orden = orden;
		}

		public boolean insertReg(Connection conn ) throws SQLException{
			PreparedStatement ps = null;
			boolean ok = false;
			try{
				ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_MODULO" +
						" (CICLO_GRUPO_ID, MODULO_ID, MODULO_NOMBRE, DESCRIPCION, CURSO_ID, ORDEN)" +
						" VALUES(?, ?, ?, ? , ?, TO_NUMBER(?, '99.99'))");
				
				ps.setString(1, cicloGrupoId);
				ps.setString(2, moduloId);
				ps.setString(3, moduloNombre);
				ps.setString(4, descripcion);
				ps.setString(5, cursoId);
				ps.setString(6, orden);
				
				if ( ps.executeUpdate()== 1){
					ok = true;
				}else{
					ok = false;
				}
				
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|insertRegDeCicloGrupoModulo|:"+ex);
			}finally{
				if (ps!=null) ps.close();
			}
			return ok;
		}
		
		
		public boolean insertReg(Connection conn, String moduloId ) throws SQLException{
			PreparedStatement ps = null;
			boolean ok = false;
			try{
				ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_MODULO" +
						" (CICLO_GRUPO_ID, MODULO_ID, MODULO_NOMBRE, DESCRIPCION, CURSO_ID, ORDEN)" +
						" VALUES(?, ?, ?, ? , ?, TO_NUMBER(?, '99.99'))");
				
				ps.setString(1, cicloGrupoId);
				ps.setString(2, moduloId);
				ps.setString(3, moduloNombre);
				ps.setString(4, descripcion);
				ps.setString(5, cursoId);
				ps.setString(6, orden);
				
				if ( ps.executeUpdate()== 1){
					ok = true;
				}else{
					ok = false;
				}
				
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|insertRegDeCicloGrupoModulo|:"+ex);
			}finally{
				if (ps!=null) ps.close();
			}
			return ok;
		}
		
		public boolean updateReg(Connection conn ) throws SQLException{
			PreparedStatement ps = null;
			boolean ok = false;
			try{
				ps = conn.prepareStatement("UPDATE CICLO_GRUPO_MODULO" +
						" SET MODULO_NOMBRE = ?," +
						" DESCRIPCION = ?, ORDEN = TO_NUMBER(?, '99.99') " +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND MODULO_ID = ?  " +
						" AND CURSO_ID = ?");			
				ps.setString(1, moduloNombre);
				ps.setString(2, descripcion);
				ps.setString(3, orden);
				ps.setString(4, cicloGrupoId);
				ps.setString(5, moduloId);
				ps.setString(6, cursoId);
				
				if ( ps.executeUpdate()== 1){
					ok = true;
				}else{
					ok = false;
				}
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|updateReg|:"+ex);
			}finally{
				if (ps!=null) ps.close();
			}
			return ok;
		}
		
		public boolean deleteReg(Connection conn ) throws SQLException{
			PreparedStatement ps = null;
			boolean ok = false;
			try{
				ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_MODULO" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND MODULO_ID = ?" +
						" AND CURSO_ID = ?");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, moduloId);
				ps.setString(3, cursoId);
				
				if ( ps.executeUpdate()== 1){
					ok = true;
				}else{
					ok = false;
				}
				
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|deleteReg|:"+ex);
			}finally{
				if (ps!=null) ps.close();
			}
			return ok;
		}
		
		public void mapeaReg(ResultSet rs ) throws SQLException{
			cicloGrupoId	= rs.getString("CICLO_GRUPO_ID");
			moduloId		= rs.getString("MODULO_ID");
			moduloNombre	= rs.getString("MODULO_NOMBRE");
			descripcion		= rs.getString("DESCRIPCION");
			cursoId			= rs.getString("CURSO_ID");
			orden			= rs.getString("ORDEN");
		}
		
		public void mapeaRegId(Connection con, String cicloGrupoId, String moduloId, String cursoId) throws SQLException{
			PreparedStatement ps = null;
			ResultSet rs = null;		
			try{
				ps = con.prepareStatement("SELECT CICLO_GRUPO_ID, MODULO_ID, MODULO_NOMBRE, DESCRIPCION, CURSO_ID, ORDEN" +
						" FROM CICLO_GRUPO_MODULO" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND MODULO_ID = ?" +
						" AND CURSO_ID = ? ");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, moduloId);
				ps.setString(3, cursoId);
				
				rs = ps.executeQuery();
				
				if(rs.next()){
					mapeaReg(rs);
				}
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|mapeaRegId|:"+ex);
				ex.printStackTrace();
			}finally{
				if (rs!=null) rs.close();
				if (ps!=null) ps.close();
			}
		}
		
		public boolean existeReg(Connection conn) throws SQLException{
			boolean ok 			= false;
			ResultSet rs 			= null;
			PreparedStatement ps	= null;
			
			try{
				ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_MODULO" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND MODULO_ID = ?" +
						" AND CURSO_ID = ?");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, moduloId);
				ps.setString(3, cursoId);
				
				rs= ps.executeQuery();		
				if(rs.next()){
					ok = true;
				}else{
					ok = false;
				}
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|existeReg|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (ps!=null) ps.close();
			}		
			
			return ok;
		}
		
		public boolean existeEnGrupo(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
			boolean ok 			= false;
			ResultSet rs 			= null;
			PreparedStatement ps	= null;
			
			try{
				ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_MODULO" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, cursoId);
				
				rs= ps.executeQuery();		
				if(rs.next()){
					ok = true;
				}else{
					ok = false;
				}
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|existeEnGrupo|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (ps!=null) ps.close();
			}		
			
			return ok;
		}
		
		public boolean existeEnGrupo(Connection conn, String cicloGrupoId, String cursoId, String moduloId) throws SQLException{
			boolean ok 			= false;
			ResultSet rs 			= null;
			PreparedStatement ps	= null;
			
			try{
				ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_MODULO" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?"+
						" AND MODULO_ID = ?");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, cursoId);
				ps.setString(3, moduloId);
				
				rs= ps.executeQuery();		
				if(rs.next()){
					ok = true;
				}else{
					ok = false;
				}
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|existeEnGrupo|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (ps!=null) ps.close();
			}		
			
			return ok;
		}
		
		public String maximoReg(Connection conn) throws SQLException{
			String maximo 			= "01";
			ResultSet rs			= null;
			PreparedStatement ps	= null;
			
			try{
				ps = conn.prepareStatement("SELECT" +
						" COALESCE(TRIM(TO_CHAR(MAX(TO_NUMBER(MODULO_ID,'99'))+1,'00')), '01') AS MAXIMO " +
						" FROM CICLO_GRUPO_MODULO" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, cursoId);
				
				rs = ps.executeQuery();
				if (rs.next())
					maximo = rs.getString("MAXIMO");
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|maximoReg|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (ps!=null) ps.close();
			}
			
			return maximo;
		}
		
		public String maximoOrden(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
			String maximo 			= "1.00";
			ResultSet rs			= null;
			PreparedStatement ps	= null;
			
			try{
				ps = conn.prepareStatement("SELECT" +
						" COALESCE(MAX(ORDEN)+1, '1.00') AS MAXIMO " +
						" FROM CICLO_GRUPO_MODULO" +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, cursoId);
				
				rs = ps.executeQuery();
				if (rs.next())
					maximo = rs.getString("MAXIMO");
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|maximoOrden|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (ps!=null) ps.close();
			}
			
			return maximo;
		}
		
		public static int numTemas(Connection conn, String cicloGrupoId, String cursoId, String moduloId) throws SQLException{
			
			ResultSet rs			= null;
			PreparedStatement ps	= null;
			int numTemas			= 0;
			
			try{
				ps = conn.prepareStatement("SELECT COUNT(TEMA_ID) AS NUMTEMAS FROM CICLO_GRUPO_TEMA " +
						" WHERE CICLO_GRUPO_ID = ?" +
						" AND CURSO_ID = ?" +
						" AND MODULO_ID = ?");
				ps.setString(1, cicloGrupoId);
				ps.setString(2, cursoId);
				ps.setString(3, moduloId);
				
				rs = ps.executeQuery();
				if (rs.next())
					numTemas = rs.getInt("NUMTEMAS");
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.CicloGpoModulo|NumTemas|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (ps!=null) ps.close();
			}
			
			return numTemas;
		}
	}
	

