playIntroAudio = require "./play-intro"
musicPlayer = require "./music-player"

module.exports =

  title: 'Play Background Music'
  description: 'A plugin for activate power mode that plays background music while you are in combo mode.'
  name: "activate-background-music"
  type: "package"
  active: false
  api: null
  playIntroAudio: playIntroAudio
  musicPlayer: musicPlayer
  isCombomode: false

  enable: (api) ->
    @active = true
    @api = api
    @setup()

  disable: ->
    @active = false
    @musicPlayer.disable()

  setup: ->
    @playIntroAudio.play() if @getConfig "enabled"
    @musicPlayer.setup()

  onInput: (cursor, screenPosition, input, data) ->
    combo = @api.getCombo()
    currentStreak = combo.getCurrentStreak()
    if @getConfigActions("duringStreak.typeLapse") is "streak"
      currentLevel = combo.getLevel()
      n = currentLevel + 1
      mod = currentStreak % @getConfigActions "duringStreak.lapse"
      if mod is 0 or (currentStreak - n < currentStreak - mod < currentStreak)
        @musicPlayer.action("duringStreak",currentStreak)

    if @getConfigActions("duringStreak.typeLapse") is "time"
      if @musicPlayer.debouncedActionDuringStreak? and @musicPlayer.debouncedActionDuringStreak != null and not @musicPlayer.isPlaying
        @musicPlayer.debouncedActionDuringStreak()

    activationThreshold = @getConfigActivatePowerMode "activationThreshold"
    if currentStreak >= activationThreshold[0]
      @musicPlayer.play() if not @musicPlayer.isPlaying

  onComboLevelChange: (newLvl, oldLvl) ->
    @musicPlayer.action "onNextLevel"

  onComboEndStreak: () ->
    @musicPlayer.action "endStreak"
    if @musicPlayer.debouncedActionDuringStreak != null
      @musicPlayer.debouncedActionDuringStreak?.cancel()

  playPause: ->
    return @musicPlayer.pause() if @musicPlayer.isPlaying and @active
    return @musicPlayer.play() if @active

  stop: ->
    @musicPlayer.stop() if @musicPlayer.isPlaying and @active

  repeat: ->
    @musicPlayer.repeat() if @active

  next: ->
    @musicPlayer.next() if @active

  previous: ->
    @musicPlayer.previous() if @active

  volumeUpDown: (action) ->
    @musicPlayer.volumeUpDown action if @active

  muteToggle: ->
    @musicPlayer.mute() if @active

  getConfig: (config) ->
    atom.config.get "activate-background-music.playIntroAudio.#{config}"

  getConfigActions: (config) ->
    atom.config.get "activate-background-music.actions.#{config}"

  getConfigActivatePowerMode: (config) ->
    atom.config.get "activate-power-mode.comboMode.#{config}"
