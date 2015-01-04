import 'org.bukkit.Material'
import 'org.bukkit.Bukkit'

module Virtual
  extend self
  extend Rukkit::Util

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'

    args = args.to_a
    case args.shift
    when 'virtual'
      material = Material.const_get(args.shift.upcase) rescue return
      Bukkit.online_players.each do |player|
        player.send_block_change(sender.location, material, 0)
      end
    else
    end
  end
end
