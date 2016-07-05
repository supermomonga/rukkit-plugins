# encoding: utf-8
require 'set'
import 'org.bukkit.event.block.Action'
import 'org.bukkit.material.Crops'
import 'org.bukkit.CropState'
import 'org.bukkit.Sound'
import 'org.bukkit.entity.Player'
import 'org.bukkit.event.entity.EntityDamageEvent'
import 'org.bukkit.potion.PotionEffectType'
import 'org.bukkit.Effect'

module PlayerJobDigger
  extend self
  extend Rukkit::Util
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが採掘師になりました(範囲採掘が可能)"
  end

  def name
    '採掘師'
  end

  def detail
    '[採掘師]:範囲採掘が可能'
  end

  @num_blocks ||= {}
  @bonus_time ||= {}

  @num_lava_removed ||= {}

  BONUS_TABLE = {
    Material::STONE => 500,
    Material::NETHERRACK => 500,
    Material::DIRT => 500,
    Material::GRASS => 450,
    Material::SAND => 300,
  }

  def on_block_break(evt)
    block = evt.block
    player = evt.player
    return unless has_job?(player)

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

      player.add_potion_effect(PotionEffectType::FAST_DIGGING.create_effect(sec(42), 5)) # it's actually 63

      @bonus_time[player.name] = true
      later sec(60) do
        @bonus_time[player.name] = false

        play_sound(player.location, Sound::AMBIENT_CAVE  , 1.0, 0.3)
        text = "[HUMAN BULLDOZER] #{player.name}'s bonus time ended."
        Lingr.post(text)
        broadcast(text)
      end

      Bukkit.online_players.to_a.each do |p|
        play_sound(p.location, Sound::ENTITY_DONKEY_DEATH , 1.0, 0.0)
      end
      play_sound(player.location, Sound::ENTITY_PLAYER_LEVELUP , 0.8, 1.5)

      if player.health < player.max_health
        player.send_message '(HPが全回復します)'
        player.health = player.max_health
      end
    end
  end

  def on_block_place(evt)
    player = evt.player
    block = evt.block
    state = evt.getBlockReplacedState()
    return unless has_job?(player)

    if state.type == Material::STATIONARY_LAVA && state.raw_data.to_i == 0
      @num_lava_removed[player.name] ||= 0
      @num_lava_removed[player.name] += 1

      player.send_message("You have removed #{@num_lava_removed[player.name]} statinary lava.")

      if @num_lava_removed[player.name] >= 20
        text = 'Congratulations! You filled 20 lava'
        # Lingr.post(text)
        broadcast(text)
        @num_lava_removed[player.name] = 0
      end
    end
  end

  @glass_punched ||= Set.new
  def on_block_damage(evt)
    player = evt.player
    block = evt.block
    return if @glass_punched.include?(player.name)
    return unless [Material::GLASS, Material::THIN_GLASS].include?(block.type)
    play_effect(block.location, Effect::ZOMBIE_CHEW_IRON_DOOR, 0)

    orb = spawn(block.location, EntityType::EXPERIENCE_ORB)
    orb.experience = 0

    @glass_punched.add(player.name)
    later sec(1) do
      @glass_punched.delete(player.name)
    end
  end
end
