import 'org.bukkit.Sound'
import 'org.bukkit.entity.Player'
import 'org.bukkit.event.entity.EntityDamageEvent'

class HumanBulldozer
  extend self
  extend Rukkit::Util

  def on_block_break(evt)
    block = evt.block
    player = evt.player

    if !player
      log.info("on_block_break #{evt} is missing player")
      return
    end

    if !block
      log.info("on_block_break #{evt} is missing block")
      return
    end

    @num_blocks ||= {}
    @num_blocks[player.name] ||= {}
    @num_blocks[player.name][block.type] ||= 0
    @num_blocks[player.name][block.type] += 1

    if @num_blocks[player.name][block.type] > 100
      text = "#{player.name} broke 100 #{block.type}s!"
      Lingr.post text
      broadcast text

      @num_blocks[player.name][block.type] = 0
    end
  end
end
