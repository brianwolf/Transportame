package pagosInterface

import viajes.Viaje

class Pagos {
	
	private static final Pagos pagos = new Pagos
	
	private new(){
		
	}
	
	public static def Pagos getInstance(){
		return pagos
	}
	
	def boolean sePuedeRealizarElPago(Viaje viaje){
		return true
	}
	
}