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
  private :iikanji_effect

  @time_sneaked ||= {}

  def on_player_toggle_sneak(evt)
    player = evt.player
    return unless %w[world world_nether].include?(player.location.world.name)

    name = player.name
    @crouching_counter ||= {}
    @crouching_counter[name] ||= 0
    @crouching_countingdown ||= false
    if evt.sneaking?
      @time_sneaked[name] = Time.now.to_i

      # counting up
      @crouching_counter[name] += 1
      later sec(1.5) do
        @crouching_counter[name] -= 1
      end
      if @crouching_counter[name] == 3
        loc = player.location
        play_sound(add_loc(loc, 0, 5, 0), Sound::ENTITY_BAT_TAKEOFF, 0.9, 0.0)
        iikanji_effect(loc)

        player.send_message('[SUPER JUMP] This feature will be removed soon.')
        player.fall_distance = 0.0
        player.velocity = player.velocity.tap {|v| v.set_y jfloat(1.3) }
      end
    else
      @time_sneaked.delete(name)
    end
  end

  def on_player_interact(evt)
    player = evt.player

    case evt.action
    when Action::PHYSICAL
      wood_plate_jump(player, evt.clicked_block)

    when Action::LEFT_CLICK_AIR, Action::LEFT_CLICK_BLOCK
      return unless player.item_in_hand.type == Material::FEATHER
      return if player.on_ground?
      evt.cancelled = true

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
            x * 2.0, y, z * 2.0)
        end

        @vertical_accelerated[player.name] = true
        later sec(0.6) do
          @vertical_accelerated[player.name] = false
        end
      end
    end
  end

  def on_entity_interact(evt)
    wood_plate_jump(evt.entity, evt.block)
  end

  def wood_plate_jump(entity, block)
    return unless block.type == Material::WOOD_PLATE
    return unless block_below(block).type == Material::GOLD_ORE

    play_sound(entity.location, Sound::CAT_HIT, 0.5, 1.0)
    later 0 do
      entity.velocity = entity.velocity.tap {|v| v.set_y(jfloat(1.8)) }
    end
  end

  def on_player_move(evt)
    player = evt.player
    return unless player.sneaking?
    return unless evt.from.y < evt.to.y
    return if evt.to.y - evt.from.y == 0.5
    return unless player.on_ground?
    return unless %w[world world_nether].include?(player.location.world.name)
    return unless @time_sneaked[player.name]

    time_diff = Time.now.to_i - @time_sneaked[player.name]
    @time_sneaked.delete(player.name)
    play_sound(player.location, Sound::BURP, 0.5, 0.0)
    iikanji_effect(player.location)
    later 0 do
      f = [time_diff / 3.0 + 1.0, 5.0].min
      player.velocity = player.velocity.tap {|v| v.set_y jfloat(f) }
    end
  end
end
