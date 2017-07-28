module.exports =
  autoToggle:
    title: "Auto Toggle"
    description: "Toggle on start."
    type: "boolean"
    default: true
    order: 1

  playIntroAudio:
    type: "object"
    properties:
      enabled:
        title: "Play Intro Audio - Enabled"
        description: "Play audio clip on/off."
        type: "boolean"
        default: false
        order: 1

      audioclip:
        title: "Play Intro Audio - Audioclip"
        description: "Which audio clip played at keystroke."
        type: "string"
        default: '../sounds/intro.wav'
        enum: [
          {value: '../sounds/intro.wav', description: 'Intro'}
          {value: 'customAudioclip', description: 'Custom Path'}
        ]
        order: 2

      customAudioclip:
        title: "Play Intro Audio - Path to Audioclip"
        description: "Path to audioclip played at keystroke."
        type: "string"
        default: 'intro.wav'
        order: 3

      volume:
        title: "Play Intro Audio - Volume"
        description: "Volume of the audio clip played at keystroke."
        type: "number"
        default: 1
        minimum: 0.0
        maximum: 1.0
        order: 4
      order: 2

  playBackgroundMusic:
    type: "object"
    properties:
      enabled:
        title: "Background Music - Enabled"
        description: "Play Background Music on/off."
        type: "boolean"
        default: true
        order: 1

      musicPath:
        title: "Background Music - Path to Audio"
        description: "Path to Music Tracks played in combo Mode."
        type: "string"
        default: '../sounds/'
        order: 2

      musicVolume:
        title: "Background Music - Volume"
        description: "Volume of the Music Track played in combo Mode."
        type: "number"
        default: 0.25
        minimum: 0.0
        maximum: 1.0
        order: 3

      actions:
        type: "object"
        properties:
          command:
            title: "Music Player - Action"
            description: 'Syntax "action, when, lapseType, lapse".\n
            action: repeat, change, none\n
            execution: duringStreak, endStreak, endMusic\n
            lapseType: streak, time (This value is used only if execution is duringStreak)\n
            lapse: Number Value (if lapseType is time, lapse will be in seconds) Min:10 Max:100\n
            Note: the lapsetype and lapse values is only used in duringStreak.'
            type: "array"
            default: ['change', 'duringStreak', 'streak', '100']
