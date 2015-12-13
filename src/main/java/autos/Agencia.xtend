package autos

import SistemaGeograficoInterface.Area
import SistemaGeograficoInterface.SistemaGeografico
import enums.EstadoAutoEnums
import java.util.ArrayList
import java.util.List
import notificador.Notificador
import org.eclipse.xtend.lib.annotations.Accessors
import tipoEjecutivo.TipoEjecutivo
import viajes.ViajeEjecutivo
import enums.EstadoViajeEnums

@Accessors
class Agencia extends Auto{
	
	private Notificador notificador = Notificador.getInstance
	
	List<ViajeEjecutivo> listaViajesAceptados = new ArrayList<ViajeEjecutivo>
	
	List<Ejecutivo> listaEjecutivos = new ArrayList<Ejecutivo>		
	List<Area> listaAreas = new ArrayList<Area>	
	List<TipoEjecutivo> listaTiposQueBrinda = new ArrayList<TipoEjecutivo>
	List<ViajeEjecutivo> listaViajesEnEspera = new ArrayList<ViajeEjecutivo>
	
	SistemaGeografico sistemaGeografico = SistemaGeografico.getInstance
	
	
	new(String idN, String numero,  List<Area> listaAreaN, List<TipoEjecutivo> listaTiposQueBrindaN){
		id = idN
		numeroDeCelular = numero
		
		listaAreas.addAll(listaAreaN)
		listaTiposQueBrinda.addAll(listaTiposQueBrindaN) 
	}

	def void pedirAceptarViaje(ViajeEjecutivo viajeEjecutivo){
		
		if(tengoAutosLibres){
			
			var ejecutivoQueHaceElViaje = listaEjecutivos
			.filter[ejecutivo|
				ejecutivo.estasLibre &&
				ejecutivo.tipoEjecutivo.equals(viajeEjecutivo.tipoejecutivo)]
			.sortBy[ejecutivo|
				sistemaGeografico.distanciaEntre(viajeEjecutivo.usuario.ubicacion, ejecutivo.ubicacion)]
			.toList
			.head
					
			viajeEjecutivo.ejecutivo = ejecutivoQueHaceElViaje
			ejecutivoQueHaceElViaje.estadoAuto = EstadoAutoEnums.OCUPADO
			
			listaViajesEnEspera.add(viajeEjecutivo)
			
		}else{
			rechazarViaje(viajeEjecutivo)
		}
	}
	
	def boolean tengoAutosLibres(){
		return (listaEjecutivos.exists[ejecutivo| ejecutivo.estasLibre])
	}
	
	def boolean tengoAutosLibresDeEsteTipo(TipoEjecutivo tipoEjecutivoABuscar){
		return (listaEjecutivos.exists[ejecutivo| 
			ejecutivo.estasLibre && 
			ejecutivo.tipoEjecutivo.equals(tipoEjecutivoABuscar)
		])
	}
	
	def void aceptarViaje(ViajeEjecutivo viajeEjecutivo){
		viajeEjecutivo.aceptarViaje
		
		listaViajesAceptados.add(viajeEjecutivo)
		listaViajesEnEspera.remove(viajeEjecutivo)
		
		//notificador.viajeAceptado(viajeEjecutivo.usuario, viajeEjecutivo)

	}
	
	def void rechazarViaje(ViajeEjecutivo viajeARechazar){
		
		if(viajeARechazar.ejecutivo !== null){
			viajeARechazar.ejecutivo.estadoAuto = EstadoAutoEnums.LIBRE
			viajeARechazar.ejecutivo = null
		}
		
		viajeARechazar.buscarAuto	
		
		listaViajesEnEspera.remove(viajeARechazar)
		
	}
	
	def void cancelarViaje(ViajeEjecutivo viajeACancelar){
		viajeACancelar.cancelarViaje
		viajeACancelar.buscarAuto		
		
	}
	
	def void finalizarViaje(ViajeEjecutivo viajeAFinalizar){
		viajeAFinalizar.finalizarViaje
	}
	
	def void confirmarPagoViajeConEjectivo(ViajeEjecutivo viaje){
		if(viaje.estado == EstadoViajeEnums.FINALIZADO)	viaje.confirmarPagoViajeConEfectivo;
	}
	
	def void enviarMensaje(String numero, String mensaje) {
		notificador.enviarMensaje(numero, mensaje)
	}
	
}