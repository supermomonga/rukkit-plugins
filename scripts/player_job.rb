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
    @players ||= Set.new
  end

  def register(player)
    @players.add(player.entity_id) if @players
  end

  def unregister(player)
    @players.delete(player.entity_id) if @players
  end

  def on_player_quit(evt)
    unregister(evt.player)
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
