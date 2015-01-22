import 'org.bukkit.entity.Player'

module PlayerJobCommand
  extend self
  extend Rukkit::Util

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    return unless Player === sender

    args = args.to_a
    case args.shift
    when 'player-job'
      arg2 = args.shift
      case
      when arg2 == 'id'
        name = args.shift
        return unless name
        player = sender.world.players.find { |p| p.name ==  name }
        return unless player
        PlayerJob.select { |job|
           job.has_job?(player) && job.respond_to?(:detail)
        }.each { |job|
          sender.send_message(job.detail)
        }
      when arg2 == 'me'
        PlayerJob.select { |job|
          job.has_job?(sender) && job.respond_to?(:detail)
        }.each { |job|
          sender.send_message(job.detail)
        }
      when arg2 == 'list'
        PlayerJob.select { |job|
          job.respond_to?(:detail)
        }.each { |job|
          sender.send_message(job.detail)
        }
      when arg2 == 'help'
        broadcast '/rukkit player-job id [user id] --'
        broadcast '        show current job of user specified by id'
        broadcast '/rukkit player-job me -- show current job of youself'
        broadcast '/rukkit player-job list -- show all job list'
        broadcast '/rukkit player-job help -- show help'
      end
    else
    end
  end
end
