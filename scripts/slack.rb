# coding: utf-8
require 'digest/sha1'
require 'erb'
require 'open-uri'
require 'json'
require 'net/https'
require 'sinatra/base'

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

  post '/gateway/' do
    if params[:token] == Rukkit::Util.plugin_config('slack.outgoing_token')
      text = params[:text].gsub(params[:trigger_word], '').strip
      user = params[:user_name]

      Thread.new do
        Slack::command(text)
        user = Rukkit::Util.colorize(user, :gray)
        message = "<#{user}> #{text}"
        Rukkit::Util.broadcast message
      end
    end

    status 200
    body ''
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
    if Rack::Handler::WEBrick.instance_variable_get('@server')
      Rukkit::Util.log.info "Server is running. Shutdown."
      Rack::Handler::WEBrick.shutdown
      sleep 3
    else
      Rukkit::Util.log.info "Server is not running."
    end

    begin
      puts "launch server on port #{Rukkit::Util.plugin_config('slack.server_port')}."
      Rack::Handler::WEBrick.run(
        self,
        Host: '0.0.0.0',
        Port: Rukkit::Util.plugin_config('slack.server_port'),
        AccessLog: [],
        Logger: WEBrick::Log.new(Rukkit::Util.rukkit_dir + 'slack_webrick.log')
      )
    rescue Errno::EADDRINUSE => e
      Rukkit::Util.log.info "Address in use. retry."
      sleep 3
      retry
    end

  end
end

Thread.start do
  SlackServer.run
end
