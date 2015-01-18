# encoding: utf-8
require 'set'
import 'org.bukkit.entity.Player'
# import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.Material'
import 'org.bukkit.Sound'

module PlayerJobLegion
  extend self
  extend PlayerJob
  extend Rukkit::Util

  login_message do |evt|
    "#{evt.player.name}さんが古代ローマ市民になりました (鉄装備で固めるとローマの栄光を得ます)"
  end

  def detail
    '[古代ローマ市民]:鉄装備で固めるとローマの栄光を得ます'
  end

  @legioning ||= {}

  def on_inventory_click(evt)
    player = evt.who_clicked
    return unless has_job?(player)

    later 0 do
      armor_contents = player.inventory.armor_contents.to_a.map(&:type).to_set
      new_legioning_p = [Material::IRON_CHESTPLATE, Material::IRON_HELMET].to_set.subset?(armor_contents)
      if !@legioning[player.name] && new_legioning_p
        broadcast("[LEGION] #{player.name}さんがただのローマ市民からレギオンになりました")
        Lingr.post("[LEGION] #{player.name}さんがただのローマ市民からレギオンになりました")
        @legioning[player.name] = :vanila
      elsif @legioning[player.name] && !new_legioning_p
        broadcast("[LEGION] #{player.name}さんがレギオンからただのローマ市民になりました")
        Lingr.post("[LEGION] #{player.name}さんがレギオンからただのローマ市民になりました")
        @legioning.delete(player.name)
      end
    end
  end

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    player = sender
    return unless Player === player
    args = args.to_a
    return unless args.shift == 'player-job-legion'

    unless has_job?(player)
      player.send_message('You are not a Legion nor a Roman.')
      return false
    end

    unless @legioning[player.name]
      player.send_message('You are a Roman, but not a Legion.')
      return false
    end

    text = "[LEGION] レギオンの#{player.name}さんがモードを#{@legioning[player.name]}から#{toggled_mode(@legioning[player.name])}に変更しました。"
    broadcast(text)
    Lingr.post(text)

    @legioning[player.name] = toggled_mode(@legioning[player.name])
    play_sound(player.location, Sound::LEVEL_UP, 0.5, 0.5)
  end

  def on_player_move(evt)
    player = evt.player
    return unless has_job?(player)
    return unless @legioning[player.name]
    return unless [:road, :foundation].include?(@legioning[player.name])
    return unless player.on_ground?
    return unless player.inventory.contains(Material::COBBLESTONE)

    xmove = evt.to.x - evt.from.x
    zmove = evt.to.z - evt.from.z
    return if xmove == 0.0 && zmove == 0.0
    xdiff, zdiff =
      xmove.abs > zmove.abs ? [xmove > 0 ? 1 : -1, 0] : [0, zmove > 0 ? 1 : -1]

    blocks = [-2, -1].map {|ydiff|
      add_loc(player.location, xdiff, ydiff, zdiff).block
    }
    # TODO item consumption
    case @legioning[player.name]
    when :road
      blocks.reject {|b| b.type.occluding? }.each do |b|
        b.type = Material::COBBLESTONE
        b.data = 0
      end
    when :foundation
      unless blocks[0].type.occluding?
        blocks[0].type = Material::COBBLESTONE
        blocks[0].data = 0
      end
      unless blocks[1].type.occluding?
        blocks[1].type = Material::DIRT
        blocks[1].data = 0
      end
    end
  end

  def on_entity_damage_by_entity(evt)
    damager = evt.damager
    damagee = evt.entity
    legion_iron_sword_attack(evt, damager)
    legion_iron_sword_guard(evt, damagee)
  end

  def legion_iron_sword_attack(evt, damager)
    return unless Player === damager
    return unless has_job?(damager)
    return unless @legioning[damager.name]
    return unless damager.item_in_hand.type == Material::IRON_SWORD
    evt.damage += 8
    play_sound(damager.location, Sound::ANVIL_BREAK, 0.3, 1.0)
  end
  private :legion_iron_sword_attack

  def legion_iron_sword_guard(evt, damagee)
    return unless Player === damagee
    return unless has_job?(damagee)
    return unless @legioning[damagee.name]
    return unless damagee.item_in_hand.type == Material::IRON_SWORD
    return unless damagee.blocking?
    evt.damage = [evt.damage - 8, 0].max
    play_sound(damagee.location, Sound::ANVIL_USE, 0.3, 1.0)
  end
  private :legion_iron_sword_guard

  def on_block_place(evt)
    player = evt.player
    block = evt.block

    return unless has_job?(player)
    return unless @legioning[player.name] == :fortress
    return unless block.type == Material::COBBLESTONE

    players = Bukkit.online_players.to_a.select {|p| block.chunk == p.location.chunk }
    (1..8).each do |ydiff|
      b = add_loc(block.location, 0, ydiff, 0).block
      return if players.any? {|p| p.location.block == b }
      return unless player.item_in_hand.type == Material::COBBLESTONE
      unless b.type.occluding?
        b.type = Material::COBBLESTONE
        b.data = 0
        KillerQueen.consume_item(player) # TODO
      end
    end
  end

  # toggled_mode(:vanila) == :road
  def toggled_mode(mode)
    modes = [:vanila, :road, :foundation, :fortress]
    modes[(modes.index(mode) + 1) % modes.size]
  end
  private :toggled_mode
end
