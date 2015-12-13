package SistemaGeograficoInterface

class SistemaGeografico {
	
	private static final SistemaGeografico sistemaGeografico = new SistemaGeografico
	
	
	private new(){
		
	}
	
	public static def SistemaGeografico getInstance(){
		return sistemaGeografico
	}
	
	def Area obtenerArea(Ubicacion ubicacion){
		//hardcodeo
		var Area areaAux
		
		switch(ubicacion){
			//taxis
			case ubicacion.longitud == 1 && ubicacion.latitud == 1:
				areaAux = new Area("1",null)
			
			case ubicacion.longitud == 2 && ubicacion.latitud == 2:
				areaAux = new Area("1",null)
				
			case ubicacion.longitud == 3 && ubicacion.latitud == 3:
				areaAux = new Area("2",null)
				
			case ubicacion.longitud == 4 && ubicacion.latitud == 4:
				areaAux = new Area("3", null)
			
			case ubicacion.longitud == 5 && ubicacion.latitud == 5:
				areaAux = new Area("3", new Area("1", null) )
			
				
			//Usuarios
			case ubicacion.longitud == 10 && ubicacion.latitud == 10:
				areaAux = new Area("1",null)
				
			case ubicacion.longitud == 20 && ubicacion.latitud == 20:
				areaAux = new Area("2",null)
			
			case ubicacion.longitud == 30 && ubicacion.latitud == 30:
				areaAux = new Area("3",null)	
		}
		
		return areaAux
	}
	
	def double distanciaEntre(Ubicacion origen, Ubicacion destino){
		var double latitud = origen.latitud - destino.latitud
		var double longitud = origen.longitud - destino.longitud
			
		return Math.sqrt( Math.pow(longitud,2) + Math.pow(latitud, 2))		
	}
}