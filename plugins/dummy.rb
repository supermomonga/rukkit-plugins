import 'org.bukkit.Sound'

module Dummy
  extend self
  extend Rukkit::Util

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'

    args = args.to_a
    case args.shift
    when 'eval'
      # very dangerous!
      later(0) do
        begin
          # how to handle double-space?
          sender.send_message(eval(args.join(' ')).inspect)
        rescue => e
          sender.send_message(e.inspect)
        end
      end
    when 'what-time'
      msg = "#{sender.name} (what-time) => #{Time.now.to_s}"
      broadcast msg
      Lingr.post msg
    end
  end
end
