package SistemaGeograficoInterface

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Ubicacion {
	
	private double latitud	
	private double longitud
	
	new(double latitudNueva, double longitudNueva){
		latitud = latitudNueva
		longitud = longitudNueva
	}
	
	override equals(Object obj){
		val Ubicacion otraUbicacion = obj as Ubicacion
		return (latitud == otraUbicacion.latitud && longitud == otraUbicacion.longitud)
	}

}