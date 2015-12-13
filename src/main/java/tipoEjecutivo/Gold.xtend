package tipoEjecutivo

import enums.TipoEjecutivoEnums

class Gold extends TipoEjecutivo{
	
	new(double costoMinN, double costoPorKMN){
		costoMinimo = costoMinN
		costoPorKM = costoPorKMN		
		tipoEnum = TipoEjecutivoEnums.GOLD
	}
	
}