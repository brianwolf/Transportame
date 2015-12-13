package autos

import enums.EstadoAutoEnums
import viajes.Viaje
import tipoEjecutivo.TipoEjecutivo
import org.eclipse.xtend.lib.annotations.Accessors
import SistemaGeograficoInterface.Ubicacion

@Accessors
class Ejecutivo extends Auto{
	
	EstadoAutoEnums estadoAuto 
	
	TipoEjecutivo tipoEjecutivo	
	
	
	new(String idNuevo, TipoEjecutivo tipoEjecutivoNuevo, Ubicacion ubicacionN){
		id = idNuevo
		tipoEjecutivo = tipoEjecutivoNuevo
		estadoAuto = EstadoAutoEnums.LIBRE
		ubicacion = ubicacionN
	}
	
	
	def boolean estasLibre(){
		return (estadoAuto == EstadoAutoEnums.LIBRE)
	}
	
	def void pedirAceptarViaje(Viaje viajeNuevo){		
		//viajeEnEspera = viajeNuevo
		
		if(estasLibre){
			//mostrarle algo al chofer para que acepte o no
		}else{	
			rechazarViaje
		}
	}
	
	def void rechazarViaje(){
		//viajeEnEspera.buscarAuto
		//viajeEnEspera = null
	}
	
}
