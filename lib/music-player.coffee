debounce = require "lodash.debounce"
path = require "path"
fs = require "fs"

module.exports =
  audio: null
  music: []
  musicFiles: []
  currentMusic: 0

  disable: ->
    @stop() if @music['isPlaying']
    @lapseTypeObserver?.dispose()
    @actionEndMusicObserver?.dispose()
    @debouncedActionDuringStreak?.cancel()
    @debouncedActionDuringStreak = null
    @musicVolumeObserver?.dispose()
    @musicPathObserver?.dispose()
    @music['file'] = null
    @music = null
    @musicFiles = null
    @currentMusic = 0

  setup: (conf) ->
    @music['isMute'] = false
    @music['isPlaying'] = false

    @musicVolumeObserver?.dispose()
    @musicVolumeObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.volume', (volume) =>
      @music['volume'] = (volume * 0.01)
      @music['file'].volume = @music['volume'] if @music['file'] != undefined

    @musicPathObserver?.dispose()
    @musicPathObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.path', (value) =>
      mPath = value
      if mPath is "../sounds/musics/"
        @music['path'] = path.join(__dirname, mPath)
      else
        if mPath[mPath.length-1] != '/' or mPath[mPath.length-1] != '\\'
          @music['path'] = mPath + '\\'
        else if mPath[mPath.length-1] is '/'
          @music['path'] = mPath.replace('/','\\')
        else @music['path'] = mPath

      if fs.existsSync(@music['path'])
        @musicFiles = @getAudioFiles()
        @currentMusic = 0
        @setMusic(conf)
      else
        @musicFiles = null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("musicPath","../sounds/musics/")

    @actionEndMusicObserver?.dispose()
    @actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (value) =>
      @action('endMusic', conf)

    @lapseTypeObserver?.dispose()
    @lapseTypeObserver = atom.config.observe 'activate-background-music.actions.duringStreak', (value) =>
      if value.typeLapse is "time"
        timeLapse = (value.lapse * 1000)
        @debouncedActionDuringStreak?.cancel()
        @debouncedActionDuringStreak = debounce @action.bind(this), timeLapse
        @debouncedActionDuringStreak('duringStreak', conf) if @music['isPlaying']
      else
        @debouncedActionDuringStreak?.cancel()
        @debouncedActionDuringStreak = null

  getAudioFiles: ->
    allFiles = fs.readdirSync(@music['path'])
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

    return if (allFiles.length > 0) then allFiles else null

  setMusic: (conf) ->
    @music['file'].pause() if @music['file'] != undefined and @music['isPlaying']
    @music['file'] = new Audio(@music['path'] + @musicFiles[@currentMusic])
    @music['file'].volume = if @music['isMute'] then 0 else @music['volume']
    @action('endMusic', conf)

  play: ->
    return null if !@music['file'].paused
    @music['file'].play()
    @music['isPlaying'] = true

  pause: ->
    @music['file'].pause()
    @music['isPlaying'] = false

  stop: ->
    @music['file'].pause()
    @music['isPlaying'] = false
    @music['file'].currentTime = 0

  repeat: (conf) ->
    isPlaying = @music['isPlaying']
    @stop()
    @autoPlay() if isPlaying and conf['autoplay']

  autoPlay: ->
    @music['file'].play()

  previous: (conf) ->
    @changeMusic(-1, conf)

  next: (conf) ->
    @changeMusic(1, conf)


  changeMusic: (nextIndex, conf) ->
    isPlaying = @music['isPlaying']
    maxIndex = @musicFiles.length - 1
    @currentMusic = @currentMusic + nextIndex
    @currentMusic = 0 if @currentMusic > maxIndex
    @currentMusic = maxIndex if @currentMusic < 0

    @setMusic(conf)
    @autoPlay() if isPlaying and conf['autoplay']


  volumeUpDown: (volumeChange) ->
    volume = (@music['volume'] * 100)
    @music['isMute'] = false
    haschanged = false
    volume += volumeChange
    volume = 0 if volume < 0
    volume = 100 if volume > 100
    return if volume is (@music['volume'] * 100)
    @setConfig("volume", volume)

  mute: ->
    @music['isMute'] = !@music['isMute']
    @music['file'].volume = if @music['isMute'] then 0 else @music['volume']

  action: (name, conf) ->
    if name is "onNextLevel"
      return @performAction conf['onNextLevel'], conf

    if name is "duringStreak"
      if conf['typeLapse'] is "streak"
        return @performAction conf['duringStreak'], conf
      else
        @performAction conf['duringStreak'], conf
        return @debouncedActionDuringStreak('duringStreak', conf)

    if name is "endStreak"
      @pause() if conf['pause']
      return @performAction conf['endStreak'], conf

    if name is "endMusic"
      if conf['endMusic'] != "none"
        @music['file'].onended = =>
          @performAction conf['endMusic'], conf
      else
        @music['file'].onended = null

  performAction: (action, conf) ->
    return @play()     if action is "play"
    return @pause()    if action is "pause"
    return @stop()     if action is "stop"
    return @repeat(conf)   if action is "repeat"
    return @previous(conf) if action is "previous"
    return @next(conf)     if action is "next"

  setConfig: (config, value) ->
    atom.config.set("activate-background-music.playBackgroundMusic.#{config}", value)
