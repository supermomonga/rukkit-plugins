import 'org.bukkit.Bukkit'
import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.inventory.ShapedRecipe'
import 'org.bukkit.Material'

module DirtToClayRecipe
  extend self
  extend Rukkit::Util

  # convert String to Java char
  def char(str)
    str.ord
  end

  def dirt_to_clay_recipe
    ShapedRecipe.new(
      ItemStack.new(Material::CLAY_BALL, 8)
    ).shape(
      '###',
      '#_#',
      '###'
    ).set_ingredient(char('#'), Material::DIRT).set_ingredient(char('_'), Material::WATER_BUCKET)
  end

  Bukkit.add_recipe(dirt_to_clay_recipe)
end
