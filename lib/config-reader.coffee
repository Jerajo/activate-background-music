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
      console.log "se invoca: septup2"
      @musicPathObserver?.dispose()
      @musicPathObserver = atom.config.observe 'activate-background-music.playBackgroundMusic.musicPath', (value) =>
        if value is "../sounds/musics/"
          @pathtoMusic = path.join(__dirname, value)
        else
          @pathtoMusic = value

      @actionDuringStreakObserver?.dispose()
      @actionDuringStreakObserver = atom.config.observe 'activate-background-music.actions.duringStreak', (value) =>
        @actionDuringStreak = value.action
        @typeLapse = value.typeLapse
        @lapse = value.lapse

      @actionEndStreakObserver?.dispose()
      @actionEndStreakObserver = atom.config.observe 'activate-background-music.actions.endStreak.action', (value) =>
        @actionEndStreak = value

      @actionNextLevelObserver?.dispose()
      @actionNextLevelObserver = atom.config.observe 'activate-background-music.actions.nextLevel.action', (value) =>
        @actionNextLevel = value

      @actionEndMusicObserver?.dispose()
      @actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (value) =>
        @actionEndMusic = value

    destroy: ->
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