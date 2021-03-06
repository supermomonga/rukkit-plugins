require 'set'
# import 'org.bukkit.Material'
# import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.entity.Skeleton'
import 'org.bukkit.event.entity.CreatureSpawnEvent'
import 'org.bukkit.entity.Arrow'
import 'org.bukkit.entity.Player'
import 'org.bukkit.event.entity.EntityDamageEvent'
import 'org.bukkit.entity.EntityType'

module SkeletonCrossbow
  extend self
  extend Rukkit::Util

  @skeletons ||= Set.new()

  def on_creature_spawn(evt)
    return unless evt.spawn_reason == CreatureSpawnEvent::SpawnReason::NATURAL
    skeleton = evt.entity
    return unless Skeleton === skeleton
    return unless skeleton.skeleton_type == Skeleton::SkeletonType::NORMAL
    return if skeleton.location.y >= 180
    # return unless rand(10) == 0
    return unless rand(3) == 0

    skeletons = [
      skeleton,
      spawn(skeleton.location, EntityType::SKELETON),
      spawn(skeleton.location, EntityType::SKELETON)]
    skeletons.each do |s|
      s.custom_name = 'Crossbowman'
      @skeletons.add(s)
    end

    garbage_collection()
  end

  def on_projectile_launch(evt)
    arrow = evt.entity
    return unless Arrow === arrow
    shooter = arrow.shooter
    return unless @skeletons.include?(shooter)

    if rand(3) == 0
      evt.cancelled = true
      return
    end

    8.times {|i| play_effect(shooter.location, Effect::SMOKE, i) }
    play_sound(arrow.location, Sound::SHOOT_ARROW, 1.0, 0.0)
    arrow.critical = true
  end

  def on_entity_damage_by_entity(evt)
    player = evt.entity
    arrow = evt.damager
    return unless Player === player
    return unless Arrow === arrow

    skeleton = arrow.shooter
    return unless @skeletons.include?(skeleton)

    # evt.cancelled = true
    damage_value = 4 + rand(2)
    # evt.setDamage(EntityDamageEvent::DamageModifier::BASE, damage_value)
    evt.setDamage(damage_value)
    player.send_message("[CROWSSBOW] #{player.name} was damaged by Crossbowman (#{damage_value})")
  end

  def on_entity_death(evt)
    entity = evt.entity
    if @skeletons.include?(entity)
      evt.dropped_exp = (evt.dropped_exp * 1.2).round
    end
  end

  def garbage_collection
    @skeletons.reject!(&:dead?)
  end
end
