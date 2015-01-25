# encoding: utf-8
import 'org.bukkit.Material'
import 'org.bukkit.event.block.Action'

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
end
