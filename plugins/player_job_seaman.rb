# encoding: utf-8
import 'org.bukkit.event.entity.EntityDamageEvent'

module PlayerJobSeaman
  extend self
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが海士になりました(海に入っても溺れない)"
  end

  def name
    '海士'
  end

  def detail
    '[海士]:海に入っても溺れない'
  end

  def on_entity_damage(evt)
    entity = evt.entity
    return unless Player === entity
    return unless has_job?(entity)

    evt.cancelled = true if evt.cause == EntityDamageEvent::DamageCause::DROWNING
  end
end
