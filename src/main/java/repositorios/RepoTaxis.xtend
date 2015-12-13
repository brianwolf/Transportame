package repositorios

import autos.Taxi
import java.util.List
import java.util.ArrayList
import SistemaGeograficoInterface.Area
import org.eclipse.xtend.lib.annotations.Accessors

class RepoTaxis {
	
	private static final RepoTaxis repositorioTaxis = new RepoTaxis

	@Accessors private List<Taxi> listaTaxis = new ArrayList<Taxi>
		
	
	private new(){
		
	}

	public static def RepoTaxis getInstance(){
		return repositorioTaxis
	}

	def List<Taxi> taxisDisponibles(Area area){			
		var List<Taxi> listaTaxisDisponibles = listaTaxis
		.filter[taxi| taxi.estasLibre && taxi.area.equals(area)]
		.toList
		
		return  listaTaxisDisponibles
	}
	
	def void actualizarEstadoTaxi(Taxi taxiAModificar){
		listaTaxis.remove(taxiAModificar)
		listaTaxis.add(taxiAModificar)
	}
}