resouses = require "./resources"
debounce = require "lodash.debounce"

module.exports =
  resouses: resouses
  isPlaying: false
  currentMusic: 0
  typeLapse: ""
  timeLapse: 0
  lapse: ""

  disable: ->
    @resouses.disable()
    @lapseTypeObserver?.dispose()
    @actionEndMusicObserver?.dispose()
    @debouncedActionDuringStreak?.cancel()
    @debouncedActionDuringStreak = null
    @isPlaying = false
    @currentMusic = 0
    @typeLapse = ""
    @timeLapse = 0
    @lapse = ""

  setup: ->
    @resouses.setup()
    @lapseTypeObserver?.dispose()
    @lapseTypeObserver = atom.config.observe 'activate-background-music.actions.duringStreak.typeLapse', (value) =>
      @typeLapse = value
      if @typeLapse is "time"
        @timeLapse = @lapse * 1000
        @debouncedActionDuringStreak?.cancel()
        @debouncedActionDuringStreak = debounce @action.bind(this), @timeLapse
      else
        @debouncedActionDuringStreak?.cancel()
        @debouncedActionDuringStreak = null

    @lapseObserver?.dispose()
    @lapseObserver = atom.config.observe 'activate-background-music.actions.duringStreak.lapse', (value) =>
      @lapse = value
      if @typeLapse is "time"
        @timeLapse = @lapse * 1000
        @debouncedActionDuringStreak?.cancel()
        @debouncedActionDuringStreak = debounce @action.bind(this), @timeLapse
        @debouncedActionDuringStreak() if @isPlaying

    @actionEndMusicObserver?.dispose()
    @actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (value) =>
      if @resouses.musicCong.actionEndMusic != "none"
        @resouses.music.onended = =>
          @performAction @resouses.musicCong.actionEndMusic
      else
        @resouses.music.onended = null

  play: ->
    @isPlaying  = @resouses.isPlaying = false if (@resouses.music.paused)
    return null if @isPlaying

    @isPlaying  = @resouses.isPlaying = true
    @resouses.music.play()

  pause: ->
    @isPlaying  = @resouses.isPlaying = false
    @resouses.music.pause()

  stop: ->
    @isPlaying  = @resouses.isPlaying = false
    if @resouses.music != null
      @resouses.music.pause()
      @resouses.music.currentTime = 0

  repeat: ->
    isPlaying = @resouses.isPlaying
    @isPlaying  = @resouses.isPlaying = false
    if @resouses.music != null
      @resouses.music.pause()
      @resouses.music.currentTime = 0
    @autoPlay() if isPlaying and @getConfigActions "autoplay"

  autoPlay: ->
    @isPlaying  = @resouses.isPlaying = true
    @resouses.music.play()

  previous: ->
    console.log "la accion es: previous"
    isPlaying = @resouses.isPlaying
    @stop()
    maxIndex = @resouses.musicFiles.length - 1
    if (@currentMusic > 0)
      @currentMusic--
    else
      @currentMusic = maxIndex
    @resouses.music = new Audio(@resouses.pathtoMusic + @resouses.musicFiles[@currentMusic])
    @resouses.music.volume = if @resouses.isMute then 0 else (@getConfig("musicVolume") * 0.01)
    if @resouses.musicCong.actionEndMusic != "none"
      @resouses.music.onended = =>
        @performAction @resouses.musicCong.actionEndMusic
    else
      @resouses.music.onended = null
    @autoPlay() if isPlaying and @getConfigActions "autoplay"

  next: ->
    console.log "la accion es: next"
    isPlaying = @resouses.isPlaying
    @stop()
    maxIndex = @resouses.musicFiles.length - 1
    if (maxIndex > @currentMusic)
      @currentMusic++
    else
      @currentMusic = 0
    @resouses.music = new Audio(@resouses.pathtoMusic + @resouses.musicFiles[@currentMusic])
    @resouses.music.volume = if @resouses.isMute then 0 else (@getConfig("musicVolume") * 0.01)
    if @resouses.musicCong.actionEndMusic != "none"
      @resouses.music.onended = =>
        @performAction @resouses.musicCong.actionEndMusic
    else
      @resouses.music.onended = null
    @autoPlay() if isPlaying and @getConfigActions "autoplay"

  volumeUpDown: (action = "") ->
    @resouses.isMute = false
    volume = @getConfig "musicVolume"
    if action is "up"
      console.log "la accion es: volumeUp"
      volume += @getConfigActions "volumeChangeRate"
    else if action is "down"
      console.log "la accion es: volumeDown"
      if (volume - @getConfigActions("volumeChangeRate") < 0)
        volume = 0
      else
        volume -= @getConfigActions "volumeChangeRate"
    console.log "El volumen es: " + volume
    @setConfig("musicVolume", volume)

  mute: (timer = 0) ->
    @resouses.isMute = !@resouses.isMute
    @resouses.music.volume = if @resouses.isMute then 0 else (@getConfig("musicVolume") * 0.01)
    if timer != 0
      time = timer * 1000
      @debouncedMute?.cancel()
      @debouncedMute = debounce @mute.bind(this), @time
      @debouncedMute()

  action: (name = "duringStreak", streak = 0) ->
    if name is "onNextLevel"
      return @performAction @resouses.musicCong.actionNextLevel

    if name is "duringStreak"
      if streak > 0 and @typeLapse is "streak"
        return @performAction @resouses.musicCong.actionDuringStreak
      else if streak is 0 and @typeLapse is "time"
        @performAction @resouses.musicCong.actionDuringStreak
        return @debouncedActionDuringStreak()

    if name is "endStreak"
      @pause() if @getConfigActions "endStreak.pause"
      return @performAction @resouses.musicCong.actionEndStreak

    if name is "endMusic"
      return @performAction @resouses.musicCong.endMusic

  performAction: (action) ->
    return @play()     if action is "play"
    return @pause()    if action is "pause"
    return @stop()     if action is "stop"
    return @repeat()   if action is "repeat"
    return @previous() if action is "previous"
    return @next()     if action is "next"

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"

  setConfig: (config, value) ->
    atom.config.set("activate-background-music.playBackgroundMusic.#{config}", value)

  getConfigActions: (config) ->
    atom.config.get "activate-background-music.actions.#{config}"
