import 'org.bukkit.entity.Player'

module PlayerJobCommand
  extend self
  extend Rukkit::Util

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    return unless Player === sender

    args = args.to_a
    case args.shift
    when 'player_job'
      arg2 = args.shift
      case
      when arg2 == 'id'
        name = args.shift
        return unless name
        player = sender.world.players.find { |p| p.name ==  name }
        return unless player
        PlayerJob.each_job do |job|
          sender.send_message(job.detail) if job.has_job?(player) && job.respond_to?(:detail)
        end
      when arg2 == 'me'
        PlayerJob.each_job do |job|
          sender.send_message(job.detail) if job.has_job?(sender) && job.respond_to?(:detail)
        end
      when arg2 == 'list'
        PlayerJob.each_job do |job|
          sender.send_message(job.detail) if job.respond_to?(:detail)
        end
      when arg2 == 'help'
        broadcast '/rukkit player_job id [user id] --'
        broadcast '        show current job of user specified by id'
        broadcast '/rukkit player_job me -- show current job of youself'
        broadcast '/rukkit player_job list -- show all job list'
        broadcast '/rukkit player_job help -- show help'
      end
    else
    end
  end
end
