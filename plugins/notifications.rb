# encoding: utf-8

import 'org.bukkit.entity.Player'
import 'org.bukkit.Material'

module Notifications
  extend self
  extend Rukkit::Util

  def on_entity_death(evt)
    entity = evt.entity
    player = entity.killer

    case player
    when Player
      equip_msg = player.item_in_hand.type == Material::AIR ?
        '' :
        " with #{player.item_in_hand.type}"
      text = "[KILL] #{player.name} killed a #{entity.type ? entity.type.name.downcase : entity.inspect}#{equip_msg}."
      Lingr.post text
      broadcast text
    end
  end

  def on_player_death(evt)
    player = evt.entity
    Lingr.post "#{player.name} died: #{evt.death_message.sub(/^#{player.name}/, '')} at (#{player.location.x.to_i}, #{player.location.z.to_i}) in #{player.location.world.name}."
  end

  def on_player_bed_enter(evt)
    player = evt.player
    text = "[BED] #{player.name}さんがベッドに横たわっておられる"

    later sec(0.5) do
      awake_players = Bukkit.online_players.to_a.reject(&:sleeping?)
      unless awake_players.empty?
        players = awake_players.map(&:name).join "#{%w[くん さん ちゃん 君 様 君 子 肉].sample} "
        if awake_players.size > 1
          players += "達"
        elsif awake_players.size == 1
          Bukkit.online_players.to_a.size.times do
           awake_players[0].send_message "[BED] #{awake_players[0].name}: いいから寝#{%w[ましょう ろ んかい].sample}"
          end
        end
        text += " (#{players}は今すぐ寝#{%w[ましょう ろ んかい ようね♡].sample})"
      end
      Lingr.post text
      broadcast text
    end

  end

  def on_player_bed_leave(evt)
    player = evt.player
    if player.world.time > 0
      text = "[BED] #{player.name}さんがベッドから身体を起こした模様"
      Lingr.post text
      broadcast text
    else
      @good_morning ||= true
      later sec(1) do
        if @good_morning
          text = "[BED] あさだーーーーーーー! #{%w[ょ ゅ 肉 !].sample}"
          Lingr.post text
          broadcast text
          @good_morning = false
        end
      end
    end
  end
end
