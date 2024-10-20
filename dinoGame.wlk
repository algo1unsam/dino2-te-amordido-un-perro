import wollok.game.*

const velocidad = 250

object juego {

    method configurar() {
        game.width(12)
        game.height(8)
        game.title("Dino Game")
        game.boardGround("fondo.png")
        game.addVisual(suelo)
        game.addVisual(cactus)
        game.addVisual(dino)
        //game.addVisual(reloj)
        game.addVisual(comenzar)

        game.onCollideDo(dino, { obstaculo => obstaculo.chocar() }) // se fija con que choca

        keyboard.space().onPressDo { self.iniciarGame() }
        keyboard.c().onPressDo { tiempoDisplay.mostrar() } // Muestra el tiempo al presionar "C"
        keyboard.up().onPressDo { dino.saltar() } // si toco up salto 
    } 

    method iniciarGame() {
        dino.iniciar()
        reloj.iniciar()
        cactus.iniciar()
        game.removeVisual(comenzar)
        game.start()
    }

    method jugar() {
        if (dino.estaVivo())
            dino.saltar()
        else {
            game.removeVisual(gameOver)
            self.iniciarGame()
        }
    }

    method terminar() {
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

object comenzar {
    method position() = game.center()
    method text() = "Presione space para comenzar y C para ver tu recorrido"
    method textColor() = "05043b"
}

object reloj {
    var property tiempo = 0 

    method text() = tiempo.toString()
    method textColor() = "FFA500FF"
    method position() = game.at(1, game.height() - 3)

    method pasarTiempo() {
        tiempo = tiempo + 1
    }

    method iniciar() {
        tiempo = 0
        game.onTick(100, "tiempo", { self.pasarTiempo() })
    }

    method detener() {
        game.stop()
    }
}

object cactus {
    var property position = self.posicionInicial()

    method image() = "cactus.png"
    method posicionInicial() = game.at(game.width() - 1, suelo.position().y())

    method iniciar() {
        position = self.posicionInicial()
        game.onTick(velocidad, "moverCactus", { self.mover() })
    }

    method mover() {
        if (position.x() > 0)
            position = position.left(1)
        else
            position = self.posicionInicial()
    }

    method chocar() {
        dino.morir()
    }

    method detener() {
		game.addVisual(tiempoDisplay2)
        game.addVisual(gameOver)
        game.say(dino, "¡Auch!")
        game.schedule(100, { game.stop() })
    }
}

object suelo {
    method position() = game.origin().up(1)
    method image() = "suelo.png"
}

object dino {
    var vivo = true
    var property position = game.at(1, suelo.position().y())

    var alturaSalto = 2
    var enSuelo = true 

    method image() = "dino.png"

    method saltar() {
        if (vivo && enSuelo) {
            self.subir(alturaSalto)
            enSuelo = false
            game.schedule(800, { self.bajar(alturaSalto) })
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

object tiempoDisplay {
    var property position = game.at(2, game.height() - 2) 
 
    method text() = "Tiempo: " + reloj.tiempo().toString() // Muestra el tiempo
    method textColor() = "000000" 

    method mostrar() {
    game.addVisual(self) 
	 game.schedule(1000, { game.removeVisual(tiempoDisplay) })
    }
}
object tiempoDisplay2 {
    var property position = game.at(6, game.height() - 2) 
   
    method text() = "Tiempo: " + reloj.tiempo().toString() // Muestra el tiempo
    method textColor() = "000000" 

    method mostrar() {
    game.addVisual(self) 
	 game.schedule(1500, { game.removeVisual(tiempoDisplay) })
    }
}

