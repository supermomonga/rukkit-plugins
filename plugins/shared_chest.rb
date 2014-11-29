import 'org.bukkit.Bukkit'
import 'org.bukkit.event.block.Action'
import 'org.bukkit.Material'
import 'org.bukkit.block.BlockFace'
import 'org.bukkit.entity.ItemFrame'

module SharedChest
  extend self
  extend Rukkit::Util

  def create_shared_chest(block)
    block.type = Material::CHEST
    block.data = 0
    [
      BlockFace::UP,
      BlockFace::NORTH,
      BlockFace::SOUTH,
      BlockFace::EAST,
      BlockFace::WEST,
    ].each do |face|
      b = block.get_relative(face)
      b.type = Material::BEDROCK
      b.data = 0
    end
  end

  def shared_chest_inventory
    chest = Bukkit.get_world('world').get_block_at(0, 0, 0)
    if chest.type != Material::CHEST
      create_shared_chest(chest)
    end
    chest.state.block_inventory
  end

  def shared_chest?(entity)
    case entity
    when ItemFrame
      entity.item.type == Material::CHEST
    else
      false
    end
  end

  def on_player_interact_entity(evt)
    return unless shared_chest?(evt.right_clicked)
    evt.cancelled = true
    evt.player.open_inventory(shared_chest_inventory)
  end

end
