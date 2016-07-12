# encoding: utf-8
require 'set'
import 'org.bukkit.Material'
import 'org.bukkit.event.block.Action'
import 'org.bukkit.event.block.BlockBreakEvent'

module PlayerJobDigger
  extend self
  extend MaterialUtil
  extend Rukkit::Util
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが採掘師になりました(範囲採掘が可能)"
  end

  def name
    '採掘師'
  end

  def detail
    '[採掘師]:範囲採掘が可能'
  end

  TARGET_BLOCKS = [
    Material::STONE,
    Material::GRAVEL,
    [ Material::DIRT, Material::GRASS, Material::GRASS_PATH ],
    Material::SAND
  ]

  def range_breakable?(block)
    TARGET_BLOCKS.find { |target|
      if target.class == Array
        target.include? block.type
      else
        target == block.type
      end
    }
  end

  def breakable_together?(a, b)
    TARGET_BLOCKS.find { |target|
      if target.class == Array
        target.include?(a.type) && target.include?(b.type)
      else
        target == a.type && a.type == b.type
      end
    }
  end

  # It also breaks around blocks
  def on_block_break(evt)
    target_block = evt.block
    player = evt.player
    tool = player.item_in_hand
    return if player.sneaking?
    return unless pickaxe?(tool.type) || spade?(tool.type)
    return unless has_job?(player)
    return unless range_breakable?(target_block)

    around_blocks = cubic_around_blocks(target_block)
    blocks = around_blocks.reject { |block|
      block.y < player.location.y
    }.select { |block|
      breakable_together?(target_block, block)
    }

    blocks.each do |block|
      later(0) do
        block.break_naturally(tool)
      end
    end

  end

  def cubic_around_blocks(target, n = 1)
    [*(-n..n)].repeated_permutation(3).map { |xdiff, ydiff, zdiff|
      add_loc(target.location, xdiff, ydiff, zdiff).block
    }
  end

end
