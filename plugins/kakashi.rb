import 'org.bukkit.Material'
import 'org.bukkit.block.BlockFace'

module Kakashi
  extend self
  extend Rukkit::Util

  SAVED_RADIUS = 3

  @kakashies ||= {}

  def block_vertical?(top, materials)
    current = top
    materials.all? {|m|
      current.tap { current = current.get_relative(BlockFace::DOWN) }.type == m
    }
  end

  def kakashi?(head)
    body = [Material::PUMPKIN, Material::HAY_BLOCK, Material::HAY_BLOCK]
    arm = [Material::AIR, Material::FENCE, Material::AIR]
    block_vertical?(
      head, body
    ) && (
      (block_vertical?(head.get_relative(BlockFace::NORTH), arm) && block_vertical?(head.get_relative(BlockFace::SOUTH), arm)) ||
      (block_vertical?(head.get_relative(BlockFace::EAST), arm) && block_vertical?(head.get_relative(BlockFace::WEST), arm))
    )
  end

  def in_range?(v, p)
    (p - SAVED_RADIUS..p + SAVED_RADIUS).include?(v)
  end

  def saved_chunk?(chunk)
    @kakashies.values.map {|k| k[:chunk] }.any? {|x, z|
      in_range?(x, chunk.x) && in_range?(z, chunk.z)
    }
  end

  def on_block_place(evt)
    block = evt.block_placed
    return unless kakashi?(block)
    chunk = block.chunk
    @kakashies[evt.player.name] = {chunk: [chunk.x, chunk.z], block: [block.x, block.y, block.z]}
    broadcast("#{evt.player.name} built kakashi (chunk = #{chunk.x},#{chunk.z})")
  end

  def on_chunk_unload(evt)
    evt.cancelled = true if saved_chunk?(evt.chunk)
  end
end
