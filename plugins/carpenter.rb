import 'org.bukkit.event.block.Action'

module Carpenter
  extend self
  extend Rukkit::Util

  def on_player_interact(evt)
    material = evt.material
    return unless material.block?
    player = evt.player
    return unless player.location.pitch == 90.0
    action = evt.action

    case action
    when Action::RIGHT_CLICK_BLOCK, Action::RIGHT_CLICK_AIR
      # evt.block is nil
      block = player.get_last_two_target_blocks(nil, 100).to_a.last
      return unless block.type == player.item_in_hand.type # just for now
      return unless [1, 2, 3].all? {|ydiff| !add_loc(player.location, 0, ydiff, 0).block.type.occluding? }

      evt.cancelled = true
      consume_item(player)
      player.teleport(add_loc(player.location, 0, 1, 0))
      new_block = add_loc(block.location, 0, 1, 0).block
      new_block.type = block.type
      new_block.data = block.data
    else
      # nop
    end
  end
end
