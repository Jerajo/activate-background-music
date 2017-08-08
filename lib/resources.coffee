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
    console.log "es imbocado: desable"
    @musicCong.destroy()
    if @music != null and @isSetup is true
      @music.pause
      @musicPathObserver?.dispose()
      @musicVolumeObserver?.dispose()
      pathtoMusic: ""
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
        @pathtoMusic = path.join(__dirname, value)
      else
        @pathtoMusic = value

      @musicFiles = @getAudioFiles()

      if @musicFiles is null
        console.log "Note! The folder doesn't contain audio files!\nThis may cause an error."
        console.log @musicFiles
        @setConfig("musicPath","../sounds/musics/")
      else
        @music.pause() if @music != null and @isPlaying
        @music = new Audio(@pathtoMusic + @musicFiles[0])
        @music.volume = if @isMute then 0 else (@getConfig("musicVolume") * 0.01)

    @musicVolumeObserver?.dispose()
    @musicVolumeObserver = atom.config.observe 'activate-background-music.playBackgroundMusic', (value) =>
      @music.volume = (@getConfig("musicVolume") * 0.01) if @music != null
      console.log "El volumen actual es: " + @getConfig "musicVolume"

    @isSetup = true

  getAudioFiles: ->
    allFiles = fs.readdirSync(@pathtoMusic)
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
