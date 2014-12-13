require 'mathn'
import 'org.bukkit.Sound'
import 'org.bukkit.Material'
import 'org.bukkit.Effect'
import 'org.bukkit.event.block.Action'
import 'org.bukkit.entity.EntityType'

module SuperJump
  extend self
  extend Rukkit::Util

  def iikanji_effect(loc)
    8.times do |i|
      play_effect(loc, Effect::SMOKE, i)
    end
    # 5.times do
    #   orb = spawn(loc, EntityType::EXPERIENCE_ORB)
    #   orb.experience = 0
    # end
  end

  def on_player_toggle_sneak(evt)
    player = evt.player
    return unless %w[world world_nether].include?(player.location.world.name)

    name = player.name
    @crouching_counter ||= {}
    @crouching_counter[name] ||= 0
    @crouching_countingdown ||= false
    if evt.sneaking?
      # counting up
      @crouching_counter[name] += 1
      later sec(1.5) do
        @crouching_counter[name] -= 1
      end
      if @crouching_counter[name] == 3
        loc = player.location
        play_sound(add_loc(loc, 0, 5, 0), Sound::BAT_TAKEOFF, 0.9, 0.0)
        iikanji_effect(loc)

        # evt.player.send_message "superjump!"
        player.fall_distance = 0.0
        player.velocity = player.velocity.tap {|v| v.set_y jfloat(1.3) }
      end
    end
  end

  def on_player_interact(evt)
    player = evt.player
    return unless [Action::LEFT_CLICK_AIR, Action::LEFT_CLICK_BLOCK].include?(evt.action)
    # return unless player.item_in_hand.type == Material::AIR
    return unless player.item_in_hand.type == Material::FEATHER
    return if player.on_ground?

    @vertical_accelerated ||= {}
    unless @vertical_accelerated[player.name]
      # play_sound(player.location, Sound::BAT_IDLE, 0.5, 0.0)
      play_sound(player.location, Sound::BURP, 0.5, 0.0)
      iikanji_effect(player.location)
      later 0 do
        phi = (player.location.yaw + 90) % 360
        x, y, z =
          Math.cos(phi / 180.0 * Math::PI),
          0.8,
          Math.sin(phi / 180.0 * Math::PI)
        x, y, z = 0, 2, 0 if player.sneaking?

        entity = player.vehicle ? player.vehicle : player
        player.velocity = org.bukkit.util.Vector.new(
          x * 1.5, y, z * 1.5)
      end

      @vertical_accelerated[player.name] = true
      later sec(0.6) do
        @vertical_accelerated[player.name] = false
      end
    end
  end
end
