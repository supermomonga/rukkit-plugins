import 'org.bukkit.entity.Player'
import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.Material'

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
    equip_sword?(player) && player.blocking?
  end

  def consume_item(player)
    if player.item_in_hand.amount == 1
      player.item_in_hand = ItemStack.new(Material::AIR)
    else
      player.item_in_hand.amount -= 1
    end
  end

  module_function :naked?
  module_function :no_armor?
  module_function :no_hold_item?
  module_function :equip_sword?
  module_function :block_with_sword?
  module_function :consume_item
end
