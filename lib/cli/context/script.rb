# frozen_string_literal: true

SCRIPTS_DIR = File.join(__dir__, '../../..', 'scripts')
SCRIPTS_EXT = 'rb'

SCRIPTS_STRUCT = Struct.new(:jobs, :counter)
SCRIPTS_JOB_STRUCT = Struct.new(:id, :thread, :instance, :datetime, :class_name, :name)
SCRIPTS = SCRIPTS_STRUCT.new([], 1)

module Script
  ##
  # Base script
  class Base
    def initialize(shell, game, id, name, args)
      @shell = shell
      @game = game
      @id = id
      @name = name
      @args = args

      prefix = "\u2731 [#{@name}:#{@id}] "
      @logger = Logger.new(@shell)
      @logger.log_prefix = prefix
      @logger.success_prefix = prefix
      @logger.fail_prefix = prefix
      @logger.info_prefix = prefix
      @logger.warning_prefix = prefix
    end

    def start; end

    def finish; end
  end
end

## Commands

# run
CONTEXT_SCRIPT.add_command(
  :run,
  description: 'Run the script',
  params: ['<script>', '[args]']
) do |tokens, shell|
  script_name = tokens[1]
  script_file = File.join(SCRIPTS_DIR, [script_name, SCRIPTS_EXT].join('.'))
  unless File.file?(script_file)
    shell.puts('No such script')
    next
  end

  script_const = ['Job', SCRIPTS.counter].join
  script = Script.const_set(script_const, Script::Base)
  script_instance = script.new(shell, GAME, SCRIPTS.counter, script_name, tokens[2..])

  begin
    script_instance.instance_eval(File.read(script_file))
  rescue StandardError, SyntaxError => e
    shell.puts(e.backtrace.join("\n"))
    shell.puts(e)
  end

  SCRIPTS.jobs << SCRIPTS_JOB_STRUCT.new(
    SCRIPTS.counter,
    nil,
    script_instance,
    Time.now,
    script_const,
    script_name
  )

  script = SCRIPTS.jobs.last
  script.thread = Thread.new do
    script.instance.start
    script.instance.finish
  rescue StandardError => e
    shell.puts(e.backtrace.join("\n"))
    shell.puts(e)
  ensure
    Script.send(:remove_const, script.class_name) if Script.const_defined?(script.class_name)
    SCRIPTS.jobs.delete_if { |j| j.id == script.id }
  end

  SCRIPTS.counter += 1
end

# kill
CONTEXT_SCRIPT.add_command(
  :kill,
  description: 'Kill the script',
  params: ['<id>']
) do |tokens, shell|
  id = tokens[1].to_i

  script = SCRIPTS.jobs.detect { |j| j.id == id }
  unless script
    shell.puts('No such job')
    next
  end

  script.thread.kill
  Script.send(:remove_const, script.class_name)
  SCRIPTS.jobs.delete_if { |j| j.id == id }
end

# jobs
CONTEXT_SCRIPT.add_command(
  :jobs,
  description: 'Show running scripts'
) do |_tokens, shell|
  SCRIPTS.jobs.each do |job|
    time = (Time.now - job.datetime).to_i
    duration = []
    duration << (time / 60 / 60)
    duration << (time / 60 % 60)
    duration << (time % 60)
    duration.map! { |d| Kernel.format('%02d', d) }

    shell.puts(
      Kernel.format(
        ' [%d] %s %s (%s)',
        job.id,
        duration.join(':'),
        job.name,
        job.class_name
      )
    )
  end
end

# list
CONTEXT_SCRIPT.add_command(
  :list,
  description: 'List available script'
) do |_tokens, shell|
  next unless Dir.exist?(SCRIPTS_DIR)

  Dir.each_child(SCRIPTS_DIR) do |script|
    next unless script.end_with?(".#{SCRIPTS_EXT}")

    shell.puts(File.basename(script, '.*'))
  end
end
