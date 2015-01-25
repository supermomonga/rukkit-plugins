# encoding: utf-8
import 'org.bukkit.entity.Player'

module PlayerJobFighter
  extend self
  extend PlayerJob

  login_message do |evt|
    "#{evt.player.name}さんが武闘家になりました(装備なし、手持ちなしで攻撃と防御が強くなります。裸足のときのみノーダメージ着地可能)"
  end

  def name
    '武闘家'
  end

  def detail
    '[武闘家]:装備なし、手持ちなしで攻撃と防御が強くなります。裸足のときのみノーダメージ着地可能'
  end

  def on_entity_damage_by_entity(evt)
    damager = evt.damager
    damagee = evt.entity

    if damager.is_a?(Player)
      if has_job?(damager) && PlayerUtil.naked?(damager)
        evt.damage = evt.damage + 3.0
      end
    end
    if damagee.is_a?(Player)
      if has_job?(damagee) && PlayerUtil.naked?(damagee)
        evt.damage = damage_after_defend(evt.damage, 10.0)
      end
    end

    case evt.cause
    when EntityDamageEvent::DamageCause::FALL
      return if player.inventory.boots
      evt.cancelled = true
      play_sound(player.location, Sound::BAT_HURT, 0.5, 0.0)
    end
  end

  def damage_after_defend(damage, defend)
    damage * (1.0 - (0.08 * defend))
  end
end
