# encoding: utf-8
import 'org.bukkit.entity.Player'
import 'org.bukkit.Material'

module PlayerJob
  extend self
  extend Rukkit::Util

  def on_player_join(evt)
    player = evt.player
    random = Random.new

    # become job with 50% of probability
    @be_knights = @be_knights || {}
    @be_fighters = @be_fighters || {}
    @be_knights[player] = true if random.rand(100) < 50
    @be_fighters[player] = true if random.rand(100) < 50
    broadcast "#{player.name}さんが剣士になりました" if @be_knights[player]
    broadcast "#{player.name}さんが武闘家になりました" if @be_fighters[player]
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
      if @be_knights.key?(damager) && damager.equip_sword?
        evt.set_damage(evt.get_damage + 1.0)
      end
    end
    if damagee.is_a?(Player)
      if @be_knights.key?(damagee) && damagee.block_with_sword?
        evt.set_damage(damage_after_defend(evt.get_damage, 3.0))
      end
    end
  end

  def act_as_fighter(evt)
    damager = evt.get_damager
    damagee = evt.get_entity

    if damager.is_a?(Player)
      if @be_fighters.key?(damager) && damager.naked?
        evt.set_damage(evt.get_damage + 3.0)
      end
    end
    if damagee.is_a?(Player)
      if @be_fighters.key?(damagee) && damagee.naked?
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

  attr_writer :knight
  attr_writer :fighter

  def knight?
    @knight ? true : false
  end

  def fighter?
    @fighter ? true : false
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
