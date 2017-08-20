{CompositeDisposable} = require "atom"

configSchema = require "./config-schema"
backgroundMusic = require "./background-music"

module.exports = activateBackgroundMusic =

  config: configSchema
  subscriptions: null
  active: false
  backgroundMusic: backgroundMusic

  activate: (state) ->
    @active = @setConfig(true) if !@isActive()
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:toggle": => @toggle()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:play/pasue": => @backgroundMusic.playPause()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:stop": => @backgroundMusic.stop()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:repeat": => @backgroundMusic.repeat()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:next": => @backgroundMusic.next()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:previous": => @backgroundMusic.previous()
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:volumeUp": => @backgroundMusic.volumeUpDown("up")
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:volumeDown": => @backgroundMusic.volumeUpDown("down")
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:muteToggle": ({duration}) => @backgroundMusic.muteToggle(duration)

    require('atom-package-deps').install('activate-background-music');

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateBackgroundMusic', @backgroundMusic)

  deactivate: ->
    @subscriptions?.dispose()
    @active = @setConfig(false) if @isActive()

  toggle: ->
    if @isActive() then @disable() else @enable()

  enable: ->
    @active = @setConfig(true)

  disable: ->
    @active = @setConfig(false)

  isActive: ->
    atom.config.get "activate-power-mode.plugins.activateBackgroundMusic"

  setConfig: (value) ->
    atom.config.set "activate-power-mode.plugins.activateBackgroundMusic", value
    value
