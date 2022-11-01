def pbMessageDisplay(msgwindow, message, letterbyletter = true, commandProc = nil)
  return if !msgwindow
  oldletterbyletter = msgwindow.letterbyletter
  msgwindow.letterbyletter = (letterbyletter) ? true : false
  ret = nil
  commands = nil
  facewindow = nil
  faceRightwindow = nil
  goldwindow = nil
  coinwindow = nil
  battlepointswindow = nil
  cmdvariable = 0
  cmdIfCancel = 0
  msgwindow.waitcount = 0
  autoresume = false
  text = message.clone
  msgback = nil
  linecount = (Graphics.height > 400) ? 3 : 2
  ### Text replacement
  text.gsub!(/\\sign\[([^\]]*)\]/i) {   # \sign[something] gets turned into
    next "\\op\\cl\\ts[]\\w[" + $1 + "]"    # \op\cl\ts[]\w[something]
  }
  text.gsub!(/\\\\/, "\5")
  text.gsub!(/\\1/, "\1")
  if $game_actors
    text.gsub!(/\\n\[([1-8])\]/i) {
      m = $1.to_i
      next $game_actors[m].name
    }
  end
  text.gsub!(/\\pn/i,  $player.name) if $player
  text.gsub!(/\\pm/i,  _INTL("${1}", $player.money.to_s_formatted)) if $player
  text.gsub!(/\\n/i,   "\n")
  text.gsub!(/\\\[([0-9a-f]{8,8})\]/i) { "<c2=" + $1 + ">" }
  text.gsub!(/\\pg/i,  "\\b") if $player&.male?
  text.gsub!(/\\pg/i,  "\\r") if $player&.female?
  text.gsub!(/\\pog/i, "\\r") if $player&.male?
  text.gsub!(/\\pog/i, "\\b") if $player&.female?
  text.gsub!(/\\pg/i,  "")
  text.gsub!(/\\pog/i, "")
  text.gsub!(/\\b/i,   "<c3=3050C8,D0D0C8>")
  text.gsub!(/\\r/i,   "<c3=E00808,D0D0C8>")
  text.gsub!(/\\[Ww]\[([^\]]*)\]/) {
    w = $1.to_s
    if w == ""
      msgwindow.windowskin = nil
    else
      msgwindow.setSkin("Graphics/Windowskins/#{w}", false)
    end
    next ""
  }
  isDarkSkin = isDarkWindowskin(msgwindow.windowskin)
  text.gsub!(/\\c\[([0-9]+)\]/i) {
    m = $1.to_i
    next getSkinColor(msgwindow.windowskin, m, isDarkSkin)
  }
  loop do
    last_text = text.clone
    text.gsub!(/\\v\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    break if text == last_text
  end
  loop do
    last_text = text.clone
    text.gsub!(/\\l\[([0-9]+)\]/i) {
      linecount = [1, $1.to_i].max
      next ""
    }
    break if text == last_text
  end
  colortag = ""
  if $game_system && $game_system.message_frame != 0
    colortag = getSkinColor(msgwindow.windowskin, 0, true)
  else
    colortag = getSkinColor(msgwindow.windowskin, 0, isDarkSkin)
  end
  text = colortag + text
  ### Controls
  textchunks = []
  controls = []
  while text[/(?:\\(f|ff|mr|ml|mnr|mnl|ts|cl|me|se|wt|wtnp|ch)\[([^\]]*)\]|\\(g|cn|pt|wd|wm|op|cl|wu|\.|\||\!|\^))/i]
    textchunks.push($~.pre_match)
    if $~[1]
      controls.push([$~[1].downcase, $~[2], -1])
    else
      controls.push([$~[3].downcase, "", -1])
    end
    text = $~.post_match
  end
  textchunks.push(text)
  textchunks.each do |chunk|
    chunk.gsub!(/\005/, "\\")
  end
  textlen = 0
  controls.length.times do |i|
    control = controls[i][0]
    case control
    when "wt", "wtnp", ".", "|"
      textchunks[i] += "\2"
    when "!"
      textchunks[i] += "\1"
    end
    textlen += toUnformattedText(textchunks[i]).scan(/./m).length
    controls[i][2] = textlen
  end
  text = textchunks.join
  signWaitCount = 0
  signWaitTime = Graphics.frame_rate / 2
  haveSpecialClose = false
  specialCloseSE = ""
  startSE = nil
  controls.length.times do |i|
    control = controls[i][0]
    param = controls[i][1]
    case control
    when "op"
      signWaitCount = signWaitTime + 1
    when "cl"
      text = text.sub(/\001\z/, "")   # fix: '$' can match end of line as well
      haveSpecialClose = true
      specialCloseSE = param
    when "f"
      facewindow&.dispose
      facewindow = PictureWindow.new("Graphics/Pictures/#{param}")
    when "ml"
      facewindow&.dispose
      facewindow = MugshotWindow.new(param)
    when "mr"
      faceRightwindow&.dispose
      faceRightwindow = MugshotWindow.new(param)
    when "mnl"
      facewindow&.dispose
      facewindow = Window_AdvancedTextPokemon.new(param)
    when "mnr"
      faceRightwindow&.dispose
      faceRightwindow = Window_AdvancedTextPokemon.new(param)
    when "ff"
      facewindow&.dispose
      facewindow = FaceWindowVX.new(param)
    when "ch"
      cmds = param.clone
      cmdvariable = pbCsvPosInt!(cmds)
      cmdIfCancel = pbCsvField!(cmds).to_i
      commands = []
      while cmds.length > 0
        commands.push(pbCsvField!(cmds))
      end
    when "wtnp", "^"
      text = text.sub(/\001\z/, "")   # fix: '$' can match end of line as well
    when "se"
      if controls[i][2] == 0
        startSE = param
        controls[i] = nil
      end
    end
  end
  if startSE
    pbSEPlay(pbStringToAudioFile(startSE))
  elsif signWaitCount == 0 && letterbyletter
    pbPlayDecisionSE
  end
  ########## Position message window  ##############
  pbRepositionMessageWindow(msgwindow, linecount)
  if facewindow
    pbPositionNearMsgWindow(facewindow, msgwindow, :left)
    facewindow.viewport = msgwindow.viewport
    facewindow.z        = msgwindow.z - 1
  end
  if faceRightwindow
    pbPositionNearMsgWindow(faceRightwindow, msgwindow, :right)
    faceRightwindow.viewport = msgwindow.viewport
    faceRightwindow.z        = msgwindow.z - 1
  end
  atTop = (msgwindow.y == 0)
  ########## Show text #############################
  msgwindow.text = text
  Graphics.frame_reset if Graphics.frame_rate > 40
  loop do
    if signWaitCount > 0
      signWaitCount -= 1
      if atTop
        msgwindow.y = -msgwindow.height * signWaitCount / signWaitTime
      else
        msgwindow.y = Graphics.height - (msgwindow.height * (signWaitTime - signWaitCount) / signWaitTime)
      end
    end
    controls.length.times do |i|
      next if !controls[i]
      next if controls[i][2] > msgwindow.position || msgwindow.waitcount != 0
      control = controls[i][0]
      param = controls[i][1]
      case control
      when "f"
        facewindow&.dispose
        facewindow = PictureWindow.new("Graphics/Pictures/#{param}")
        pbPositionNearMsgWindow(facewindow, msgwindow, :left)
        facewindow.viewport = msgwindow.viewport
        facewindow.z        = msgwindow.z
      when "ml"
        facewindow&.dispose
        facewindow = MugshotWindow.new(param)
        pbPositionNearMsgWindow(facewindow, msgwindow, :left)
        facewindow.viewport = msgwindow.viewport
        facewindow.z        = msgwindow.z - 1
      when "mr"
        faceRightwindow&.dispose
        faceRightwindow = MugshotWindow.new(param)
        pbPositionNearMsgWindow(faceRightwindow, msgwindow, :right)
        faceRightwindow.viewport = msgwindow.viewport
        faceRightwindow.z        = msgwindow.z - 1
      when "mnl"
        facewindow&.dispose
        facewindow = Window_AdvancedTextPokemon.new(param)
        pbPositionNearMsgWindow(facewindow, msgwindow, :left)
        facewindow.viewport = msgwindow.viewport
        facewindow.z        = msgwindow.z - 1
      when "mnr"
        faceRightwindow&.dispose
        faceRightwindow = Window_AdvancedTextPokemon.new(param)
        pbPositionNearMsgWindow(faceRightwindow, msgwindow, :right)
        faceRightwindow.viewport = msgwindow.viewport
        faceRightwindow.z        = msgwindow.z - 1
      when "ff"
        facewindow&.dispose
        facewindow = FaceWindowVX.new(param)
        pbPositionNearMsgWindow(facewindow, msgwindow, :left)
        facewindow.viewport = msgwindow.viewport
        facewindow.z        = msgwindow.z
      when "g"      # Display gold window
        goldwindow&.dispose
        goldwindow = pbDisplayGoldWindow(msgwindow)
      when "cn"     # Display coins window
        coinwindow&.dispose
        coinwindow = pbDisplayCoinsWindow(msgwindow, goldwindow)
      when "pt"     # Display battle points window
        battlepointswindow&.dispose
        battlepointswindow = pbDisplayBattlePointsWindow(msgwindow)
      when "wu"
        msgwindow.y = 0
        atTop = true
        msgback.y = msgwindow.y if msgback
        pbPositionNearMsgWindow(facewindow, msgwindow, :left)
        msgwindow.y = -msgwindow.height * signWaitCount / signWaitTime
      when "wm"
        atTop = false
        msgwindow.y = (Graphics.height - msgwindow.height) / 2
        msgback.y = msgwindow.y if msgback
        pbPositionNearMsgWindow(facewindow, msgwindow, :left)
      when "wd"
        atTop = false
        msgwindow.y = Graphics.height - msgwindow.height
        msgback.y = msgwindow.y if msgback
        pbPositionNearMsgWindow(facewindow, msgwindow, :left)
        msgwindow.y = Graphics.height - (msgwindow.height * (signWaitTime - signWaitCount) / signWaitTime)
      when "ts"     # Change text speed
        msgwindow.textspeed = (param == "") ? -999 : param.to_i
      when "."      # Wait 0.25 seconds
        msgwindow.waitcount += Graphics.frame_rate / 4
      when "|"      # Wait 1 second
        msgwindow.waitcount += Graphics.frame_rate
      when "wt"     # Wait X/20 seconds
        param = param.sub(/\A\s+/, "").sub(/\s+\z/, "")
        msgwindow.waitcount += param.to_i * Graphics.frame_rate / 20
      when "wtnp"   # Wait X/20 seconds, no pause
        param = param.sub(/\A\s+/, "").sub(/\s+\z/, "")
        msgwindow.waitcount = param.to_i * Graphics.frame_rate / 20
        autoresume = true
      when "^"      # Wait, no pause
        autoresume = true
      when "se"     # Play SE
        pbSEPlay(pbStringToAudioFile(param))
      when "me"     # Play ME
        pbMEPlay(pbStringToAudioFile(param))
      end
      controls[i] = nil
    end
    break if !letterbyletter
    Graphics.update
    Input.update
    facewindow&.update
    faceRightwindow&.update
    if autoresume && msgwindow.waitcount == 0
      msgwindow.resume if msgwindow.busy?
      break if !msgwindow.busy?
    end
    if Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
      if msgwindow.busy?
        pbPlayDecisionSE if msgwindow.pausing?
        msgwindow.resume
      elsif signWaitCount == 0
        break
      end
    end
    pbUpdateSceneMap
    msgwindow.update
    yield if block_given?
    break if (!letterbyletter || commandProc || commands) && !msgwindow.busy?
  end
  Input.update   # Must call Input.update again to avoid extra triggers
  msgwindow.letterbyletter = oldletterbyletter
  if commands
    $game_variables[cmdvariable] = pbShowCommands(msgwindow, commands, cmdIfCancel)
    $game_map.need_refresh = true if $game_map
  end
  if commandProc
    ret = commandProc.call(msgwindow)
  end
  msgback&.dispose
  goldwindow&.dispose
  coinwindow&.dispose
  battlepointswindow&.dispose
  facewindow&.dispose
  faceRightwindow&.dispose
  if haveSpecialClose
    pbSEPlay(pbStringToAudioFile(specialCloseSE))
    atTop = (msgwindow.y == 0)
    (0..signWaitTime).each do |i|
      if atTop
        msgwindow.y = -msgwindow.height * i / signWaitTime
      else
        msgwindow.y = Graphics.height - (msgwindow.height * (signWaitTime - i) / signWaitTime)
      end
      Graphics.update
      Input.update
      pbUpdateSceneMap
      msgwindow.update
    end
  end
  return ret
end