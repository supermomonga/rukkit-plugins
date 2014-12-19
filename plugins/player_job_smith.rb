# encoding: utf-8
import 'org.bukkit.event.block.Action'

module PlayerJobSmith
  extend self
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが鍛冶屋になりました(空気中で剣、斧などを振ると耐久力回復)"
  end

  def on_player_interact(evt)
    item = evt.item
    material = evt.material
    action = evt.action

    return unless has_job?(evt.player)

    case action
    when Action::LEFT_CLICK_AIR
      if MaterialUtil.pickaxe?(material) ||
         MaterialUtil.sword?(material) ||
         MaterialUtil.axe?(material) ||
         MaterialUtil.spade?(material) ||
         MaterialUtil.hoe?(material)
        item.durability = item.durability - 1 if item.durability > 0
      end
    end
  end
end
