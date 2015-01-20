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
* 横移動の時の判定 <- よくわかんない(direction をどうのする)
=end

import 'org.bukkit.Bukkit'
import 'org.bukkit.Material'
import 'org.bukkit.util.Vector'

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


  def on_player_move(evt)
    player = evt.player
    loc = evt.to

    return unless [0, -1].any? {|ydiff| STAIRS.include?(add_loc(loc.clone, 0, ydiff,0).block.type)}

    if desc?(loc) && player.sneaking?
      later 0 do
        player.velocity = org.bukkit.util.Vector.new(loc.direction.x, loc.direction.y*0.5, loc.direction.z)
      end
    end
  end

  def desc?(loc)
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

    check_stair = loc.clone
    # right in front
    check_stair.set_yaw new_yaw if new_yaw
    check_stair.set_pitch 0.0

    # diagonally downward
    check_stair.add(loc.direction)
    check_stair.set_y (loc.y-2).truncate

    STAIRS.include?(check_stair.block.type)
  end
end
