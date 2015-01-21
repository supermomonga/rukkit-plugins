# encoding: utf-8
require 'set'

module PlayerJob
  extend self
  class << self
    include Enumerable

    def each(&block)
      @@job_plugins.each(&block)
    end
  end

  @@job_plugins ||= []

  def on_player_join(evt)
    player = evt.player

    # become job with 30% of probability
    @players ||= Set.new
    @players.add(player.entity_id) if rand(100) < 30
    message = @message_proc.call(evt) if @message_proc
    Rukkit::Util.broadcast(message) if message && has_job?(player)
  end

  def on_player_quit(evt)
    player = evt.player
    @players.delete(player.entity_id) if @players
  end

  def on_plugin_enable(evt)
    @@job_plugins << self unless @@job_plugins.include?(self)
  end

  def on_plugin_disable(evt)
    @@job_plugins.delete(self) if @@job_plugins.include?(self)
  end

  def has_job?(player)
    @players && @players.include?(player.entity_id)
  end

  def login_message(&block)
    @message_proc = block
  end
end
