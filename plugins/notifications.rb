# encoding: utf-8

import 'org.bukkit.entity.Player'
import 'org.bukkit.entity.Chicken'
import 'org.bukkit.entity.Enderman'
import 'org.bukkit.entity.Zombie'
import 'org.bukkit.entity.PigZombie'
import 'org.bukkit.Material'

module Notifications
  extend self
  extend Rukkit::Util

  def on_entity_death(evt)
    @last_kill_notice ||= ''
    entity = evt.entity
    player = entity.killer

    return if player.location.y >= 180 # TT

    case player
    when Player
      case entity
      when Chicken
        text = "[KILL] ・°°・(((p(≧□≦)q)))・°°・。ｳﾜｰﾝ!! #{player.name} killed a #{readable_name(entity)}."
      when Player
        if player.name == entity.name
          text = "[KILL] #{player.name}さんが#{player.item_in_hand.type}で自害いたしました。というかたぶん事故です。"
        else
          text = "[KILL] 殺人事件発生! #{player.name}容疑者が#{entity.name}さんを#{player.item_in_hand.type}殺害した疑いで書類送検されました"
        end
      when Enderman
        evt.dropped_exp *= 3
      when PigZombie
        text = "[KILL] #{player.name} killed a #{readable_name(entity)} (exp #{evt.dropped_exp}.)"
      when Zombie
        if entity.baby?
          evt.dropped_exp *= 4
        end
        text = "[KILL] #{player.name} killed a #{readable_name(entity)} (exp #{evt.dropped_exp}.)"
      else
        text = "[KILL] #{player.name} killed a #{readable_name(entity)} (exp #{evt.dropped_exp}.)"
      end
      if text
        Lingr.post(text) unless text == @last_kill_notice
        broadcast text
        @last_kill_notice = text
      end
    end
  end

  def readable_name(entity)
    case
    when entity.custom_name
      entity.custom_name
    when entity.type
      entity.type.name.capitalize
    else
      entity.inspect
    end
  end
  private :readable_name

  def on_player_death(evt)
    player = evt.entity
    Lingr.post "#{player.name} died: #{evt.death_message.sub(/^#{player.name}/, '')} at (#{player.location.x.to_i}, #{player.location.z.to_i}) in #{player.location.world.name}."

    text = "[DESPAWN] It has been 4 minutes after #{player.name}'s death. You have only one minute left to gain all the items dropped if you still didn't get them yet."
    later sec(4 * 60) do
      broadcast(text)
    end
  end

  def on_player_bed_enter(evt)
    player = evt.player
    text = [
      "[BED] #{player.name}さんがベッドに横たわっておられる",
      "[BED] #{player.name}さんがベッドに横たわっておられる",
      "[BED] #{player.name}さんが寝る前の歯磨きすら忘れてベッドに入り就寝する模様です",
      "[BED] #{player.name} went to bed.",
      "[BED] #{player.name}さんがベッドに縦たわっておられる",
      "[BED] #{player.name}さんが寝落ちしました",
      "[BED] #{player.name}さん爆睡中、寝坊まちがいなし"].sample

    later sec(0.5) do
      awake_players = Bukkit.online_players.to_a.reject(&:sleeping?)
      unless awake_players.empty?
        players = awake_players.map(&:name).join "#{%w[くん さん ちゃん 君 様 君 子].sample} "
        if awake_players.size > 1
          players += "達"
        elsif awake_players.size == 1
          Bukkit.online_players.to_a.size.times do
           awake_players[0].send_message "[BED] #{awake_players[0].name}: いいから寝#{%w[ましょう ろ んかい].sample}"
          end
        end
        text += " (#{players}は今すぐ寝#{%w[ましょう ろ んかい ようね♡ ろや てね るべし].sample})"
      end
      Lingr.post(text) if Bukkit.online_players.to_a.size == 1
      broadcast text
    end
  end

  def on_player_bed_leave(evt)
    player = evt.player
    if player.world.time > 0
      text = "[BED] #{player.name}さんが夜にもかかわらずベッドから身体を起こした模様"
      Lingr.post(text) if Bukkit.online_players.to_a.size == 1
      broadcast text
    else
      @good_morning ||= true
      later sec(1) do
        play_sound(player.location, Sound::LEVEL_UP, 0.0, 0.5)
        orb = spawn(player.location, EntityType::EXPERIENCE_ORB)
        orb.experience = 5

        if @good_morning
          text =
            case rand(2)
            when 0
              "[BED] あさ（あさ）"
            when 1
              "[BED] あさだーーーーーーー! #{%w[ょ ゅ ゃ ね vim 肉 ! 朝です。 淺田].sample}"
            end
          Lingr.post(text) if Bukkit.online_players.to_a.size == 1
          broadcast text
          @good_morning = false
        end
      end
    end
  end

  def on_player_achievement_awarded(evt)
    text = [:achievement, evt.player.name, evt.achievement.name].inspect
    Lingr.post(text)
    broadcast(text)
  end

  def on_player_portal(evt)
    player = evt.player
    from_name = evt.from.world.name
    to_name = evt.to.world.name
    text = "[PORTAL] #{player.name}: #{from_name} -> #{to_name} (#{evt.cause.name})"

    Lingr.post(text)
    broadcast(text)
  end
end
