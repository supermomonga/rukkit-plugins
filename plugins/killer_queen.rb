# encoding: utf-8

import 'org.bukkit.entity.Player'
import 'org.bukkit.Material'
import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.event.block.Action'

module KillerQueen
  extend self
  extend Rukkit::Util

  def on_player_interact(evt)
    if evt.player.name == 'supermomonga' # only for now
      killerqueen_explode(evt)
    end
  end

  def stochastically(percentage)
    yield if rand(100) < percentage
  end

  def location_around(loc, size)
    location_list = ([*-size..size] * 3).combination(3).to_a.uniq - [0, 0, 0]
    location_list.map {|x, y, z|
      loc.clone.add(x, y, z)
    }
  end

  def consume_item(player)
    if player.item_in_hand.amount == 1
      player.item_in_hand = ItemStack.new(Material::AIR)
    else
      player.item_in_hand.amount -= 1
    end
  end

  def killerqueen_explode(evt)
    player = evt.player
    killerqueen_explodable_blocks = [
      Material::SAND,
      Material::WOOL,
      Material::WOOD,
      Material::FENCE,
      Material::DIRT,
      Material::GRASS,
      Material::WHEAT,
      Material::LEAVES,
      Material::COBBLESTONE,
      Material::STONE,
      Material::COAL_ORE,
      Material::WEB
    ]
    if player.item_in_hand.type == Material::SULPHUR && [Action::LEFT_CLICK_AIR, Action::LEFT_CLICK_BLOCK].include?(evt.action)
      # player.send_message "KILLERQUEEN...!!"

      # 20 if cat on player head and have uekibachi
      explodable_distance = 20

      _, target = player.get_last_two_target_blocks(nil, 100).to_a
      return if target.type == Material::AIR
      target_distance = target.location.distance(player.location)

      # effect
      if target_distance <= explodable_distance
        explode(target.location, 0, false)
        location_around(target.location, 1).each do |loc|
          explode(loc, 0, false) if rand(9) < 2
        end
      end
      # explode
      p target.type.name
      case target.type
      when *killerqueen_explodable_blocks
        if target_distance <= explodable_distance
          # target.type = Material::AIR
          stochastically(15) do
            consume_item(player)
          end
        end
      when Material::TNT
        # explode TNT (can be long distance)
        # target.type = Material::AIR
        explode(target.location, 3, false)
        stochastically(15) do
          consume_item(player)
        end
      end
    end
  end

end
