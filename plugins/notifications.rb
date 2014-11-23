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

    later sec(0.5) do
      awake_players = Bukkit.online_players.to_a.reject(&:sleeping?).map(&:name)
      unless awake_players.empty?
        players = awake_players.join ' '
        if awake_players.size > 1
          players += "達"
          Bukkit.get_player(players[0]).send_message "いいから寝#{%w[ましょう ろ んかい].sample}"
        end
        text += " (#{players}は今すぐ寝#{%w[ましょう ろ んかい].sample})"
      end
      Lingr.post text
      broadcast text
    end

  end

  def on_player_bed_leave(evt)
    player = evt.player
    text = "[BED] #{player.name}さんがベッドから身体を起こした模様 at #{player.world.time}"
    Lingr.post text
    broadcast text
  end
end
