# encoding: utf-8

import 'org.bukkit.entity.Player'
import 'org.bukkit.ChatColor'

module ChatRelay
  Message = Struct.new(:name, :text)

  extend self
  extend Rukkit::Util

  def on_async_player_chat(evt)
    Slack.post evt.message, evt.player.name
  end
end
# vim:foldmethod=marker
