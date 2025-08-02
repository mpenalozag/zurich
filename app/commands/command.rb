# typed: strict

class Command
  extend T::Sig

  sig { returns(T.untyped) }
  def run
    execute
  end

  private

  sig { void }
  def execute
    raise NotImplementedError, "#{self.class} must implement #execute"
  end
end
