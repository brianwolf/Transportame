package test

import SistemaGeograficoInterface.Ubicacion
import autos.Taxi
import enums.EstadoAutoEnums
import enums.EstadoViajeEnums
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import repositorios.RepoTaxis
import usuarios.Usuario
import viajes.ViajeTaxi

//import static org.mockito.Matchers.*
import static extension org.mockito.Mockito.*
import notificador.Notificador

class TaxiTestSuite {
	
////////////////////////////////////////////////////////////////////////////////
/********************************HARDCODEO*************************************/
////////////////////////////////////////////////////////////////////////////////

	Usuario nicolas 
	Usuario pablo
		
	Taxi taxi1
	Taxi taxi2
	Taxi taxi3
	Taxi taxi4
	Taxi taxi5	
	
	/*
	 * Area 1 [taxi1 taxi2 nicolas]
	 * Area 2 [taxi3 taxi5 pablo]
	 * Area 3 [taxi4]
	 * 
	 * el taxi1 esta mas lejos de nicolas que el taxi2, lo mismo con pablo
	 */
	 
	ViajeTaxi autopistaBsAs
	
	RepoTaxis repoTaxis = RepoTaxis.getInstance
	
	Notificador notificadorMockeado = mock(Notificador)
	
	@Before
	def void cargarDatos(){
		notificadorMockeado = mock(Notificador)
		
		nicolas = new Usuario("nicolas","1111111111" , new Ubicacion(10, 10))
		pablo = new Usuario("pablo", "1122222222", new Ubicacion(20, 20))
	
		taxi1 = new Taxi("1", "1156676344",new Ubicacion(1,1)) 
		taxi2 = new Taxi("2", "1145678950",new Ubicacion(2,2))
		taxi3 = new Taxi("3", "1145678947",new Ubicacion(3,3))
		taxi4 = new Taxi("4", "1145678781",new Ubicacion(4,4))
		taxi5 = new Taxi("5", "1145612783",new Ubicacion(3,3))
		
		autopistaBsAs = new ViajeTaxi
		
		repoTaxis.listaTaxis.clear
		repoTaxis.listaTaxis.add(taxi1)
		repoTaxis.listaTaxis.add(taxi2)
		taxi3.estadoAuto = EstadoAutoEnums.OCUPADO
		repoTaxis.listaTaxis.add(taxi3)
		repoTaxis.listaTaxis.add(taxi4)
		repoTaxis.listaTaxis.add(taxi5)
	}
	
////////////////////////////////////////////////////////////////////////////////
/********************************TEST******************************************/
////////////////////////////////////////////////////////////////////////////////

/*****************MOCK NOTIFICADOR**********************/
	@Test
	def void testTaxiAceptaUnViajeYLeEnviaUnMensageANicolas(){
		
		nicolas.notificador = notificadorMockeado
		taxi2.notificador = notificadorMockeado
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.aceptarViaje
		
		notificadorMockeado.verify(1.times).enviarMensaje(taxi2.numeroDeCelular, notificadorMockeado.queresAceptarViaje)
		notificadorMockeado.verify(1.times).enviarMensaje(nicolas.numeroDeCelular, notificadorMockeado.aceptarViaje)
		
		Assert.assertTrue(
			taxi2.viaje.equals(autopistaBsAs) && 
			nicolas.viaje.equals(autopistaBsAs) &&
			nicolas.ubicacionDelAutoQueTeVieneABuscar.equals(taxi2.ubicacion) &&
			autopistaBsAs.estado.equals(EstadoViajeEnums.ACEPTADO)
		)	
	}

	@Test
	def void testTaxi2RechazaUnViajeYSeLeNotificaATaxi1QueAcepta(){
		
		nicolas.notificador = notificadorMockeado
		taxi2.notificador = notificadorMockeado
		taxi1.notificador = notificadorMockeado
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.rechazarViaje
		
		taxi1.aceptarViaje		
	
		notificadorMockeado.verify(2.times).enviarMensaje("", notificadorMockeado.queresAceptarViaje)
		notificadorMockeado.verify(1.times).enviarMensaje(nicolas.numeroDeCelular, notificadorMockeado.aceptarViaje)
		
		Assert.assertTrue(
			taxi1.viaje.equals(autopistaBsAs) &&
			taxi2.viaje == null &&
			nicolas.ubicacionDelAutoQueTeVieneABuscar.equals(taxi1.ubicacion)
		)
		
	}	
	
	@Test
	def void testTodosLosTaxisDeLaZonaRechazan(){
		
		nicolas.notificador = notificadorMockeado
		taxi2.notificador = notificadorMockeado
		taxi1.notificador = notificadorMockeado
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.rechazarViaje
		taxi1.rechazarViaje
		
		notificadorMockeado.verify(2.times).enviarMensaje("", notificadorMockeado.queresAceptarViaje)
		notificadorMockeado.verify(1.times).enviarMensaje(nicolas.numeroDeCelular,notificadorMockeado.rechazarViaje)
		
		Assert.assertTrue(
			taxi1.viaje == null && 
			taxi2.viaje == null && 
			autopistaBsAs.estado.equals(EstadoViajeEnums.RECHAZADO)
		)	
	}
	
	
	
/*****************CASOS DE USO**********************/

	@Test
	def void testNicolasPideUnViajeYUnTaxiSeLoAcepta(){
		
		nicolas.solicitarViaje(autopistaBsAs)
	
		taxi2.aceptarViaje
		
		Assert.assertTrue(
			taxi2.viaje.equals(autopistaBsAs) && 
			nicolas.viaje.equals(autopistaBsAs) &&
			nicolas.ubicacionDelAutoQueTeVieneABuscar.equals(taxi2.ubicacion) &&
			autopistaBsAs.estado.equals(EstadoViajeEnums.ACEPTADO)
		)	
	}
	
	@Test
	def void testNicolasPideUnViajeYSeLoAceptaElSegundoTaxi(){
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.rechazarViaje
		taxi1.aceptarViaje		
	
		Assert.assertTrue(
			taxi1.viaje.equals(autopistaBsAs) &&
			taxi2.viaje == null &&
			nicolas.ubicacionDelAutoQueTeVieneABuscar.equals(taxi1.ubicacion)
		)
	}	

	@Test
	def void testNicolasPideUnViajeYNoSeLoAceptaNadie(){
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.rechazarViaje
		taxi1.rechazarViaje
		
		Assert.assertTrue(taxi1.viaje == null && taxi2.viaje == null && autopistaBsAs.estado.equals(EstadoViajeEnums.RECHAZADO))	
	}
	
	@Test
	def void testElViajeDePabloLoAceptaElTaxi5PorqueElTaxi3EstaOcupado(){
		pablo.solicitarViaje(autopistaBsAs)
		
		taxi5.aceptarViaje
		
		Assert.assertTrue(
			taxi5.viaje.equals(autopistaBsAs) &&
			taxi3.estadoAuto.equals(EstadoAutoEnums.OCUPADO) &&
			pablo.ubicacionDelAutoQueTeVieneABuscar.equals(taxi5.ubicacion)		
		)	
	}
	
	@Test
	def void elTaxi3ActualizaSuEstadoEnElRepo(){
		taxi3.estadoAuto = EstadoAutoEnums.LIBRE
		taxi3.actualizarEstadoEnElRepo
		
		Assert.assertTrue(repoTaxis.listaTaxis.size == 5)
	}
	
	@Test
	def void testAhoraElTaxi3AceptaElViajeDePabloPorqueSeDesocupo(){
		taxi3.estadoAuto = EstadoAutoEnums.LIBRE
		taxi3.actualizarEstadoEnElRepo
		
		pablo.solicitarViaje(autopistaBsAs)
		
		taxi5.rechazarViaje
		taxi3.aceptarViaje
		
		Assert.assertTrue(
			taxi3.viaje.equals(autopistaBsAs) &&
			taxi5.viaje == null &&
			taxi5.viajeEnEspera == null &&
			pablo.ubicacionDelAutoQueTeVieneABuscar.equals(taxi3.ubicacion)
		)
	}
	
	@Test
	def void nicolasPideUnViajePeroSeLoCancelaElTaxi(){
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.aceptarViaje
		taxi2.cancelarViaje
		
		taxi1.aceptarViaje
		
		Assert.assertTrue(
			autopistaBsAs.estado == EstadoViajeEnums.ACEPTADO &&
			autopistaBsAs.taxi.equals(taxi1) &&
			taxi2.estadoAuto == EstadoAutoEnums.LIBRE
		)
	}
	
	@Test
	def void nicolasPideUnViajePeroLoCancela(){
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.aceptarViaje
		
		nicolas.cancelarViaje	
		
		Assert.assertTrue(
			autopistaBsAs.estado == EstadoViajeEnums.CANCELADO &&
			taxi2.estadoAuto == EstadoAutoEnums.LIBRE
		)
	}
	
	@Test
	def void nicolasPideUnViajeYLoPagaConTargeta(){
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.aceptarViaje
		
		nicolas.confirmarPagoViaje
		
		Assert.assertTrue(
			autopistaBsAs.estado == EstadoViajeEnums.PAGADO &&
			taxi2.estadoAuto == EstadoAutoEnums.LIBRE
		)
	}
	
	@Test
	def void nicolasPideUnViajeYLoPagaEnEfectivo(){
		
		nicolas.solicitarViaje(autopistaBsAs)
		
		taxi2.taximetro = 120.5
		taxi2.aceptarViaje
		taxi2.finalizarViaje
				
		//nicolas le da la plata al taxi y este avisa que esta pago
		taxi2.confirmarPagoViajeConEfectivo
		
		Assert.assertTrue(
			autopistaBsAs.estado == EstadoViajeEnums.PAGADO 
		)
	} 
	
}












































