configSchema = require "./config-schema"
musiControler = require "./music-controler"


module.exports = activatePowerModeBackgroundMusic =

  musiControler: musiControler

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    #console.log("Se activo mi paquete XD")
    #require('atom-package-deps').install('activate-power-mode-background-music');

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activatePowerModeBackgroundMusic', musiControler)
