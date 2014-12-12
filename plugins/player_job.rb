# encoding: utf-8
require 'set'
import 'org.bukkit.entity.Player'
import 'org.bukkit.Material'

module PlayerJob
  extend self
  extend Rukkit::Util

  def on_player_join(evt)
    player = evt.player
    random = Random.new

    # become job with 50% of probability
    @be_knights ||= Set.new
    @be_fighters ||= Set.new
    @be_knights.add(player) if random.rand(100) < 50
    @be_fighters.add(player) if random.rand(100) < 50
    broadcast "#{player.name}さんが剣士になりました(剣の攻撃と防御が強くなります!)" if @be_knights.include?(player)
    broadcast "#{player.name}さんが武闘家になりました(装備なし、手持ちなしで攻撃と防御が強くなります!)" if @be_fighters.include?(player)
  end

  def on_player_quit(evt)
    player = evt.player
    @be_knights.delete(player)
    @be_fighters.delete(player)
  end

  def on_entity_damage_by_entity(evt)
    act_as_knight(evt)
    act_as_fighter(evt)
  end

  def act_as_knight(evt)
    damager = evt.get_damager
    damagee = evt.get_entity

    if damager.is_a?(Player)
      if @be_knights.include?(damager) && damager.equip_sword?
        evt.set_damage(evt.get_damage + 1.0)
      end
    end
    if damagee.is_a?(Player)
      if @be_knights.include?(damagee) && damagee.block_with_sword?
        evt.set_damage(damage_after_defend(evt.get_damage, 3.0))
      end
    end
  end

  def act_as_fighter(evt)
    damager = evt.get_damager
    damagee = evt.get_entity

    if damager.is_a?(Player)
      if @be_fighters.include?(damager) && damager.naked?
        evt.set_damage(evt.get_damage + 3.0)
      end
    end
    if damagee.is_a?(Player)
      if @be_fighters.include?(damagee) && damagee.naked?
        evt.set_damage(damage_after_defend(evt.get_damage, 10.0))
      end
    end
  end

  def damage_after_defend(damage, defend)
    damage * (1.0 - (0.08 * defend))
  end
end

module Player

  def naked?
    no_armor? && no_hold_item?
  end

  def no_armor?
    inventory = self.get_inventory
    armor = inventory.get_armor_contents
    armor.all? { |x| x.get_amount == 0 }
  end

  def no_hold_item?
    inventory = self.get_inventory
    item = inventory.get_item_in_hand
    item.get_amount == 0
  end

  def equip_sword?
    inventory = self.get_inventory
    item = inventory.get_item_in_hand
    material = item.get_type
    material.sword?
  end

  def block_with_sword?
    self.equip_sword? && self.is_blocking
  end
end

class Material
  def sword?
    case self
    when Material::IRON_SWORD,
         Material::WOOD_SWORD,
         Material::STONE_SWORD,
         Material::DIAMOND_SWORD,
         Material::GOLD_SWORD
      true
    else
      false
    end
  end
end
