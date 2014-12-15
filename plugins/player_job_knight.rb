# encoding: utf-8
require 'set'
import 'org.bukkit.entity.Player'

module PlayerJobKnight
  extend self
  extend Rukkit::Util

  def on_player_join(evt)
    player = evt.player
    random = Random.new

    # become job with 50% of probability
    @be_knights ||= Set.new
    @be_knights.add(player) if random.rand(100) < 50
    broadcast "#{player.name}さんが剣士になりました(剣の攻撃と防御が強くなります!)" if @be_knights.include?(player)
  end

  def on_player_quit(evt)
    player = evt.player
    @be_knights.delete(player)
  end

  def on_entity_damage_by_entity(evt)
    act_as_knight(evt)
  end

  def act_as_knight(evt)
    damager = evt.damager
    damagee = evt.entity

    if damager.is_a?(Player)
      if @be_knights.include?(damager) && PlayerUtil.equip_sword?(damager)
        evt.damage = evt.damage + 1.0
      end
    end
    if damagee.is_a?(Player)
      if @be_knights.include?(damagee) && PlayerUtil.block_with_sword?(damagee)
        evt.damage = damage_after_defend(evt.damage, 3.0)
      end
    end
  end

  def damage_after_defend(damage, defend)
    damage * (1.0 - (0.08 * defend))
  end
end
