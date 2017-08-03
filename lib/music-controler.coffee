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

  onInput: (cursor, screenPosition, input, data) ->
    combo = @api.getCombo()
    console.log "onInput Invocado " + combo.getCurrentStreak() + " " + @getConfig "activationThreshold"
    if combo.getCurrentStreak() >= @getConfig "activationThreshold"
      @musicPlayer.play()
      @musicPlayer.action("duringStreak",combo.getCurrentStreak)

  #onComboStartStreak: () ->
    #combo = @api.getCombo()
    #console.log "es imbocado: comboStartStreak " + combo.getCurrentStreak() + " " + @getConfig "activationThreshold"
    #if combo.getCurrentStreak() >= @getConfig "activationThreshold"
      #@musicPlayer.play combo.getCurrentStreak()

  onComboLevelChange: (newLvl, oldLvl) ->
    console.log "es imbocado: actionNextLevel"
    @musicPlayer.action "onNextLevel"

  onComboEndStreak: () ->
    console.log "es imbocado: actionEndStreak"
    @musicPlayer.action "endStreak"

  #onComboExclamation: (text) ->

  #onComboMaxStreak: (maxStreak) ->

  playPause: ->
    if @musicPlayer.isPlaying
      @musicPlayer.pause()
    else
      @musicPlayer.play()

  stop: ->
    @musicPlayer.stop() if @musicPlayer.isPlaying

  repeat: ->
    @musicPlayer.repeat()

  next: ->
    @musicPlayer.next()

  previous: ->
    @musicPlayer.previous()

  muteToggle: ->
    @musicPlayer.mute()


  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"
