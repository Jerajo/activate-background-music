resouses = require "./resources"
debounce = require "lodash.debounce"

module.exports =
  resouses: resouses
  currentMusic: 0
  timeLapse: 0


  enable: ->
    @resouses.setup()
    @setup()

  disable: ->
    @resouse.disable()
    @lapseTypeObserver?.dispose()
    @actionEndMusicObserver?.dispose()
    @debouncedActionDuringStreak?.cancel()
    @debouncedActionDuringStreak = null
    @musicVolumeObserver?.dispose()
    @currentMusic = 0
    @timeLapse = 0

  setup: ->
    @lapseTypeObserver?.dispose()
    @lapseTypeObserver = atom.config.observe 'activate-background-music.actions.duringStreak.typeLapse', (newValue, oldValue) =>
      if @resouses.musicCong.typeLapse is "time"
        @timeLapse = @resouses.musicCong.lapse * 1000
        @debouncedActionDuringStreak?.cancel()
        @debouncedActionDuringStreak = debounce @action.bind(this), @timeLapse
        @debouncedActionDuringStreak "actionDuringStreak"
      else
        @debouncedActionDuringStreak?.cancel()
        @debouncedActionDuringStreak = null

    @actionEndMusicObserver?.dispose()
    @actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (newValue, oldValue) =>
      if @resouses.musicCong.actionEndMusic != "none"
        @resouses.music.onended = =>
          @performAction @resouses.musicCong.actionEndMusic
      else
        @resouses.music.onended = null

    @musicVolumeObserver?.dispose()
    @musicVolumeObserver = atom.config.observe 'activate-background-music.playBackgroundMusic', (value) =>
      @setVolume()

  play: ->
    console.log "se invoca: play"
    @resouses.isPlaying = false if (@resouses.music.paused)
    return null if @resouses.isPlaying

    @resouses.isPlaying = true
    @resouses.music.play()

  pause: ->
    console.log "es imbocado: music pause"
    @resouses.isPlaying = false
    @resouses.music.pause()

  stop: ->
    console.log "es imbocado: stop"
    @resouses.isPlaying = false
    if @resouses.music != null
      @resouses.music.pause()
      @resouses.music.currentTime = 0

  repeat: ->
    isPlaying = @resouses.isPlaying
    console.log "es imbocado: stop"
    @resouses.isPlaying = false
    if @resouses.music != null
      @resouses.music.pause()
      @resouses.music.currentTime = 0
    @autoPlay() if isPlaying and @getConfigActions "autoplay"

  autoPlay: ->
    console.log "es imbocado: autoplay"
    @resouses.isPlaying = true
    @resouses.music.play()

  previous: ->
    isPlaying = @resouses.isPlaying
    console.log "es imbocado: previous"
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
    isPlaying = @resouses.isPlaying
    console.log "es imbocado: next"
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

  setVolume: ->
    @resouses.music.volume = (@getConfig("musicVolume") * 0.01)
    console.log "El volumen actual es: " + @getConfig "musicVolume"

  mute: (timer = 0) ->
    console.log "es imbocado: mute"
    @resouses.isMute = !@resouses.isMute
    @resouses.music.volume = if @resouses.isMute then 0 else (@getConfig("musicVolume") * 0.01)
    if timer != 0
      time = timer * 1000
      @debouncedMute?.cancel()
      @debouncedMute = debounce @mute.bind(this), @time
      @debouncedMute()

  action: (name, streak = 0) ->
    if name is "onNextLevel"
      return @performAction @resouses.musicCong.actionNextLevel

    if name is "duringStreak"
      if streak > 0 and @resouses.musicCong.typeLapse is "streak" and (streak % @resouses.musicCong.lapse is 0)
        return @performAction @resouses.musicCong.actionDuringStreak
      else if streak is 0 and @resouses.musicCong.typeLapse is "time"
        @performAction @resouses.musicCong.actionDuringStreak
        return @debouncedActionDuringStreak "actionDuringStreak"

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
