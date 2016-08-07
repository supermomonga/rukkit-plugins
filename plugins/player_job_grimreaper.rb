# encoding: utf-8
import 'org.bukkit.Sound'
import 'org.bukkit.entity.Player'
import 'org.bukkit.Material'
import 'org.bukkit.event.block.Action'

module PlayerJobGrimreaper
  extend self
  extend MaterialUtil
  extend Rukkit::Util
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが死神になりました(範囲即耕攻撃が可能)"
  end

  def name
    '死神'
  end

  def detail
    '[死神]:範囲即耕攻撃が可能'
  end

  def on_player_interact(evt)
    player = evt.player
    action = evt.action
    target = evt.clicked_block
    item_in_hand = player.item_in_hand

    return unless has_job?(player)
    return unless target && [ Material::DIRT, Material::SOIL, Material::GRASS ]
    return unless action === Action::RIGHT_CLICK_BLOCK
    return unless item_in_hand && hoe?(item_in_hand.type)

    flat_around_locations(target.location, 3).each do |loc|
      if [ Material::DIRT, Material::GRASS, Material::SOIL ].include? loc.block.type
        upper = add_loc(loc, 0, 1, 0).block
        if [ Material::LONG_GRASS, Material::AIR ].include? upper.type
          upper.type = Material::AIR
          loc.block.type = Material::SOIL
          play_effect(upper.location, Effect::ENDER_SIGNAL, nil) if rand(4) == 0
        end
      end
    end
    play_sound(player.location, Sound::ENTITY_BAT_TAKEOFF, 0.5, 0.0)
    # Inochi wo karitoru katachi wo shiteru darou?
    broadcast "──命を刈り取る"
    broadcast "        形をしてるだろ？──"
  end

  def flat_around_locations(loc, size)
    location_list = ([*-size..size] * 2).combination(2).to_a.uniq - [0, 0]
    location_list.map {|x, z|
      loc.clone.add(x, 0, z)
    }
  end

end
