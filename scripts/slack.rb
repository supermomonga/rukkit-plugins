# coding: utf-8
require 'digest/sha1'
require 'erb'
require 'open-uri'
require 'json'
require 'net/https'

import 'org.bukkit.ChatColor'

module Slack
  extend self

  def say(message, user)
    # TODO: say with users' specific bot
  end

  def post(message, user = nil)
    # curl -X POST --data-urlencode 'payload={
    # "channel": "#minecraft",
    # "username": "webhookbot",
    # "text": "This is posted to #minecraft and comes from a bot named webhookbot.",
    # "icon_emoji": ":ghost:"
    # }' https://hooks.slack.com/services/xxxxxxxxxx

    channel = Rukkit::Util.plugin_config 'slack.channel'
    channel = "##{channel}" unless channel[0] == '#'
    webhook_url = Rukkit::Util.plugin_config 'slack.url'
    icon_url_base = Rukkit::Util.plugin_config 'slack.icon_url_base'
    # https://shicraft.darui.io/tiles/faces/32x32/supermomonga.png
    if user
      post_name = "%s (minecraft)" % user
    else
      post_name = "Rukkit"
    end

    params = {
      channel: channel,
      username: post_name,
      text: remove_colors(message)
    }

    if icon_url_base && user
      icon_url = icon_url_base % user
      params.merge!(icon_url: icon_url)
    end


    Thread.start do
      # uri = URI.parse(wehbook_url)
      # http = Net::HTTP.new(uri.host, uri.port)

      # http.use_ssl = true
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # req = Net::HTTP::Post.new(uri.path)
      # req.body = params.to_json

      # res = http.request(req)
      request_url = webhook_url
      uri = URI.parse(request_url)
      http = Net::HTTP.post_form(uri, { payload: params.to_json})
    end
  end

  def remove_colors(message)
    ChatColor.values.inject(message) {|memo, color|
      memo.gsub(color.to_s, '')
    }
  end

  def command(text)
    command = text.split(/[\s　]+/)
    if "/rukkit" == command.shift
      case command.shift
      when "member"
      when "update"
      else
      end
    end
  end
end
