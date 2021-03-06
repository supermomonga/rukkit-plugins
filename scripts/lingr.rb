# coding: utf-8
require 'digest/sha1'
require 'erb'
require 'open-uri'
require 'json'

import 'org.bukkit.ChatColor'
# require 'sinatra/base'
# require 'sinatra/reloader'
# require 'mechanize'

module Lingr
  extend self

  def say(message, user)
    # TODO: say with users' specific bot
  end

  def post(message)
    room = Rukkit::Util.plugin_config 'lingr.room'
    bot = Rukkit::Util.plugin_config 'lingr.bot'
    secret = Rukkit::Util.plugin_config 'lingr.secret'
    verifier = Digest::SHA1.hexdigest(bot + secret)

    params = {
      room: room,
      bot: bot,
      text: remove_colors(message),
      bot_verifier: verifier
    }

    query_string = params.map{|k,v|
      key = ERB::Util.url_encode k.to_s
      value = ERB::Util.url_encode v.to_s
      "#{key}=#{value}"
    }.join "&"

    Thread.start do
      open("http://lingr.com/api/room/say?#{query_string}")
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


Thread.start do
  LingrServer.run
end

p :debug7
