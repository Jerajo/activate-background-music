module.exports =
  conf: []

  setup: ->
    @subscriptions = new CompositeDisposable

    @observe "actions.duringStreak.action",   "duringStreak"
    @observe "actions.duringStreak.typeLapse","typeLapse"
    @observe "actions.duringStreak.lapse",    "lapse"
    @observe "actions.endStreak.action",      "endStreak"
    @observe "actions.endStreak.pause",       "pause"
    @observe "actions.endMusic.action",       "endMusic"
    @observe "actions.nextLevel.action",      "onNextLevel"
    @observe "actions.autoplay",              "autoplay"
    @observe "actions.volumeChangeRate",      "volumeChangeRate"

    @subscriptions.add atom.config.observe(
      "activate-power-mode.comboMode.activationThreshold", (value) =>
        @conf['activationThreshold'] = value[0]
    )

    #@activationThresholdObserver?.dispose()
    #@activationThresholdObserver = atom.config.observe "activate-power-mode.comboMode.activationThreshold", (value) =>
      #@conf['activationThreshold'] = value[0]

    #@actionDuringStreakObserver?.dispose()
    #@actionDuringStreakObserver = atom.config.observe 'activate-background-music.actions.duringStreak.action', (value) =>
      #@conf['actionDuringStreak'] = value

    #@actionEndStreakObserver?.dispose()
    #@actionEndStreakObserver = atom.config.observe 'activate-background-music.actions.endStreak.action', (value) =>
      #@conf['actionEndStreak'] = value

    #@actionNextLevelObserver?.dispose()
    #@actionNextLevelObserver = atom.config.observe 'activate-background-music.actions.nextLevel.action', (value) =>
      #@conf['actionNextLevel'] = value

    #@actionEndMusicObserver?.dispose()
    #@actionEndMusicObserver = atom.config.observe 'activate-background-music.actions.endMusic.action', (value) =>
      #@conf['actionEndMusic'] = value

    #@typeLapseObserver?.dispose()
    #@typeLapseObserver = atom.config.observe 'activate-background-music.actions.duringStreak.typeLapse', (value) =>
      #@conf['typeLapse'] = value

    #@typeLapseObserver?.dispose()
    #@typeLapseObserver = atom.config.observe 'activate-background-music.actions.duringStreak.lapse', (value) =>
      #@conf['lapse'] = value

    #@pauseObserver?.dispose()
    #@pauseObserver = atom.config.observe 'activate-background-music.actions.endStreak.pause', (value) =>
      #@conf['pause'] = value
      #console.log "Pause existe y su valor es " + @conf['pause']

    #@autoPlayObserver?.dispose()
    #@autoPlayObserver = atom.config.observe 'activate-background-music.actions.autoplay', (value) =>
      #console.log if value then "es verdadero" else "es falso"
      #@conf['autoPlay'] = value

    #@volumeChangeRateObserver?.dispose()
    #@volumeChangeRateObserver = atom.config.observe 'activate-background-music.actions.volumeChangeRate', (value) =>
      #@conf['volumeChangeRate'] = value

  observe: (path, key) ->
    @subscriptions.add atom.config.observe(
      "activate-background-music.#{path}", (value) =>
        @conf[key] = value
    )

  destroy: ->
    @subscriptions?.dispose()
    @conf = null
    #@activationThresholdObserver?.dispose()
    #@actionDuringStreakObserver?.dispose()
    #@volumeChangeRateObserver?.dispose()
    #@actionEndStreakObserver?.dispose()
    #@actionNextLevelObserver?.dispose()
    #@actionEndMusicObserver?.dispose()
    #@autoPlayObserver?.dispose()
    #@pauseObserver?.dispose()
