import 'org.bukkit.Material'
import 'org.bukkit.util.Vector'

module TrapdoorJump
  extend self
  extend Rukkit::Util

  def on_block_redstone(evt)
    block = evt.block
    return unless block.type === Material::IRON_TRAPDOOR
    return if evt.old_current >= evt.new_current
    trapdoor_jump(evt.block, evt.new_current)
  end

  def within_limit(v)
    x, y, z = [v.get_x, v.get_y, v.get_z].map {|d|
      [8.0, [d, -8.0].max].min
    }
    Vector.new(x, y, z)
  end

  def trapdoor_jump(door, current)
    return if !door.state.data.inverted? && door.state.data.open? or
      door.state.data.inverted? && !door.state.data.open?

    y_velocity = 1.0 + current / 5.0

    facing = door.state.data.facing
    entities = door.chunk.entities.select { |entity|
      entity.location.block == door
    }

    later(0) do
      entities.each do |entity|
        entity.velocity = within_limit entity.velocity.tap {|v|
          v.add Vector.new(facing.mod_x, y_velocity, facing.mod_z)
        }
      end
    end

  end
end
