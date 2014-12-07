# encoding: utf-8

import 'org.bukkit.Sound'
import 'org.bukkit.entity.Player'
import 'org.bukkit.event.entity.EntityDamageEvent'

module HumanBulldozer
  extend self
  extend Rukkit::Util

  def on_block_break(evt)
    block = evt.block
    player = evt.player

    @num_blocks ||= {}
    @num_blocks[player.name] ||= {}
    @num_blocks[player.name][block.type] ||= 0
    @num_blocks[player.name][block.type] += 1

    if @num_blocks[player.name][block.type] > 200
      @num_blocks[player.name][block.type] = 0

      text = "#{player.name} broke 200 #{block.type}s!"
      Lingr.post text
      broadcast text

      play_sound(player.location, Sound::DONKEY_DEATH , 1.0, 0.0)
      play_sound(player.location, Sound::LEVEL_UP , 0.8, 1.5)

      player.send_message '(HPが全回復し、expちょっともらえます)'
      player.health = player.max_health
      10.times do |i|
        later sec(i) do
          orb = spawn(player.location, EntityType::EXPERIENCE_ORB)
          orb.experience = 1
        end
      end
    end
  end
end
