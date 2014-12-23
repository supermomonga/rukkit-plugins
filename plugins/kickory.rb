import 'org.bukkit.Material'
import 'org.bukkit.event.block.BlockBreakEvent'

module Kickory
  extend self
  extend Rukkit::Util

  # If you break a log with an axe with at least 1 enchantment,
  # it will also break logs below/above. If will chain as long as you keep your axe.
  def on_block_break(evt)
    return if evt.cancelled
    woodlog = evt.block
    return unless [Material::LOG, Material::LOG_2].include?(woodlog.type)
    player = evt.player
    axe = player.item_in_hand
    return unless [Material::DIAMOND_AXE, Material::GOLD_AXE, Material::IRON_AXE, Material::STONE_AXE, Material::WOOD_AXE].include?(axe.type)
    return if axe.enchantments.empty?

    [*0..1].each do |ydiff|
      [*-1..1].each do |xdiff|
        [*-1..1].each do |zdiff|
          block = add_loc(woodlog.location, xdiff, ydiff, zdiff).block

          later sec(0.5) do
            if player.valid? && [Material::LOG, Material::LOG_2].include?(block.type)
              evt2 = BlockBreakEvent.new(block, player)
              Bukkit.plugin_manager.call_event(evt2)
              block.break_naturally(axe)
            end
          end
        end
      end
    end
  end
end
