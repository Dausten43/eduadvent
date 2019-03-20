package aca.reporte;

import java.util.ArrayList;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import aca.vista.AlumnoProm;

public class GradoReporte {
	private String cicloId;
	private String nombreGrado;
	private String cicloGrupoId;
	private String observaciones;
	private String nombrePlan;
	private String fechaInicial;
	private String fechaFinal;
	private ArrayList<MateriaReporte> listaMaterias;
	
	// Escala de evaluación... daaa xD
	private int escalaEval;
	// Tipo de redondeo en el ciclo
	private String redondeoCiclo;
	// Cantidad de decimales para las calificaciones
	private String numDecimales;
	// Math Context para manejar los formatos de los BigDecimal
	private java.math.MathContext mc;
	
	public GradoReporte() {
		cicloId = "";
		nombreGrado = "";
		cicloGrupoId = "";
		observaciones = "";
		listaMaterias = new ArrayList<MateriaReporte>();
	}
	
	public GradoReporte(Connection conElias, String planId, String cicloGrupoId, String grado) throws Exception{
		setCicloId(cicloGrupoId.equals("")?"":cicloGrupoId.substring(0, 8));
		setNombreGrado(aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(grado)));
		setCicloGrupoId(cicloGrupoId);
		setNombrePlan(aca.plan.Plan.getNombrePlan(conElias, planId));
		listaMaterias 	= new ArrayList<MateriaReporte>();
		
		/* Solo si el alumno tiene la posibilidad de tener
		 * calificaciones se inicializan las variables necesarias.
		 * De lo contrario se ignoran para evadir la llamada a la base de datos.
		 */
		if(!cicloGrupoId.equals("")){
			aca.ciclo.Ciclo ciclo = new aca.ciclo.Ciclo();
			ciclo.mapeaRegId(conElias, this.cicloId);
			setFInicial(ciclo.getFInicial());
			setFFinal(ciclo.getFFinal());
			setEscalaEval(aca.ciclo.Ciclo.getEscala(conElias, this.cicloId));
			setRedondeoCiclo(aca.ciclo.Ciclo.getRedondeo(conElias, this.cicloId));
			setNumDecimales(aca.ciclo.Ciclo.getDecimales(conElias, this.cicloId));
			setMc(new java.math.MathContext(4, java.math.RoundingMode.HALF_EVEN));
		}
	}
	
	public String getCicloId(){
		return cicloId;
	}
	
	public void setCicloId(String cicloId){
		this.cicloId = cicloId;
	}

	public String getNombrePlan() {
		return nombrePlan;
	}
	
	public void setNombrePlan(String nombrePlan) {
		this.nombrePlan = nombrePlan;
	}
	
	public String getNombreGrado() {
		return nombreGrado;
	}
	
	public void setNombreGrado(String nombreGrado) {
		this.nombreGrado = nombreGrado;
	}
	
	public ArrayList<MateriaReporte> getListaMaterias() {
		return listaMaterias;
	}
	
	public void setListaMaterias(ArrayList<MateriaReporte> listaMaterias){
		this.listaMaterias.addAll(listaMaterias);
	}
	
	public void setListaMaterias(Connection conElias, ArrayList<MateriaReporte> listaMaterias, String codigoId) throws Exception {
		this.listaMaterias.addAll(listaMaterias);
		
		java.util.TreeMap<String, AlumnoProm> treeProm = new java.util.TreeMap<String, AlumnoProm>();
		// Solo se inicializa si el alumno curso ese grado
		// para intentar evitar tantas llamadas a la base de datos
		if(!this.cicloGrupoId.equals("")){
			treeProm = new  aca.vista.AlumnoPromLista().getTreeCurso(conElias, this.cicloGrupoId,"");
		}
		
		for(MateriaReporte materia: this.listaMaterias){
			// Si el alumno curso esa materia se le calcula la calificación final
			if(!this.cicloGrupoId.equals("")){
				AlumnoProm alumProm = (AlumnoProm) treeProm.get(this.cicloGrupoId+materia.getCursoId()+codigoId);
				setCalificaciónFinal(conElias, codigoId, materia, alumProm);
			}
			// Si no se le asigna -
			else{
				materia.setCalificacion("-");
			}
		}
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getCicloGrupoId() {
		return cicloGrupoId;
	}

	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}

	public String getFInicial(){
		return fechaInicial;
	}
	
	public void setFInicial(String fecha){
		this.fechaInicial = fecha;
	}
	
	public String getFFinal(){
		return fechaFinal;
	}
	
	public void setFFinal(String fecha){
		this.fechaFinal = fecha;
	}

	
	public void setCalificaciónFinal(Connection conElias, String codigoId, MateriaReporte materia, AlumnoProm alumProm) throws Exception{
		// Aquí se calculará la calificación final de la materia...
		
		// THINK ABOUT IT
		
		// Pensar en si se deberían de obtener las calificaciones desde
		// la consulta en ReporteAlumno ya que si se hace una consulta
		// por materia podría resultar en un mal perfomance.
		// Just maybe...
		
		// Si es null significa que no tiene calificada la materia
		// Si la calificación es cero igual la ignora
		
		if(alumProm != null && !alumProm.getPromedio().equals("0.00000")){
			BigDecimal promFinalCurso = new BigDecimal(alumProm.getPromedio(), this.mc).add(new BigDecimal(alumProm.getPuntosAjuste(), this.mc), this.mc);
			String promConRedondeo = aca.ciclo.Ciclo.numRedondeo(conElias, String.valueOf(promFinalCurso), Integer.parseInt(this.numDecimales), this.redondeoCiclo);
			materia.setCalificacion(promConRedondeo);
		}else{
			materia.setCalificacion("-");
		}
	}

	public String getRedondeoCiclo() {
		return redondeoCiclo;
	}

	public void setRedondeoCiclo(String redondeoCiclo) {
		this.redondeoCiclo = redondeoCiclo;
	}

	public int getEscalaEval() {
		return escalaEval;
	}

	public void setEscalaEval(int escalaEval) {
		this.escalaEval = escalaEval;
	}
	
	public void setNumDecimales(String numDecimales){
		this.numDecimales = numDecimales;
	}
	
	public String getNumDecimales(){
		return numDecimales;
	}

	public java.math.MathContext getMc() {
		return mc;
	}

	public void setMc(java.math.MathContext mc) {
		this.mc = mc;
	}
}
