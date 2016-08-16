import 'org.bukkit.Material'
import 'org.bukkit.Effect'

module SignTeleport
  extend self
  extend Rukkit::Util

  def on_player_interact(evt)
    action = evt.action
    block = evt.clicked_block
    return unless action == Action::RIGHT_CLICK_BLOCK
    return unless [Material::SIGN, Material::SIGN_POST, Material::WALL_SIGN].include? block.type
    sign_command(evt)
  end

  def sign_command(evt)
    player = evt.player
    sign = evt.clicked_block
    sign_state = sign.state

    raw_command = sign_state.get_line(0).strip.downcase
    args = 1.upto(3).map { |n|
      sign_state.get_line(n).strip
    }.reject { |n|
      n == ''
    }
    return unless raw_command.match %r`<(.+)>`
    command = raw_command.tr('<>', '').to_sym
    log.info("#{command}")
    args.each do |arg|
      log.info("#{arg}")
    end
    case command
    when :elevator then elevator(sign, player, *args)
    end
  end

  def face2pitchyaw(face)
    x, z = face.mod_x, face.mod_z
    phi = Math.atan2(-x, z) * 180 / Math::PI
    [0.0, phi]
  end

  def elevator(sign, player, direction)
    base_loc = sign.location.clone
    facing = sign.state.data.facing
    pitch, yaw = face2pitchyaw(facing)

    if direction.match /UP/
      n = 1
      loc = base_loc.clone
      while n < 250 do
        loc.set_y loc.y + 1
        unless [ Material::AIR, Material::TORCH, Material::SIGN, Material::SIGN_POST, Material::WALL_SIGN ].include? loc.block.type
          teleport_loc = player.location.clone
          teleport_loc.x = loc.x + 0.5
          teleport_loc.y = loc.y + 1
          teleport_loc.z = loc.z + 0.5
          teleport_loc.yaw = yaw
          teleport_loc.pitch = pitch
          later(0) do
            play_effect(teleport_loc, Effect::ENDER_SIGNAL, nil)
            player.teleport(teleport_loc)
          end
          break
        end
        n += 1
      end
    elsif direction.match /DOWN/
      n = 1
      block_count = 0
      loc = base_loc.clone
      while n < 250 do
        loc.set_y loc.y - 1
        unless [ Material::AIR, Material::TORCH, Material::SIGN, Material::SIGN_POST, Material::WALL_SIGN ].include? loc.block.type
          block_count += 1
          if block_count > 1
            teleport_loc = player.location.clone
            teleport_loc.x = loc.x + 0.5
            teleport_loc.y = loc.y + 1
            teleport_loc.z = loc.z + 0.5
            teleport_loc.yaw = yaw
            teleport_loc.pitch = pitch
            later(0) do
              play_effect(teleport_loc, Effect::ENDER_SIGNAL, nil)
              player.teleport(teleport_loc)
            end
            break
          end
        end
        n += 1
      end
    end
  end
end
