path = require "path"
fs = require "fs"

module.exports =
  play: ->
    if (@getConfig "audioPath") is "../sounds/intro.wav"
      pathtoaudio = path.join(__dirname, @getConfig "audioPath")
    else
      pathtoaudio = @getConfig "audioPath"
      if !fs.existsSync(pathtoaudio)
        console.error  "Error!: The given file can not be found!. On (Play Intro Audio - Path to Audioclip)"
        @setConfig("audioPath", "../sounds/intro.wav")
        pathtoaudio = path.join(__dirname, @getConfig "audioPath")

    audio = new Audio(pathtoaudio)
    audio.currentTime = 0
    audio.volume = (@getConfig("volume") * 0.01)
    audio.play()

  getConfig: (config) ->
    atom.config.get "activate-background-music.playIntroAudio.#{config}"

  setConfig: (config, value) ->
    atom.config.set("activate-background-music.playIntroAudio.#{config}", value)
