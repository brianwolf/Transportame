package tipoEjecutivo

import enums.TipoEjecutivoEnums

class Silver extends TipoEjecutivo{
	
	new(double costoMinN, double costoPorKMN){
		costoMinimo = costoMinN
		costoPorKM = costoPorKMN
		tipoEnum = TipoEjecutivoEnums.SILVER
	}
	
}