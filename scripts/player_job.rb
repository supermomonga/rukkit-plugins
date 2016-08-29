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
    Rukkit::Util.jedis.set('playername:%s:job' % player.name, self.to_s) if Rukkit::Util.jedis
  end

  # def unregister(player)
  #   Rukkit::Util.jedis.del('playername:%s:job' % damager.name) if Rukkit::Util.jedis
  # end

  def on_plugin_enable(evt)
    @@job_plugins << self unless @@job_plugins.include?(self)
  end

  def on_plugin_disable(evt)
    @@job_plugins.delete(self) if @@job_plugins.include?(self)
  end

  def has_job?(player)
    return unless Rukkit::Util.jedis
    class_name = Rukkit::Util.jedis.get('playername:%s:job' % player.name)
    return unless class_name
    class_name == self.to_s
  end

  def login_message(&block)
    @message_proc = block
  end
end
