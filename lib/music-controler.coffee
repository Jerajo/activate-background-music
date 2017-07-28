
musicPlayer = require "./music-player"

module.exports =

  api: null
  musicPlayer: musicPlayer
  isCombomode: false

  # When plugin is enabled, you get the api object here.
  enable: (api) ->
    @api = api

  disable: ->
    @musicPlayer.destroy()
  #onChangePane: (editor, editorElement) ->

  onInput: (cursor, screenPosition, input, data) ->
    @musicPlayer.play @api.getCombo()

  #onComboStartStreak: () ->

  #onComboLevelChange: (newLvl, oldLvl) ->

  onComboEndStreak: () ->
    @musicPlayer.stop()

  #onComboExclamation: (text) ->

  #onComboMaxStreak: (maxStreak) ->
