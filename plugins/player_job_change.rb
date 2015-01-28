# encoding: utf-8
import 'org.bukkit.entity.Player'
import 'org.bukkit.Material'
import 'org.bukkit.block.BlockFace'
import 'org.bukkit.entity.EntityType'
import 'redis.clients.jedis.Jedis'
import 'redis.clients.jedis.JedisPool'
import 'redis.clients.jedis.JedisPoolConfig'
import 'redis.clients.jedis.Protocol'

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

  def on_plugin_enable(evt)
    hostname = plugin_config('redis.hostname')
    return unless hostname

    port = plugin_config('redis.port') || Protocol::DEFAULT_PORT
    @pool = JedisPool.new(JedisPoolConfig.new, hostname, port.to_i)
  end

  def on_plugin_disable(evt)
    @pool.destroy if @pool
  end

  def on_entity_damage_by_entity(evt)
    damager = evt.damager
    return unless Player === damager
    entity = evt.entity
    return unless entity.type == EntityType::ITEM_FRAME
    return unless JOB_SYMBOL[entity.item.type]
    facing = FACE_MAP[entity.facing]
    return unless entity.location.block.get_relative(facing).type == Material::QUARTZ_BLOCK

    job_class = JOB_SYMBOL[entity.item.type]
    job = PlayerJob.find(&job_class.method(:===))
    return unless job

    evt.cancelled = true

    attack_counter = Counter.instance(damager, entity)
    case attack_counter.value
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
        attack_counter.reset
      end
    when 10
      PlayerJob.each do |j|
        j.unregister(damager)
      end
      job.register(damager)

      damager.send_message("今からお前は#{job.name}だ おめでとう！")

      begin
        jedis = @pool.resource
        jedis.set('playername:%s:job' % damager.name, job_class.to_s)
      rescue
        # ignore
      ensure
        @pool.return_resource(jedis) if jedis
      end

      attack_counter.reset
    end
    attack_counter.increment
  end

  def on_player_join(evt)
    return unless @pool
    player = evt.player
    begin
      jedis = @pool.resource
      class_name = jedis.get('playername:%s:job' % player.name)
    ensure
      @pool.return_resource(jedis) if jedis
    end
    return unless class_name
    return unless module_exists?(class_name)
    job_class = Module.const_get(class_name)
    job = PlayerJob.find(&job_class.method(:===))
    job.register(player)
  end

  class Counter
    def self.instance(player, entity)
      @@instance ||= {}
      @@instance[player.entity_id] ||= {}
      @@instance[player.entity_id][entity.item.type.id] ||= new
    end

    private_class_method :new
    def initialize
      reset
    end

    def increment
      @counter += 1
    end

    def reset
      @counter = 0
    end

    def value
      @counter
    end
  end
end
