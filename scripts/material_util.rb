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

  def pickaxe?(material)
    case material
    when Material::IRON_PICKAXE,
      Material::WOOD_PICKAXE,
      Material::STONE_PICKAXE,
      Material::DIAMOND_PICKAXE,
      Material::GOLD_PICKAXE
      true
    else
      false
    end
  end

  def axe?(material)
    case material
    when Material::IRON_AXE,
      Material::WOOD_AXE,
      Material::STONE_AXE,
      Material::DIAMOND_AXE,
      Material::GOLD_AXE
      true
    else
      false
    end
  end

  def spade?(material)
    case material
    when Material::IRON_SPADE,
      Material::WOOD_SPADE,
      Material::STONE_SPADE,
      Material::DIAMOND_SPADE,
      Material::GOLD_SPADE
      true
    else
      false
    end
  end

  def hoe?(material)
    case material
    when Material::IRON_HOE,
      Material::WOOD_HOE,
      Material::STONE_HOE,
      Material::DIAMOND_HOE,
      Material::GOLD_HOE
      true
    else
      false
    end
  end

  module_function :sword?
  module_function :pickaxe?
  module_function :axe?
  module_function :spade?
  module_function :hoe?
end
