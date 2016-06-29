import 'org.bukkit.Sound'
import 'org.bukkit.entity.Player'
import 'org.bukkit.event.entity.EntityDamageEvent'

module StrongBoots
  extend self
  extend Rukkit::Util

  @deprecated_message = {}
  def on_entity_damage(evt)
    # log.info("on_entity_damage: #{evt}")
    player = evt.entity
    return unless Player === player

    case evt.cause
    when EntityDamageEvent::DamageCause::FALL
      b = player.inventory.boots or return

      evt.cancelled = true
      # play_sound(player.location, Sound::BAT_HURT, 0.5, 0.0)
      play_sound(player.location, Sound::ENTITY_PLAYER_BURP, 0.5, 0.0)

      if !@deprecated_message[player.name]
        @deprecated_message[player.name] = true
        player.send_message "[BOOTS] This behaviour will change in the future. Be careful."
        later sec(3600) do # every 1 hour
          @deprecated_message[player.name] = false
        end
      end
    end
  end
end
