package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class CicloGrupoTareaLista {

	public ArrayList<CicloGrupoTarea> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGrupoTarea> lisCicloGrupoTarea 	= new ArrayList<CicloGrupoTarea>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoTarea cicloGrupo = new CicloGrupoTarea();				
				cicloGrupo.mapeaReg(rs);
				lisCicloGrupoTarea.add(cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTarea;
	}
	
	public ArrayList<CicloGrupoTarea> getListTareasTema(Connection conn, String cicloGrupoId, String cursoId, String temaId, String orden ) throws SQLException{
		ArrayList<CicloGrupoTarea> lisCicloGrupoTarea 	= new ArrayList<CicloGrupoTarea>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA " +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'" +
					" AND TEMA_ID = '"+temaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoTarea cicloGrupo = new CicloGrupoTarea();				
				cicloGrupo.mapeaReg(rs);
				lisCicloGrupoTarea.add(cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getListTareaTema|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTarea;
	}
	
	public String getInicioFinSemana(String semana){
        String[] se = semana.split("-");
        final Integer year = new Integer(se[0].trim());
        final Integer week = new Integer(se[1].trim());

        Calendar calendarFirstDay = Calendar.getInstance(new Locale("es_ES"));
        calendarFirstDay.set(Calendar.YEAR, year);
        calendarFirstDay.set(Calendar.WEEK_OF_YEAR, week);
        calendarFirstDay.setMinimalDaysInFirstWeek(3);
        calendarFirstDay.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        
        Calendar calendarLastDay = Calendar.getInstance(new Locale("es_ES"));
        calendarLastDay.set(Calendar.YEAR, year);
        calendarLastDay.set(Calendar.WEEK_OF_YEAR, week);
        calendarLastDay.setMinimalDaysInFirstWeek(3);
        calendarLastDay.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
        
        Date weekStart = calendarFirstDay.getTime();
        Date weekEnd = calendarLastDay.getTime(); 
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd 'de' MMM",new Locale("es_ES"));
        SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
        
		return "Semana del " + dateFormat.format(weekStart) + " al " + dateFormat.format(weekEnd) + " " + yearFormat.format(weekEnd);
    }
	
	
	
	
	public List<String> getTareasFecha(Connection conn, String codigoId, String fecha, String orden, String cicloId ) throws SQLException{
		List<String>salida	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		Statement stb 	= conn.createStatement();
		ResultSet rs 	= null;
		ResultSet rsb 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT distinct(extract(WEEK FROM fecha))  , to_char(extract(WEEK FROM fecha),'09') we , extract(YEAR FROM fecha) ye , SUBSTR(CICLO_GRUPO_ID,1,8) cicloid " +
					" FROM CICLO_GRUPO_TAREA WHERE CICLO_GRUPO_ID||CURSO_ID " +
					" IN (SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' )"
							+ " and SUBSTR(CICLO_GRUPO_ID,1,8) = (SELECT CICLO_ID FROM alum_ciclo where codigo_id='"+codigoId+"' "
						    + "and ciclo_id in (select ciclo_id from ciclo where current_timestamp BETWEEN f_inicial AND f_final) and estado='I')  "+orden;
			String comandob = " SELECT distinct(extract(WEEK FROM fecha))  , to_char(extract(WEEK FROM fecha),'09') we , extract(YEAR FROM fecha) ye, SUBSTR(CICLO_GRUPO_ID,1,8) cicloid " +
					" FROM CICLO_GRUPO_ACTIVIDAD " +
					" WHERE CICLO_GRUPO_ID||CURSO_ID " +
					" IN (SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' )" +
					" and SUBSTR(CICLO_GRUPO_ID,1,8) = (SELECT CICLO_ID FROM alum_ciclo where codigo_id='"+codigoId+"'"
					+ " and estado='I' and ciclo_id in (select ciclo_id from ciclo where current_timestamp BETWEEN f_inicial AND f_final)) and MOSTRAR='S' "+
					orden;
			rs = st.executeQuery(comando);	
			
			System.out.println(comando);
			System.out.println(comandob);
			
			while (rs.next()){
				salida.add(rs.getString("ye") + "-" +rs.getString("we"));
				System.out.println("cicloid" + rs.getString("cicloid"));
			}
			
			rsb = stb.executeQuery(comandob);
			while(rsb.next()){
				if(!salida.contains(rsb.getString("ye") + "-" +rsb.getString("we"))){
					salida.add(rsb.getString("ye") + "-" +rsb.getString("we"));
					System.out.println("cicloid" + rsb.getString("cicloid"));
				}
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getTareasFecha|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
			if (rsb!=null) rsb.close();
			if (stb!=null) stb.close();
		}
		
		return salida;
	}
	
	public ArrayList<CicloGrupoTarea> getTareasFecha(Connection conn, String codigoId, String fecha, String orden ) throws SQLException{
		ArrayList<CicloGrupoTarea> lisCicloGrupoTarea 	= new ArrayList<CicloGrupoTarea>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA WHERE TO_CHAR(FECHA,'DD/MM/YYYY') = '"+fecha+"' " +
					" AND CICLO_GRUPO_ID||CURSO_ID " +
					" IN (SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' ) "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoTarea cicloGrupo = new CicloGrupoTarea();				
				cicloGrupo.mapeaReg(rs);
				lisCicloGrupoTarea.add(cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getTareasFecha|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTarea;
	}
	
	public ArrayList<CicloGrupoTarea> getTareasFecha(Connection conn, String codigoId, String fecha, String orden, String cicloId, int algo) throws SQLException{
		ArrayList<CicloGrupoTarea> lisCicloGrupoTarea 	= new ArrayList<CicloGrupoTarea>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		String[] txtSplit=fecha.split("-");
		try{
			comando = "SELECT CICLO_GRUPO_ID, TAREA_ID, TAREA_NOMBRE, DESCRIPCION, TEMA_ID, CURSO_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA" +
					" FROM CICLO_GRUPO_TAREA WHERE CICLO_GRUPO_ID||CURSO_ID " +
					" IN (SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' AND TIPOCAL_ID != 6) "
						+ " and SUBSTR(CICLO_GRUPO_ID,1,8) = (SELECT CICLO_ID FROM alum_ciclo where codigo_id='"+codigoId+"' "
						    + "and ciclo_id in (select ciclo_id from ciclo where current_timestamp BETWEEN f_inicial AND f_final) and estado='I') "
								+ " and extract(YEAR FROM fecha)=" + txtSplit[0] + " and extract(WEEK FROM fecha)=" + txtSplit[1]  + " "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoTarea cicloGrupo = new CicloGrupoTarea();				
				cicloGrupo.mapeaReg(rs);
				lisCicloGrupoTarea.add(cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoTareaLista|getTareasFecha|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloGrupoTarea;
	}

}
