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

  def on_tab_complete(sender, command, label, args)
    return unless Player === sender
    return unless sender.name == 'deris0126'
    text = "[DERIS] #{{command: command, label: label, args: args.to_a}.inspect}"
    Lingr.post(text)
    broadcast(text)
    true
  end
end
