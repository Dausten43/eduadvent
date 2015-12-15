// Bean del Cat�logo de Bloques
package  aca.ciclo;
import java.sql.*;

public class CicloGrupoEval{
	private String cicloGrupoId;
	private String cursoId;
	private String evaluacionId;	
	private String evaluacionNombre;
	private String fecha;		
	private String valor;
	private String tipo;
	private String calculo;
	private String orden;
	private String estado;
	private String promedioId;
	
	
	public CicloGrupoEval(){
		cicloGrupoId		= "";
		cursoId				= "";
		evaluacionId		= "";
		evaluacionNombre	= "";
		fecha				= "";		
		valor				= "";
		tipo				= "";
		estado				= "";
		calculo				= "";
		orden				= "1";
		promedioId			= "";
	}
	
	
	/**
	 * @return Returns the cicloGrupoId.
	 */
	public String getCicloGrupoId() {
		return cicloGrupoId;
	}
	

	/**
	 * @param cicloGrupoId The cicloGrupoId to set.
	 */
	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}
	

	/**
	 * @return Returns the cursoId.
	 */
	public String getCursoId() {
		return cursoId;
	}


	/**
	 * @param cursoId The cursoId to set.
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}
	

	/**
	 * @return Returns the evaluacionId.
	 */
	public String getEvaluacionId() {
		return evaluacionId;
	}


	/**
	 * @param evaluacionId The evaluacionId to set.
	 */
	public void setEvaluacionId(String evaluacionId) {
		this.evaluacionId = evaluacionId;
	}
	

	/**
	 * @return Returns the evaluacionNombre.
	 */
	public String getEvaluacionNombre() {
		return evaluacionNombre;
	}
	

	/**
	 * @param evaluacionNombre The evaluacionNombre to set.
	 */
	public void setEvaluacionNombre(String evaluacionNombre) {
		this.evaluacionNombre = evaluacionNombre;
	}


	/**
	 * @return Returns the fecha.
	 */
	public String getFecha() {
		return fecha;
	}
	

	/**
	 * @param fecha The fecha to set.
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	

	/**
	 * @return Returns the tipo.
	 */
	public String getTipo() {
		return tipo;
	}
	

	/**
	 * @param tipo The tipo to set.
	 */
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	

	/**
	 * @return Returns the valor.
	 */
	public String getValor() {
		return valor;
	}


	/**
	 * @param valor The valor to set.
	 */
	public void setValor(String valor) {
		this.valor = valor;
	}
	
	public String getEstado() {
		return estado;
	}


	public void setEstado(String estado) {
		this.estado = estado;
	}

	/**
	 * @return the calculo
	 */
	public String getCalculo() {
		return calculo;
	}


	/**
	 * @param calculo the calculo to set
	 */
	public void setCalculo(String calculo) {
		this.calculo = calculo;
	}	


	/**
	 * @return the orden
	 */
	public String getOrden() {
		return orden;
	}


	/**
	 * @param orden the orden to set
	 */
	public void setOrden(String orden) {
		this.orden = orden;
	}
	
	public String getPromedioId() {
		return promedioId;
	}


	public void setPromedioId(String promedioId) {
		this.promedioId = promedioId;
	}


	public boolean insertReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{		
			
			ps = conn.prepareStatement("INSERT INTO CICLO_GRUPO_EVAL"+
				"(CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, EVALUACION_NOMBRE, FECHA, VALOR, TIPO, ESTADO, CALCULO, ORDEN ) "+
				"VALUES( ?, ?,"+
				"TO_NUMBER(?,'99'), "+
				"?, "+
				"TO_DATE(?,'DD/MM/YYYY'), "+				
				"TO_NUMBER(?,'999.99'), "+
				"?,?,?," +
				"TO_NUMBER(?,'99'))");
					
			ps.setString(1, cicloGrupoId);			
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			ps.setString(4, evaluacionNombre);
			ps.setString(5, fecha);						 
			ps.setString(6, valor);
			ps.setString(7, tipo);
			ps.setString(8, estado);
			ps.setString(9, calculo);
			ps.setString(10, orden);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|insertReg|:"+ex);	
		}finally{
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO_EVAL "+
				" SET EVALUACION_NOMBRE = ?,"+
				" FECHA = TO_DATE(?,'DD/MM/YYYY'),"+				
				" VALOR = TO_NUMBER(?,'999.99'),"+
				" TIPO  = ?, ESTADO = ?, CALCULO = ?," +
				" ORDEN = TO_NUMBER(?,'99')" +				
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND CURSO_ID = ?"+
				" AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, evaluacionNombre);
			ps.setString(2, fecha);						
			ps.setString(3, valor);
			ps.setString(4, tipo);
			ps.setString(5, estado);
			ps.setString(6, calculo);
			ps.setString(7, orden);
			ps.setString(8, cicloGrupoId);
			ps.setString(9, cursoId);
			ps.setString(10, evaluacionId);		
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static boolean updateEvalDatos(Connection conn, String cicloId, String evaluacionId, String Nombre, String fecha, String valor, String orden ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CICLO_GRUPO_EVAL "+
				"SET EVALUACION_NOMBRE = ?, "+
				"FECHA = TO_DATE(?,'DD/MM/YYYY'), "+
				"VALOR = TO_NUMBER(?,'999.99'), "+
				"ORDEN = TO_NUMBER(?,'99') "+
				"WHERE CICLO_GRUPO_ID LIKE ?||'%' "+
				"AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, Nombre);
			ps.setString(2, fecha);
			ps.setString(3, valor);
			ps.setString(4, orden);
			ps.setString(5, cicloId);			
			ps.setString(6, evaluacionId);			
			
			if (ps.executeUpdate() > 0)
				ok = true;	
			else
				ok = true;
			
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static boolean deleteEvalDatos(Connection conn, String cicloId, String evaluacionId ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_EVAL "+
				"WHERE CICLO_GRUPO_ID LIKE ?||'%' "+
				"AND EVALUACION_ID = TO_NUMBER(?,'99')");
			
			ps.setString(1, cicloId);			
			ps.setString(2, evaluacionId);			
			
			if (ps.executeUpdate() > 0)
				ok = true;	
			else
				ok = true;
			
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|deleteEvalDatos|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? AND CURSO_ID = ? AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn, String cicloGrupoId) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? ");
			ps.setString(1, cicloGrupoId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
			
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	/*
	 * BORRA LAS EVALUACIONES DE UNA MATERIA
	 * */
	public static boolean deleteGrupoEval(Connection conn, String cicloGrupoId, String cursoId) throws Exception{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CICLO_GRUPO_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			if (ps.executeUpdate() >= 1)
				ok = true;
			else
				ok = false;
			
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|deleteGrupoEval|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		cicloGrupoId 		= rs.getString("CICLO_GRUPO_ID");
		cursoId				= rs.getString("CURSO_ID");
		evaluacionId 		= rs.getString("EVALUACION_ID");
		evaluacionNombre	= rs.getString("EVALUACION_NOMBRE");
		fecha	 			= rs.getString("FECHA");	
		valor 				= rs.getString("VALOR");
		tipo 				= rs.getString("TIPO");	
		estado				= rs.getString("ESTADO");
		calculo				= rs.getString("CALCULO");
		orden				= rs.getString("ORDEN");
		promedioId			= rs.getString("PROMEDIO_ID");
	}
	
	public void mapeaRegId( Connection conn, String cicloGrupoId, String cursoId, String evaluacionId ) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
		ps = conn.prepareStatement("SELECT"+
			" CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, EVALUACION_NOMBRE,"+ 
			" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPO, ESTADO, CALCULO, ORDEN, PROMEDIO_ID"+
			" FROM CICLO_GRUPO_EVAL"+
			" WHERE CICLO_GRUPO_ID = ?"+
			" AND CURSO_ID = ?"+
			" AND EVALUACION_ID = TO_NUMBER(?,'99')");
		ps.setString(1, cicloGrupoId);
		ps.setString(2, cursoId);
		ps.setString(3, evaluacionId);
		
		rs = ps.executeQuery();
		if (rs.next()){
			mapeaReg(rs);
		}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|existeReg|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? " +
				"AND CURSO_ID = ? "+
				"AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public String maximoReg(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String maximo			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(EVALUACION_ID)+1,'1') AS MAXIMO "+
				"FROM CICLO_GRUPO_EVAL "+				
				"WHERE CICLO_GRUPO_ID = ? " +				
				"AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	//Notas Registradas
	public boolean notasReg(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		boolean bOk				= false;
		
		try{
			ps = conn.prepareStatement("SELECT * "+
				"FROM KRDX_ALUM_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? "+
				"AND CURSO_ID = ? "+
				"AND EVALUACION_ID = TO_NUMBER(?,'99') "+
				"AND NOTA!=0");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs = ps.executeQuery();
			if (rs.next()) bOk = true;							
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|notasReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return bOk;
	}
	
	public boolean deleteNotas(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		boolean bOk			 	= false;		
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("DELETE FROM KRDX_ALUM_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? "+
				"AND CURSO_ID = ? "+
				"AND EVALUACION_ID = TO_NUMBER(?,'99')");	
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			if (ps.executeUpdate() > 0)		
				bOk = true;
			else
				bOk = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|deleteNotas|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}	
		
		return bOk;
	}
	
	public static double promedioEstrategia(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		double promedio=0, alumnos=0;
		
		
		try{
			ps = conn.prepareStatement("SELECT NOTA "+
				"FROM KRDX_ALUM_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? "+
				"AND CURSO_ID = ? "+
				"AND EVALUACION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);			
			rs = ps.executeQuery();
			while(rs.next()){
				alumnos++;
				promedio += rs.getDouble("NOTA");
			}
			promedio = promedio / alumnos;		
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|promedioEstrategia|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return promedio;
	}	
	
	public int numEvaluaciones(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int evaluaciones		= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(EVALUACION_ID) AS NUMEVAL "+
				"FROM CICLO_GRUPO_EVAL "+
				"WHERE CICLO_GRUPO_ID = ? "+
				"AND CURSO_ID = ? ");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);						
			rs = ps.executeQuery();
			while(rs.next()){				
				evaluaciones = rs.getInt("NUMEVAL");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|numEvaluaciones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return evaluaciones;
	}
	
	public static boolean estanTodasCerradas(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int evaluaciones		= 0;
		boolean ok				= false;
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(EVALUACION_ID) AS NUMEVAL"+
				" FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND CURSO_ID = ?" +
				" AND ESTADO != 'C'");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);						
			rs = ps.executeQuery();
			while(rs.next()){				
				evaluaciones = rs.getInt("NUMEVAL");
				if(evaluaciones == 0)
					ok = true;
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|estanTodasCerradas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	public static String tieneNotasConCero(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String cantidad 		= "0";
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS CANTIDAD "+
				" FROM KRDX_ALUM_EVAL "+
				" WHERE CICLO_GRUPO_ID = ? "+
				" AND CURSO_ID = ? "+
				" AND EVALUACION_ID = TO_NUMBER(?,'99')"+ 
				" AND NOTA>0 ");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				cantidad = rs.getString("CANTIDAD");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|tieneNotasConCero|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return cantidad;
	}
	
	public static String getEstado(Connection conn, String cicloGrupoId, String cursoId, int evaluacionId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String estado 			= "X";
		
		try{
			ps = conn.prepareStatement("SELECT ESTADO FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND CURSO_ID = ?" +
				" AND EVALUACION_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setInt(3, evaluacionId);
			
			rs = ps.executeQuery();
			while(rs.next()){				
				estado = rs.getString("ESTADO");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|estanTodasCerradas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return estado;
	}
	
	public static boolean conductaBimestralCerrada(Connection conn, String cicloGrupoId, String evaluacionId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		boolean ok				= false;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND EVALUACION_ID = TO_NUMBER(?, '99')" +
					" AND CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CONDUCTA = 'S')" +
					" AND ESTADO != 'C'");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, evaluacionId);
			
			rs = ps.executeQuery();
			if(!rs.next()){
				ok = true;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|conductaBimestralCerrada|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return ok;
	}
	
	public static boolean tieneEstrategias(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CICLO_GRUPO_EVAL" +
					" WHERE CICLO_GRUPO_ID = ?" +
					" AND CURSO_ID = ?");
			
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|tieneEstrategias|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public static String getNombreEstrategia(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String nombre 			= "X";
		
		try{
			ps = conn.prepareStatement("SELECT EVALUACION_NOMBRE FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND CURSO_ID = ?" +
				" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs = ps.executeQuery();
			while(rs.next()){				
				nombre = rs.getString("EVALUACION_NOMBRE");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|getNombreEstrategia|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return nombre;
	}
	
	public static String getCalculo(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String nombre 			= "X";
		
		try{
			ps = conn.prepareStatement("SELECT CALCULO FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND CURSO_ID = ?" +
				" AND EVALUACION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);
			ps.setString(3, evaluacionId);
			
			rs = ps.executeQuery();
			while(rs.next()){				
				nombre = rs.getString("CALCULO");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|getNombreEstrategia|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return nombre;
	}
	
	public static int getNumEval(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		int total				= 0;
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(COUNT(EVALUACION_ID),0) AS NUMEVAL FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = ?"+
				" AND CURSO_ID = ?");
			ps.setString(1, cicloGrupoId);
			ps.setString(2, cursoId);		
			
			rs = ps.executeQuery();
			while(rs.next()){				
				total = rs.getInt("NUMEVAL");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|getNumEval|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return total;
	}
	
	public static String getMaxOrden(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String max				= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ORDEN)+1,'1') AS MAXIMO "+
				" FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+
				" AND CURSO_ID = '"+cursoId+"'");
			
			rs = ps.executeQuery();
			while(rs.next()){				
				max = rs.getString("MAXIMO");
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEval|getMaxOrden|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
		
		return max;
	}
	
}
