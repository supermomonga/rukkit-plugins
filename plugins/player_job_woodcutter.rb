# encoding: utf-8
import 'org.bukkit.Material'
import 'org.bukkit.event.block.Action'
import 'org.bukkit.event.block.BlockBreakEvent'

module PlayerJobWoodcutter
  extend self
  extend Rukkit::Util
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが木こりになりました(斧で木を切るのが早くなります)"
  end

  def name
    '木こり'
  end

  def detail
    '[木こり]:斧で木を切るのが早くなります'
  end

  def on_player_interact(evt)
    material = evt.material
    action = evt.action
    block = evt.clicked_block

    return unless has_job?(evt.player)

    case action
    when Action::LEFT_CLICK_BLOCK
      if block.type == Material::LOG &&
         MaterialUtil.axe?(material)
        @block_damage ||= {}
        cur_pos = [block.x, block.y, block.z]
        @block_damage[cur_pos] ||= 0
        @block_damage[cur_pos] += 1
        later sec(1.0) do
          @block_damage[cur_pos] -= 1 if @block_damage.include?(cur_pos)
        end

        if @block_damage[cur_pos] >= 2
          block.break_naturally
          @block_damage.delete(cur_pos)
        end
      end
    end
  end

  # If you break a log with an axe with at least 1 enchantment,
  # it will also break logs below/above. If will chain as long as you keep your axe.
  def on_block_break(evt)
    return unless has_job?(evt.player)

    return if evt.cancelled
    woodlog = evt.block
    return unless [Material::LOG, Material::LOG_2].include?(woodlog.type)
    player = evt.player
    axe = player.item_in_hand
    return unless [Material::DIAMOND_AXE, Material::GOLD_AXE, Material::IRON_AXE, Material::STONE_AXE, Material::WOOD_AXE].include?(axe.type)

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
