import 'org.bukkit.Sound'
import 'org.bukkit.Material'
import 'org.bukkit.entity.Player'

module Build
  extend self
  extend Rukkit::Util

  # this will ignore outside valid area
  def debug_render(size_x, size_y, size_z, dots)
    [*0...size_y].reverse.each do |y|
      [*0...size_z].each do |z|
        puts [*0...size_x].map {|x|
          dots.any? {|(x1, y1, z1)| x == x1 && y == y1 && z == z1 } ? '**' : '  '
        }.join + '|'
      end
      puts '++' * size_x
    end
  end

  # this may make dots outside valid area
  def circle(centre, radius)
    centre_x, centre_y, centre_z = centre
    [1, -1].map {|sign|
      (centre_x - radius .. centre_x + radius).map {|x|
        z1 = Math.sqrt(radius ** 2 - (centre_x - x) ** 2).round * sign
        z2 = Math.sqrt(radius ** 2 - (centre_x - (x + 1)) ** 2).round * sign rescue centre_y
        ([z1, z2].min..[z1, z2].max).map {|z|
          [x, centre_y, centre_z + z]
        }
      }.flatten(1)
    }.flatten(1)
  end

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    args = args.to_a
    p args
    return unless args.shift == 'build'
    return unless Player === sender

    case args.shift
    when 'help'
      sender.message '/rukkit build draw-circle n -- By consumes 64 blocks, it draws a circle line with n radius'
    when 'draw-circle'
      if !sender.item_in_hand.type.block? || sender.item_in_hand.amount < 64
        sender.send_message 'ERROR You must have 64 blocks.'
        return false
      end
      btype = sender.item_in_hand.type

      dots = circle(
        [sender.location.x.to_i, sender.location.y.to_i - 1, sender.location.z.to_i],
        10)
      dots.map {|(x, y, z)| sender.world.get_block_at(x, y, z) }.
        reject {|b| b.type.occluding? }.
        each do |b|
          b.type = btype
          b.data = 0
          play_sound(sender.location, Sound::EXPLODE, 1.0, 0.0)
        end
        sender.send_message "SUCCESS with consuing all your #{btype}s."
      # sender.item_in_hand = nil

      true
    end
  end
end
