package aca.reporte;

public class MateriaReporte {
	private String cursoId;
	private String nombre;
	private Double horas;
	private String calificacion;
	private String convalidacion;
	private String cursoBase;//Si es madre o hija
	private String boleta;//"S":sí aparece en boleta, "N": no aparece
	private String cicloGrupoId;
	
	public MateriaReporte(){
		cursoId = "";
		nombre = "";
		horas = 0.0;
		calificacion = "0.0";
		convalidacion = "";
		cursoBase = "";
		boleta = "";
		cicloGrupoId = "";
	}
	
	public MateriaReporte(String cursoId, String nombre, Double horas, String convalidacion, String cursoBase, String boleta, String cicloGrupoId){
		setCursoId(cursoId);
		setNombre(nombre);
		setHoras(horas);
		setConvalidacion(convalidacion);
		setCursoBase(cursoBase);
		setBoleta(boleta);
		setCicloGrupoId(cicloGrupoId);
	}
	
	public String getCursoId() {
		return cursoId;
	}
	
	public void setCursoId(String codigo) {
		this.cursoId = codigo;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public Double getHoras() {
		return horas;
	}
	
	public void setHoras(Double horas) {
		this.horas = horas;
	}
	
	public String getCalificacion() {
		return calificacion;
	}
	
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	
	public String getConvalidacion() {
		return convalidacion;
	}
	
	public void setConvalidacion(String convalidacion) {
		this.convalidacion = convalidacion;
	}
	
	public String getCursoBase() {
		return cursoBase;
	}
	
	public void setCursoBase(String cursoBase) {
		this.cursoBase = cursoBase;
	}
	
	public String getBoleta() {
		return boleta;
	}
	
	public void setBoleta(String boleta) {
		this.boleta = boleta;
	}

	public String getCicloGrupoId() {
		return cicloGrupoId;
	}

	public void setCicloGrupoId(String cicloGrupoId) {
		if(cicloGrupoId == null) {
			cicloGrupoId = "";
		}
		this.cicloGrupoId = cicloGrupoId;
	}
}
