configSchema = require "./config-schema"
musiControler = require "./music-controler"
playIntroAudio = require "./play-intro"

module.exports = activateBackgroundMusic =

  config: configSchema
  subscriptions: null
  active: false
  musiControler: musiControler
  playIntroAudio: playIntroAudio

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:toggle": => @toggle()

    if @getConfig "autoToggle"
      @toggle()
    #console.log("Se activo mi paquete XD")
    #require('atom-package-deps').install('activate-power-mode-background-music');

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateBackgroundMusic', musiControler)

  toggle: ->
    if @active then @disable() else @enable()

  enable: ->
    @active = true
    @musiControler.enable()
    @playIntroAudio.play()

  disable: ->
    @active = false
    @musiControler.disable()

  getConfig: (config) ->
    atom.config.get "activate-background-music.#{config}"
