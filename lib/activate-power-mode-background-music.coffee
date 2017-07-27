
module.exports = activatePowerModeBackgroundMusic =

  activate: (state) ->
    console.log("Se activo mi paquete XD")
    #require('atom-package-deps').install('activate-power-mode-background-music');

  consumeActivatePowerModeServiceV1: (service) ->
    plugin = require('./music-controler')
    service.registerPlugin('activatePowerModeBackgroundMusic', plugin)
