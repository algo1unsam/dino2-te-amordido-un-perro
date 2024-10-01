import wollok.game.*

const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.boardGround("fondo.png")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		

		game.onCollideDo(dino, { obstaculo => obstaculo.chocar() }) // se fija con que choca ( si es cactus llama a cactus.choar())

		keyboard.space().onPressDo{ self.iniciarGame()}

		keyboard.up().onPressDo({dino.saltar()}) // si toco up salto 

		
	} 
	
	method iniciarGame(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		game.start()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciarGame()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
}

object reloj {
	var property tiempo = 0 
	method text() = tiempo.toString()
   	method textColor() = "FFA500FF"
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo+1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.stop()
	}
}

object cactus {
	var property position = self.posicionInicial()

	method image() = "cactus.png"
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
    if (position.x() > 0)
        position = position.left(1)
    else
        position = self.posicionInicial()
	} // posicion inicial = borde derecho , muevo el cactus hacia la izquierda y cuando la posicion en X sea 0 vuelve al borde derecho
	
	method chocar(){ //llama a dino.morir() que termina el juego mientras dice auch
	dino.morir()
	}
    method detener(){
		game.schedule(100, { game.stop() }) // terminar game
	}
}

object suelo{

	method position() = game.origin().up(1)
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var property position = game.at(1, suelo.position().y())

	var alturaSalto = 2 // lo q dino salta y baja

	var enSuelo = true 

	method image() = "dino.png"
	
	method saltar() {
		if (vivo  && enSuelo) { // Solo si está vivo
			self.subir(alturaSalto) 
			enSuelo = false //sino podia saltar muchaas veces jaja
			game.schedule(800, { self.bajar(alturaSalto) }) // Esperar 0.8 seg y  bajar
		}
	}
	
	method subir(cantidad) {
		position = position.up(cantidad) 
	}
	
	method bajar(cantidad) {
		position = position.down(cantidad) 
		enSuelo = true
	}
	
	method morir() {
		game.say(self, "¡Auch!")
		vivo = false
		cactus.detener()
	}
	
	method iniciar() {
		vivo = true
	}
	
	method estaVivo() {
		return vivo
	}

}
