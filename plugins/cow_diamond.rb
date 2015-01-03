import 'org.bukkit.event.entity.CreatureSpawnEvent'
import 'org.bukkit.entity.Cow'
import 'org.bukkit.Bukkit'

module CowDiamond
  extend self
  extend Rukkit::Util

  def on_creature_spawn(evt)
    return unless evt.spawn_reason == CreatureSpawnEvent::SpawnReason::BREEDING
    cow = evt.entity
    return unless Cow === cow
    player = Bukkit.online_players.to_a.min_by {|p| cow.location.distance(p.location) }
    text = "#{player.name} bred a cow."
    Lingr.post(text)
    broadcast(text)

    return if rand(10000) < 5 # p = 0.0005
    text = "Congratulations! #{player.name} got a diamond by breeding the cow!"
    Lingr.post(text)
    broadcast(text)
    drop_item(cow.location, ItemStack.new(Material::DIAMOND, 1))
  end
end
