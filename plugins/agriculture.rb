# import 'org.bukkit.Bukkit'
import 'org.bukkit.Material'
# import 'org.bukkit.block.BlockFace'
import 'org.bukkit.inventory.ItemStack'

module Agriculture
  extend self
  extend Rukkit::Util

  @num_seeded = {}

  def on_block_place(evt)
    player = evt.player
    block = evt.block

    case block.type
    when Material::CROPS, Material::PUMPKIN_SEEDS, Material::MELON_SEEDS, Material::CARROT, Material::POTATO
      # player.send_message "[DEBUG] seed #{block}"
      @num_seeded[player.name] ||= 0
      @num_seeded[player.name] += 1

      if @num_seeded[player.name] > 100
        20.times do |i|
          later sec(i) do
            loc = player.location
            later sec(1) do
              play_sound(player.location, Sound::FIRE_IGNITE, 0.5, 1.0)
              itemstack = [
                -> { ItemStack.new(Material::ARROW, 1) },
                -> { ItemStack.new(Material::STICK, 1) },
                -> { ItemStack.new(Material::WOOD, 1) },
              ].sample.()
              drop_item(loc, itemstack)
            end
          end
        end
        play_sound(player.location, Sound::LEVEL_UP, 0.5, 1.0)
        text = "[AGRICULTURE] #{player.name} planted 100 crops. She/he gains bonus."
        broadcast text
        Lingr.post text
        @num_seeded[player.name] = 0
      end
    end
  end
end
