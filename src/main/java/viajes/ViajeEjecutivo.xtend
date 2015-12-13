package viajes

import SistemaGeograficoInterface.Area
import SistemaGeograficoInterface.SistemaGeografico
import SistemaGeograficoInterface.Ubicacion
import autos.Agencia
import autos.Ejecutivo
import enums.EstadoViajeEnums
import java.util.ArrayList
import java.util.List
import java.util.Random
import pagosInterface.Pagos
import repositorios.RepoAgencias
import tipoEjecutivo.TipoEjecutivo
import usuarios.Usuario
import org.eclipse.xtend.lib.annotations.Accessors
import enums.EstadoAutoEnums

@Accessors
class ViajeEjecutivo implements Viaje{
	
	private String id
	
	private double costo 	
	
	private TipoEjecutivo tipoejecutivo
	private Ubicacion destino

	private Agencia agencia
	private Usuario usuario
	private Ejecutivo ejecutivo
	
	private EstadoViajeEnums estado

	private List<Agencia> agenciasDisponibles = new ArrayList<Agencia>	
	
	private RepoAgencias repoAgencias = RepoAgencias.getInstance
	
	SistemaGeografico sistemaGeografico = SistemaGeografico.getInstance	
	Pagos pagos = Pagos.getInstance
	
	new(Ubicacion destinoNuevo, TipoEjecutivo tipoEjecutivoNuevo){
		destino = destinoNuevo	
		tipoejecutivo = tipoEjecutivoNuevo
		
		val random = new Random		
		id = random.nextInt(100).toString 	//esto es para poder hacer un equals y usarlo en los test, asi me es mas facil saber si un viaje es el correcto
		
		
	}
	
	override buscarAuto() {
		
		if(quedanAgenciasParaSolicitar){
			agencia = agenciasDisponibles.head
			agenciasDisponibles.remove(0)
			
			usuario.enviarMensaje(agencia.numeroDeCelular, "Aceptas el viaje?")			
			agencia.pedirAceptarViaje(this)			
		}
		else if(elAreaDelUsuairoTienePadre){
			cargarListaDeAutosDisponilbesEnLaZona(usuario.area.padre)
			buscarAuto()
									
		}else{
			rechazarViaje
		}
	}
	
	override cargarListaDeAutosDisponilbesEnLaZona(Area areaNueva) {
		agenciasDisponibles.clear
		agenciasDisponibles.addAll(repoAgencias.agenciasDisponibles(areaNueva, tipoejecutivo))
	}
	
	def boolean elAreaDelUsuairoTienePadre(){
		return (usuario.area.padre != null)
	}
	
	def boolean quedanAgenciasParaSolicitar(){
		return (!agenciasDisponibles.isEmpty)
	}
	
	
	override getUsuario() {
		return usuario
	}
	
	override setUsuario(Usuario usuarioNuevo) {
		usuario = usuarioNuevo
	}
	
	
	override getEstado() {
		return estado
	}
	
	override setEstado(EstadoViajeEnums estadoNuevo) {
		estado = estadoNuevo
	}
	
	override getUbicacionDelAuto() {
		return ejecutivo.ubicacion
	}
	
	override getId() {
		return id
	}
	
	override aceptarViaje() {
		agencia.enviarMensaje(usuario.numeroDeCelular, "Vaieje aceptado, enviamos un auto para allá")
		
		usuario.viajeAceptado(this)
		usuario.ubicacionDelAutoQueTeVieneABuscar = ejecutivo.ubicacion
		
		costo = ejecutivo.tipoEjecutivo.costoMasAlto(destino, ejecutivo.ubicacion)
		
		estado = EstadoViajeEnums.ACEPTADO
	}
	
	override rechazarViaje() {
		if (agencia!== null)agencia.enviarMensaje(usuario.numeroDeCelular, "viaje rechazado")
		else usuario.enviarMensaje(usuario.numeroDeCelular, "viaje rechazado")
		
		estado = EstadoViajeEnums.RECHAZADO
		ejecutivo = null
		agencia = null
		
		usuario.viajeRechazado(this)
	}
	
	override finalizarViaje() {
		
		if(estado == EstadoViajeEnums.PAGADO){
			estado = EstadoViajeEnums.PAGADO
		
			usuario.viaje = null
			agencia.listaViajesAceptados.remove(this)
		
			ejecutivo.estadoAuto = EstadoAutoEnums.LIBRE
		}else{
			estado = EstadoViajeEnums.FINALIZADO
		}
		
		usuario.enviarMensaje(agencia.numeroDeCelular, "viaje finalizado")
		agencia.enviarMensaje(usuario.numeroDeCelular, "viaje finalizado")
	}
	
	override cancelarViaje() {
		estado = EstadoViajeEnums.CANCELADO
		
		ejecutivo.estadoAuto = EstadoAutoEnums.LIBRE
		agencia.listaViajesAceptados.remove(this)
				
		usuario.enviarMensaje(agencia.numeroDeCelular, "viaje cancelado")		
		agencia.enviarMensaje(usuario.numeroDeCelular, "viaje cancelado")
	}
	
	override confirmarPagoViajeConEjectivo() {
		estado = EstadoViajeEnums.PAGADO
		
		usuario.viaje = null
		agencia.listaViajesAceptados.remove(this)
		
		ejecutivo.estadoAuto = EstadoAutoEnums.LIBRE
		
		agencia.enviarMensaje(usuario.numeroDeCelular, "el pago con targeta fue exitoso")
	}
	
	override confirmarPagoViajeConTargeta() {
		
		if (pagos.sePuedeRealizarElPago(this)){

			if(estado == EstadoViajeEnums.FINALIZADO){
				
				usuario.viaje = null
				agencia.listaViajesAceptados.remove(this)
				
				ejecutivo.estadoAuto = EstadoAutoEnums.LIBRE
			}
			estado = EstadoViajeEnums.PAGADO			
			
			agencia.enviarMensaje(usuario.numeroDeCelular, "pago con targeta exitoso")
			
		}else{
			agencia.enviarMensaje(usuario.numeroDeCelular, "pago con targeta fallido, no se pudo hacer el pago")
		}
	}
	
	override numeroDeCelularDelAuto() {
		return agencia.numeroDeCelular
	}
	
	override solicitarViajePara(Usuario usuarioQueViaja) {
		usuario = usuarioQueViaja
		estado = EstadoViajeEnums.SOLICITADO
		
		cargarListaDeAutosDisponilbesEnLaZona(usuarioQueViaja.area)
		buscarAuto()
	}
	
}