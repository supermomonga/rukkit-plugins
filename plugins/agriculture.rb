# import 'org.bukkit.Bukkit'
import 'org.bukkit.Material'
# import 'org.bukkit.block.BlockFace'
# import 'org.bukkit.entity.ItemFrame'

module Agriculture
  extend self
  extend Rukkit::Util

  @num_seeded = {}

  def on_block_place(evt)
    player = evt.player
    block = evt.block

    case block.type
    when Material::CROPS, Material::PUMPKIN_SEEDS, Material::MELON_SEEDS, Material::CARROT, Material::POTATO
      player.send_message "[DEBUG] seed #{block}"
      @num_seeded[player.name] ||= 0
      @num_seeded[player.name] += 1
    end
  end
end
