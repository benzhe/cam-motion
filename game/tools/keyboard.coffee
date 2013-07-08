LETTER_CHECKING_TIME = 300
LETTER_CHECKING_DELAY = 100
CircleInput = $('#J_KeyBoardCircle')
Circle = CircleInput.knob
  thickness : 0.3
  width     : 60

class LettersCtrl
  constructor: ->
    @letters = []
    letters = [
      ["Q", 23, 249]
      ["W", 99, 249]
      ["E", 175, 249]
      ["R", 252, 249]
      ["T", 330, 249]
      ["Y", 407, 249]
      ["U", 484, 249]
      ["I", 561, 249]
      ["O", 637, 249]
      ["P", 713, 249]
      ["A", 60, 328]
      ["S", 136, 328]
      ["D", 213, 328]
      ["F", 289, 328]
      ["G", 367, 328]
      ["H", 445, 328]
      ["J", 521, 328]
      ["K", 598, 328]
      ["L", 675, 328]
      ["Z", 97, 410]
      ["X", 173, 410]
      ["C", 250, 410]
      ["V", 326, 410]
      ["B", 404, 410]
      ["N", 481, 410]
      ["M", 558, 410]
      ["BackSpace", 531, 110]
      ["Enter", 655, 110]
    ]
    for letter in letters
      @letters.push new Letter letter[0], letter[1], letter[2]
    @init()

  init: ->
    @delayTimer = null
    @inputTimer = null
    @inLetter = ""

    Circle.bind 'change', (ev)=>
      if ev.target.value >= 100
        @inputLetter @preLetter

    # @bind()

  bind: (x, y)->
    @x = x - 33
    @y = y - 33
    letter = @checkInLetter x, y
    Circle[0].style.cssText = """
      position: absolute; left: #{@x}px; top: #{@y}px;
    """
    return if (letter is @preLetter) # and @isStart
    clearTimeout @delayTimer
    clearTimeout @inputTimer
    @hideProgress()
    @preLetter = letter
    return if !letter
    @delayTimer = setTimeout => 
      @checkAfterDelay.call @
    , LETTER_CHECKING_DELAY

  checkAfterDelay: ->
    @showProgress()
    # @inputTimer = setTimeout =>
    #   @inputLetter @preLetter
    # , LETTER_CHECKING_TIME


  inputLetter: (letter)->
    console.log letter
    return if !letter
    SoundBox.play('ding')
    val = $('#username').val()
    if letter.letter is "BackSpace"
      $('#username').val val.substring(0, val.length - 1)
    else if letter.letter is "Enter"
      Watcher.clearTimer()
      game.nextPhase ->
        game.on('start', (mapArea)->
          App.init(mapArea)
        ).on("process", (i)->
          App.process(i)
        ).on('over', (score)->
          App.stop(score)
        )
        Watcher.gameStart.bind(undefined, App.hit.bind(App))()

      #game.nextPhase(Watcher.gameStart.bind(undefined, App.hit.bind(App)))
    else
      val = $('#username').val()
      $('#username').val val + letter.letter


  showProgress: ->
    @isStart = true
    #Circle.show()
    CircleInput.val(6).trigger('change')
    clearInterval @progressTimer
    value = 6
    @progressTimer = setInterval ->
      return if value >= 100
      value = value + 6
      CircleInput.val(value).trigger('change')
    , LETTER_CHECKING_TIME / 17
    return


  hideProgress: ->
    # Circle.hide()
    @isStart = false
    CircleInput.val(0).trigger('change')
    clearInterval @progressTimer
    
  checkInLetter: (x, y)->
    for letter in @letters
      if letter.checkIsSelf(x, y)
        @x = letter.x
        @y = letter.y
        console.log letter
        return letter
        break
    return false

class Letter
  width: 66
  height: 66

  constructor: (letter, x, y)->
    @letter = letter
    @x = x
    @y = y
    @r = x + @width
    @b = y + @height

  checkIsSelf: (x, y)->
    return x >= @x and x<= @r and y >= @y and y <= @b



