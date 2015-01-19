import 'org.bukkit.entity.Arrow'
import 'org.bukkit.entity.Player'
import 'org.bukkit.util.Vector'

=begin
## Summary

This provides alternative bow that you can choose either normal bow or this
special bow called crossbow.

## Command

/rukkit crossbow

This will work only when you have a bow in your hand. This will toggle your bow
to crossbow, and vice versa.

## Crossbow

* You have to charge more than usual, other than it won't launch.
* Crossbow arrows go faster than normal.
* Crossbow arrows go more straight than normal.
* Crossbow arrows stop after certain distance.

=end
module Crossbow
  extend self
  extend Rukkit::Util

  def on_projectile_launch(evt)
    arrow = evt.entity
    return unless Arrow === arrow
    shooter = arrow.shooter
    return unless Player === shooter
    return unless shooter.item_in_hand.item_meta.display_name == 'Crossbow'

    unless arrow.critical?
      shooter.send_message("[CROWSSBOW] Not enough charge. It didn't get launched.")
      evt.cancelled = true
    end
    vel = arrow.velocity
    original_loc = arrow.location
    play_sound(original_loc, Sound::SHOOT_ARROW, 1.0, 0.0)
    arrow.setMetadata('crossbow', org.bukkit.metadata.FixedMetadataValue.new(Bukkit.plugin_manager.get_plugin("rukkit"), true))

    repeated_task = -> {
      # if rand(1000) == 0
      #   broadcast('randome die')
      #   return
      # end
      return if arrow.on_ground?
      return unless arrow.valid?
      if arrow.location.distance(original_loc) > 30.0
        # broadcast("can't fly more")
        play_effect(arrow.location, Effect::SMOKE, 0)
        arrow.velocity = Vector.new()
        arrow.critical = false
        return
      end
      later(1) do
        repeated_task.()
      end
    }
    later(0) do
      arrow.velocity = vel.multiply(1.8)
      repeated_task.()
    end
  end

  def on_entity_damage_by_entity(evt)
    target = evt.entity
    arrow = evt.damager
    return unless Arrow === arrow

    player = arrow.shooter
    return unless Player === player

    # detect crossbow arrow
    if arrow.get_metadata('crossbow').to_a.any? {|m| m.asBoolean }
      # reduce, because it's too strong due to the speed
      evt.setDamage((evt.damage * 0.7).round)
    end
  end

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    return unless Player === sender
    return unless args.first == 'crossbow'
    return unless sender.item_in_hand
    return unless sender.item_in_hand.type == Material::BOW
    old_name = sender.item_in_hand.item_meta.display_name
    new_display_name = old_name == 'Crossbow' ? 'Bow' : 'Crossbow'
    sender.item_in_hand.tap {|itemstack| itemstack.setItemMeta(itemstack.item_meta.tap {|im| im.display_name = new_display_name }) }

    text = "[CROWSSBOW] #{sender.name} toggled the bow from #{old_name} to #{new_display_name}"
    Lingr.post(text)
    broadcast(text)
  end
end
