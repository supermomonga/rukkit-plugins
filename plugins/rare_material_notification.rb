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
        unless @diamond
          @diamond ||= true
          later sec(10) do
            @diamond = false
          end
          "[RARE MATERIAL] <#{player.name}> ダイアモンド鉱石#{item.item_stack.amount}ゲットだぜ！"
        else
          nil
        end
      when Material::LAPIS_ORE
        unless @lapis
          @lapis ||= true
          later sec(10) do
            @lapis = false
          end
          "[RARE MATERIAL] <#{player.name}> ラピスラズリ鉱石#{item.item_stack.amount} ヽ(*´∀｀)ノ ｷｬｯﾎｰｲ!!"
        else
          nil
        end
      when Material::EMERALD
        unless @emerald
          @emerald ||= true
          later sec(10) do
            @emerald = false
          end
          "[RARE MATERIAL] <#{player.name}> エメラルド鉱石#{item.item_stack.amount} ｷﾀﾜｧ*:.｡..｡.:*･ﾟ (n‘∀‘)ηﾟ･*:.｡..｡.:* ﾐ ☆"
        else
          nil
        end
      else
        nil
      end

    if msg
      broadcast msg
      Lingr.post msg
    end
  end
end
