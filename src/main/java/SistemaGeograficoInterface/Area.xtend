package SistemaGeograficoInterface

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Area {
	
	private String id	
	private Area padre
	
	new(String idNuevo, Area padreNuevo){
		id = idNuevo		
	}
	
	override equals(Object obj){
		val Area areaComparar = obj as Area
		return (id == areaComparar.id)
	}	
	
}