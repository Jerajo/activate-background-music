musicPlayer = require "./music-player"

module.exports =

  active: false
  api: null
  musicPlayer: musicPlayer
  isCombomode: false

  enable: (api) ->
    @api = api
    @setup()

  disable: ->
    @musicPlayer.disable()
    @active = false

  setup: ->
    @musicEnabledObserver?.dispose()
    @musicEnabledObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.enabled', (value) =>
      if value
        @musicPlayer.setup()
        @active = true
      else
        @disable()

  onInput: (cursor, screenPosition, input, data) ->
    if @active
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

  #onComboStartStreak: () ->

  onComboLevelChange: (newLvl, oldLvl) ->
    @musicPlayer.action "onNextLevel" if @active

  onComboEndStreak: () ->
    @musicPlayer.action "endStreak" if @active
    if @musicPlayer.debouncedActionDuringStreak != null
      @musicPlayer.debouncedActionDuringStreak?.cancel()

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
    @musicPlayer.volumeUpDown action

  muteToggle: ->
    @musicPlayer.mute() if @active

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"

  getConfigActions: (config) ->
    atom.config.get "activate-background-music.actions.#{config}"

  getConfigActivatePowerMode: (config) ->
    atom.config.get "activate-power-mode.comboMode.#{config}"
