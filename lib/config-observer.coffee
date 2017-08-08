module.exports =
  actionDuringStreak: ""
  actionEndStreak: ""
  actionNextLevel: ""
  actionEndMusic: ""
  typeLapse: ""

  setup: ->
    @actionDuringStreakObserver?.dispose()
    @actionDuringStreakObserver = atom.config.observe 'activate-background-music.actions.duringStreak.action', (value) =>
      @actionDuringStreak = value

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
