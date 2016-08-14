import 'org.bukkit.entity.Player'
import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.Material'

module PlayerUtil
  def in_water?(player)
    type = player.location.block.type
    type == Material::STATIONARY_WATER || type == Material::WATER
  end

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

  def looking_entity(player, distance = 50)
    block = player.get_target_block(nil, distance)
    bx, by, bz = block.location.tap { |l| break [ l.x, l.y, l.z ] }
    nearby = player.get_nearby_entities(distance * 2, distance * 2, distance * 2)
    nearby.each do |entity|
      ex, ey, ez = entity.location.tap { |l| break [ l.x, l.y, l.z ] }
      if (bx - 1.5 <= ex && ex <= bx + 2) && (bz - 1.5 <= ez && ez <= bz + 2) && (by - 1 <= ey && ey <= by + 2.5)
        return entity
      end
    end
    return nil
  end

  module_function :in_water?
  module_function :naked?
  module_function :no_armor?
  module_function :no_hold_item?
  module_function :equip_sword?
  module_function :block_with_sword?
  module_function :looking_entity
end
