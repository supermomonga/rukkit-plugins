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

  def post(user, message)
    # curl -X POST --data-urlencode 'payload={
    # "channel": "#minecraft",
    # "username": "webhookbot",
    # "text": "This is posted to #minecraft and comes from a bot named webhookbot.",
    # "icon_emoji": ":ghost:"
    # }' https://hooks.slack.com/services/xxxxxxxxxx

    channel = Rukkit::Util.plugin_config 'slack.channel'
    channel = "##{channel}" unless channel[0] == '#'
    webhook_url = Rukkit::Util.plugin_config 'slack.url'

    params = {
      channel: channel,
      username: user,
      text: remove_colors(message)
    }


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

if false
  class LingrServer < Sinatra::Base
    register Sinatra::Reloader

    post '/chats/' do
      JSON.parse(request.body.read)['events'].map{ |e|
        e['message']
      }.each do |m|
        text = m['text']
        Lingr::command(text)
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
        url: 'https://github.com/supermomonga/akechi.rukkit',
      }.inspect
    end

    def self.run
      begin
        Rack::Handler::WEBrick.shutdown
      rescue
      end

      begin
        puts "launch server on port #{Rukkit::Util.plugin_config('lingr.server_port')}."
        Rack::Handler::WEBrick.run(
          self,
          Port: Rukkit::Util.plugin_config('lingr.server_port'),
          AccessLog: [],
          Logger: WEBrick::Log.new(Rukkit::Util.rukkit_dir + 'lingr_webrick.log')
        )
      rescue Exception => e
        p ['exception-in-lingr', e.class, e]
        puts e.message
      end

      p :debug6

    end

    # private
    # def agent
    #   @@agent ||= Mechanize.new
    # end
    # def login
    #   # TODO
    # end
    # def bot_list
    #   # TODO
    #   res = agent.get 'http://lingr.com/developer'
    #   if res.code == '200'
    #   else
    #     login
    #   end
    # end
    # def create_bot(id, name)
    #   # TODO
    # end
  end
end

p :debug3


# Thread.start do
#   LingrServer.run
# end

p :debug7
