package aca.kinder;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import aca.ciclo.Ciclo;
import aca.ciclo.CicloLista;
import aca.conecta.Conectar;

public class KinderUtilCopia {

	private Connection con;

	public KinderUtilCopia() {
		super();
		this.con = new Conectar().conEliasPostgres();
	}

	public void close() {
		try {
			con.close();
		} catch (SQLException sqle) {

		}
	}

	public void copiaPanama() {

		UtilAreas uar = new UtilAreas(con);
		UtilCriterios ucr = new UtilCriterios(con);

		try {

			CicloLista ciclo = new CicloLista();

			List<Ciclo> lsCiclos = ciclo.getListAll(con,
					" and upper(CICLO_NOMBRE)='PARVULARIA K6 2018' AND ESTADO='A' and ciclo_id not in ('S211818G') ");

			Map<Long, Areas> mapAreas = uar.getMapAreas(0L, "", "S211818G", 1, "");
			Map<Long, Criterios> mapCriterios = ucr.getMapCriterios(0L, "", "S211818G", 0L, 1);

			for (Ciclo c : lsCiclos) {
				Map<Long, Areas> mapAreasDes = uar.getMapAreas(0L, "", c.getCicloId(), 1);
				Map<Long, Criterios> mapCriteriosDes = ucr.getMapCriterios(0L, "", c.getCicloId(), 0L, 1);
				if (mapAreasDes.size() == 0 && mapCriteriosDes.size() == 0) {
					for (Long ida : mapAreas.keySet()) {
						Areas a = mapAreas.get(ida);
						Areas an = new Areas();
						an.setArea(a.getArea());
						an.setCiclo_id(c.getCicloId());
						Long idan = uar.addAreaId(an);
						if (!idan.equals(0L)) {
							System.out.println("se agrego area " + an.toString());
							for (Long idc : mapCriterios.keySet()) {
								Criterios cb = mapCriterios.get(idc);
								if (cb.getArea_id().equals(a.getId())) {
									Criterios crn = new Criterios();
									crn.setArea_id(idan);
									crn.setCiclo_id(c.getCicloId());
									crn.setCriterio(cb.getCriterio());
									crn.setEstado(1);
									ucr.addCriterio(crn);
									System.out.println("se agrego criterio " + crn.toString());
								}
							}
						}

					}
				}else{
					System.out.println("no se inserto nada ya tiene datos");
				}
			}

		} catch (SQLException sqle) {
			System.out.println(sqle);
		}
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		KinderUtilCopia kuc = new KinderUtilCopia();

		kuc.copiaPanama();

		kuc.close();

	}

}
