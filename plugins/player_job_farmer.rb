# encoding: utf-8
import 'org.bukkit.event.block.Action'
import 'org.bukkit.material.Crops'
import 'org.bukkit.CropState'

module PlayerJobFarmer
  extend self
  extend Rukkit::Util
  extend PlayerJob

  CROP_STATE = [
    CropState::SEEDED,
    CropState::GERMINATED,
    CropState::VERY_SMALL,
    CropState::SMALL,
    CropState::MEDIUM,
    CropState::TALL,
    CropState::VERY_TALL,
    CropState::RIPE,
  ]

  login_message do |evt|
    "#{evt.player.name}さんが農家になりました(空気中で鍬を振ると周りの作物が成長)"
  end

  def on_player_interact(evt)
    material = evt.material
    action = evt.action
    player = evt.player
    world = player.world

    return unless has_job?(player)
    return unless MaterialUtil.hoe?(material)
    return unless rand(3) == 0

    case action
    when Action::LEFT_CLICK_AIR
      around_square_loc(player.location).each do |(x, y, z)|
        block = world.get_block_at(x, y, z)
        state = block.state
        case state.data
        when Crops
          if state.data.state != CropState::RIPE
            next_state = CROP_STATE[CROP_STATE.index(state.data.state) + 1]
            state.data.state = next_state
            state.update
          end
        end
      end
    end
  end

  def around_square_loc(location)
    around_square(location.block_x, location.block_y, location.block_z)
  end

  def around_square(x, y, z)
    xa = (x-2 .. x+2).to_a
    za = (z-2 .. z+2).to_a
    xa.product(za).map { |arr| arr.insert(1, y) }
  end
end
