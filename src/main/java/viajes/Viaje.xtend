package viajes

import usuarios.Usuario
import enums.EstadoViajeEnums
import SistemaGeograficoInterface.Ubicacion
import SistemaGeograficoInterface.Area

interface Viaje {
	
	//Getters
	def String getId()
	def Usuario getUsuario()
	def EstadoViajeEnums getEstado()
	def Ubicacion getUbicacionDelAuto()
	
	//Setters
	def void setUsuario(Usuario usuarioNuevo)
	def void setEstado(EstadoViajeEnums estadoNuevo)
	
	//Funciones
	def void solicitarViajePara(Usuario usuarioQueViaja)
	def void cargarListaDeAutosDisponilbesEnLaZona(Area areaNueva)
	def void buscarAuto()
	override equals(Object obj)
	def void aceptarViaje()
	def void rechazarViaje()
	def void finalizarViaje()
	def void cancelarViaje()
	def void confirmarPagoViajeConEjectivo()
	def void confirmarPagoViajeConTargeta()
	
	def String numeroDeCelularDelAuto()
}