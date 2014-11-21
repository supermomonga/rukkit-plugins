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

  def on_player_bed_enter_event(evt)
    player = evt.player
    text = "#{player.name}さんがベッドに横たわっておられる"
    Lingr.post text
    broadcast text
  end


end
