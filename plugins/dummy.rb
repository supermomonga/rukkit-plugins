import 'org.bukkit.Sound'

module Dummy
  extend self
  extend Rukkit::Util

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'

    args = args.to_a
    case args.shift
    when 'what-time'
      msg = "#{sender.name} (what-time) => #{Time.now.to_s}"
      broadcast msg
      Lingr.post msg
    end
  end

  def on_player_chat_tab_complete(evt)
    player = evt.player
    return unless player.name == 'deris0126'
    text = "[DERIS] #{[evt.chat_message, evt.last_token, evt.tab_completions.to_a.join(', ')].inspect}"
    Lingr.post(text)
    broadcast(text)
  end
end
