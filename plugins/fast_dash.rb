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
        # monorail
        unless player.location.y.between?(15, 78)
          player.walk_speed = 1.0
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
    return unless player.walk_speed == 1.0
    block_below = add_loc(player.location, 0, -1, 0).block
    return unless block_below.type == Material::COBBLE_WALL
    yaw_mod = evt.to.yaw % 90
    new_yaw =
      case
      when yaw_mod < 1
        return # !
      when yaw_mod > 89
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
    when evt.entity.walk_speed >= 1.0
      evt.cancelled = true
    when evt.entity.level > 2 && evt.entity.walk_speed >= 0.4
      evt.cancelled = true
    end
  end
end
