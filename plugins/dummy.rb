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
end
