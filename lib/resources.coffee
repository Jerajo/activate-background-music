configReader = require "./config-observer"
path = require "path"
fs = require "fs"

module.exports =
  musicCong: configReader
  music: null
  isPlaying: false
  isSetup: false
  musicFiles: null
  isMute: false

  disable: ->
    @musicCong.destroy()
    if @music != null and @isSetup is true
      @music.pause
      @musicPathObserver?.dispose()
      @musicVolumeObserver?.dispose()
      @pathToMusic = ""
      @isSetup = false
      @music = null
      @musicFiles = null
      @isPlaying = false
      @isMute = false

  setup: ->
    @musicCong.setup()

    @musicPathObserver?.dispose()
    @musicPathObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.musicPath', (value) =>
      if value is "../sounds/musics/"
        @pathToMusic = path.join(__dirname, value)
      else
        if value[value.length-1] != '/' or value[value.length-1] != '\\'
          @pathToMusic = value + '/'
        else @pathToMusic = value

      if fs.existsSync(@pathToMusic)
        @musicFiles = @getAudioFiles()
      else
        @musicFiles = null

      if @musicFiles is null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("musicPath","../sounds/musics/")
      else
        @music.pause() if @music != null and @isPlaying
        @music = new Audio(@pathToMusic + @musicFiles[0])
        @music.volume = if @isMute then 0 else (@getConfig("musicVolume") * 0.01)

    @musicVolumeObserver?.dispose()
    @musicVolumeObserver = atom.config.observe 'activate-background-music.playBackgroundMusic', (value) =>
      @music.volume = (@getConfig("musicVolume") * 0.01) if @music != null

    @isSetup = true

  getAudioFiles: ->
    allFiles = fs.readdirSync(@pathToMusic)
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

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"

  setConfig: (config, value) ->
    atom.config.set("activate-background-music.playBackgroundMusic.#{config}", value)
