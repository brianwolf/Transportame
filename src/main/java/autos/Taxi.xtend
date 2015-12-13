package autos

import SistemaGeograficoInterface.SistemaGeografico
import SistemaGeograficoInterface.Ubicacion
import enums.EstadoAutoEnums
import enums.EstadoViajeEnums
import notificador.Notificador
import org.eclipse.xtend.lib.annotations.Accessors
import repositorios.RepoTaxis
import viajes.ViajeTaxi

@Accessors
class Taxi extends Auto {
	
	private Notificador notificador = Notificador.getInstance
	
	private double taximetro
	
	private RepoTaxis repoTaxi	
		
	private EstadoAutoEnums estadoAuto 
	private ViajeTaxi viaje
	private ViajeTaxi viajeEnEspera
	
	new(String idNuevo, String numeroCelularNuevo, Ubicacion ubicacionNueva){		
		id = idNuevo
		numeroDeCelular = numeroCelularNuevo
		
		ubicacion = ubicacionNueva
		
		estadoAuto = EstadoAutoEnums.LIBRE
		
		sistemaGeografico = SistemaGeografico.getInstance
		area = sistemaGeografico.obtenerArea(ubicacionNueva)		
		repoTaxi = RepoTaxis.getInstance
		
		viaje = null
		viajeEnEspera = null
	}
	
	def void actualizarEstadoEnElRepo(){
		repoTaxi.actualizarEstadoTaxi(this)
	}
	
	def boolean estasLibre(){
		return (estadoAuto == EstadoAutoEnums.LIBRE)
	}
	
	def void pedirAceptarViaje(ViajeTaxi viajeNuevo){
		viajeEnEspera = viajeNuevo

		if(!estasLibre)	{
			rechazarViaje
			return
		}
		
		notificador.enviarMensaje(numeroDeCelular, notificador.queresAceptarViaje)
	}
	
	def void aceptarViaje(){
		if(viaje !== null) return;
		
		viaje = viajeEnEspera
		viaje.costo = taximetro
		viajeEnEspera = null
			
		estadoAuto = EstadoAutoEnums.OCUPADO
		actualizarEstadoEnElRepo	
		
		viaje.aceptarViaje
	}
	
	def void rechazarViaje(){
		viajeEnEspera.buscarAuto
		viajeEnEspera = null
	}
	
	def void finalizarTaxi(){
		estadoAuto = EstadoAutoEnums.LIBRE
				
		enviarMensaje(numeroDeCelular, notificador.viajeFinalizado)
	}
	
	def void finalizarViaje(){
		viaje.finalizarViaje
	}
	
	def void cancelarViaje(){
		enviarMensaje(numeroDeCelular, notificador.viajeCancelado)
		
		viaje.cancelarViaje
		viaje.buscarAuto
		viaje = null
	}
	
	def void confirmarPagoYLiberarAuto(){
		viaje = null			
		estadoAuto = EstadoAutoEnums.LIBRE	
		notificador.enviarMensaje(numeroDeCelular, notificador.viajePagado)	
	}
	
	def void confirmarPagoViajeConEfectivo(){
		if(viaje.estado == EstadoViajeEnums.FINALIZADO)	viaje.confirmarPagoViajeConEfectivo
	}
	
	def void confirmarPagoViajeTaxi(){
		viaje = null
		estadoAuto = EstadoAutoEnums.LIBRE
		
		notificador.enviarMensaje(numeroDeCelular, notificador.viajePagado)
	}
	
	def enviarMensaje(String numero, String mensaje) {
		notificador.enviarMensaje(numero, mensaje)
	}	
}



