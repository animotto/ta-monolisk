# frozen_string_literal: true

NOT_CONNECTED = 'Not connected'

##
# Game thread
GAME_THREAD_STRUCT = Struct.new(:thread, :proc)
GAME_THREAD = GAME_THREAD_STRUCT.new
GAME_THREAD.proc = proc do |game, logger|
  loop do
    game.check_session
    sleep(game.app_settings['appSettings']['periodicSessionCheckInterval'])
  rescue Monolisk::RequestError
    logger.fail('[SESSION IS INVALID]')
    game.disconnect
    break
  end
end

##
# Logger
class Logger
  def initialize(shell)
    @shell = shell
  end

  def log(message)
    @shell.puts(message)
  end

  def success(message)
    @shell.puts("\e[32m\u2714 #{message}\e[0m")
  end

  def fail(message)
    @shell.puts("\e[31m\u2718 #{message}\e[0m")
  end
end
