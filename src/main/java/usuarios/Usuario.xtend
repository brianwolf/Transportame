package usuarios

import SistemaGeograficoInterface.Area
import SistemaGeograficoInterface.SistemaGeografico
import SistemaGeograficoInterface.Ubicacion
import notificador.Notificador
import org.eclipse.xtend.lib.annotations.Accessors
import pagosInterface.Pagos
import viajes.Viaje

@Accessors
class Usuario {

	private String nombre
	private String numeroDeCelular

	private String numeroTargeta
	
	private Ubicacion ubicacion	
	private Area area	
	private Viaje viaje
	
	private SistemaGeografico sistemaGeografico = SistemaGeografico.getInstance
	private Pagos pagos = Pagos.getInstance
	private Notificador notificador = Notificador.getInstance

	
	private Ubicacion ubicacionDelAutoQueTeVieneABuscar

	new(String nombreNuevo, String numeroDeCelularNuevo, Ubicacion ubicacionNueva){
		nombre = nombreNuevo
		numeroDeCelular = numeroDeCelularNuevo
		
		ubicacion = ubicacionNueva
		area = sistemaGeografico.obtenerArea(ubicacionNueva)
	}


	def void viajeAceptado(Viaje viajeAceptado){
		notificador.enviarMensaje(numeroDeCelular, notificador.aceptarViaje)
		
		ubicacionDelAutoQueTeVieneABuscar = viajeAceptado.ubicacionDelAuto
	}
	
	def void viajeRechazado(Viaje viajeRechazado){
		notificador.enviarMensaje(numeroDeCelular, notificador.rechazarViaje)
	}
	
	def void solicitarViaje(Viaje viajeNuevo){	
		viaje = viajeNuevo 
		viaje.solicitarViajePara(this)		
	}
	
	def void finalizarUsuario(){
		notificador.enviarMensaje(numeroDeCelular, notificador.viajeFinalizado)
	}
	
	def void finalizarViaje(){
		if(viaje === null) return;
		
		viaje.finalizarViaje
	}
	
	def void cancelarViaje(){
		if(viaje === null) return;
		
		viaje.cancelarViaje
		viaje = null
		
	}
	
	def void confirmarPagoViajeUsuario(){
		viaje = null
		notificador.enviarMensaje(numeroDeCelular, "viaje pagado con targeta")
	}
	
	def void confirmarPagoViaje(){
		//el usuairo lo paga siempre con targeta, si paga en ejectivo lo confirma el auto
		viaje.confirmarPagoViajeConTargeta
	}
	
	def void notificarPagoErroneo(){
		notificador.enviarMensaje(numeroDeCelular, notificador.viajePagadoErroneo)
	}

	def void enviarMensaje(String numero, String mensaje) {
		notificador.enviarMensaje(numero, mensaje)
	}
	
}



















