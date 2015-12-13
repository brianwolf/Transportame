package tipoEjecutivo

import org.eclipse.xtend.lib.annotations.Accessors
import enums.TipoEjecutivoEnums
import SistemaGeograficoInterface.Ubicacion
import SistemaGeograficoInterface.SistemaGeografico

@Accessors
abstract class TipoEjecutivo {
	
	double costoMinimo
	double costoPorKM
	SistemaGeografico sistemaGeografico = SistemaGeografico.getInstance
	
	TipoEjecutivoEnums tipoEnum

	override equals(Object obj){
		val TipoEjecutivo comparar = obj as TipoEjecutivo
		return (tipoEnum.equals(comparar.tipoEnum)) 
	}
		
	def double costoMasAlto(Ubicacion usuario, Ubicacion ejecutivo){
		
		val double costoKm = costoPorKM * sistemaGeografico.distanciaEntre(usuario, ejecutivo)
		
		if(costoMinimo < costoKm) return costoKm
		else return costoMinimo 
	}
}