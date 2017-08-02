{CompositeDisposable} = require "atom"

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
    console.log("Se activo mi paquete XD")
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:play/pasue": => @musiControler.playPause()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:stop": => @musiControler.stop()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:repeat": => @musiControler.repeat()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:next": => @musiControler.next()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:previous": => @musiControler.previous()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:muteToggle": => @musiControler.muteToggle()

    @playIntroAudio.play()

    #if @getConfig "autoToggle"
      #@toggle()

    #require('atom-package-deps').install('activate-power-mode-background-music');

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateBackgroundMusic', @musiControler)

  enable: ->
    @active = true
    @musiControler.enable()
    @playIntroAudio.play()

  disable: ->
    @active = false
    @musiControler.disable()

  getConfig: (config) ->
    atom.config.get "activate-background-music.#{config}"
