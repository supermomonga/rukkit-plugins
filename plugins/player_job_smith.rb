# encoding: utf-8
require 'set'

module PlayerJobSmith
  extend self
  extend Rukkit::Util

  def on_player_join(evt)
    player = evt.player
    random = Random.new

    # become job with 50% of probability
    @be_smith ||= Set.new
    @be_smith.add(player) if random.rand(100) < 50
    broadcast "#{player.name}さんが鍛冶屋になりました(空気中で剣、斧などを振ると耐久力回復)" if @be_smith.include?(player)
  end

  def on_player_quit(evt)
    player = evt.player
    @be_smith.delete(player)
  end

  def on_player_interact(evt)
    item = evt.item
    material = evt.material
    action = evt.action

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
