package aca.ciclo;

public class CicloGrupoPromedio {

	private String CicloGrupoId;
	private String PromedioId;
	private String Ciclo_Id;
	private String nombre;
	private String corto;
	private String calculo;

	public CicloGrupoPromedio(){
		
		  CicloGrupoId	= "";
		  PromedioId 	= "";
		  Ciclo_Id 		= "";
		  nombre 		= "";
		  corto 		= "";
		  calculo 		= "";
	}

	public String getCicloGrupoId() {
		return CicloGrupoId;
	}

	public void setCicloGrupoId(String cicloGrupoId) {
		CicloGrupoId = cicloGrupoId;
	}

	public String getPromedioId() {
		return PromedioId;
	}

	public void setPromedioId(String promedioId) {
		PromedioId = promedioId;
	}

	public String getCiclo_Id() {
		return Ciclo_Id;
	}

	public void setCiclo_Id(String ciclo_Id) {
		Ciclo_Id = ciclo_Id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getCorto() {
		return corto;
	}

	public void setCorto(String corto) {
		this.corto = corto;
	}

	public String getCalculo() {
		return calculo;
	}

	public void setCalculo(String calculo) {
		this.calculo = calculo;
	}

}

