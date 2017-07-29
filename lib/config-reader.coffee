path = require "path"

module.exports =
    pathtoMusic: ""
    actionDuringStreak: ""
    actionEndStreak: ""
    actionNextLevel: ""
    actionEndMusic: ""
    typeLapse: ""
    lapse: 0

    setup: ->
      console.log "es imbocado: el setup2"
      @musicPathObserver?.dispose()
      @musicPathObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.musicPath', (value) =>
        console.log "es imbocado: musicPathObserver2"
        if value is "../sounds/"
          @pathtoMusic = path.join(__dirname, value)
        else
          @pathtoMusic = value

      @actionDuringStreakObserver?.dispose()
      @actionDuringStreakObserver = atom.config.observe 'activate-background-music.actions.duringStreak', (value) =>
        console.log "es imbocado: actionDuringStreakObserver2"
        @actionDuringStreak = value.action
        @typeLapse = value.typeLapse
        @lapse = value.lapse

      @actionEndStreakObserver?.dispose()
      @actionEndStreakObserver = atom.config.observe 'activate-background-music.actions.endStreak.action', (value) =>
        console.log "es imbocado: actionEndStreakObserver2"
        @actionEndStreak = value

      @actionNextLevelObserver?.dispose()
      @actionNextLevelObserver = atom.config.observe 'activate-background-music.actions.nextLevel.action', (value) =>
        console.log "es imbocado: actionNextLevelObserver2"
        @actionNextLevel = value

      @actionEndMusicObserver?.dispose()
      @actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (value) =>
        console.log "es imbocado: actionEndMusic2"
        @actionEndMusic = value

    destroy: ->
      console.log "es imbocado: el destroy2"
      @actionDuringStreakObserver?.dispose()
      @actionEndStreakObserver?.dispose()
      @actionNextLevelObserver?.dispose()
      @actionEndMusicObserver?.dispose()
      @pathtoMusic = ""
      @actionDuringStreak = ""
      @actionEndStreak = ""
      @actionNextLevel = ""
      @actionEndMusic = ""
      @typeLapse = ""
      @lapse = 0
