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
          console.log @musicFiles[@currentMusic]
          @music.volume = @getConfig "musicVolume"

        @lapseTypeObserver?.dispose()
        @lapseTypeObserver = atom.config.observe 'activate-background-music.actions.duringStreak.typeLapse', (newValue, oldValue) =>
          if @musicCong.typeLapse is "time"
            @timeLapse = @musicCong.lapse * 1000
            @debouncedActionDuringStreak?.cancel()
            @debouncedActionDuringStreak = debounce @action.bind(this), @timeLapse
          else
            @debouncedActionDuringStreak?.cancel()
            @debouncedActionDuringStreak = null

        @actionEndMusicObserver?.dispose()
        @actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (newValue, oldValue) =>
          if @musicCong.actionEndMusic != "none"
            @music.onended = =>
              @actionDuringStreak(@musicCong.actionEndMusic)
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

  play: (streak) ->
    console.log "se invoca: play"
    #@setup() if not @isSetup
    if @musicCong.actionDuringStreak != "none" and @musicCong.typeLapse is "streak"
      console.log "es imbocado: actionDuringStreak"
      @actionDuringStreak(@musicCong.actionDuringStreak, streak)

    @isPlaying = false if (@music.paused)
    return null if @isPlaying

    if @musicCong.actionDuringStreak != "none" and @musicCong.typeLapse is "time"
      console.log "es imbocado: debouncedActionDuringStreak"
      @debouncedActionDuringStreak(@musicCong.actionDuringStreak)

    @isPlaying = true
    console.log "es imbocado: music.play"
    console.log @musicFiles[@currentMusic]
    @music.play()

  pause: ->
    console.log "es imbocado: music pause"
    console.log @musicFiles[@currentMusic]
    @isPlaying = false
    @music.pause()

  stop: -> #arreglar error se ejuta primero
    console.log "es imbocado: stop"
    console.log @musicFiles[@currentMusic]
    @isPlaying = false
    if @music != null
      @music.pause()
      @music.currentTime = 0

  autoPlay: ->
    console.log "es imbocado: autoplay"
    if @musicCong.actionEndMusic != "none"
      @music.onended = =>
        @actionDuringStreak(@musicCong.actionEndMusic)
    else
      @music.onended = null
    @isPlaying = true
    @music.play()

  previous: ->
    console.log "es imbocado: previous"
    @stop()
    maxIndex = @musicFiles.length - 1
    if (@currentMusic > 0)
      @currentMusic--
    else
      @currentMusic = maxIndex
    console.log @musicFiles[@currentMusic]
    @music = new Audio(@musicCong.pathtoMusic + @musicFiles[@currentMusic])
    @music.volume = @getConfig "musicVolume"

  next: ->
    console.log "es imbocado: next"
    @stop()
    maxIndex = @musicFiles.length - 1
    if (maxIndex > @currentMusic)
      @currentMusic++
    else
      @currentMusic = 0
    console.log @musicFiles[@currentMusic]
    @music = new Audio(@musicCong.pathtoMusic + @musicFiles[@currentMusic])
    @music.volume = @getConfig "musicVolume"

  mute: (timer = 0) ->
    console.log "es imbocado: mute"
    if timer is 0
      if @music.volume != 0
        @music.volume = 0
      else
        @music.volume = @getConfig "musicVolume"
    else
      time = timer * 1000
      @debouncedMute?.cancel()
      @debouncedMute = debounce @mute.bind(this), @time
      @debouncedMute()

  actionDuringStreak: (action, streak = 0) ->
    if streak is 0
      console.log("La accion es: " + @musicCong.actionDuringStreak)
      @play()     if action is "play"
      @pause()    if action is "pause"
      @stop()     if action is "repeat" or action is "stop"
      @previous() if action is "previous"
      @next()     if action is "next"
      @debouncedActionDuringStreak(@musicCong.actionDuringStreak) if @musicCong.typeLapse is "time"
      return @autoPlay() if action != "stop" and @getConfigActions "autoplay"
    else if streak % @musicCong.lapse is 0
      console.log("La accion es: " + @musicCong.endMusic)
      @play()     if action is "play"
      @pause()    if action is "pause"
      @stop()     if action is "repeat" or action is "stop"
      @previous() if action is "previous"
      @next()     if action is "next"
      return @autoPlay() if action != "stop" and @getConfigActions "autoplay"

  actionEndStreak: ->
    if @isPlaying
      console.log("La accion es: " + @musicCong.actionEndStreak)
      @debouncedActionDuringStreak?.cancel()
      @pause() if @getConfigActions "endStreak.pause"
      return @stop()     if @musicCong.actionEndStreak is "repeat" or @musicCong.actionEndStreak is "stop"
      return @previous() if @musicCong.actionEndStreak is "previous"
      return @next()     if @musicCong.actionEndStreak is "next"

  actionNextLevel: ->
    console.log("La accion es: " + @musicCong.actionNextLevel)
    @play()     if @musicCong.actionNextLevel is "play"
    @pause()    if @musicCong.actionNextLevel is "pause"
    @stop()     if @musicCong.actionNextLevel is "repeat" or @musicCong.actionNextLevel is "stop"
    @previous() if @musicCong.actionNextLevel is "previous"
    @next()     if @musicCong.actionNextLevel is "next"
    if @musicCong.actionNextLevel != "stop" and @musicCong.actionNextLevel != "pause" and @musicCong.actionNextLevel != "none"
      return @autoPlay() if @musicCong.actionNextLevel != "stop" and @getConfigActions "autoplay"

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"

  getConfigActions: (config) ->
    atom.config.get "activate-background-music.actions.#{config}"
