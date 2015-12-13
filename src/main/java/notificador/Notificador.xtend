package notificador

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Notificador {
	
	private static final Notificador notificador = new Notificador
	
	String aceptarViaje = "Un taxi acepto el viaje"
	String rechazarViaje = "todos los taxis rechazaron el viaje"
	String queresAceptarViaje = "¿queres aceptar el vieje?"
	String viajeFinalizado = "viaje finalizado"
	String viajeCancelado = "viaje cancelado"
	String viajePagado = "viaje pagado"
	String viajePagadoErroneo = "no se pudo realizar el pago"
	
	private new(){
	}
	
	public static def Notificador getInstance(){
		return notificador
	}
	
	def void enviarMensaje(String numero, String mensaje){
		
	}	
}