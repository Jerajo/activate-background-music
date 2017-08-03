musicPlayer = require "./music-player"

module.exports =

  active: false
  api: null
  musicPlayer: musicPlayer
  isCombomode: false

  enable: (api) ->
    @active = true
    @api = api
    @musicPlayer.setup()

  disable: ->
    @active = false
    @api = null
    @musicPlayer.destroy()

  #onChangePane: (editor, editorElement) ->

  onInput: (cursor, screenPosition, input, data) ->
    #console.log "es imbocado: actionInput"
    combo = @api.getCombo()
    if @musicPlayer.debouncedActionDuringStreak? and @musicPlayer.debouncedActionDuringStreak != null and not @musicPlayer.isPlaying
      console.log "actionDuringStreak:Time"
      @musicPlayer.debouncedActionDuringStreak "actionDuringStreak"
    if combo.getCurrentStreak() >= @getConfig "activationThreshold"
      #console.log "actionDuringStreak:Streak (" + combo.getCurrentStreak() + " == " + @getConfig("activationThreshold") + ")"
      @musicPlayer.play() if not @musicPlayer.isPlaying
      @musicPlayer.action("duringStreak",combo.getCurrentStreak)

  #onComboStartStreak: () ->
    #combo = @api.getCombo()
    #console.log "es imbocado: comboStartStreak " + combo.getCurrentStreak() + " " + @getConfig "activationThreshold"
    #if combo.getCurrentStreak() >= @getConfig "activationThreshold"
      #@musicPlayer.play combo.getCurrentStreak()

  onComboLevelChange: (newLvl, oldLvl) ->
    #console.log "es imbocado: actionNextLevel"
    @musicPlayer.action "onNextLevel"

  onComboEndStreak: () ->
    #console.log "es imbocado: actionEndStreak"
    @musicPlayer.action "endStreak"

  #onComboExclamation: (text) ->

  #onComboMaxStreak: (maxStreak) ->

  playPause: ->
    return @musicPlayer.pause() if @musicPlayer.isPlaying and @active
    return @musicPlayer.play()  if @active

  stop: ->
    @musicPlayer.stop() if @musicPlayer.isPlaying and @active

  repeat: ->
    @musicPlayer.repeat() if @active

  next: ->
    @musicPlayer.next() if @active

  previous: ->
    @musicPlayer.previous() if @active

  volumeUpDown: (action) ->
    console.log "es invocado: volumeUpDown"
    @musicPlayer.volumeUpDown action

  muteToggle: ->
    @musicPlayer.mute() if @active

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"
