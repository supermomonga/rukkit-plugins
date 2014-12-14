# encoding: utf-8
require 'set'
import 'org.bukkit.entity.Player'

module PlayerJobFighter
  extend self
  extend Rukkit::Util

  def on_player_join(evt)
    player = evt.player
    random = Random.new

    # become job with 50% of probability
    @be_fighters ||= Set.new
    @be_fighters.add(player) if random.rand(100) < 50
    broadcast "#{player.name}さんが武闘家になりました(装備なし、手持ちなしで攻撃と防御が強くなります!)" if @be_fighters.include?(player)
  end

  def on_player_quit(evt)
    player = evt.player
    @be_fighters.delete(player)
  end

  def on_entity_damage_by_entity(evt)
    act_as_fighter(evt)
  end

  def act_as_fighter(evt)
    damager = evt.get_damager
    damagee = evt.get_entity

    if damager.is_a?(Player)
      if @be_fighters.include?(damager) && PlayerUtil.naked?(damager)
        evt.set_damage(evt.get_damage + 3.0)
      end
    end
    if damagee.is_a?(Player)
      if @be_fighters.include?(damagee) && PlayerUtil.naked?(damagee)
        evt.set_damage(damage_after_defend(evt.get_damage, 10.0))
      end
    end
  end

  def damage_after_defend(damage, defend)
    damage * (1.0 - (0.08 * defend))
  end
end
