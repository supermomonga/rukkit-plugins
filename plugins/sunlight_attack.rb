# encoding: utf-8
=begin
砂漠とその類、あと台地における、日陰・水中を除く
炎天下の場所にいると player は日射病になりダメージを食らう.
日射病による kill は起こさない.

iron helmet を装備している場合は、ダメージを受ける間隔が短くなる

TODO
* じっとしてる時も日射病の条件下にいる時間を判定 <- すぐできなさそう
* あえてiron helmet を装備した時のアラートを出す <- できるとは思う
=end

import 'org.bukkit.Sound'
import 'org.bukkit.Material'
import 'org.bukkit.block.Biome'
import 'org.bukkit.inventory.ItemStack'

module SunlightAttack
  extend self
  extend Rukkit::Util

  @strong_sunlight = 14
  @strong_sunlight_spot = [
    Biome::DESERT,
    Biome::DESERT_HILLS,
    Biome::DESERT_MOUNTAINS,
    Biome::MESA
  ]
  @player_info ||= {}
  @alert_time = 6
  @damage_time = 15
  @damage_interval = 3
  @daytime = 4000..11000
  @need_to_escape ||= false

  @iron_heat_ratio = 0.7
  @iron_alert_time = @alert_time * @iron_heat_ratio
  @iron_damage_time = @damage_time * @iron_heat_ratio
  @iron_damage_interval = @damage_interval * @iron_heat_ratio

  def on_player_move(evt)
    player = evt.player

    # ここどうにかしたい
    if player.inventory.helmet
      iron_helmet = player.inventory.helmet.data.item_type == Material::IRON_HELMET
      head_guard = !iron_helmet ? true : false
    else
      iron_helmet = false
      head_guard = false
    end

    if !@strong_sunlight_spot.include?(player.location.block.biome)                      ||
       player.location.block.light_from_sky < @strong_sunlight                           ||
       player.location.world.has_storm                                                   ||
       player.location.y < player.location.world.get_highest_block_at(player.location).y ||
       !@daytime.include?(player.world.get_time)                                         ||
       head_guard

      @player_info = {}
      if @need_to_escape
        broadcast "あぶないあぶない"
        @need_to_escape = false
      end
      return
    end

    @need_to_escape = true

    now = Time.now
    if !@player_info[player.name]

      # これどうにかならんかな
      @player_info[player.name] = {
        "alert" => iron_helmet ? now+@iron_alert_time : now+@alert_time,
        "alert_done" => false,
        "damage" => iron_helmet ? now+@iron_damage_time : now+@damage_time,
        "iron_helmet" => iron_helmet
      }

      text = "ここはあついなー！！！！日射病に気をつけましょう"
      text += "(鉄被ってると激ヤバです)" if iron_helmet
      broadcast text
    end

    if now > @player_info[player.name]["alert"] && !@player_info[player.name]["alert_done"]
      broadcast "炎天下でクラクラしてきました(涼しいところに逃げたり鉄でない何かをかぶる等しましょう)"
      @player_info[player.name]["alert_done"] = true
    elsif now > @player_info[player.name]["damage"] && player.health != 1

      # これどうにかならんかな
      @player_info[player.name]["damage"] = iron_helmet ? now+@iron_damage_interval : now+@damage_interval

      player.set_health player.health-1
      play_sound(player.location, Sound::HURT_FLESH, 1.0, 1.0)
    end
  end
end
