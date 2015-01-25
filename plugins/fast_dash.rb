import 'org.bukkit.Bukkit'
import 'org.bukkit.entity.Squid'
import 'org.bukkit.Material'
import 'org.bukkit.Effect'

module FastDash
  extend self
  extend Rukkit::Util

  def on_player_toggle_sprint(evt)
    player = evt.player

    return if player.passenger && Squid === player.passenger
    block_below = add_loc(player.location, 0, -1, 0).block
    if evt.sprinting? && !player.passenger
      case block_below.type
      when Material::SAND
        evt.cancelled = true
      when Material::COBBLE_WALL
        # monorail ... 0.6 -> 0.9 -> 1.4
        if on_monorail?(player)
          player.walk_speed = 0.6

          later sec(3) do
            if player.walk_speed >= 0.6 - 0.001
              player.walk_speed = 0.9
            end
          end

          later sec(7) do
            if player.walk_speed >= 0.6 - 0.001 && on_monorail?(player)
              player.send_message('[MONORAIL] 最高速度に達しました。自動巡回します')
              monorail_cruise_control(player)
            end
          end

          # align yaw if it's close enough
          yaw_mod = player.location.yaw % 90
          new_yaw =
            case
            when yaw_mod < 45
              (player.location.yaw - yaw_mod) % 360
            when yaw_mod > 45
              (player.location.yaw + 90 - yaw_mod) % 360
            else
              nil
            end
          later(0) do
            new_loc = player.location
            new_loc.set_yaw(new_yaw) if new_yaw
            new_loc.set_x(block_below.location.x + 0.5)
            new_loc.set_z(block_below.location.z + 0.5)
            player.teleport(new_loc)
          end
        end
      else
        player.walk_speed = 0.4
      end
    else
      player.walk_speed = 0.2
    end
  end

  def on_player_move(evt)
    player = evt.player
    return unless player.walk_speed >= 0.8
    block_below = add_loc(player.location, 0, -1, 0).block
    return unless block_below.type == Material::COBBLE_WALL
    yaw_mod = evt.to.yaw % 90
    new_yaw =
      case
      when yaw_mod < 0.1
        return # !
      when yaw_mod > 89.9
        return # !
      when yaw_mod < 10
        (player.location.yaw - yaw_mod) % 360
      when yaw_mod > 80
        (player.location.yaw + 90 - yaw_mod) % 360
      else
        return # !
      end
    later(0) do
      new_loc = player.location.tap {|l| l.set_yaw(new_yaw) }
      player.teleport(new_loc)
      play_effect(player.location, Effect::SMOKE, 0)
    end
  end

  def on_food_level_change(evt)
    case
    when evt.entity.walk_speed >= 0.8
      evt.cancelled = true
    when evt.entity.level > 2 && evt.entity.walk_speed >= 0.4
      evt.cancelled = true
    end
  end

  private
  def monorail_cruise_control(player)
    table = {0 => [0, 1], 1 => [-1, 0], 2 => [0, -1], 3 => [1, 0]}
    xdiff, zdiff = table[(player.location.yaw / 90.0).round]
    longest = [*1..5].reverse.find {|i|
      btypes = [-1, 0, 1].map {|ydiff|
        add_loc(player.location, xdiff * i, ydiff, zdiff * i).block.type
      }
      btypes == [Material::COBBLE_WALL, Material::AIR, Material::AIR]
    }
    if longest
      player.teleport(add_loc(player.location, xdiff * longest, 0, zdiff * longest))
      later(1, method(:monorail_cruise_control))
    end
  end

  def on_monorail?(player)
    !player.location.y.between?(15, 78)
  end
end
