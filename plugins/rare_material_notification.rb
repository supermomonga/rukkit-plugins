# encoding: utf-8
import 'org.bukkit.Material'

module RareMaterialNotification
  extend self
  extend Rukkit::Util

  def on_player_pickup_item(evt)
    player = evt.player
    item = evt.item

    msg =
      case item.item_stack.type
      when Material::DIAMOND
        "[RARE MATERIAL] <#{player.name}> ダイアモンド鉱石#{item.item_stack.amount}ゲットだぜ！"
      when Material::LAPIS_ORE
        "[RARE MATERIAL] <#{player.name}> ラピスラズリ鉱石#{item.item_stack.amount} ヽ(*´∀｀)ノ ｷｬｯﾎｰｲ!!"
      when Material::EMERALD
        "[RARE MATERIAL] <#{player.name}> エメラルド鉱石#{item.item_stack.amount} ｷﾀﾜｧ*:.｡..｡.:*･ﾟ (n‘∀‘)ηﾟ･*:.｡..｡.:* ﾐ ☆"
      else
        nil
      end

    if msg
      broadcast msg
      Lingr.post msg
    end
  end
end
