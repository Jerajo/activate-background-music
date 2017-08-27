playIntroAudio = require "./play-intro"
musicPlayer = require "./music-player"

module.exports =

  title: 'Play Background Music'
  description: 'A plugin for activate power mode that plays background music while you are in combo mode.'
  name: "activate-background-music"
  type: "package"
  playIntroAudio: playIntroAudio
  musicPlayer: musicPlayer
  api: null
  isCombomode: false
  activationThreshold: null

  enable: (api) ->
    @api = api
    @setup()

  disable: ->
    @musicPlayer.disable()
    api = null
    isCombomode = false
    activationThreshold = null

  setup: ->
    @activationThreshold = atom.config.get "activate-power-mode.comboMode.activationThreshold"
    @playIntroAudio.play()
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

    if currentStreak >= @activationThreshold[0]
      @musicPlayer.play() if not @musicPlayer.isPlaying

  onComboLevelChange: (newLvl, oldLvl) ->
    @musicPlayer.action "onNextLevel"

  onComboEndStreak: () ->
    @musicPlayer.action "endStreak"
    if @musicPlayer.debouncedActionDuringStreak != null
      @musicPlayer.debouncedActionDuringStreak?.cancel()

  playPause: ->
    return @musicPlayer.pause() if @musicPlayer.isPlaying and @active
    return @musicPlayer.play()

  stop: ->
    @musicPlayer.stop() if @musicPlayer.isPlaying and @active

  repeat: ->
    @musicPlayer.repeat()

  next: ->
    @musicPlayer.next()

  previous: ->
    @musicPlayer.previous()

  volumeUpDown: (action) ->
    @musicPlayer.volumeUpDown action

  muteToggle: ->
    @musicPlayer.mute()

  getConfigActions: (config) ->
    atom.config.get "activate-background-music.actions.#{config}"
