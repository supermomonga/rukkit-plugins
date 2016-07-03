# coding: utf-8
$LOAD_PATH.each do |lp|
  Rukkit::Util.log.info(lp)
end
require 'digest/sha1'
require 'erb'
require 'open-uri'
require 'json'
require 'net/https'
require 'sinatra/base'
require 'sinatra/reloader'

import 'org.bukkit.ChatColor'

module Slack
  extend self

  def say(message, user)
    # TODO: say with users' specific bot
  end

  def post(message, user = nil)
    channel = Rukkit::Util.plugin_config 'slack.channel'
    channel = "##{channel}" unless channel[0] == '#'
    webhook_url = Rukkit::Util.plugin_config 'slack.url'
    icon_url_base = Rukkit::Util.plugin_config 'slack.icon_url_base'
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
      icon_url = "#{icon_url}##{Time.now.to_i / 3600}"
      params.merge!(icon_url: icon_url)
    end


    Thread.start do
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

Onject.send(:remove_const, :SlackServer) if Object.const_defined?(:SlackServer)

class SlackServer < Sinatra::Base
  register Sinatra::Reloader

  post '/chats/' do
    JSON.parse(request.body.read)['events'].map{ |e|
      e['message']
    }.each do |m|
      text = m['text']
      Slack::command(text)
      user = Rukkit::Util.colorize(m['nickname'], :gray)
      message = "<#{user}> #{text}"
      Rukkit::Util.broadcast message
    end
  end

  get '/' do
    {
      name: 'rukkit',
      authors: ['supermomonga', 'ujm'],
      version: '0.0dev',
      url: 'https://github.com/supermomonga/rukkit-plugins',
    }.inspect
  end

  def self.run
    begin
      Rack::Handler::WEBrick.shutdown
    rescue
    end

    begin
      puts "launch server on port #{Rukkit::Util.plugin_config('slack.server_port')}."
      Rack::Handler::WEBrick.run(
        self,
        Port: Rukkit::Util.plugin_config('slack.server_port'),
        AccessLog: [],
        Logger: WEBrick::Log.new(Rukkit::Util.rukkit_dir + 'slack_webrick.log')
      )
    rescue Exception => e
      p ['exception-in-slack', e.class, e]
      puts e.message
    end

  end
end

Thread.start do
  SlackServer.run
end
