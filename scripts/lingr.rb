require 'digest/sha1'
require 'erb'
require 'open-uri'
require 'json'

import 'org.bukkit.ChatColor'
require 'sinatra/base'
require 'sinatra/reloader'
require 'mechanize'

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
      open "http://lingr.com/api/room/say?#{query_string}"
    end
  end

  def remove_colors(message)
    ChatColor.values.inject(message) {|memo, color|
      memo.gsub(color.to_s, '')
    }
  end
end

class LingrServer < Sinatra::Base
  register Sinatra::Reloader

  before do
    p "Just for debug"
  end

  post '/chats/' do
    JSON.parse(request.body.read)['events'].map{ |e|
      e['message']
    }.each do |m|
      text = m['text']
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
        Logger: WEBrick::Log.new('/dev/null')
      )
    rescue Exception => e
      puts e.message
    end
  end

  private
  def agent
    @@agent ||= Mechanize.new
  end
  def login
    # TODO
  end
  def bot_list
    # TODO
    res = agent.get 'http://lingr.com/developer'
    if res.code == '200'
    else
      login
    end
  end
  def create_bot(id, name)
    # TODO
  end
end

Thread.start do
  LingrServer.run
end

