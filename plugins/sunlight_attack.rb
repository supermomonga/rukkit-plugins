# encoding: utf-8
=begin
砂漠とその類、あと赤土における、日陰・水中を除く
場所にいると player は日射病になりダメージを食らう.
日射病による kill は起こさない.

TODO
* じっとしてる時も日射病の条件下にいる時間を判定 <- すぐできなさそう
* 頭の防具してるかどうかの判定 <- すぐできそう
* 頭の防具でも iron は熱効率が良すぎるのでダメージを受ける間隔が加速するようにしたい <- すぐできそう
=end

import 'org.bukkit.Sound'
import 'org.bukkit.block.Biome'

module SunlightAttack
  extend self
  extend Rukkit::Util

  @strong_sunlight = 15
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

  def on_player_move(evt)
    player = evt.player

    if !@strong_sunlight_spot.include?(player.location.block.biome)                      || \
       player.location.block.light_from_sky < @strong_sunlight                           || \
       player.location.world.has_storm                                                   || \
       player.location.y < player.location.world.get_highest_block_at(player.location).y || \
       !@daytime.include?(player.world.get_time)

      @player_info = {}
      return
    end

    # for development
    player.saturation = 10
    if player.health == 1
      player.health = 20
    end

    now = Time.now
    if !@player_info[player.name]
      @player_info[player.name] = {"alert"=>now+@alert_time, "alert_done"=>false, "damage"=>now+@damage_time}
    end

    #text = "あついなー！！！"
    #Lingr.post(text)
    #broadcast(text)

    if now > @player_info[player.name]["alert"] && !@player_info[player.name]["alert_done"]
      player.send_message "炎天下でクラクラしてきました。(涼しいところに逃げるとか頭に何かをかぶるなどしましょう)"
      @player_info[player.name]["alert_done"] = true
    elsif now > @player_info[player.name]["damage"] && player.health != 1
      @player_info[player.name]["damage"] = now+@damage_interval
      player.health -= 1
    end
  end
end
