musicPlayer = require "./music-player"

module.exports =

  api: null
  musicPlayer: musicPlayer
  isCombomode: false

  enable: (api) ->
    @api = api
    @musicPlayer.setup()

  disable: ->
    @musicPlayer.destroy()

  #onChangePane: (editor, editorElement) ->

  #onInput: (cursor, screenPosition, input, data) ->
    #@musicPlayer.play @api.getCombo()

  onComboStartStreak: () ->
    if @api.getCombo() >= @getConfig "activationThreshold"
      @musicPlayer.play @api.getCombo()

  onComboLevelChange: (newLvl, oldLvl) ->
    console.log "es imbocado: actionNextLevel"
    @musicPlayer.actionNextLevel()

  onComboEndStreak: () ->
    console.log "es imbocado: actionEndStreak"
    @musicPlayer.actionEndStreak()

  #onComboExclamation: (text) ->

  #onComboMaxStreak: (maxStreak) ->

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"
