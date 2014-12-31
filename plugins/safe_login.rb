require 'set'

module SafeLogin
  extend self
  extend Rukkit::Util

  @within_3_sec ||= Set.new

  def on_player_join(evt)
    player = evt.player
    @within_3_sec.add(player.name)
    later sec(3) do
      @within_3_sec.delete(player.name)
    end
  end

  def on_entity_target(evt)
    return unless @within_3_sec.include?(evt.player.name)
    evt.cancelled = true
  end
end
