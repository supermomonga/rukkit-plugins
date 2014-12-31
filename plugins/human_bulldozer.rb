# encoding: utf-8

import 'org.bukkit.Sound'
import 'org.bukkit.entity.Player'
import 'org.bukkit.event.entity.EntityDamageEvent'
import 'org.bukkit.potion.PotionEffectType'

module HumanBulldozer
  extend self
  extend Rukkit::Util

  @num_blocks ||= {}
  @bonus_time ||= {}

  @num_lava_removed ||= {}

  remove_const :BONUS_TABLE if const_defined? :BONUS_TABLE
  BONUS_TABLE = {
    Material::STONE => 500,
    Material::DIRT => 500,
    Material::GRASS => 450,
    Material::SAND => 300,
  }

  def on_block_break(evt)
    block = evt.block
    player = evt.player

    threshould = BONUS_TABLE[block.type] || 150

    if @bonus_time[player.name]
      istack = player.item_in_hand
      istack.durability -= 1 if istack.durability > 0
      return
    end

    @num_blocks[player.name] ||= {}
    @num_blocks[player.name][block.type] ||= 0
    @num_blocks[player.name][block.type] += 1

    if @num_blocks[player.name][block.type] > threshould
      @num_blocks[player.name][block.type] = 0

      text = "[HUMAN BULLDOZER] #{player.name} broke #{threshould} #{block.type}s. #{player.name} can dig faster for 1 minute, without consuming pickaxe/spade!"
      Lingr.post text
      broadcast text

      player.add_potion_effect(PotionEffectType::FAST_DIGGING.create_effect(sec(60), 5))

      @bonus_time[player.name] = true
      later sec(60) do
        @bonus_time[player.name] = false

        play_sound(player.location, Sound::AMBIENCE_CAVE  , 1.0, 0.3)
        text = "[HUMAN BULLDOZER] #{player.name}'s bonus time ended."
        Lingr.post(text)
        broadcast(text)
      end


      play_sound(player.location, Sound::DONKEY_DEATH , 1.0, 0.0)
      play_sound(player.location, Sound::LEVEL_UP , 0.8, 1.5)

      if player.health < player.max_health
        player.send_message '(HPが全回復します)'
        player.health = player.max_health
      end
    end
  end

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    args = args.to_a
    return unless args.shift == 'human-bulldozer'

    threshould = BONUS_TABLE[block.type] || 150
    soons = @num_blocks[sender.name].select {|k, v| threshould * 0.5 < v && v <= threshould * 0.8 }
    verysoons = @num_blocks[sender.name].select {|k, v| threshould * 0.8 < v }

    text =
      if soons.empty? && verysoons.empty?
        "[HUMAN BULLDOZER] #{sender.name} Nothing to report"
      else
        "[HUMAN BULLDOZER] #{sender.name} soon: #{soons.keys.join ', '}, very soon: #{verysoons.keys.join ', '}"
      end
    Lingr.post(text)
    broadcast(text)
  end

  def on_block_place(evt)
    player = evt.player
    block = evt.block
    state = evt.getBlockReplacedState()

    if state.type == Material::STATIONARY_LAVA
      @num_lava_removed[player.name] ||= 0
      @num_lava_removed[player.name] += 1

      # just for now
      player.send_message("You have removed #{@num_lava_removed[player.name]} statinary lava. #{state} #{state.data}")
    end
  end
end
