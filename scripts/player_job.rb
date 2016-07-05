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

  def players
    @players ||= Set.new
  end

  def register(player)
    players.add(player.entity_id)
  end

  def unregister(player)
    players.delete(player.entity_id)
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
    Rukkit::Util.log.info("#{self} players: %s" % players.inspect)
    if players.include?(player.entity_id)
      Rukkit::Util.log.info "You(#{player.entity_id}) are in the playres."
      true
    else
      Rukkit::Util.log.info "You(#{player.entity_id}) are not in the playres."
      false
    end
  end

  def login_message(&block)
    @message_proc = block
  end
end
