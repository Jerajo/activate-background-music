
musicPlayer = require "./music-player"

module.exports =

  musicPlayer: musicPlayer

  # When plugin is enabled, you get the api object here.
  enable: (api) ->
    @api = api;


  # When plugin is disabled.
  disable: ->

  # When the pane is changed. If the editor is null means
  # the new active pane is not a text editor.
  onChangePane: (editor, editorElement) ->

  # When a new cursor is added.
  onNewCursor: (cursor) ->

  # When the user writes something. You get the cursor,
  # the screen position of the input, an input object
  # and data processed by the flow.
  onInput: (cursor, screenPosition, input, data) ->

  # When the combo streak starts.
  onComboStartStreak: () ->

  # When the combo level changes.
  onComboLevelChange: (newLvl, oldLvl) ->

  # When the combo streak ends.
  onComboEndStreak: () ->
    @musicPlayer.mostrarMensaje("onComboEndStreak")


  # When the combo shows an exclamation.
  onComboExclamation: (text) ->

  # When the combo reach a new maximum.
  onComboMaxStreak: (maxStreak) ->
