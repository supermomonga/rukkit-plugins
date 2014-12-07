# encoding: utf-8

import 'org.bukkit.entity.Player'
import 'org.bukkit.entity.Chicken'
import 'org.bukkit.entity.Zombie'
import 'org.bukkit.Material'

module Notifications
  extend self
  extend Rukkit::Util

  def on_entity_death(evt)
    entity = evt.entity
    player = entity.killer

    case player
    when Player
      case entity
      when Chicken
        text = "[KILL] ・°°・(((p(≧□≦)q)))・°°・。ｳﾜｰﾝ!! #{player.name} killed a #{entity.type ? entity.type.name.downcase : entity.inspect}."
      when Player
        if player.name == entity.name
          text = "[KILL] #{player.name}さんが#{player.item_in_hand.type}で自害いたしました。というかたぶん事故です。"
        else
          text = "[KILL] 殺人事件発生! #{player.name}容疑者が#{entity.name}さんを#{player.item_in_hand.type}殺害した疑いで書類送検されました"
        end
      when Zombie
        if entity.baby?
          evt.dropped_exp *= 3
        end
        text = "[KILL] #{player.name} killed a #{entity.type ? entity.type.name.downcase : entity.inspect} (exp #{evt.dropped_exp}.)"
      else
        text = "[KILL] #{player.name} killed a #{entity.type ? entity.type.name.downcase : entity.inspect} (exp #{evt.dropped_exp}.)"
      end
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
    text = [
      "[BED] #{player.name}さんがベッドに横たわっておられる",
      "[BED] #{player.name}さんがベッドに横たわっておられる",
      "[BED] #{player.name} went to bed.",
      "[BED] #{player.name}さんがベッドに縦たわっておられる",
      "[BED] #{player.name}さん爆睡中、寝坊まちがいなし"].sample

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
        play_sound(player.location, Sound::LEVEL_UP, 0.5, 0.5)
        if @good_morning
          text = "[BED] あさだーーーーーーー! #{%w[ょ ゅ ゃ ね vim 肉 ! 朝です。 浅田].sample}"
          Lingr.post text
          broadcast text
          @good_morning = false
        end
      end
    end
  end

  def on_player_achievement_awarded(evt)
    Lingr.post [evt.player.name, evt.achievement.name].inspect
  end
end
