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
      (centre_x - radius ... centre_x + radius).map {|x|
        z1 = Math.sqrt(radius ** 2 - (centre_x - x) ** 2).round * sign
        z2 = Math.sqrt(radius ** 2 - (centre_x - (x + 1)) ** 2).round * sign
        ([z1, z2].min..[z1, z2].max).map {|z|
          [x, centre_y, centre_z + z]
        }
      }.flatten(1)
    }.flatten(1)
  end

  def on_command(sender, command, label, args)
    # return unless label == 'rukkit'
    args = args.to_a
    return unless args.shift == 'build'
    return unless Player === sender

    case args.shift
    when 'help'
      sender.message '/rukkit build draw-circle -- By consuming 64 blocks you have in hand, it draws a circle line with 10 radius'
      sender.message '/rukkit build draw-square -- By consuming 64 blocks you have in hand, it draws a square line with 12 radius'
    when 'draw-square'
      if !sender.item_in_hand.type.block? || sender.item_in_hand.amount < 64
        sender.send_message 'ERROR You must have 64 blocks.'
        return false
      end

      n = args.shift.to_i || 6
      if n > 64
        sender.send_message('[BUILD] n is too big. Aborted.')
        return false
      end

      dots = (-n..n).map {|x|
        [sender.location.x.to_i + x, sender.location.y.to_i, sender.location.z - n]
      } + (-n..n).map {|z|
        [sender.location.x.to_i - n, sender.location.y.to_i, sender.location.z + z]
      } + (-n..n).map {|x|
        [sender.location.x.to_i + x, sender.location.y.to_i, sender.location.z + n]
      } + (-n..n).map {|z|
        [sender.location.x.to_i + n, sender.location.y.to_i, sender.location.z + z]
      }

      btype = sender.item_in_hand.type
      dots.map {|(x, y, z)| sender.world.get_block_at(x, y, z) }.
        reject {|b| b.type.occluding? }.
        each_slice(10).with_index.each do |blocks, idx|
          later(idx) do
            play_sound(blocks[0].location, Sound::EXPLODE, 1.0, rand(10) * 0.1)
            blocks.each do |b|
              b.type = btype
              b.data = 0
            end
          end
        end

      sender.send_message("SUCCESS with consuing all your #{btype}s.")
      sender.item_in_hand = nil
      sender.health = 1
      true
    when 'draw-circle'
      if !sender.item_in_hand.type.block? || sender.item_in_hand.amount < 64
        sender.send_message 'ERROR You must have 64 blocks.'
        return false
      end

      n = args.shift.to_i || 10
      if n > 64
        sender.send_message('[BUILD] n is too big. Aborted.')
        return false
      end

      dots = circle(
        [sender.location.x.to_i, sender.location.y.to_i - 1, sender.location.z.to_i],
        n)
      p [:dots, dots]

      btype = sender.item_in_hand.type
      dots.map {|(x, y, z)| sender.world.get_block_at(x, y, z) }.
        reject {|b| b.type.occluding? }.
        each_slice(10).with_index.each do |blocks, idx|
          later(idx) do
            play_sound(blocks[0].location, Sound::EXPLODE, 1.0, rand(10) * 0.1)
            blocks.each do |b|
              p [:placing, b.location.x, b.location.y, b.location.z]
              b.type = btype
              b.data = 0
            end
          end
        end
      sender.send_message "SUCCESS with consuing all your #{btype}s."
      sender.item_in_hand = nil
      sender.health = 1
      true
    end
  end
end
