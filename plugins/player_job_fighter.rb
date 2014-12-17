# encoding: utf-8
require 'set'
import 'org.bukkit.entity.Player'

module PlayerJobFighter
  extend self
  extend Rukkit::Util

  def on_player_join(evt)
    player = evt.player

    # become job with 50% of probability
    @be_fighters ||= Set.new
    @be_fighters.add(player.entity_id) if rand(100) < 50
    broadcast "#{player.name}さんが武闘家になりました(装備なし、手持ちなしで攻撃と防御が強くなります!)" if @be_fighters.include?(player.entity_id)
  end

  def on_player_quit(evt)
    player = evt.player
    @be_fighters.delete(player.entity_id)
  end

  def on_entity_damage_by_entity(evt)
    act_as_fighter(evt)
  end

  def act_as_fighter(evt)
    damager = evt.damager
    damagee = evt.entity

    if damager.is_a?(Player)
      if @be_fighters.include?(damager.entity_id) && PlayerUtil.naked?(damager)
        evt.damage = evt.damage + 3.0
      end
    end
    if damagee.is_a?(Player)
      if @be_fighters.include?(damagee.entity_id) && PlayerUtil.naked?(damagee)
        evt.damage = damage_after_defend(evt.damage, 10.0)
      end
    end
  end

  def damage_after_defend(damage, defend)
    damage * (1.0 - (0.08 * defend))
  end
end
