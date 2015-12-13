package test

import SistemaGeograficoInterface.Area
import SistemaGeograficoInterface.SistemaGeografico
import SistemaGeograficoInterface.Ubicacion
import autos.Agencia
import autos.Ejecutivo
import enums.EstadoAutoEnums
import enums.EstadoViajeEnums
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import pagosInterface.Pagos
import repositorios.RepoAgencias
import tipoEjecutivo.Gold
import tipoEjecutivo.Platinum
import tipoEjecutivo.Silver
import tipoEjecutivo.TipoEjecutivo
import usuarios.Usuario
import viajes.ViajeEjecutivo

@Accessors
class EjecutivoTestSuite {

////////////////////////////////////////////////////////////////////////////////
/********************************HARDCODEO*************************************/
////////////////////////////////////////////////////////////////////////////////

	Usuario nicolas 
	Usuario pablo
	
	/*
	 * Area 1 [agencia1 agencia2 nicolas]
	 * Area 2 [agencia3 pablo]
	 * 
	 * 
	 * el taxi1 esta mas lejos de nicolas que el taxi2, lo mismo con pablo
	 */
	
	ViajeEjecutivo viajeGold1 
	ViajeEjecutivo viajePlatinum1
	ViajeEjecutivo viajeSilver1
	
	
	TipoEjecutivo gold = new Gold(100, 80)
	TipoEjecutivo platinum = new Platinum(50, 30)
	TipoEjecutivo silver = new Silver(30, 10)
		
	
	Agencia agencia1
	Agencia agencia2
	Agencia agencia3
	
	//agencia1
	Ejecutivo autoGold1
	Ejecutivo autoGold2	
	Ejecutivo autoPlatinum1
	Ejecutivo autoPlatinum2
	Ejecutivo autoSilver1
	Ejecutivo autoSilver2

	//agencia2
	Ejecutivo autoGold3
	Ejecutivo autoPlatinum3
	Ejecutivo autoSilver3
	
	//agencia3
	Ejecutivo autoGold4
	Ejecutivo autoPlatinum4
	
	
	List<Area> listaArea1 =  new ArrayList<Area>
	List<TipoEjecutivo> listaTipoEje1 = new ArrayList<TipoEjecutivo>
	
	
	RepoAgencias repoAgencias = RepoAgencias.getInstance
	
	Pagos pagos = Pagos.getInstance		
	
	//Notificador notificador = Notificador.getInstance
	
	SistemaGeografico sistemaGeografico = SistemaGeografico.getInstance
	
	
	@Before
	def void cargarDatos(){
		
		nicolas = new Usuario("nicolas", "1111111111", new Ubicacion(10, 10))
		pablo = new Usuario("pablo", "1122222222", new Ubicacion(30, 30))

		viajeGold1 = new ViajeEjecutivo(new Ubicacion(1,1), gold)
		viajePlatinum1 = new ViajeEjecutivo(new Ubicacion(2,2), platinum)
		viajeSilver1 = new ViajeEjecutivo(new Ubicacion(3,3), silver)

		//agencia1
		autoGold1 = new Ejecutivo("gold1", gold, new Ubicacion(2,2))
		autoGold2 = new Ejecutivo("gold2", gold, new Ubicacion(1,1))
		autoPlatinum1 = new Ejecutivo("Platinum1", platinum, new Ubicacion(1,1))
		autoPlatinum2 = new Ejecutivo("Platinum2", platinum, new Ubicacion(1,1))
		autoSilver1 = new Ejecutivo("Platinum1", silver, new Ubicacion(1,1))
		autoSilver2 = new Ejecutivo("Platinum2", silver, new Ubicacion(1,1))

		listaArea1.clear
		listaArea1.addAll(new Area("1",null), new Area("2", null))
		
		listaTipoEje1.clear
		listaTipoEje1.addAll(gold, platinum, silver)
		
		agencia1 = new Agencia("agencia1", "1145678998",listaArea1, listaTipoEje1)
		agencia1.listaEjecutivos.addAll(autoGold1, autoGold2, autoPlatinum1, autoPlatinum2, autoSilver1, autoSilver2)
		
		
		//agencia2
		autoGold3 = new Ejecutivo("gold3", gold, new Ubicacion(3,3))
		autoPlatinum3 = new Ejecutivo("Platinum3", platinum, new Ubicacion(3,3))
		autoSilver3 = new Ejecutivo("Platinum3", silver, new Ubicacion(1,1))

		listaArea1.clear
		listaArea1.addAll(new Area("1",null), new Area("2", null))

				
		listaTipoEje1.clear
		listaTipoEje1.addAll(gold, platinum, silver)
		
		agencia2 = new Agencia("agencia2","1145678998", listaArea1, listaTipoEje1)
		agencia2.listaEjecutivos.addAll(autoGold3, autoPlatinum3, autoSilver3)
		
		//agencia3
		autoGold4 = new Ejecutivo("gold4", gold, new Ubicacion(4,4))
		autoPlatinum4 = new Ejecutivo("Platinum4", platinum, new Ubicacion(4,4))

		listaArea1.clear
		listaArea1.addAll(new Area("3",null))
		
		listaTipoEje1.clear
		listaTipoEje1.addAll(gold, platinum)
		
		agencia3 = new Agencia("agencia3", "1145678998",listaArea1, listaTipoEje1)
		agencia3.listaEjecutivos.addAll(autoGold4, autoPlatinum4)
		
		//repositorio
		repoAgencias.listaAgencias.clear
		repoAgencias.listaAgencias.addAll(agencia1, agencia2, agencia3)
	}
	
////////////////////////////////////////////////////////////////////////////////
/********************************TEST******************************************/
////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	@Test
	def void testNicolasPideUnViajeGoldYLoConsigue(){

		nicolas.solicitarViaje(viajeGold1)
		
		agencia1.aceptarViaje(viajeGold1)
		
		Assert.assertTrue(
			viajeGold1.estado == EstadoViajeEnums.ACEPTADO &&
			nicolas.ubicacionDelAutoQueTeVieneABuscar.equals(viajeGold1.ejecutivo.ubicacion)						
		)	
	}
	
	@Test 
	def void testPAbloPideUnViajeSilverYEsRechazadoPorqueLaAgenciaNoTieneSilver(){
		
		pablo.solicitarViaje(viajeSilver1)
				
		Assert.assertTrue(viajeSilver1.estado == EstadoViajeEnums.RECHAZADO)
	}
	
	@Test 
	def void testPAbloPideUnViajeSilverYEsRechazadoPorLaunicaAgencia(){
		
		pablo.solicitarViaje(viajeGold1)
		
		agencia3.rechazarViaje(viajeGold1)
				
		Assert.assertTrue(viajeGold1.estado == EstadoViajeEnums.RECHAZADO)
	}
	
	@Test 
	def void testPAbloPideUnViajePlatinumYEsAceptado(){
		
		pablo.solicitarViaje(viajePlatinum1)
		
		agencia3.aceptarViaje(viajePlatinum1)
				
		Assert.assertTrue(
			viajePlatinum1.estado == EstadoViajeEnums.ACEPTADO &&
			pablo.ubicacionDelAutoQueTeVieneABuscar.equals(viajePlatinum1.ejecutivo.ubicacion)						
		)
	}
	
	@Test
	def void testNicolasPideUnViajeGoldYLoAceptaLaAgencia2(){

		nicolas.solicitarViaje(viajeGold1)
		
		agencia1.rechazarViaje(viajeGold1)
		agencia2.aceptarViaje(viajeGold1)
		
		Assert.assertTrue(
			viajeGold1.estado == EstadoViajeEnums.ACEPTADO &&
			nicolas.ubicacionDelAutoQueTeVieneABuscar.equals(viajeGold1.ejecutivo.ubicacion) &&
			viajeGold1.agencia.equals(agencia2)						
		)	
	}
	
	@Test 
	def void testSeRechazaUnViaje(){
		nicolas.solicitarViaje(viajeGold1)
		
		agencia1.rechazarViaje(viajeGold1)
		
		Assert.assertTrue(
			viajeGold1.agencia.equals(agencia2) &&
			agencia2.listaViajesEnEspera.contains(viajeGold1) &&
			!agencia1.listaViajesEnEspera.contains(viajeGold1)
		)
	}
	
	@Test
	def void testNicolasPideUnViajeYLoFinaliza(){
		nicolas.solicitarViaje(viajeSilver1)
		
		agencia1.finalizarViaje(viajeSilver1)
				
		Assert.assertTrue(
			viajeSilver1.estado == EstadoViajeEnums.FINALIZADO &&
			viajeSilver1.ejecutivo.estadoAuto == EstadoAutoEnums.OCUPADO
		)
	}
	
	@Test
	def void testNicolasPideUnViajeYLoCancela(){
		nicolas.solicitarViaje(viajeSilver1)
		
		agencia1.aceptarViaje(viajeSilver1)
		
		nicolas.cancelarViaje
				
		Assert.assertTrue(
			viajeSilver1.estado == EstadoViajeEnums.CANCELADO &&
			!agencia1.listaViajesAceptados.contains(viajeSilver1)
		)
	}
	
	@Test
	def void testNicolasPideUnViajeSeLoCancelaLaAgencia1YLoAceptaAgencia2(){
		
		nicolas.solicitarViaje(viajeSilver1)
		
		agencia1.aceptarViaje(viajeSilver1)
		agencia1.cancelarViaje(viajeSilver1)		
		
		agencia2.aceptarViaje(viajeSilver1)
		
		Assert.assertTrue(
			!agencia1.listaViajesAceptados.contains(viajeSilver1) &&
			agencia2.listaViajesAceptados.contains(viajeSilver1)
		)
	}
	
	@Test
	def void testNicolasPideUnViajeYlLoPagaEnEfectivo(){
		
		nicolas.solicitarViaje(viajePlatinum1)
		
		agencia1.aceptarViaje(viajePlatinum1)
		agencia1.finalizarViaje(viajePlatinum1)
		
		agencia1.confirmarPagoViajeConEjectivo(viajePlatinum1)
		
		Assert.assertTrue(
			viajePlatinum1.estado == EstadoViajeEnums.PAGADO &&
			viajePlatinum1.ejecutivo.estadoAuto == EstadoAutoEnums.LIBRE &&
			!agencia1.listaViajesAceptados.contains(this) &&
			nicolas.viaje === null			
		)
	}
	
	@Test
	def void testNicolasPideUnViajeYlLoPagaConTargetaAlPrincipio(){
		
		nicolas.solicitarViaje(viajePlatinum1)
		agencia1.aceptarViaje(viajePlatinum1)
		
		nicolas.confirmarPagoViaje		
		agencia1.finalizarViaje(viajePlatinum1)
		
		
		Assert.assertTrue(
			viajePlatinum1.estado == EstadoViajeEnums.PAGADO &&
			viajePlatinum1.ejecutivo.estadoAuto == EstadoAutoEnums.LIBRE &&
			!agencia1.listaViajesAceptados.contains(this) &&
			nicolas.viaje === null			
		)
	}
	
	@Test
	def void testNicolasPideUnViajeYlLoPagaConTargetaDespuesDeFianlizar(){
		
		nicolas.solicitarViaje(viajePlatinum1)
		
		agencia1.aceptarViaje(viajePlatinum1)
		agencia1.finalizarViaje(viajePlatinum1)
		
		nicolas.confirmarPagoViaje		
		
		
		Assert.assertTrue(
			viajePlatinum1.estado == EstadoViajeEnums.PAGADO &&
			viajePlatinum1.ejecutivo.estadoAuto == EstadoAutoEnums.LIBRE &&
			!agencia1.listaViajesAceptados.contains(this) &&
			nicolas.viaje === null			
		)
	}
	
	@Test
	def void testCostoDelViaje(){
		nicolas.solicitarViaje(viajeGold1)
		
		agencia1.aceptarViaje(viajeGold1)
		
		Assert.assertTrue(
			viajeGold1.costo > viajeGold1.ejecutivo.tipoEjecutivo.costoMinimo
		)
	}
	
	
}