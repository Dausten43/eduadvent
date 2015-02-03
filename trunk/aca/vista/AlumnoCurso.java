// Bean de la tabla KRDX_ALUMNO_EVAL
package  aca.vista;
import java.sql.*;

public class AlumnoCurso{
	private String codigoId;
	private String cicloGrupoId;
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
	private String notaExtra;
	private String fExtra;
	private String tipocalId;
	private String comentario;
	private String cicloId;
	private String falta1;
	private String falta2;
	private String falta3;
	private String falta4;
	private String falta5;
	private String falta6;
	private String falta7;
	private String falta8;
	private String falta9;
	private String falta10;
	
	public AlumnoCurso(){
		codigoId		= "";
		cicloGrupoId	= "";
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
		notaExtra		= "";
		fExtra			= "";
		tipocalId		= "";
		comentario		= "";
		cicloId			= "";
		falta1			= "";
		falta2			= "";
		falta3			= "";
		falta4			= "";
		falta5			= "";
		falta6			= "";
		falta7			= "";
		falta8			= "";
		falta9			= "";
		falta10			= "";
	}
	

	/**
	 * @return the cicloGrupoId
	 */
	public String getCicloGrupoId() {
		return cicloGrupoId;
	}


	/**
	 * @param cicloGrupoId the cicloGrupoId to set
	 */
	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}


	/**
	 * @return the falta1
	 */
	public String getFalta1() {
		return falta1;
	}


	/**
	 * @param falta1 the falta1 to set
	 */
	public void setFalta1(String falta1) {
		this.falta1 = falta1;
	}


	/**
	 * @return the falta2
	 */
	public String getFalta2() {
		return falta2;
	}


	/**
	 * @param falta2 the falta2 to set
	 */
	public void setFalta2(String falta2) {
		this.falta2 = falta2;
	}


	/**
	 * @return the falta3
	 */
	public String getFalta3() {
		return falta3;
	}


	/**
	 * @param falta3 the falta3 to set
	 */
	public void setFalta3(String falta3) {
		this.falta3 = falta3;
	}


	/**
	 * @return the falta4
	 */
	public String getFalta4() {
		return falta4;
	}


	/**
	 * @param falta4 the falta4 to set
	 */
	public void setFalta4(String falta4) {
		this.falta4 = falta4;
	}


	/**
	 * @return the falta5
	 */
	public String getFalta5() {
		return falta5;
	}


	/**
	 * @param falta5 the falta5 to set
	 */
	public void setFalta5(String falta5) {
		this.falta5 = falta5;
	}
	
	public String getFalta6() {
		return falta6;
	}


	/**
	 * @param falta6 the falta5 to set
	 */
	public void setFalta6(String falta6) {
		this.falta6 = falta6;
	}
	
	public String getFalta7() {
		return falta7;
	}


	/**
	 * @param falta7 the falta5 to set
	 */
	public void setFalta7(String falta7) {
		this.falta7 = falta7;
	}

	public String getFalta8() {
		return falta8;
	}


	/**
	 * @param falta8 the falta5 to set
	 */
	public void setFalta8(String falta8) {
		this.falta8 = falta8;
	}
	
	public String getFalta9() {
		return falta9;
	}


	/**
	 * @param falta9 the falta5 to set
	 */
	public void setFalta9(String falta9) {
		this.falta9 = falta9;
	}
	
	public String getFalta10() {
		return falta10;
	}


	/**
	 * @param falta10 the falta5 to set
	 */
	public void setFalta10(String falta10) {
		this.falta10 = falta10;
	}
	
	public String getCal1() {
		return cal1.equals("-1")?"-":cal1;
	}



	public void setCal1(String cal1) {
		this.cal1 = cal1;
	}



	public String getCal2() {
		return cal2.equals("-1")?"-":cal2;
	}



	public void setCal2(String cal2) {
		this.cal2 = cal2;
	}



	public String getCal3() {
		return cal3.equals("-1")?"-":cal3;
	}



	public void setCal3(String cal3) {
		this.cal3 = cal3;
	}



	public String getCal4() {
		return cal4.equals("-1")?"-":cal4;
	}



	public void setCal4(String cal4) {
		this.cal4 = cal4;
	}



	public String getCal5() {
		return cal5.equals("-1")?"-":cal5;
	}


	
	public void setCal5(String cal5) {
		this.cal5 = cal5;
	}

	public String getCal6() {
		return cal6.equals("-1")?"-":cal6;
	}


	
	public void setCal6(String cal6) {
		this.cal6 = cal6;
	}
	
	public String getCal7() {
		return cal7.equals("-1")?"-":cal7;
	}


	
	public void setCal7(String cal7) {
		this.cal7 = cal7;
	}
	
	public String getCal8() {
		return cal8.equals("-1")?"-":cal8;
	}


	
	public void setCal8(String cal8) {
		this.cal8 = cal8;
	}
	
	public String getCal9() {
		return cal9.equals("-1")?"-":cal9;
	}


	
	public void setCal9(String cal9) {
		this.cal9 = cal9;
	}
	
	public String getCal10() {
		return cal10.equals("-1")?"-":cal10;
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



	public String getTipocalId() {
		return tipocalId;
	}



	public void setTipocalId(String tipocalId) {
		this.tipocalId = tipocalId;
	}



	/**
	 * @return the cicloId
	 */
	public String getCicloId() {
		return cicloId;
	}


	/**
	 * @param cicloId the cicloId to set
	 */
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}


	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId			= rs.getString("CODIGO_ID");
		cicloGrupoId		= rs.getString("CICLO_GRUPO_ID");
		cursoId				= rs.getString("CURSO_ID");
		cal1				= rs.getString("CAL1");
		cal2				= rs.getString("CAL2");
		cal3 				= rs.getString("CAL3");
		cal4	 			= rs.getString("CAL4");		
		cal5				= rs.getString("CAL5");
		cal6 				= rs.getString("CAL6");
		cal7 				= rs.getString("CAL7");
		cal8 				= rs.getString("CAL8");
		cal9 				= rs.getString("CAL9");
		cal10 				= rs.getString("CAL10");
		nota 				= rs.getString("NOTA");
		fNota 				= rs.getString("F_NOTA");
		notaExtra 			= rs.getString("NOTA_EXTRA");
		fExtra 				= rs.getString("F_EXTRA");
		tipocalId 			= rs.getString("TIPOCAL_ID");
		comentario 			= rs.getString("COMENTARIO");
		cicloId				= rs.getString("CICLO_ID");
		falta1				= rs.getString("FALTA1");
		falta2				= rs.getString("FALTA2");
		falta3				= rs.getString("FALTA3");
		falta4				= rs.getString("FALTA4");
		falta5				= rs.getString("FALTA5");
		falta6				= rs.getString("FALTA6");
		falta7				= rs.getString("FALTA7");
		falta8				= rs.getString("FALTA8");
		falta9				= rs.getString("FALTA9");
		falta10				= rs.getString("FALTA10");
	}
	
	public void mapeaRegId( Connection conn, String codigoId, String cursoId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT "+
				" CODIGO_ID," +
				" CICLO_GRUPO_ID," +			
				" CURSO_ID," +
				" CAL1," +
				" CAL2," +
				" CAL3," +
				" CAL4," +
				" CAL5," +
				" CAL6," +
				" CAL7," +
				" CAL8," +
				" CAL9," +
				" CAL10," +				
				" NOTA," +
				" F_NOTA," +
				" NOTA_EXTRA," +
				" F_EXTRA," +
				" TIPOCAL_ID," +
				" COMENTARIO, " +
				" CICLO_ID, " +
				" FALTA1," +
				" FALTA2," +
				" FALTA3," +
				" FALTA4," +
				" FALTA5,"+
				" FALTA6,"+
				" FALTA7,"+
				" FALTA8,"+
				" FALTA9,"+
				" FALTA10"+
				" FROM ALUMNO_CURSO" +
				" WHERE CODIGO_ID = ? "+			
				" AND CURSO_ID = ?");			
			ps.setString(1, codigoId);		
			ps.setString(2, cursoId);		
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCurso|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 			ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps= null;
		
		try{
			ps = conn.prepareStatement("SELECT "+
					"CODIGO_ID, " +
					"CICLO_GRUPO_ID" +			
					"CURSO_ID, " +
					"CAL1, " +
					"CAL2, " +
					"CAL3, " +
					"CAL4, " +
					"CAL5, " +
					"NOTA," +
					"F_NOTA," +
					"NOTA_EXTRA," +
					"F_EXTRA," +
					"TIPOCAL_ID," +
					"COMENTARIO, " +
					"CICLO_ID "+
					"FROM ALUMNO_CURSO" +
					"WHERE CODIGO_ID = ? "+			
					"AND CURSO_ID = ?");		
			ps.setString(1, codigoId);			
			ps.setString(3, cursoId);			
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumnoCurso|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
}