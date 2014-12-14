import 'org.bukkit.Material'

module MaterialUtil
  def sword?(material)
    case material
    when Material::IRON_SWORD,
      Material::WOOD_SWORD,
      Material::STONE_SWORD,
      Material::DIAMOND_SWORD,
      Material::GOLD_SWORD
      true
    else
      false
    end
  end

  module_function :sword?
end
