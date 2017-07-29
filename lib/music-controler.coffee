musicPlayer = require "./music-player3"

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
    @musicPlayer.play @api.getCombo()
    
  onComboLevelChange: (newLvl, oldLvl) ->
    @musicPlayer.actionDuringStreak

  onComboEndStreak: () ->
    @musicPlayer.actionEndStreak()

  #onComboExclamation: (text) ->

  #onComboMaxStreak: (maxStreak) ->
