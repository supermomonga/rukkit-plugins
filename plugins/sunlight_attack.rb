# encoding: utf-8
import 'org.bukkit.Sound'
import 'org.bukkit.block.Biome'

module SunlightAttack
  extend self
  extend Rukkit::Util

  @strong_sunlight_spot ||= false
  @player_info ||= {}
  @damage_interval = 3

  def on_player_move(evt)
    player = evt.player
    unless [Biome::DESERT, Biome::MESA].include?(player.location.block.biome)
      @strong_sunlight_spot = false
      @player_info = {}
      return
    end

    @strong_sunlight_spot = true
    now = Time.now
    if !@player_info[player.name]
      @player_info[player.name] = {"alert"=>now+6, "alert_done"=>false, "damage"=>now+15}
    end

    # for development
    #player.saturation = 10
    #if player.health == 1
    #  player.health = 20
    #end

    if now.between?(@player_info[player.name]["alert"], @player_info[player.name]["damage"])
      if !@player_info[player.name]["alert_done"]
        player.send_message "炎天下でクラクラしてきました。(この場から逃げるか頭に何かかぶりましょう)"
        @player_info[player.name]["alert_done"] = true
      end
    elsif now > @player_info[player.name]["damage"] && player.health != 1
      @player_info[player.name]["damage"] += @damage_interval
      player.health -= 1
    end
  end
end
