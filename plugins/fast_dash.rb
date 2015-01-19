import 'org.bukkit.Bukkit'
import 'org.bukkit.entity.Squid'
import 'org.bukkit.Material'

module FastDash
  extend self
  extend Rukkit::Util

  def on_player_toggle_sprint(evt)
    player = evt.player

    return if player.passenger && Squid === player.passenger
    block_below = player.location.clone.add(0, -1, 0).block
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
            when yaw_mod < 40
              player.location.yaw - yaw_mod
            when yaw_mod > 60
              player.location.yaw + 270 + yaw_mod
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

  def on_food_level_change(evt)
    case
    when evt.entity.walk_speed >= 1.0
      evt.cancelled = true
    when evt.entity.level > 2 && evt.entity.walk_speed >= 0.4
      evt.cancelled = true
    end
  end
end
