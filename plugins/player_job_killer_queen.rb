# encoding: utf-8
import 'org.bukkit.Material'
import 'org.bukkit.event.block.Action'
import 'org.bukkit.event.entity.EntityDamageEvent'
import 'org.bukkit.entity.LivingEntity'

module PlayerJobKillerQueen
  extend self
  extend MaterialUtil
  extend Rukkit::Util
  extend PlayerJob
  extend PlayerUtil

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
    return unless evt.player.item_in_hand.type == Material::SULPHUR
    return unless [Action::RIGHT_CLICK_AIR, Action::RIGHT_CLICK_BLOCK].include?(evt.action)
    if evt.player.sneaking?
      killerqueen_explode_block(evt)
    else
      killerqueen_explode_entity(evt)
    end
  end

  def killerqueen_explode_entity(evt)
    player = evt.player
    entity = looking_entity(player, 50)
    return unless entity.java_kind_of? LivingEntity
    explode_effect(entity, 2)
    entity.damage(8, evt.player)
    stochastically(15) do
      consume_item(player)
    end
  end

  def killerqueen_explode_block(evt)
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
    # player.send_message "KILLERQUEEN...!!"

    # 20 if cat on player head and have uekibachi
    explodable_distance = 20

    _, target = player.get_last_two_target_blocks(nil, 100).to_a
    return if target.type == Material::AIR
    target_distance = target.location.distance(player.location)

    # effect
    if target_distance <= explodable_distance
      explode_effect(target, 1)
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

  def explode_effect(target, around = 3)
    explode(target.location, 0, false)
    location_around(target.location, around).each do |loc|
      explode(loc, 0, false) if rand(9) < 2
    end
  end


end
