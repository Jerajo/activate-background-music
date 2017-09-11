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

  observe: (path, key) ->
    @subscriptions.add atom.config.observe(
      "activate-background-music.#{path}", (value) =>
        @conf[key] = value
    )

  destroy: ->
    @subscriptions?.dispose()
    @conf = null
