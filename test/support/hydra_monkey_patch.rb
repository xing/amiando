Typhoeus::Hydra.class_eval do
  alias_method :run_without_monkeys, :run

  def run_with_monkeys
    run_without_monkeys
  ensure
    @active_stubs = []
  end

  alias_method :run, :run_with_monkeys
end
