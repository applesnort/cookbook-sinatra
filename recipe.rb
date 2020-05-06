class Recipe
  attr_accessor :id, :name, :description, :created_at, :prep_time, :difficulty, :archived, :img

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @done = false
    @difficulty = attributes[:difficulty]
    @img = attributes[:img]
  end

  def mark_as_done!
    @done = true
  end

  def done?
    return @done
  end
end
