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
    active = true
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:toggle": => @toggle()
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
      "activate-background-music:volumeUp": => @musiControler.volumeUpDown("up")
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:volumeDown": => @musiControler.volumeUpDown("down")
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:muteToggle": ({duration}) => @musiControler.muteToggle(duration)

    @playIntroAudio.play() if @getConfig "playIntroAudio.enabled"

    #require('atom-package-deps').install('activate-background-music');

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateBackgroundMusic', @musiControler)

  toggle: ->
    if @active then @disable() else @enable()

  enable: ->
    @active = true
    @musiControler.enable()
    @playIntroAudio.play() if @getConfig "playIntroAudio.enabled"

  disable: ->
    @active = false
    @musiControler.disable()

  getConfig: (config) ->
    atom.config.get "activate-background-music.#{config}"
