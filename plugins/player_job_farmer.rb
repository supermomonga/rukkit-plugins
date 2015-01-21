# encoding: utf-8
import 'org.bukkit.event.block.Action'
import 'org.bukkit.material.Crops'
import 'org.bukkit.CropState'

module PlayerJobFarmer
  extend self
  extend Rukkit::Util
  extend PlayerJob

  @crop_state = [
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
    "#{evt.player.name}さんが農家になりました(空気中で鍬を振ると周りの作物が成長。範囲耕し、範囲種植が可能)"
  end

  def detail
    '[農家]:空気中で鍬を振ると周りの作物が成長。範囲耕しが可能'
  end

  def on_player_interact(evt)
    material = evt.material
    action = evt.action
    player = evt.player

    return unless has_job?(player)

    if MaterialUtil.hoe?(material)
      case action
      when Action::LEFT_CLICK_AIR
        return unless rand(3) == 0
        boost_growth(evt)
      when Action::RIGHT_CLICK_BLOCK
        boost_cultivation(evt)
      end
    elsif [Material::SEEDS, Material::CARROT_ITEM].include?(material)
      case action
      when Action::RIGHT_CLICK_BLOCK
        boost_seeding(evt, material)
      end
    end
  end

  def boost_growth(evt)
    player = evt.player
    around_square_loc(player.location).each do |(x, y, z)|
      block = player.world.get_block_at(x, y, z)
      state = block.state
      case state.data
      when Crops
        if state.data.state != CropState::RIPE
          next_state = @crop_state[@crop_state.index(state.data.state) + 1]
          state.data.state = next_state
          state.update
        end
      end
    end
  end

  def boost_cultivation(evt)
    block = evt.clicked_block
    world = evt.player.world
    return unless [Material::DIRT, Material::GRASS].include?(block.type)
    around_square_loc(block.location).each do |(x, y, z)|
      block = world.get_block_at(x, y, z)
      block.type = Material::SOIL if [Material::DIRT, Material::GRASS].include?(block.type)
    end
  end

  def boost_seeding(evt, seeding_type)
    player = evt.player
    world = player.world
    clicked_block = evt.clicked_block

    return unless player.item_in_hand.type == seeding_type
    upper_block = clicked_block.get_relative(BlockFace::UP)
    return unless clicked_block.type == Material::SOIL && upper_block.type == Material::AIR
    evt.cancelled = true
    uzumaki_loc(clicked_block.location, 25).each do |(location)|
      block = world.get_block_at(location)
      upper_block = block.get_relative(BlockFace::UP)
      if block.type == Material::SOIL && upper_block.type == Material::AIR
        upper_block.type = Material::CROPS

        # TODO: deris will use consume_item() instead.
        if player.item_in_hand.amount == 1
          player.item_in_hand = ItemStack.new(Material::AIR)
          return
        end
        player.item_in_hand.amount -= 1
      end
    end
  end

  def around_square_loc(location)
    around_square(location.block_x, location.block_y, location.block_z)
  end

  def around_square(x, y, z)
    xa = [*x-2 .. x+2]
    za = [*z-2 .. z+2]
    xa.product(za).map { |arr| arr.insert(1, y) }
  end

  def uzumaki_loc(location, num)
    [*0..num].map do |n|
      x, z = uzumaki_base(n)
      location.clone.add(x, 0, z)
    end
  end

  def uzumaki_base(n)
    base = Math.sqrt(n).floor.to_i
    delta = n - base**2
    if base%2 == 0
      basex = -base / 2
      basey = base / 2
      xdir = 1
      ydir = -1
    else
      basex = base / 2 + 1
      basey = -base / 2 + 1
      xdir = -1
      ydir = 1
    end
    x = basex.to_i + xdir * (delta > base ? delta - base : 0)
    y = basey.to_i + ydir * (delta < base ? delta : base)
    [x, y]
  end
end
