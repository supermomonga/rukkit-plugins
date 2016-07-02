# encoding: utf-8

module SayHelloAndGoodbye
  include_package 'org.bukkit.entity'
  extend self
  extend Rukkit::Util

  def on_player_join(evt)
    player = evt.player

    msg = "[LOGIN] #{player.name}さんが現実世界に帰ってきました"
    broadcast msg
    Slack.post msg if defined? Slack
  end

  def on_player_quit(evt)
    player = evt.player

    msg = "[LOGOUT] #{player.name}さんが仮想世界に旅立ちました"
    broadcast msg
    Slack.post msg if defined? Slack

    loc = player.location
    2.times do |i|
      later sec(i) do
        loc.world.strikeLightningEffect(loc)
      end
    end
  end
end
