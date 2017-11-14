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

    require('atom-package-deps').install('activate-background-music');

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('backgroundMusic', @backgroundMusic)

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
    atom.config.get "activate-power-mode.plugins.backgroundMusic"

  setConfig: (value) ->
    atom.config.set "activate-power-mode.plugins.backgroundMusic", value
    return value
