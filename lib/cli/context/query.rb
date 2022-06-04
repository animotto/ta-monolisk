# frozen_string_literal: true

LOGGER_QUERY = Logger.new(SHELL)

## Commands

# qr
CONTEXT_QUERY_QR = CONTEXT_QUERY.add_command(
  :qr,
  description: 'Raw query',
  params: ['<path>', '[args]']
) do |tokens, _shell|
  params = {}
  tokens[2..].each do |param|
    p = param.split('=', 2)
    params[p[0]] = p[1]
  end

  data = GAME.api.client.request(tokens[1], params)
  LOGGER_QUERY.success(data)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

CONTEXT_QUERY_QR.completion do |line|
  Monolisk::API::COMMANDS.values.grep(/^#{Regexp.escape(line)}/)
end

# qs
CONTEXT_QUERY_QS = CONTEXT_QUERY.add_command(
  :qs,
  description: 'Sessions query',
  params: ['<path>', '[args]']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.fail(NOT_CONNECTED)
    next
  end

  params = {}
  tokens[2..].each do |param|
    p = param.split('=', 2)
    params[p[0]] = p[1]
  end

  data = GAME.api.client.request(tokens[1], params, GAME.id, GAME.api.sid)
  LOGGER_QUERY.success(data)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

CONTEXT_QUERY_QS.completion do |line|
  Monolisk::API::COMMANDS.values.grep(/^#{Regexp.escape(line)}/)
end
