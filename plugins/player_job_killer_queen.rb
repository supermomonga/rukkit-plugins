# encoding: utf-8
import 'org.bukkit.Material'
import 'org.bukkit.event.block.Action'

module PlayerJobKillerQueen
  extend self
  extend MaterialUtil
  extend Rukkit::Util
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんがスタンド能力者（キラークイーン）になりました"
  end

  def name
    'スタンド能力者（キラークイーン）'
  end

  def detail
    '[キラークイーン]:爆破能力を得る'
  end

  def on_player_interact(evt)
    return unless has_job?(evt.player)
    killerqueen_explode(evt)
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
      case target.type
      when *killerqueen_explodable_blocks
        if target_distance <= explodable_distance
          # target.type = Material::AIR
          target.break_naturally
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
