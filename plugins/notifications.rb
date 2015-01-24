# encoding: utf-8
require 'set'
import 'org.bukkit.entity.Player'
import 'org.bukkit.entity.Chicken'
import 'org.bukkit.entity.Cow'
import 'org.bukkit.entity.Enderman'
import 'org.bukkit.entity.Zombie'
import 'org.bukkit.entity.PigZombie'
import 'org.bukkit.Material'
import 'org.bukkit.event.entity.EntityDamageEvent'
import 'org.bukkit.entity.EntityType'

module Notifications
  extend self
  extend Rukkit::Util

  @lava_notified ||= Set.new

  def on_entity_death(evt)
    @last_kill_notice ||= ''
    entity = evt.entity
    player = entity.killer

    case player
    when Player
      return if player.location.y >= 180 # TT

      case entity
      when Chicken, Cow
        text = "[KILL] ・°°・(((p(≧□≦)q)))・°°・。ｳﾜｰﾝ!! #{player.name} killed a #{readable_name(entity)}."
      when Player
        if player.name == entity.name
          text = "[KILL] #{player.name}さんが#{player.item_in_hand.type}で自害いたしました。というかたぶん事故です。"
        else
          text = "[KILL] 殺人事件発生! #{player.name}容疑者が#{entity.name}さんを#{player.item_in_hand.type}殺害した疑いで書類送検されました"
        end
      when Enderman
        text = "[KILL] #{player.name} killed a #{readable_name(entity)} (exp #{evt.dropped_exp}.)"
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
      case entity.type
      when EntityType::SKELETON
        if entity.skeleton_type == org.bukkit.entity.Skeleton::SkeletonType::WITHER
          'WitherSkeleton'
        else
          entity.type.name.capitalize
        end
      else
        entity.type.name.capitalize
      end
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
        orb.experience = Bukkit.online_players.to_a.size * 5

        if @good_morning
          text =
            case rand(3)
            when 0
              "[BED] あさ（あさ）"
            when 1
              "[BED] あさだーーーーーーー! #{%w[ょ ゅ ゃ ね vim 肉 ! 朝です。 淺田].sample}"
            when 2
              "[BED] ああああああああああああああああああさだー"
            end
          Lingr.post(text) if Bukkit.online_players.to_a.size == 1
          broadcast text
          @good_morning = false
        end
      end
    end
  end

  def on_player_achievement_awarded(evt)
    text = [:achievement, evt.player.name, evt.achievement.to_s].inspect
    Lingr.post(text)
    broadcast(text)
  end

  def on_player_portal(evt)
    player = evt.player
    from_name = evt.from.world.name
    to_name = evt.to.world.name
      text = "[PORTAL] #{player.name}: #{from_name} -> #{to_name} (#{evt.cause.name})"

    later sec(1) do
      Lingr.post(text)
      broadcast(text)
    end
  end

  def on_entity_damage(evt)
    player = evt.entity
    return unless Player === player

    case evt.cause
    when EntityDamageEvent::DamageCause::LAVA
      if evt.damage > 0 && !@lava_notified.include?(player.name)
        text = "[NOTIFICATIONS] #{player.name} is swimming in lava"
        Lingr.post(text)
        broadcast(text)

        @lava_notified.add(player.name)
        later sec(2) do
          @lava_notified.delete(player.name)
        end
      end
    end
  end

  def on_player_level_change(evt)
    player = evt.player
    if player.level >= 30 && player.level % 5 == 0
      text = "[NOTIFICATIONS] #{player.name} level: #{evt.old_level} -> #{player.level}"
      Lingr.post(text)
      broadcast(text)
    end
  end

  def on_brew(evt)
    contents = evt.contents
    text = "[NOTIFICATIONS] #{contents.ingredient.type.to_s.sub(/^Material::/, '')}(#{contents.ingredient.amount}) -> ?"
    Lingr.post(text)
    broadcast(text)
  end

  def on_weather_change(evt)
    world = evt.world
    prev_weather = world.has_storm
    later(0) do
      cur_weather = world.has_storm
      unless prev_weather == cur_weather
        text = "[NOTIFICATIONS] 天気が#{prev_weather ? '雨' : '晴れ'}から#{cur_weather ? '雨' : '晴れ'}になりました..."
        Lingr.post(text) if Bukkit.online_players.to_a.size == 1
        broadcast(text)
      end
    end
  end
end
