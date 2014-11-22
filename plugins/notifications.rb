import 'org.bukkit.entity.Player'

module Notifications
  extend self
  extend Rukkit::Util

  def on_entity_death(evt)
    entity = evt.entity
    player = entity.killer

    case player
    when Player
      text = "#{player.name} killed a #{entity.type ? entity.type.name.downcase : entity.inspect}"
      Lingr.post text
      broadcast text
    end
  end

  def on_player_bed_enter(evt)
    player = evt.player
    text = "[BED] #{player.name}さんがベッドに横たわっておられる"

    awake_players = Bukkit.online_players.to_a.map(&:name).reject(&:sleeing?)
    unless awake_players.empty?
      text += " (#{awake_players.join ' '}達は今すぐ寝#{%w[ましょう ろ んかい].sample})"
    end
    Lingr.post text
    broadcast text
  end

  def on_player_bed_leave(evt)
    player = evt.player
    text = "[BED] #{player.name}さんがベッドから身体を起こした模様"
    Lingr.post text
    broadcast text
  end
end
