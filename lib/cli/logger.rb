# frozen_string_literal: true

##
# Logger
class Logger
  attr_accessor :log_prefix, :success_prefix, :fail_prefix, :info_prefix

  def initialize(shell)
    @shell = shell
  end

  def log(message)
    @shell.puts("#{@log_prefix}#{message}")
  end

  def success(message)
    @shell.puts("\e[32m#{@success_prefix}#{message}\e[0m")
  end

  def fail(message)
    @shell.puts("\e[31m#{@fail_prefix}#{message}\e[0m")
  end

  def info(message)
    @shell.puts("\e[34m#{@info_prefix}#{message}\e[0m")
  end
end
