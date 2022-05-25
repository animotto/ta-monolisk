# frozen_string_literal: true

NOT_CONNECTED = 'Not connected'

##
# Game thread
GAME_THREAD_STRUCT = Struct.new(:thread, :proc)
GAME_THREAD = GAME_THREAD_STRUCT.new
GAME_THREAD.proc = proc do |game, logger|
  loop do
    game.check_session
  rescue Monolisk::InvalidSessionError
    logger.fail('[SESSION IS INVALID]')
    game.disconnect
    break
  rescue Monolisk::RequestError
  ensure
    sleep(game.app_settings['appSettings']['periodicSessionCheckInterval'])
  end
end
