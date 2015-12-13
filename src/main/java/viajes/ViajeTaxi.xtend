package viajes

import SistemaGeograficoInterface.SistemaGeografico
import autos.Taxi
import enums.EstadoViajeEnums
import java.util.ArrayList
import java.util.List
import repositorios.RepoTaxis
import usuarios.Usuario
import org.eclipse.xtend.lib.annotations.Accessors
import SistemaGeograficoInterface.Area
import java.util.Random
import enums.EstadoAutoEnums
import pagosInterface.Pagos

@Accessors
class ViajeTaxi implements Viaje{

	private double costo 

	private String id

	private Usuario usuario
	
	private EstadoViajeEnums estado	
	
	private Taxi taxi		
	
	private List<Taxi> taxisDisponibles = new ArrayList<Taxi>		
	
	private Pagos pagos = Pagos.getInstance 
	
	private SistemaGeografico sistemaGeografico = SistemaGeografico.getInstance	

	private RepoTaxis repoTaxis = RepoTaxis.getInstance
		
	//////////////
	//FUNCIONES
	//////////////
	
	new(){
		val random = new Random		
		id = random.nextInt(100).toString 	//esto es para poder hacer un equals y usarlo en los test, asi me es mas facil saber si un viaje es el correcto
		
		usuario = null
		taxi = null
		estado = null
	}
	
	def boolean elAreaDelUsuairoTienePadre(){
		return (usuario.area.padre != null)
	}
	
	def boolean quedanAutosParaSolicitar(){
		return (!taxisDisponibles.isEmpty)
	}

		
	//////////////
	//INTERFACE
	//////////////
	
	override getId(){
		return id
	}
	
	override equals(Object obj) {
		val ViajeTaxi viajeNuevo = obj as ViajeTaxi
		return (id == viajeNuevo.id)
	}
	
	override getUsuario() {
		return usuario
	}
	
	override setUsuario(Usuario usuarioNuevo) {
		usuario = usuarioNuevo
	}
	
	override setEstado(EstadoViajeEnums estadoNuevo) {
		estado = estadoNuevo
	}
	
	override getEstado() {
		return estado
	}
	override getUbicacionDelAuto() {
		return taxi.ubicacion
	}
	
	override cargarListaDeAutosDisponilbesEnLaZona(Area areaNueva){		
		taxisDisponibles = repoTaxis.taxisDisponibles(areaNueva)
			.sortBy[taxi| sistemaGeografico.distanciaEntre(usuario.ubicacion, taxi.ubicacion)]
			.toList
	}
	
	override buscarAuto(){ 	
		estado = EstadoViajeEnums.SOLICITADO
		
		if(quedanAutosParaSolicitar){
			taxi = taxisDisponibles.head
			taxisDisponibles.remove(0)
			
			taxi.pedirAceptarViaje(this)			
		}
		else if(elAreaDelUsuairoTienePadre){
			cargarListaDeAutosDisponilbesEnLaZona(usuario.area.padre)
			buscarAuto()
									
		}else{
			rechazarViaje
		}
	}
		
	override aceptarViaje() {
		usuario.viajeAceptado(this)
		estado = EstadoViajeEnums.ACEPTADO
	}
	
	override rechazarViaje() {		
		
		estado = EstadoViajeEnums.RECHAZADO
		taxi = null
		
		usuario.viajeRechazado(this)
	}
	
	override finalizarViaje() {
		estado = EstadoViajeEnums.FINALIZADO

		taxi.finalizarTaxi
		usuario.finalizarUsuario
	}
	
	override cancelarViaje() {
		estado = EstadoViajeEnums.CANCELADO
		
		taxi.estadoAuto = EstadoAutoEnums.LIBRE
	}
	
	override confirmarPagoViajeConEjectivo() {
			estado = EstadoViajeEnums.PAGADO
			
			usuario.viaje = null
			taxi.viaje = null
			
			taxi.estadoAuto = EstadoAutoEnums.LIBRE
			
			taxi.enviarMensaje(usuario.numeroDeCelular, "viaje pagado en efectivo")
	}
	
	override confirmarPagoViajeConTargeta() {
		if(pagos.sePuedeRealizarElPago(this)) {
			estado = EstadoViajeEnums.PAGADO
			
			usuario.confirmarPagoViajeUsuario
			taxi.confirmarPagoViajeTaxi
		}
		else{
			usuario.notificarPagoErroneo
		}
	}
	
	override numeroDeCelularDelAuto() {
		return taxi.numeroDeCelular
	}
	
	override solicitarViajePara(Usuario usuarioQueViaja){
		usuario = usuarioQueViaja
		estado = EstadoViajeEnums.SOLICITADO
		
		cargarListaDeAutosDisponilbesEnLaZona(usuarioQueViaja.area)
		buscarAuto()
	}
	
	

}