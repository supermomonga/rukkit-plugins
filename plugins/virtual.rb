import 'org.bukkit.Material'
import 'org.bukkit.Bukkit'

module Virtual
  extend self
  extend Rukkit::Util

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    return unless Player === sender

    args = args.to_a
    case args.shift
    when 'virtual'
      arg2 = args.shift
      case
      when (material = Material.const_get(arg2.upcase) rescue false)
        Bukkit.online_players.each do |player|
          player.send_block_change(sender.location, material, 0)
        end
      when arg2 == 'dry'
        (-10..10).each do |xdiff|
          (-1..10).each do |ydiff|
            (-10..10).each do |zdiff|
              loc = add_loc(sender.location, xdiff, ydiff, zdiff)
              sender.send_block_change(loc, Material::AIR, 0) if loc.block.liquid?
            end
          end
        end
      else
      end
    else
    end
  end
end
