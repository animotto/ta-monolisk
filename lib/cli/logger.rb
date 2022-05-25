# frozen_string_literal: true

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
