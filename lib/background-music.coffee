playIntroAudio = require "./play-intro"
musicPlayer = require "./music-player"
configObserver = require "./config-observer"

module.exports =

  title: 'Play Background Music'
  description: 'Plays background music while you are in combo mode.'
  name: "activate-background-music"
  playIntroAudio: playIntroAudio
  musicPlayer: musicPlayer
  observer: configObserver
  api: null
  combo: null

  enable: (api) ->
    @api = api
    @combo = @api.getCombo()
    @playIntroAudio.play()
    @observer.setup()
    @musicPlayer.setup(@observer.conf)

  disable: ->
    @musicPlayer.disable()
    @observer.destroy()
    @api = null
    @combo = null

  onInput: (cursor, screenPosition, input, data) ->
    currentStreak = @combo.getCurrentStreak()
    isPause = !@musicPlayer.music['isPlaying']
    if @observer.conf['actionDuringStreak'] != "none"
      @musicPlayer.action("duringStreak", @observer.conf) if @checkStreak(currentStreak)
      if @observer.conf['typeLapse'] is "time" and isPause
        @musicPlayer.debouncedActionDuringStreak('duringStreak', @observer.conf)

    if isPause and currentStreak >= @observer.conf['activationThreshold']
      @musicPlayer.play()

  checkStreak: (currentStreak) ->
    return false if currentStreak is 0
    return false if @observer.conf['typeLapse'] != "streak"
    currentLevel = @combo.getLevel()
    n = currentLevel + 1
    mod = currentStreak % @observer.conf['lapse']
    return true if mod is 0 or (currentStreak - n < currentStreak - mod < currentStreak)
    return false

  onComboLevelChange: (newLvl, oldLvl) ->
    return if @combo.getLevel() <= 0
    if @observer.conf['onNextLevel'] != "none"
      @musicPlayer.action("onNextLevel", @observer.conf)

  onComboEndStreak: () ->
    @musicPlayer.action("endStreak", @observer.conf)
    if @musicPlayer.debouncedActionDuringStreak != null
      @musicPlayer.debouncedActionDuringStreak?.cancel()

  playPause: ->
    return @musicPlayer.play() if not @musicPlayer.music['isPlaying']
    return @musicPlayer.pause()

  stop: ->
    @musicPlayer.stop() if @musicPlayer.music['isPlaying']

  repeat: ->
    @musicPlayer.repeat(@observer.conf)

  next: ->
    @musicPlayer.next(@observer.conf)

  previous: ->
    @musicPlayer.previous(@observer.conf)

  volumeUpDown: (action) ->
    volumeChange = @observer.conf['volumeChangeRate']
    volumeChange *= -1 if action is "down"
    @musicPlayer.volumeUpDown(volumeChange)

  muteToggle: ->
    @musicPlayer.mute()
