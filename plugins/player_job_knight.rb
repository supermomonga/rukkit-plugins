# encoding: utf-8
import 'org.bukkit.entity.Player'

module PlayerJobKnight
  extend self
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが剣士になりました(剣の攻撃と防御が強くなります)"
  end

  def detail
    '[剣士]:剣の攻撃と防御が強くなります'
  end

  def on_entity_damage_by_entity(evt)
    damager = evt.damager
    damagee = evt.entity

    if damager.is_a?(Player)
      if has_job?(damager) && PlayerUtil.equip_sword?(damager)
        evt.damage = evt.damage + 1.0
      end
    end
    if damagee.is_a?(Player)
      if has_job?(damagee) && PlayerUtil.block_with_sword?(damagee)
        evt.damage = damage_after_defend(evt.damage, 3.0)
      end
    end
  end

  def damage_after_defend(damage, defend)
    damage * (1.0 - (0.08 * defend))
  end
end
