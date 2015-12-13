package autos

import SistemaGeograficoInterface.Area
import SistemaGeograficoInterface.SistemaGeografico
import SistemaGeograficoInterface.Ubicacion
import notificador.Notificador
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Auto {
	
	private String id
	private String NumeroDeCelular
	
	private Area area	
	private Ubicacion ubicacion	
	
	private Notificador notificador
	private SistemaGeografico sistemaGeografico

	new(){
	}
	
	override equals(Object obj){
		val Auto comparar = obj as Auto
		return (id == comparar.id)
	}
}