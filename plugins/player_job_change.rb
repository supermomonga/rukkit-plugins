# encoding: utf-8
import 'org.bukkit.entity.Player'
import 'org.bukkit.Material'

module PlayerJobChange
  extend self
  extend Rukkit::Util

  def module_exists?(class_name)
    Module.const_defined?(class_name) && Module === Module.const_get(class_name)
  end

  JOB_SYMBOL = {}
  JOB_SYMBOL[Material::ANVIL]           = PlayerJobSmith      if module_exists?('PlayerJobSmith')
  JOB_SYMBOL[Material::IRON_SWORD]      = PlayerJobKnight     if module_exists?('PlayerJobKnight')
  JOB_SYMBOL[Material::IRON_CHESTPLATE] = PlayerJobLegion     if module_exists?('PlayerJobLegion')
  JOB_SYMBOL[Material::IRON_HOE]        = PlayerJobFarmer     if module_exists?('PlayerJobFarmer')
  JOB_SYMBOL[Material::COOKED_CHICKEN]  = PlayerJobFighter    if module_exists?('PlayerJobFighter')
  JOB_SYMBOL[Material::IRON_AXE]        = PlayerJobWoodcutter if module_exists?('PlayerJobWoodcutter')
  JOB_SYMBOL[Material::WATER_BUCKET]    = PlayerJobSeaman     if module_exists?('PlayerJobSeaman')

  FACE_MAP = {
    BlockFace::EAST  => BlockFace::WEST,
    BlockFace::WEST  => BlockFace::EAST,
    BlockFace::NORTH => BlockFace::SOUTH,
    BlockFace::SOUTH => BlockFace::NORTH,
  }

  def on_entity_damage_by_entity(evt)
    damager = evt.damager
    return unless Player === damager
    entity = evt.entity
    return unless entity.type == EntityType::ITEM_FRAME
    return unless JOB_SYMBOL[entity.item.type]
    facing = FACE_MAP[entity.facing]
    return unless entity.location.block.get_relative(facing).type == Material::QUARTZ_BLOCK

    evt.cancelled = true

    job_class = JOB_SYMBOL[entity.item.type]
    job = PlayerJob.find(&job_class.method(:===))
    @attack_count ||= {}
    @attack_count[damager.entity_id] ||= {}
    @attack_count[damager.entity_id][entity.item.type.id] ||= 0
    case @attack_count[damager.entity_id][entity.item.type.id]
    when 0
      if job.has_job?(damager)
        unless @noticed
          damager.send_message("すでに#{job.name}だ")
          @noticed = true
          later sec(10) do
            @noticed = false
          end
        end
        return
      end

      damager.send_message("#{job.name}になりたければ続けよ")
      later sec(10) do
        @attack_count[damager.entity_id][entity.item.type.id] = 0
      end
    when 10
      PlayerJob.each do |j|
        j.unregister(damager)
      end
      job.register(damager)

      damager.send_message("今からお前は#{job.name}だ おめでとう！")

      @attack_count[damager.entity_id][entity.item.type.id] = 0
    end
    @attack_count[damager.entity_id][entity.item.type.id] += 1
  end
end
