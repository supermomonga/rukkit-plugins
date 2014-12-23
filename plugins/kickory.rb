import 'org.bukkit.Material'

module Kickory
  extend self
  extend Rukkit::Util

  # If you break a log with an axe with at least 1 enchantment,
  # it will also break logs below/above. If won't chain.
  def on_block_break(evt)
    return if evt.cancelled
    woodlog = evt.block
    return unless [Material::LOG, Material::LOG_2].include?(woodlog.type)
    player = evt.player
    axe = player.item_in_hand
    return unless [Material::DIAMOND_AXE, Material::GOLD_AXE, Material::IRON_AXE, Material::STONE_AXE, Material::WOOD_AXE].include?(axe.type)
    return if axe.enchantments.empty?

    [-1, 1].each do |ydiff|
      block = add_loc(woodlog.location, 0, ydiff, 0).block

      later sec(0.5) do
        if [Material::LOG, Material::LOG_2].include?(block.type)
          block.break_naturally(axe)
          evt2 = org.bukkit.event.block.BlockBreakEvent.new(block, player)
          Bukkit.plugin_manager.call_event(evt2)
        end
      end
    end
  end
end
