import 'org.bukkit.Bukkit'
import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.inventory.ShapedRecipe'
import 'org.bukkit.Material'

module SaddleRecipe
  extend self
  extend Rukkit::Util

  # convert String to Java char
  def char(str)
    str.ord
  end

  def saddle_recipe
    ShapedRecipe.new(
      ItemStack.new(Material::SADDLE)
    ).shape(
      '###',
      '#_#',
      '_ _'
    ).set_ingredient(char('#'), Material::LEATHER).set_ingredient(char('_'), Material::IRON_INGOT)
  end

  Bukkit.add_recipe(saddle_recipe)
end
