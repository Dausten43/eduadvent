/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class KrdxCursoImp {
	private String codigoId;
	private String cursoId;
	private String cal1;
	private String cal2;
	private String cal3;
	private String cal4;
	private String cal5;
	private String cal6;
	private String cal7;
	private String cal8;
	private String cal9;
	private String cal10;
	private String nota;
	private String fNota;
	private String tipoCalId;
	private String comentario;
	private String notaExtra;
	private String fExtra;
	private String folio;
	
	public KrdxCursoImp(){
		codigoId		= "";
		cursoId			= "";
		cal1			= "";
		cal2			= "";
		cal3			= "";
		cal4			= "";
		cal5			= "";
		cal6			= "";
		cal7			= "";
		cal8			= "";
		cal9			= "";
		cal10			= "";
		nota			= "";
		fNota			= "";
		tipoCalId		= "";
		comentario		= "";
		notaExtra		= "";
		fExtra			= "";
		folio			= "";
	}	
	
	public String getCal1() {
		return cal1;
	}



	public void setCal1(String cal1) {
		this.cal1 = cal1;
	}



	public String getCal2() {
		return cal2;
	}



	public void setCal2(String cal2) {
		this.cal2 = cal2;
	}



	public String getCal3() {
		return cal3;
	}



	public void setCal3(String cal3) {
		this.cal3 = cal3;
	}



	public String getCal4() {
		return cal4;
	}



	public void setCal4(String cal4) {
		this.cal4 = cal4;
	}



	public String getCal5() {
		return cal5;
	}



	public void setCal5(String cal5) {
		this.cal5 = cal5;
	}


	
	public String getCal6() {
		return cal6;
	}

	public void setCal6(String cal6) {
		this.cal6 = cal6;
	}

	public String getCal7() {
		return cal7;
	}

	public void setCal7(String cal7) {
		this.cal7 = cal7;
	}

	public String getCal8() {
		return cal8;
	}

	public void setCal8(String cal8) {
		this.cal8 = cal8;
	}

	public String getCal9() {
		return cal9;
	}

	public void setCal9(String cal9) {
		this.cal9 = cal9;
	}

	public String getCal10() {
		return cal10;
	}

	public void setCal10(String cal10) {
		this.cal10 = cal10;
	}

	public String getCodigoId() {
		return codigoId;
	}



	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}



	public String getComentario() {
		return comentario;
	}



	public void setComentario(String comentario) {
		this.comentario = comentario;
	}



	public String getCursoId() {
		return cursoId;
	}



	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}



	public String getFExtra() {
		return fExtra;
	}



	public void setFExtra(String extra) {
		fExtra = extra;
	}



	public String getFNota() {
		return fNota;
	}



	public void setFNota(String nota) {
		fNota = nota;
	}



	public String getNota() {
		return nota;
	}



	public void setNota(String nota) {
		this.nota = nota;
	}



	public String getNotaExtra() {
		return notaExtra;
	}



	public void setNotaExtra(String notaExtra) {
		this.notaExtra = notaExtra;
	}



	public String getTipoCalId() {
		return tipoCalId;
	}



	public void setTipoCalId(String tipoCalId) {
		this.tipoCalId = tipoCalId;
	}
	

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO KRDX_CURSO_IMP" +
					" (CODIGO_ID, CURSO_ID, CAL1, CAL2, CAL3, CAL4, CAL5, CAL6, CAL7,CAL8,CAL9,CAL10, NOTA, F_NOTA," +
					" TIPOCAL_ID, COMENTARIO, NOTA_EXTRA, F_EXTRA, FOLIO)" +
					" VALUES(?, ?, " +
					"TO_NUMBER(?, '99'), " +
					"TO_NUMBER(?, '99'), " +
					"TO_NUMBER(?, '99'), " +
					"TO_NUMBER(?, '99'), " +
					" TO_NUMBER(?, '99'), " +
					" TO_NUMBER(?, '99'), " +
					" TO_NUMBER(?, '99'), " +
					" TO_NUMBER(?, '99'), " +
					" TO_NUMBER(?, '99'), " +
					" TO_NUMBER(?, '99'), " +
					"TO_NUMBER(?, '999.9'), " +
					"TO_DATE(?, 'DD/MM/YYYY'), " +
					"TO_NUMBER(?, '99'), ?," +
					" TO_NUMBER(?, '999.9'), " +
					"TO_DATE(?, 'DD/MM/YYYY'), " +
					"TO_NUMBER(?, '99'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, cursoId);
			ps.setString(3, cal1);
			ps.setString(4, cal2);
			ps.setString(5, cal3);
			ps.setString(6, cal4);
			ps.setString(7, cal5);
			ps.setString(8, cal6);
			ps.setString(9, cal7);
			ps.setString(10, cal8);
			ps.setString(11, cal9);
			ps.setString(12, cal10);
			ps.setString(13, nota);
			ps.setString(14, fNota);
			ps.setString(15, tipoCalId);
			ps.setString(16, comentario);
			ps.setString(17, notaExtra);
			ps.setString(18, fExtra);
			ps.setString(19, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImp|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE KRDX_CURSO_IMP" +
					" SET CAL1 = TO_NUMBER(?, '99')," +
					" CAL2 = TO_NUMBER(?, '99')," +
					" CAL3 = TO_NUMBER(?, '99')," +
					" CAl4 = TO_NUMBER(?, '99')," +
					" CAL5 = TO_NUMBER(?, '99')," +
					" CAL6 = TO_NUMBER(?, '99')," +
					" CAL7 = TO_NUMBER(?, '99')," +
					" CAL8 = TO_NUMBER(?, '99')," +
					" CAL9 = TO_NUMBER(?, '99')," +
					" CAL10 = TO_NUMBER(?, '99')," +
					" NOTA = TO_NUMBER(?, '999.9')," +
					" F_NOTA = TO_DATE(?, 'DD/MM/YYYY')," +
					" TIPOCAL_ID = TO_NUMBER(?, '99')," +
					" COMENTARIO = ?," +
					" NOTA_EXTRA = TO_NUMBER(?, '999.9')," +
					" F_EXTRA = TO_DATE(?, 'DD/MM/YYYY')" +
					" WHERE CODIGO_ID = ?" +				
					" AND FOLIO = TO_NUMBER(?, '99')");
								
			ps.setString(1, cal1);
			ps.setString(2, cal2);
			ps.setString(3, cal3);
			ps.setString(4, cal4);
			ps.setString(5, cal5);
			ps.setString(6, cal6);
			ps.setString(7, cal7);
			ps.setString(8, cal8);
			ps.setString(9, cal9);
			ps.setString(10, cal10);
			ps.setString(11, nota);
			ps.setString(12, fNota);
			ps.setString(13, tipoCalId);
			ps.setString(14, comentario);
			ps.setString(15, notaExtra);
			ps.setString(16, fExtra);
			ps.setString(17, codigoId);
			ps.setString(18, folio);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImp|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_CURSO_IMP" +
					" WHERE CODIGO_ID = ?" +		
					" AND FOLIO = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImp|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");		
		cursoId			= rs.getString("CURSO_ID");
		cal1			= rs.getString("CAL1");
		cal2			= rs.getString("CAL2");
		cal3			= rs.getString("CAL3");
		cal4			= rs.getString("CAL4");
		cal5			= rs.getString("CAL5");
		cal6			= rs.getString("CAL6");
		cal7			= rs.getString("CAL7");
		cal8			= rs.getString("CAL8");
		cal9			= rs.getString("CAL9");
		cal10			= rs.getString("CAL10");
		nota			= rs.getString("NOTA");
		fNota			= rs.getString("F_NOTA");
		tipoCalId		= rs.getString("TIPOCAL_ID");
		comentario		= rs.getString("COMENTARIO");
		notaExtra		= rs.getString("NOTA_EXTRA");
		folio			= rs.getString("FOLIO");
		
		codigoId 		= codigoId == null ? "":codigoId;
		cursoId			= cursoId == null ? "":cursoId;
		cal1			= cal1 == null ? "0":cal1;
		cal2			= cal2 == null ? "0":cal2;
		cal3			= cal3 == null ? "0":cal3;
		cal4			= cal4 == null ? "0":cal4;
		cal5			= cal5 == null ? "0":cal5;
		cal6			= cal5 == null ? "0":cal6;
		cal7			= cal5 == null ? "0":cal7;
		cal8			= cal5 == null ? "0":cal8;
		cal9			= cal5 == null ? "0":cal9;
		cal10			= cal5 == null ? "0":cal10;
		nota			= nota == null ? "0":nota;
		fNota			= fNota == null ? "":fNota;
		tipoCalId		= tipoCalId == null ? "":tipoCalId;
		comentario		= comentario == null ? "":comentario;
		notaExtra		= notaExtra == null ? "0":notaExtra;
		folio			= folio == null ? "":folio;
	}
	
	public void mapeaRegId(Connection con, String codigoId, String folio) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, CURSO_ID," +
					" CAL1, CAL2, CAL3, CAL4, CAL5,CAL6,CAL7,CAL8,CAL9,CAL10, NOTA, TO_CHAR(F_NOTA, 'DD/MM/YYYY') AS F_NOTA, TIPOCAL_ID, COMENTARIO, NOTA_EXTRA, TO_CHAR(F_EXTRA, 'DD/MM/YYYY') AS F_EXTRA, FOLIO" +
					" FROM KRDX_CURSO_IMP" +
					" WHERE CODIGO_ID = ?" +				
					" AND FOLIO = TO_NUMBER(?, '99') ");
					
			ps.setString(1, codigoId);		
			ps.setString(2, folio);		
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImp|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_IMP" +
					" WHERE CODIGO_ID = ?" +					
					" AND FOLIO = TO_NUMBER(?, '99')");
					
			ps.setString(1, codigoId);			
			ps.setString(2, cursoId);		
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImp|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static boolean existeReg(Connection conn, String codigoId, String folio) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM KRDX_CURSO_IMP" +
					" WHERE CODIGO_ID = ?" +					
					" AND FOLIO = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);			
			ps.setString(2, folio);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImp|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String getNuevoFolio(Connection conn, String codigoId) throws SQLException{
		String folio 			= "";
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT MAX(FOLIO)+1 AS FOLIO FROM KRDX_CURSO_IMP" +
					" WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				folio = rs.getString("FOLIO");
				if(folio == null){
					folio = "1";
				}
			}else{
				folio = "1";
			}
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoImp|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return folio;
	}
}
