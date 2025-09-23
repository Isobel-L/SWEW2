class PuzzleBuilder
  def set_solution(_word);        raise NotImplementedError; end
  def set_scrambled(_scrambled);  raise NotImplementedError; end
  def set_hint_manager(_manager); raise NotImplementedError; end
  def puzzle;                     raise NotImplementedError; end
end