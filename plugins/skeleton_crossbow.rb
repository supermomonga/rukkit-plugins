require 'set'
# import 'org.bukkit.Material'
# import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.entity.Skeleton'
import 'org.bukkit.event.entity.CreatureSpawnEvent'
import 'org.bukkit.entity.Arrow'

module SkeletonCrossbow
  extend self
  extend Rukkit::Util

  @skeletons ||= Set.new()

  def on_creature_spawn(evt)
    return unless evt.spawn_reason == CreatureSpawnEvent::SpawnReason::NATURAL
    skeleton = evt.entity
    return unless Skeleton === skeleton
    return unless skeleton.skeleton_type == Skeleton::SkeletonType::NORMAL
    # return unless rand(10) == 0

    @skeletons.add(skeleton)
    garbage_collection()
  end

  def on_projectile_launch(evt)
    arrow = evt.entity
    return unless Arrow === arrow
    shooter = arrow.shooter
    return unless @skeletons.include?(shooter)

    play_sound(arrow.location, Sound::EXPLODE, 1.0, 0.0)
  end

  def on_entity_death(evt)
    entity = evt.entity
    if @skeletons.include?(entity)
      evt.dropped_exp *= 10
    end
  end

  def garbage_collection
    @skeletons.reject!(&:dead?)
  end
end
