# encoding: utf-8
=begin

A player in desert or mesa biome gets hurt by sunlight.
Sunlight doesn't hurt a player who is in the water/shade or equips helmet.
However, when a player equips an iron helmet, the player gets hurt more terribly.

TODO
* じっとしてる時に heatstroke のダメージ食らう <- すぐできなさそう
=end

import 'org.bukkit.Sound'
import 'org.bukkit.Material'
import 'org.bukkit.block.Biome'
import 'org.bukkit.inventory.ItemStack'

module Heatstroke
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

  @iron_helmet_equipped = false
  @player_equipped_iron_helmet ||= {}

  def on_player_move(evt) # {{{
    player = evt.player
    helmet = player.inventory.helmet

    head_guard = helmet && helmet.data.item_type != Material::IRON_HELMET

    if !@strong_sunlight_spot.include?(player.location.block.biome)                      ||
       player.location.block.light_from_sky < @strong_sunlight                           ||
       player.location.world.has_storm                                                   ||
       player.location.y < player.location.world.get_highest_block_at(player.location).y ||
       !@daytime.include?(player.world.get_time)                                         ||
       head_guard

      @player_info.delete(player.name)
      if @need_to_escape
        player.send_message "[HEATSTROKE] ご自愛ください"
        @need_to_escape = false
      end
      return
    end

    @need_to_escape = true
    @iron_helmet_equipped = !head_guard && helmet ? true : false

    now = Time.now
    if !@player_info[player.name]
      @player_info[player.name] = {
        "alert" => @iron_helmet_equipped ? now+@iron_alert_time : now+@alert_time,
        "alert_done" => false,
        "damage" => @iron_helmet_equipped ? now+@iron_damage_time : now+@damage_time,
        "iron_eqquiped" => @iron_helmet_equipped
      }

      text = "[HEATSTROKE] ここはあついなー！！！！ 熱射病に気をつけましょう"
      text += "(鉄被ってると激ヤバです)" if @iron_helmet_equipped
      player.send_message text
    end

    @player_info[player.name]["iron_eqquiped"] = @iron_helmet_equipped

    if now > @player_info[player.name]["alert"] && !@player_info[player.name]["alert_done"]
      player.send_message "[HEATSTROKE] 炎天下でクラクラしてきました(涼しいところに逃げたり鉄でない何かをかぶる等しましょう)"
      @player_info[player.name]["alert_done"] = true
    elsif now > @player_info[player.name]["damage"] && player.health != 1

      @player_info[player.name]["damage"] = @player_info[player.name]["iron_eqquiped"] ? now+@iron_damage_interval : now+@damage_interval

      player.set_health player.health-1
      play_sound(player.location, Sound::HURT_FLESH, 1.0, 1.0)
    end
  end # }}}

  def on_inventory_click(evt) # {{{
    player = evt.who_clicked

    if !@strong_sunlight_spot.include?(player.location.block.biome)                      ||
       player.location.block.light_from_sky < @strong_sunlight                           ||
       player.location.world.has_storm                                                   ||
       player.location.y < player.location.world.get_highest_block_at(player.location).y ||
       !@daytime.include?(player.world.get_time)
      @player_equipped_iron_helmet.delete(player.name)
      return
    end

    later 0 do
      hold_iron_helmet = evt.get_current_item.data.item_type == Material::IRON_HELMET

      # うーん@player_equipped_iron_helmetにiron helmetの有無を持たせるは適切なのかな
      # よくわからん
      @iron_helmet_equipped = player.inventory.armor_contents.to_a[-1].data.item_type == Material::IRON_HELMET
      if !@player_equipped_iron_helmet[player.name]
        @player_equipped_iron_helmet[player.name] = {
          "iron_eqquiped" => @iron_helmet_equipped
        }
      end
      @player_equipped_iron_helmet[player.name]["iron_eqquiped"] = @iron_helmet_equipped

      player.send_message "[HEATSTROKE] 鉄はヤバいって！！" if @player_equipped_iron_helmet[player.name]["iron_eqquiped"] && hold_iron_helmet
    end
  end # }}}
end
