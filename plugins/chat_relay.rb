# encoding: utf-8

import 'org.bukkit.entity.Player'
import 'org.bukkit.ChatColor'

module ChatRelay
  Message = Struct.new(:name, :message)

  extend self
  extend Rukkit::Util

  def on_async_player_chat(evt)
    message = Message.new evt.player.name, evt.message
    Lingr.post "[#{message.name}] #{message.message}"
  end
end
# vim:foldmethod=marker
