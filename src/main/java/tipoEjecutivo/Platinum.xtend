package tipoEjecutivo

import enums.TipoEjecutivoEnums

class Platinum extends TipoEjecutivo{
	
	new(double costoMinN, double costoPorKMN){
		costoMinimo = costoMinN
		costoPorKM = costoPorKMN
		tipoEnum = TipoEjecutivoEnums.PLATINUM
	}
	
}