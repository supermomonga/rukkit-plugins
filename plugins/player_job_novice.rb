# encoding: utf-8
import 'org.bukkit.entity.Player'

module PlayerJobDigger
  extend self
  extend Rukkit::Util
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが無職になりました"
  end

  def name
    '無職'
  end

  def detail
    '[無職]:職がない'
  end

end
