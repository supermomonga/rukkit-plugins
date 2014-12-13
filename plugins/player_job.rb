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
      if @be_knights.include?(damager) && PlayerUtil.equip_sword?(damager)
        evt.set_damage(evt.get_damage + 1.0)
      end
    end
    if damagee.is_a?(Player)
      if @be_knights.include?(damagee) && PlayerUtil.block_with_sword?(damagee)
        evt.set_damage(damage_after_defend(evt.get_damage, 3.0))
      end
    end
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

module PlayerUtil
  def naked?(player)
    no_armor?(player) && no_hold_item?(player)
  end

  def no_armor?(player)
    inventory = player.get_inventory
    armor = inventory.get_armor_contents
    armor.all? { |x| x.get_amount == 0 }
  end

  def no_hold_item?(player)
    inventory = player.get_inventory
    item = inventory.get_item_in_hand
    item.get_amount == 0
  end

  def equip_sword?(player)
    inventory = player.get_inventory
    item = inventory.get_item_in_hand
    material = item.get_type
    MaterialUtil.sword?(material)
  end

  def block_with_sword?(player)
    equip_sword?(player) && self.is_blocking
  end

  module_function :naked?
  module_function :no_armor?
  module_function :no_hold_item?
  module_function :equip_sword?
  module_function :block_with_sword?
end

module MaterialUtil
  def sword?(material)
    case material
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

  module_function :sword?
end
