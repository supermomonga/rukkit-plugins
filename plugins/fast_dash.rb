import 'org.bukkit.Bukkit'
import 'org.bukkit.entity.Squid'
import 'org.bukkit.Material'

module FastDash
  extend self
  extend Rukkit::Util

  def on_player_toggle_sprint(evt)
    player = evt.player

    return if player.passenger && Squid === player.passenger
    if evt.sprinting? && !player.passenger
      case player.location.clone.add(0, -1, 0).block.type
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
            when yaw_mod < 20
              player.location.yaw - yaw_mod
            when yaw_mod > 70
              player.location.yaw - 90 + yaw_mod
            else
              nil
            end
          if new_yaw
            later(0) do
              new_loc = player.location.tap {|l| l.set_yaw(new_yaw) }
              endplayer.teleport(new_loc)
            end
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
