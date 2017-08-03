configReader = require "./config-reader"
path = require "path"
fs = require "fs"
debounce = require "lodash.debounce"

module.exports =
  musicCong: configReader
  music: null
  isPlaying: false
  isSetup: false
  musicFiles: null
  currentMusic: 0
  typeLapse: ""
  timeLapse: 0
  isMute: false

  setup: ->
    console.log "se invoca: septup1"
    @musicEnabledObserver?.dispose()
    @musicEnabledObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.enabled', (Enabled) =>
      if not Enabled and @isSetup
        @destroy()
      else
        @musicCong.setup()

        @musicPathObserver?.dispose()
        @musicPathObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.musicPath', (newValue, oldValue) =>
          @musicFiles = @getAudioFiles()
          @music = new Audio(@musicCong.pathtoMusic + @musicFiles[@currentMusic])
          @music.volume = if @isMute then 0 else @getConfig "musicVolume"

        @lapseTypeObserver?.dispose()
        @lapseTypeObserver = atom.config.observe 'activate-background-music.actions.duringStreak.typeLapse', (newValue, oldValue) =>
          if @musicCong.typeLapse is "time"
            @timeLapse = @musicCong.lapse * 1000
            @debouncedActionDuringStreak?.cancel()
            @debouncedActionDuringStreak = debounce @action.bind(this), @timeLapse
            @debouncedActionDuringStreak "actionDuringStreak"
          else
            @debouncedActionDuringStreak?.cancel()
            @debouncedActionDuringStreak = null

        @actionEndMusicObserver?.dispose()
        @actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (newValue, oldValue) =>
          if @musicCong.actionEndMusic != "none"
            @music.onended = =>
              @performAction @musicCong.actionEndMusic
          else
            @music.onended = null

        @isSetup = true

  getAudioFiles: ->
    allFiles = fs.readdirSync(@musicCong.pathtoMusic)
    file = 0
    while(allFiles[file])
      fileName = allFiles[file++]
      fileExtencion = fileName.split('.').pop()
      continue if(fileExtencion is "mp3") or (fileExtencion is "MP3")
      continue if(fileExtencion is "wav") or (fileExtencion is "WAV")
      continue if(fileExtencion is "3gp") or (fileExtencion is "3GP")
      continue if(fileExtencion is "m4a") or (fileExtencion is "M4A")
      continue if(fileExtencion is "webm") or (fileExtencion is "WEBM")
      allFiles.splice(--file, 1)
      break if file is allFiles.length

    return allFiles

  destroy: ->
    console.log "es imbocado: destroy"
    @musicCong.destroy()
    if @music != null and @isSetup is true
      @stop()
      @musicPathObserver?.dispose()
      @lapseTypeObserver?.dispose()
      @debouncedActionDuringStreak?.cancel()
      @debouncedActionDuringStreak = null
      @isSetup = false
      @music = null
      @musicFiles = null
      isPlaying = false
      currentMusic = 0
      isMute: false

  play: ->
    console.log "se invoca: play"
    @isPlaying = false if (@music.paused)
    return null if @isPlaying

    @isPlaying = true
    @music.play()

  pause: ->
    console.log "es imbocado: music pause"
    @isPlaying = false
    @music.pause()

  stop: ->
    console.log "es imbocado: stop"
    @isPlaying = false
    if @music != null
      @music.pause()
      @music.currentTime = 0

  repeat: ->
    isplaying = @isPlaying
    console.log "es imbocado: stop"
    @isPlaying = false
    if @music != null
      @music.pause()
      @music.currentTime = 0
    @autoPlay() if isplaying and @getConfigActions "autoplay"

  autoPlay: ->
    console.log "es imbocado: autoplay"
    @isPlaying = true
    @music.play()

  previous: ->
    isplaying = @isPlaying
    console.log "es imbocado: previous"
    @stop()
    maxIndex = @musicFiles.length - 1
    if (@currentMusic > 0)
      @currentMusic--
    else
      @currentMusic = maxIndex
    @music = new Audio(@musicCong.pathtoMusic + @musicFiles[@currentMusic])
    @music.volume = if @isMute then 0 else @getConfig "musicVolume"
    if @musicCong.actionEndMusic != "none"
      @music.onended = =>
        @performAction @musicCong.actionEndMusic
    else
      @music.onended = null
    @autoPlay() if isplaying and @getConfigActions "autoplay"

  next: ->
    isplaying = @isPlaying
    console.log "es imbocado: next"
    @stop()
    maxIndex = @musicFiles.length - 1
    if (maxIndex > @currentMusic)
      @currentMusic++
    else
      @currentMusic = 0
    @music = new Audio(@musicCong.pathtoMusic + @musicFiles[@currentMusic])
    @music.volume = if @isMute then 0 else @getConfig "musicVolume"
    if @musicCong.actionEndMusic != "none"
      @music.onended = =>
        @performAction @musicCong.actionEndMusic
    else
      @music.onended = null
    @autoPlay() if isplaying and @getConfigActions "autoplay"

  mute: (timer = 0) ->
    console.log "es imbocado: mute"
    @isMute = !@isMute
    @music.volume = if @isMute then 0 else @getConfig "musicVolume"
    if timer != 0
      time = timer * 1000
      @debouncedMute?.cancel()
      @debouncedMute = debounce @mute.bind(this), @time
      @debouncedMute()

  action: (name, streak = 0) ->
    if name is "onNextLevel"
      return @performAction @musicCong.actionNextLevel

    if name is "duringStreak"
      if streak > 0 and @musicCong.typeLapse is "streak" and (streak % @musicCong.lapse is 0)
        return @performAction @musicCong.actionDuringStreak
      else if streak is 0 and @musicCong.typeLapse is "time"
        @performAction @musicCong.actionDuringStreak
        return @debouncedActionDuringStreak "actionDuringStreak"

    if name is "endStreak"
      @pause() if @getConfigActions "endStreak.pause"
      return @performAction @musicCong.actionEndStreak

    if name is "endMusic"
      return @performAction @musicCong.endMusic

  performAction: (action) ->
    return @play()     if action is "play"
    return @pause()    if action is "pause"
    return @stop()     if action is "stop"
    return @repeat()   if action is "repeat"
    return @previous() if action is "previous"
    return @next()     if action is "next"

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"

  getConfigActions: (config) ->
    atom.config.get "activate-background-music.actions.#{config}"
