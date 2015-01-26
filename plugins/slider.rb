# encoding: utf-8

=begin

## Summary

This makes you very fun when you descend the stairs!

　　　　　　　　　　　　　　　　　　　 ,===,====、
　　　　　　　　　　　　　　　　　　 _.||＿__|_____||_
..　　　　　　　　　　　　　　　　 ／　 　／||＿＿＿|^ l
..　　 　　　　　　　　　　　　(・ω・`)／／||　　　|口| |ω・` )
.　　　　　　　　　　　　　.／(^(^ .／／||...||　　　|口| |ｃ 　）
...　 　 　 　 　 　 　 　／　　　／／　 ||...||　　　|口| ||し
.......　　　　　　　　(・ω・`) ／／....　　||...||　　　|口| ||
　　 　　　　　　／(^(^　／／ 　....　　.||...||　　　|口| ||
　"" 　　　:::''　|／　 　|／　''　"　　:::　　⌒　 :: ⌒⌒⌒ ::　""　　`
　::　,,　:::::　,,　;￣￣￣　　"､　:::: "　,, ,　:::　　 "　::　"　::::　　"


## Usage

This needs that `player.sneaking?` is true.
When you want to play slider, please press `w` with `shift` key.
Have fun. :-)


TODO
* 横/背面移動の時の判定 <- よくわかんない(direction をどうのするみたいな？)
* 吸い付き <- いらないかも
* 滑り落ちる角度を固定させる <- よくわからん
=end

import 'org.bukkit.Bukkit'
import 'org.bukkit.Material'
import 'org.bukkit.util.Vector'
import 'org.bukkit.event.entity.EntityDamageEvent'

module Slider
  extend self
  extend Rukkit::Util

  STAIRS = [
    Material::ACACIA_STAIRS,
    Material::BIRCH_WOOD_STAIRS,
    Material::BRICK_STAIRS,
    Material::COBBLESTONE_STAIRS,
    Material::DARK_OAK_STAIRS,
    Material::JUNGLE_WOOD_STAIRS,
    Material::NETHER_BRICK_STAIRS,
    Material::QUARTZ_STAIRS,
    Material::SANDSTONE_STAIRS,
    Material::SMOOTH_STAIRS,
    Material::SPRUCE_WOOD_STAIRS,
    Material::WOOD_STAIRS,
  ]

  @sliding ||= {}

  def on_player_move(evt)
    player = evt.player
    loc = player.location

    below_block = loc.clone
    below_block.set_y below_block.y.round-1

    unless STAIRS.include? below_block.block.type
      below_block.add(0, -1, 0)
      unless STAIRS.include? below_block.block.type
        @sliding[player.name] = false if @sliding[player.name] && !player.sneaking?
        return
      end
    end


    # quote from `fast_dash`
    # detect the direction
    yaw_mod = loc.yaw % 90
    new_yaw =
      case
      when yaw_mod < 45
        (loc.yaw - yaw_mod) % 360
      when yaw_mod > 45
        (loc.yaw + 90 - yaw_mod) % 360
      else
        nil
      end

    stair_direction = below_block.block.state.data.descending_direction.to_s

    case (new_yaw / 90).to_i
    when 0
      player_direction = "SOUTH"
    when 1
      player_direction = "WEST"
    when 2
      player_direction = "NORTH"
    when 3
      player_direction = "EAST"
    end

    unless stair_direction == player_direction
      @sliding[player.name] = false if @sliding[player.name] && !player.sneaking?
    end

    if player.sneaking?
      @sliding[player.name] = true
      later 0 do
        # <player name> moved wrongly! という warning でてつらみある. 不正な direction を指定してるのかな…
        loc.set_pitch 31.64 # いい感じのpitch 固定できてない
        loc.add(loc.direction)
        player.velocity = Vector.new(loc.direction.x, loc.direction.y, loc.direction.z)
      end
    end
  end

  def on_entity_damage(evt)
    return unless @sliding[evt.entity.player.name]

    evt.cancelled = true if evt.cause == EntityDamageEvent::DamageCause::FALL
  end
end
