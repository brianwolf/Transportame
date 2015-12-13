package repositorios

import java.util.List
import autos.Agencia
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import tipoEjecutivo.TipoEjecutivo
import SistemaGeograficoInterface.Area

@Accessors
class RepoAgencias {
	private static final RepoAgencias repoAgencias = new RepoAgencias
	
	List<Agencia> listaAgencias = new ArrayList<Agencia>
	
	
	private new(){
	}
	
	public static def RepoAgencias getInstance(){
		return repoAgencias
	}
	
	def List<Agencia> agenciasDisponibles(Area areaABuscar, TipoEjecutivo tipoABuscar){
		
		return listaAgencias.filter[agencia|
			agencia.listaAreas.contains(areaABuscar) &&
			agencia.listaTiposQueBrinda.contains(tipoABuscar) &&
			agencia.tengoAutosLibresDeEsteTipo(tipoABuscar)
		]
		.toList
	}
}




