class_list = %w(
  org.bukkit.block.CreatureSpawner
  org.bukkit.block.Skull
  org.bukkit.block.Dropper
  org.bukkit.block.PistonMoveReaction
  org.bukkit.block.DoubleChest
  org.bukkit.block.Sign
  org.bukkit.block.Jukebox
  org.bukkit.block.Biome
  org.bukkit.block.Beacon
  org.bukkit.block.BlockState
  org.bukkit.block.ContainerBlock
  org.bukkit.block.Block
  org.bukkit.block.Furnace
  org.bukkit.block.CommandBlock
  org.bukkit.block.NoteBlock
  org.bukkit.block.Chest
  org.bukkit.block.Hopper
  org.bukkit.block.BlockFace
  org.bukkit.block.Dispenser
  org.bukkit.block.BrewingStand
  org.bukkit.command.CommandSender
  org.bukkit.command.CommandExecutor
  org.bukkit.command.TabCompleter
  org.bukkit.command.TabExecutor
  org.bukkit.command.TabCommandExecutor
  org.bukkit.command.PluginCommandYamlParser
  org.bukkit.command.CommandException
  org.bukkit.command.CommandMap
  org.bukkit.command.PluginCommand
  org.bukkit.command.PluginIdentifiableCommand
  org.bukkit.command.ConsoleCommandSender
  org.bukkit.command.BlockCommandSender
  org.bukkit.command.SimpleCommandMap
  org.bukkit.command.FormattedCommandAlias
  org.bukkit.command.MultipleCommandAlias
  org.bukkit.command.Command
  org.bukkit.command.RemoteConsoleCommandSender
  org.bukkit.command.defaults.PlaySoundCommand
  org.bukkit.command.defaults.MeCommand
  org.bukkit.command.defaults.WeatherCommand
  org.bukkit.command.defaults.GameRuleCommand
  org.bukkit.command.defaults.ClearCommand
  org.bukkit.command.defaults.VersionCommand
  org.bukkit.command.defaults.PardonIpCommand
  org.bukkit.command.defaults.EffectCommand
  org.bukkit.command.defaults.TimingsCommand
  org.bukkit.command.defaults.SaveOnCommand
  org.bukkit.command.defaults.KickCommand
  org.bukkit.command.defaults.HelpCommand
  org.bukkit.command.defaults.PluginsCommand
  org.bukkit.command.defaults.VanillaCommand
  org.bukkit.command.defaults.AchievementCommand
  org.bukkit.command.defaults.WhitelistCommand
  org.bukkit.command.defaults.ReloadCommand
  org.bukkit.command.defaults.BanIpCommand
  org.bukkit.command.defaults.SaveOffCommand
  org.bukkit.command.defaults.DeopCommand
  org.bukkit.command.defaults.BanCommand
  org.bukkit.command.defaults.SetWorldSpawnCommand
  org.bukkit.command.defaults.OpCommand
  org.bukkit.command.defaults.TestForCommand
  org.bukkit.command.defaults.TimeCommand
  org.bukkit.command.defaults.DifficultyCommand
  org.bukkit.command.defaults.GameModeCommand
  org.bukkit.command.defaults.SaveCommand
  org.bukkit.command.defaults.StopCommand
  org.bukkit.command.defaults.BukkitCommand
  org.bukkit.command.defaults.EnchantCommand
  org.bukkit.command.defaults.ScoreboardCommand
  org.bukkit.command.defaults.SayCommand
  org.bukkit.command.defaults.ExpCommand
  org.bukkit.command.defaults.GiveCommand
  org.bukkit.command.defaults.PardonCommand
  org.bukkit.command.defaults.TellCommand
  org.bukkit.command.defaults.KillCommand
  org.bukkit.command.defaults.ListCommand
  org.bukkit.command.defaults.TeleportCommand
  org.bukkit.command.defaults.SpawnpointCommand
  org.bukkit.command.defaults.SetIdleTimeoutCommand
  org.bukkit.command.defaults.BanListCommand
  org.bukkit.command.defaults.ToggleDownfallCommand
  org.bukkit.command.defaults.SeedCommand
  org.bukkit.command.defaults.DefaultGameModeCommand
  org.bukkit.command.defaults.SpreadPlayersCommand
  org.bukkit.configuration.MemorySection
  org.bukkit.configuration.InvalidConfigurationException
  org.bukkit.configuration.ConfigurationSection
  org.bukkit.configuration.MemoryConfiguration
  org.bukkit.configuration.Configuration
  org.bukkit.configuration.ConfigurationOptions
  org.bukkit.configuration.MemoryConfigurationOptions
  org.bukkit.configuration.file.YamlConstructor
  org.bukkit.configuration.file.FileConfigurationOptions
  org.bukkit.configuration.file.YamlConfigurationOptions
  org.bukkit.configuration.file.YamlRepresenter
  org.bukkit.configuration.file.FileConfiguration
  org.bukkit.configuration.file.YamlConfiguration
  org.bukkit.configuration.serialization.ConfigurationSerialization
  org.bukkit.configuration.serialization.SerializableAs
  org.bukkit.configuration.serialization.ConfigurationSerializable
  org.bukkit.configuration.serialization.DelegateDeserialization
  org.bukkit.conversations.ConversationCanceller
  org.bukkit.conversations.PluginNameConversationPrefix
  org.bukkit.conversations.NumericPrompt
  org.bukkit.conversations.StringPrompt
  org.bukkit.conversations.ManuallyAbandonedConversationCanceller
  org.bukkit.conversations.FixedSetPrompt
  org.bukkit.conversations.NullConversationPrefix
  org.bukkit.conversations.Conversable
  org.bukkit.conversations.InactivityConversationCanceller
  org.bukkit.conversations.ConversationContext
  org.bukkit.conversations.RegexPrompt
  org.bukkit.conversations.ValidatingPrompt
  org.bukkit.conversations.ConversationAbandonedListener
  org.bukkit.conversations.Conversation
  org.bukkit.conversations.ConversationFactory
  org.bukkit.conversations.ConversationPrefix
  org.bukkit.conversations.Conversation$ConversationState
  org.bukkit.conversations.Prompt
  org.bukkit.conversations.PlayerNamePrompt
  org.bukkit.conversations.ExactMatchConversationCanceller
  org.bukkit.conversations.ConversationAbandonedEvent
  org.bukkit.conversations.MessagePrompt
  org.bukkit.conversations.BooleanPrompt
  org.bukkit.enchantments.Enchantment
  org.bukkit.enchantments.EnchantmentTarget
  org.bukkit.enchantments.EnchantmentWrapper
  org.bukkit.entity.EnderPearl
  org.bukkit.entity.Blaze
  org.bukkit.entity.Spider
  org.bukkit.entity.Snowman
  org.bukkit.entity.MushroomCow
  org.bukkit.entity.Arrow
  org.bukkit.entity.Skeleton
  org.bukkit.entity.Squid
  org.bukkit.entity.AnimalTamer
  org.bukkit.entity.EntityType
  org.bukkit.entity.Cow
  org.bukkit.entity.PoweredMinecart
  org.bukkit.entity.CaveSpider
  org.bukkit.entity.EnderDragonPart
  org.bukkit.entity.Wolf
  org.bukkit.entity.ItemFrame
  org.bukkit.entity.Player
  org.bukkit.entity.EnderSignal
  org.bukkit.entity.Villager
  org.bukkit.entity.Giant
  org.bukkit.entity.Skeleton.SkeletonType
  org.bukkit.entity.Enderman
  org.bukkit.entity.Golem
  org.bukkit.entity.Creature
  org.bukkit.entity.Horse.Style
  org.bukkit.entity.Minecart
  org.bukkit.entity.LeashHitch
  org.bukkit.entity.Zombie
  org.bukkit.entity.Ocelot
  org.bukkit.entity.Fish
  org.bukkit.entity.Snowball
  org.bukkit.entity.Vehicle
  org.bukkit.entity.StorageMinecart
  org.bukkit.entity.ComplexEntityPart
  org.bukkit.entity.Ocelot.Type
  org.bukkit.entity.Silverfish
  org.bukkit.entity.LargeFireball
  org.bukkit.entity.ComplexLivingEntity
  org.bukkit.entity.LivingEntity
  org.bukkit.entity.Creeper
  org.bukkit.entity.Flying
  org.bukkit.entity.Projectile
  org.bukkit.entity.FallingSand
  org.bukkit.entity.LightningStrike
  org.bukkit.entity.Damageable
  org.bukkit.entity.Witch
  org.bukkit.entity.Pig
  org.bukkit.entity.Weather
  org.bukkit.entity.Item
  org.bukkit.entity.Horse.Variant
  org.bukkit.entity.Horse
  org.bukkit.entity.Boat
  org.bukkit.entity.ExperienceOrb
  org.bukkit.entity.Ghast
  org.bukkit.entity.Monster
  org.bukkit.entity.ThrownPotion
  org.bukkit.entity.Ageable
  org.bukkit.entity.Horse.Color
  org.bukkit.entity.Painting
  org.bukkit.entity.Fireball
  org.bukkit.entity.ThrownExpBottle
  org.bukkit.entity.TNTPrimed
  org.bukkit.entity.IronGolem
  org.bukkit.entity.NPC
  org.bukkit.entity.HumanEntity
  org.bukkit.entity.Animals
  org.bukkit.entity.Villager.Profession
  org.bukkit.entity.Entity
  org.bukkit.entity.SmallFireball
  org.bukkit.entity.Hanging
  org.bukkit.entity.Bat
  org.bukkit.entity.Slime
  org.bukkit.entity.MagmaCube
  org.bukkit.entity.CreatureType
  org.bukkit.entity.EnderDragon
  org.bukkit.entity.WaterMob
  org.bukkit.entity.Ambient
  org.bukkit.entity.Egg
  org.bukkit.entity.Tameable
  org.bukkit.entity.FallingBlock
  org.bukkit.entity.Firework
  org.bukkit.entity.Explosive
  org.bukkit.entity.Wither
  org.bukkit.entity.WitherSkull
  org.bukkit.entity.Chicken
  org.bukkit.entity.EnderCrystal
  org.bukkit.entity.PigZombie
  org.bukkit.entity.Sheep
  org.bukkit.entity.minecart.PoweredMinecart
  org.bukkit.entity.minecart.StorageMinecart
  org.bukkit.entity.minecart.HopperMinecart
  org.bukkit.entity.minecart.RideableMinecart
  org.bukkit.entity.minecart.ExplosiveMinecart
  org.bukkit.entity.minecart.SpawnerMinecart
  org.bukkit.entity.minecart.CommandMinecart
  org.bukkit.event.EventHandler
  org.bukkit.event.Event.Result
  org.bukkit.event.HandlerList
  org.bukkit.event.Event
  org.bukkit.event.EventPriority
  org.bukkit.event.Listener
  org.bukkit.event.Cancellable
  org.bukkit.event.EventException
  org.bukkit.event.block.SignChangeEvent
  org.bukkit.event.block.LeavesDecayEvent
  org.bukkit.event.block.BlockRedstoneEvent
  org.bukkit.event.block.BlockCanBuildEvent
  org.bukkit.event.block.BlockBurnEvent
  org.bukkit.event.block.BlockMultiPlaceEvent
  org.bukkit.event.block.BlockPhysicsEvent
  org.bukkit.event.block.BlockIgniteEvent
  org.bukkit.event.block.NotePlayEvent
  org.bukkit.event.block.BlockPlaceEvent
  org.bukkit.event.block.BlockFromToEvent
  org.bukkit.event.block.BlockEvent
  org.bukkit.event.block.BlockFadeEvent
  org.bukkit.event.block.BlockDamageEvent
  org.bukkit.event.block.BlockIgniteEvent.IgniteCause
  org.bukkit.event.block.BlockPistonEvent
  org.bukkit.event.block.EntityBlockFormEvent
  org.bukkit.event.block.Action
  org.bukkit.event.block.BlockPistonExtendEvent
  org.bukkit.event.block.BlockExpEvent
  org.bukkit.event.block.BlockFormEvent
  org.bukkit.event.block.BlockGrowEvent
  org.bukkit.event.block.BlockPistonRetractEvent
  org.bukkit.event.block.BlockSpreadEvent
  org.bukkit.event.block.BlockDispenseEvent
  org.bukkit.event.block.BlockBreakEvent
  org.bukkit.event.enchantment.EnchantItemEvent
  org.bukkit.event.enchantment.PrepareItemEnchantEvent
  org.bukkit.event.entity.EntityRegainHealthEvent.RegainReason
  org.bukkit.event.entity.EntityDamageEvent.DamageCause
  org.bukkit.event.entity.EntityDamageEvent
  org.bukkit.event.entity.EntityEvent
  org.bukkit.event.entity.HorseJumpEvent
  org.bukkit.event.entity.EntityCombustEvent
  org.bukkit.event.entity.EntityRegainHealthEvent
  org.bukkit.event.entity.EntityCombustByBlockEvent
  org.bukkit.event.entity.EntityCombustByEntityEvent
  org.bukkit.event.entity.EntityTargetLivingEntityEvent
  org.bukkit.event.entity.PlayerLeashEntityEvent
  org.bukkit.event.entity.PigZapEvent
  org.bukkit.event.entity.ItemDespawnEvent
  org.bukkit.event.entity.EntityTargetEvent
  org.bukkit.event.entity.PlayerDeathEvent
  org.bukkit.event.entity.SlimeSplitEvent
  org.bukkit.event.entity.EntityChangeBlockEvent
  org.bukkit.event.entity.EntityPortalEnterEvent
  org.bukkit.event.entity.CreatureSpawnEvent.SpawnReason
  org.bukkit.event.entity.EntityDamageByBlockEvent
  org.bukkit.event.entity.CreeperPowerEvent
  org.bukkit.event.entity.EntityDeathEvent
  org.bukkit.event.entity.ProjectileHitEvent
  org.bukkit.event.entity.EntityTameEvent
  org.bukkit.event.entity.PotionSplashEvent
  org.bukkit.event.entity.EntityDamageByEntityEvent
  org.bukkit.event.entity.ExpBottleEvent
  org.bukkit.event.entity.EntityExplodeEvent
  org.bukkit.event.entity.CreatureSpawnEvent
  org.bukkit.event.entity.FoodLevelChangeEvent
  org.bukkit.event.entity.EntityInteractEvent
  org.bukkit.event.entity.EntityBreakDoorEvent
  org.bukkit.event.entity.EntityCreatePortalEvent
  org.bukkit.event.entity.SheepRegrowWoolEvent
  org.bukkit.event.entity.EntityPortalEvent
  org.bukkit.event.entity.EntityTargetEvent.TargetReason
  org.bukkit.event.entity.CreeperPowerEvent.PowerCause
  org.bukkit.event.entity.EntityUnleashEvent.UnleashReason
  org.bukkit.event.entity.ExplosionPrimeEvent
  org.bukkit.event.entity.EntityUnleashEvent
  org.bukkit.event.entity.EntityShootBowEvent
  org.bukkit.event.entity.ProjectileLaunchEvent
  org.bukkit.event.entity.EntityPortalExitEvent
  org.bukkit.event.entity.ItemSpawnEvent
  org.bukkit.event.entity.SheepDyeWoolEvent
  org.bukkit.event.entity.EntityTeleportEvent
  org.bukkit.event.hanging.HangingBreakByEntityEvent
  org.bukkit.event.hanging.HangingPlaceEvent
  org.bukkit.event.hanging.HangingBreakEvent.RemoveCause
  org.bukkit.event.hanging.HangingEvent
  org.bukkit.event.hanging.HangingBreakEvent
  org.bukkit.event.inventory.InventoryAction
  org.bukkit.event.inventory.InventoryPickupItemEvent
  org.bukkit.event.inventory.InventoryMoveItemEvent
  org.bukkit.event.inventory.FurnaceBurnEvent
  org.bukkit.event.inventory.PrepareItemCraftEvent
  org.bukkit.event.inventory.InventoryOpenEvent
  org.bukkit.event.inventory.InventoryEvent
  org.bukkit.event.inventory.BrewEvent
  org.bukkit.event.inventory.InventoryType.SlotType
  org.bukkit.event.inventory.FurnaceExtractEvent
  org.bukkit.event.inventory.CraftItemEvent
  org.bukkit.event.inventory.FurnaceSmeltEvent
  org.bukkit.event.inventory.InventoryInteractEvent
  org.bukkit.event.inventory.InventoryType
  org.bukkit.event.inventory.InventoryCloseEvent
  org.bukkit.event.inventory.ClickType
  org.bukkit.event.inventory.DragType
  org.bukkit.event.inventory.InventoryDragEvent
  org.bukkit.event.inventory.InventoryClickEvent
  org.bukkit.event.inventory.InventoryCreativeEvent
  org.bukkit.event.painting.PaintingBreakEvent.RemoveCause
  org.bukkit.event.painting.PaintingBreakEvent
  org.bukkit.event.painting.PaintingEvent
  org.bukkit.event.painting.PaintingBreakByEntityEvent
  org.bukkit.event.painting.PaintingPlaceEvent
  org.bukkit.event.player.PlayerPreLoginEvent.Result
  org.bukkit.event.player.PlayerExpChangeEvent
  org.bukkit.event.player.PlayerRespawnEvent
  org.bukkit.event.player.PlayerCommandPreprocessEvent
  org.bukkit.event.player.PlayerPickupItemEvent
  org.bukkit.event.player.PlayerBucketEmptyEvent
  org.bukkit.event.player.PlayerInventoryEvent
  org.bukkit.event.player.PlayerFishEvent
  org.bukkit.event.player.PlayerBedEnterEvent
  org.bukkit.event.player.PlayerLoginEvent
  org.bukkit.event.player.PlayerDropItemEvent
  org.bukkit.event.player.PlayerLevelChangeEvent
  org.bukkit.event.player.PlayerVelocityEvent
  org.bukkit.event.player.AsyncPlayerPreLoginEvent
  org.bukkit.event.player.PlayerAnimationType
  org.bukkit.event.player.PlayerInteractEvent
  org.bukkit.event.player.PlayerPortalEvent
  org.bukkit.event.player.PlayerQuitEvent
  org.bukkit.event.player.PlayerTeleportEvent.TeleportCause
  org.bukkit.event.player.PlayerUnregisterChannelEvent
  org.bukkit.event.player.PlayerChatTabCompleteEvent
  org.bukkit.event.player.PlayerEggThrowEvent
  org.bukkit.event.player.PlayerChatEvent
  org.bukkit.event.player.PlayerAchievementAwardedEvent
  org.bukkit.event.player.PlayerFishEvent.State
  org.bukkit.event.player.AsyncPlayerPreLoginEvent.Result
  org.bukkit.event.player.PlayerBedLeaveEvent
  org.bukkit.event.player.PlayerChannelEvent
  org.bukkit.event.player.PlayerStatisticIncrementEvent
  org.bukkit.event.player.PlayerToggleSprintEvent
  org.bukkit.event.player.PlayerUnleashEntityEvent
  org.bukkit.event.player.PlayerInteractEntityEvent
  org.bukkit.event.player.PlayerEditBookEvent
  org.bukkit.event.player.PlayerKickEvent
  org.bukkit.event.player.PlayerItemHeldEvent
  org.bukkit.event.player.PlayerItemConsumeEvent
  org.bukkit.event.player.PlayerGameModeChangeEvent
  org.bukkit.event.player.PlayerItemBreakEvent
  org.bukkit.event.player.PlayerPreLoginEvent
  org.bukkit.event.player.PlayerLoginEvent.Result
  org.bukkit.event.player.PlayerToggleFlightEvent
  org.bukkit.event.player.PlayerAnimationEvent
  org.bukkit.event.player.AsyncPlayerChatEvent
  org.bukkit.event.player.PlayerBucketEvent
  org.bukkit.event.player.PlayerRegisterChannelEvent
  org.bukkit.event.player.PlayerMoveEvent
  org.bukkit.event.player.PlayerTeleportEvent
  org.bukkit.event.player.PlayerBucketFillEvent
  org.bukkit.event.player.PlayerJoinEvent
  org.bukkit.event.player.PlayerShearEntityEvent
  org.bukkit.event.player.PlayerToggleSneakEvent
  org.bukkit.event.player.PlayerChangedWorldEvent
  org.bukkit.event.player.PlayerEvent
  org.bukkit.event.server.ServerCommandEvent
  org.bukkit.event.server.RemoteServerCommandEvent
  org.bukkit.event.server.PluginDisableEvent
  org.bukkit.event.server.MapInitializeEvent
  org.bukkit.event.server.ServiceEvent
  org.bukkit.event.server.PluginEnableEvent
  org.bukkit.event.server.PluginEvent
  org.bukkit.event.server.ServiceRegisterEvent
  org.bukkit.event.server.ServerListPingEvent
  org.bukkit.event.server.ServerEvent
  org.bukkit.event.server.ServiceUnregisterEvent
  org.bukkit.event.vehicle.VehicleEntityCollisionEvent
  org.bukkit.event.vehicle.VehicleBlockCollisionEvent
  org.bukkit.event.vehicle.VehicleExitEvent
  org.bukkit.event.vehicle.VehicleUpdateEvent
  org.bukkit.event.vehicle.VehicleDamageEvent
  org.bukkit.event.vehicle.VehicleDestroyEvent
  org.bukkit.event.vehicle.VehicleEvent
  org.bukkit.event.vehicle.VehicleEnterEvent
  org.bukkit.event.vehicle.VehicleMoveEvent
  org.bukkit.event.vehicle.VehicleCollisionEvent
  org.bukkit.event.vehicle.VehicleCreateEvent
  org.bukkit.event.weather.WeatherChangeEvent
  org.bukkit.event.weather.ThunderChangeEvent
  org.bukkit.event.weather.WeatherEvent
  org.bukkit.event.weather.LightningStrikeEvent
  org.bukkit.event.world.WorldSaveEvent
  org.bukkit.event.world.StructureGrowEvent
  org.bukkit.event.world.WorldEvent
  org.bukkit.event.world.ChunkEvent
  org.bukkit.event.world.WorldUnloadEvent
  org.bukkit.event.world.WorldLoadEvent
  org.bukkit.event.world.PortalCreateEvent.CreateReason
  org.bukkit.event.world.ChunkLoadEvent
  org.bukkit.event.world.ChunkPopulateEvent
  org.bukkit.event.world.PortalCreateEvent
  org.bukkit.event.world.SpawnChangeEvent
  org.bukkit.event.world.ChunkUnloadEvent
  org.bukkit.event.world.WorldInitEvent
  org.bukkit.generator.ChunkGenerator.BiomeGrid
  org.bukkit.generator.BlockPopulator
  org.bukkit.generator.ChunkGenerator
  org.bukkit.help.HelpTopicFactory
  org.bukkit.help.HelpTopic
  org.bukkit.help.HelpTopicComparator
  org.bukkit.help.GenericCommandHelpTopic
  org.bukkit.help.IndexHelpTopic
  org.bukkit.help.HelpTopicComparator.TopicNameComparator
  org.bukkit.help.HelpMap
  org.bukkit.inventory.BrewerInventory
  org.bukkit.inventory.AnvilInventory
  org.bukkit.inventory.InventoryView.Property
  org.bukkit.inventory.PlayerInventory
  org.bukkit.inventory.Recipe
  org.bukkit.inventory.EntityEquipment
  org.bukkit.inventory.MerchantInventory
  org.bukkit.inventory.InventoryView
  org.bukkit.inventory.ShapedRecipe
  org.bukkit.inventory.CraftingInventory
  org.bukkit.inventory.BeaconInventory
  org.bukkit.inventory.EnchantingInventory
  org.bukkit.inventory.ItemFactory
  org.bukkit.inventory.DoubleChestInventory
  org.bukkit.inventory.Inventory
  org.bukkit.inventory.InventoryHolder
  org.bukkit.inventory.FurnaceInventory
  org.bukkit.inventory.FurnaceRecipe
  org.bukkit.inventory.HorseInventory
  org.bukkit.inventory.ShapelessRecipe
  org.bukkit.inventory.ItemStack
  org.bukkit.inventory.meta.MapMeta
  org.bukkit.inventory.meta.LeatherArmorMeta
  org.bukkit.inventory.meta.ItemMeta
  org.bukkit.inventory.meta.Repairable
  org.bukkit.inventory.meta.EnchantmentStorageMeta
  org.bukkit.inventory.meta.FireworkEffectMeta
  org.bukkit.inventory.meta.BookMeta
  org.bukkit.inventory.meta.SkullMeta
  org.bukkit.inventory.meta.PotionMeta
  org.bukkit.inventory.meta.FireworkMeta
  org.bukkit.map.MapRenderer
  org.bukkit.map.MapPalette
  org.bukkit.map.MapView.Scale
  org.bukkit.map.MapCursorCollection
  org.bukkit.map.MapCursor
  org.bukkit.map.MapFont
  org.bukkit.map.MapCanvas
  org.bukkit.map.MapFont.CharacterSprite
  org.bukkit.map.MinecraftFont
  org.bukkit.map.MapView
  org.bukkit.map.MapCursor.Type
  org.bukkit.material.Diode
  org.bukkit.material.Crops
  org.bukkit.material.SmoothBrick
  org.bukkit.material.Directional
  org.bukkit.material.MonsterEggs
  org.bukkit.material.Mushroom
  org.bukkit.material.Coal
  org.bukkit.material.RedstoneWire
  org.bukkit.material.CocoaPlant.CocoaPlantSize
  org.bukkit.material.Vine
  org.bukkit.material.Skull
  org.bukkit.material.SimpleAttachableMaterialData
  org.bukkit.material.FurnaceAndDispenser
  org.bukkit.material.RedstoneTorch
  org.bukkit.material.DetectorRail
  org.bukkit.material.Button
  org.bukkit.material.Sign
  org.bukkit.material.PistonBaseMaterial
  org.bukkit.material.Torch
  org.bukkit.material.Ladder
  org.bukkit.material.Tree
  org.bukkit.material.TripwireHook
  org.bukkit.material.Openable
  org.bukkit.material.Bed
  org.bukkit.material.Wool
  org.bukkit.material.Step
  org.bukkit.material.EnderChest
  org.bukkit.material.ExtendedRails
  org.bukkit.material.Rails
  org.bukkit.material.WoodenStep
  org.bukkit.material.Lever
  org.bukkit.material.Attachable
  org.bukkit.material.PressurePlate
  org.bukkit.material.TrapDoor
  org.bukkit.material.Leaves
  org.bukkit.material.Cauldron
  org.bukkit.material.FlowerPot
  org.bukkit.material.LongGrass
  org.bukkit.material.Redstone
  org.bukkit.material.PistonExtensionMaterial
  org.bukkit.material.PressureSensor
  org.bukkit.material.Sandstone
  org.bukkit.material.Cake
  org.bukkit.material.TexturedMaterial
  org.bukkit.material.Gate
  org.bukkit.material.Tripwire
  org.bukkit.material.Furnace
  org.bukkit.material.SpawnEgg
  org.bukkit.material.PoweredRail
  org.bukkit.material.Dye
  org.bukkit.material.Command
  org.bukkit.material.Pumpkin
  org.bukkit.material.Door
  org.bukkit.material.NetherWarts
  org.bukkit.material.Colorable
  org.bukkit.material.Chest
  org.bukkit.material.CocoaPlant
  org.bukkit.material.DirectionalContainer
  org.bukkit.material.Dispenser
  org.bukkit.material.MaterialData
  org.bukkit.material.Stairs
  org.bukkit.metadata.MetadataEvaluationException
  org.bukkit.metadata.MetadataStoreBase
  org.bukkit.metadata.LazyMetadataValue
  org.bukkit.metadata.MetadataConversionException
  org.bukkit.metadata.Metadatable
  org.bukkit.metadata.MetadataValueAdapter
  org.bukkit.metadata.LazyMetadataValue.CacheStrategy
  org.bukkit.metadata.MetadataValue
  org.bukkit.metadata.MetadataStore
  org.bukkit.metadata.FixedMetadataValue
  org.bukkit.permissions.Permissible
  org.bukkit.permissions.PermissionDefault
  org.bukkit.permissions.PermissionAttachmentInfo
  org.bukkit.permissions.PermissibleBase
  org.bukkit.permissions.PermissionAttachment
  org.bukkit.permissions.ServerOperator
  org.bukkit.permissions.PermissionRemovedExecutor
  org.bukkit.permissions.Permission
  org.bukkit.plugin.InvalidPluginException
  org.bukkit.plugin.EventExecutor
  org.bukkit.plugin.PluginLoader
  org.bukkit.plugin.AuthorNagException
  org.bukkit.plugin.Plugin
  org.bukkit.plugin.PluginManager
  org.bukkit.plugin.PluginLoadOrder
  org.bukkit.plugin.ServicePriority
  org.bukkit.plugin.PluginAwareness
  org.bukkit.plugin.PluginAwareness.Flags
  org.bukkit.plugin.InvalidDescriptionException
  org.bukkit.plugin.SimpleServicesManager
  org.bukkit.plugin.IllegalPluginAccessException
  org.bukkit.plugin.PluginLogger
  org.bukkit.plugin.UnknownDependencyException
  org.bukkit.plugin.ServicesManager
  org.bukkit.plugin.TimedRegisteredListener
  org.bukkit.plugin.PluginBase
  org.bukkit.plugin.PluginDescriptionFile
  org.bukkit.plugin.SimplePluginManager
  org.bukkit.plugin.RegisteredServiceProvider
  org.bukkit.plugin.RegisteredListener
  org.bukkit.plugin.java.JavaPluginLoader
  org.bukkit.plugin.java.JavaPlugin
  org.bukkit.plugin.messaging.MessageTooLargeException
  org.bukkit.plugin.messaging.ChannelNameTooLongException
  org.bukkit.plugin.messaging.ChannelNotRegisteredException
  org.bukkit.plugin.messaging.Messenger
  org.bukkit.plugin.messaging.PluginMessageRecipient
  org.bukkit.plugin.messaging.PluginChannelDirection
  org.bukkit.plugin.messaging.PluginMessageListener
  org.bukkit.plugin.messaging.PluginMessageListenerRegistration
  org.bukkit.plugin.messaging.ReservedChannelException
  org.bukkit.plugin.messaging.StandardMessenger
  org.bukkit.potion.PotionEffectType
  org.bukkit.potion.Potion
  org.bukkit.potion.PotionEffect
  org.bukkit.potion.PotionBrewer
  org.bukkit.potion.Potion.Tier
  org.bukkit.potion.PotionEffectTypeWrapper
  org.bukkit.potion.PotionType
  org.bukkit.projectiles.BlockProjectileSource
  org.bukkit.projectiles.ProjectileSource
  org.bukkit.scheduler.BukkitTask
  org.bukkit.scheduler.BukkitRunnable
  org.bukkit.scheduler.BukkitWorker
  org.bukkit.scheduler.BukkitScheduler
  org.bukkit.scoreboard.Objective
  org.bukkit.scoreboard.Team
  org.bukkit.scoreboard.DisplaySlot
  org.bukkit.scoreboard.Score
  org.bukkit.scoreboard.ScoreboardManager
  org.bukkit.scoreboard.Criterias
  org.bukkit.scoreboard.Scoreboard
  org.bukkit.util.Vector
  org.bukkit.util.BlockIterator
  org.bukkit.util.CachedServerIcon
  org.bukkit.util.Java15Compat
  org.bukkit.util.FileUtil
  org.bukkit.util.ChatPaginator
  org.bukkit.util.StringUtil
  org.bukkit.util.ChatPaginator.ChatPage
  org.bukkit.util.NumberConversions
  org.bukkit.util.BlockVector
  org.bukkit.util.io.BukkitObjectOutputStream
  org.bukkit.util.io.BukkitObjectInputStream
  org.bukkit.util.noise.NoiseGenerator
  org.bukkit.util.noise.OctaveGenerator
  org.bukkit.util.noise.SimplexNoiseGenerator
  org.bukkit.util.noise.SimplexOctaveGenerator
  org.bukkit.util.noise.PerlinOctaveGenerator
  org.bukkit.util.noise.PerlinNoiseGenerator
  org.bukkit.util.permissions.BroadcastPermissions
  org.bukkit.util.permissions.DefaultPermissions
  org.bukkit.util.permissions.CommandPermissions
)

class_list.each do |clazz|
  begin
    import clazz
  rescue
    puts clazz
  end
end

module DebugCommand
  extend self
  extend Rukkit::Util

  def on_command(sender, command, label, args)
    return unless label == 'rukkit' || label == 'rkt'
    return unless Player === sender

    args = args.to_a
    case args.shift
    when 'debug', 'd'
      case args.shift
      when 'eval'
        code = args.join(' ')
        return if code.strip.empty?
        eval(code, BindingForEvent._command_binding(sender, command, label, args))
      when 'register'
        event_pattern = args.shift
        code = args.join(' ')
        return if code.strip.empty?
        case
        when @events.include?(event_pattern)
          register_code(event_pattern, code)
          sender.send_message("code registered!(execute when #{event_pattern})")
        else
          sender.send_message("#{event_pattern} is invalid event pattern")
        end
      when 'help'
        sender.send_message('/rukkit debug eval [something code] --')
        sender.send_message('  eval ruby code')
        sender.send_message('/rukkit debug register [event pattern] [something code] --')
        sender.send_message('  add ruby code that execute when matched event has occured')
      end
    else
    end
  end

  def on_tab_complete(sender, command, aliaz, args)
    return unless aliaz == 'rukkit' || aliaz == 'rkt'
    return unless Player === sender

    args = args.to_a
    case args.shift
    when 'debug'
      case args.length
      when 1
        %w[eval register].grep(/#{args.shift}/)
      when 2
        case args.shift
        when 'register'
          event_pattern = args.shift
          case
          when @events.include?(event_pattern)
            [event_pattern]
          when @events.any? { |e| /^#{event_pattern}/ =~ e }
            @events.grep(/^#{event_pattern}/)
          when events = @events.grep(/^#{abbr_pattern(event_pattern)}$/)
            events if events.length > 0
          end
        end
      end
    end
  end

  def abbr_pattern(pattern)
    case pattern
    when /_/
      pattern.gsub(/_/, '[^_]*\0') + '[^_]*'
    else
      pattern.gsub(/(?<=.)(.)/, '[^_]*_\0') + '[^_]*'
    end
  end

  def register_code(event_name, code)
    @code_evaluator ||= CodeEvaluator.new
    @code_evaluator.register(event_name, code)
  end

  @events = %w(
    block_break
    block_burn
    block_can_build
    block_damage
    block_dispense
    block_exp
    block_fade
    block_form
    block_from_to
    block_grow
    block_ignite
    block_physics
    block_piston_ext
    block_piston_retract
    block_place
    block_redstone
    block_spread
    entity_block_form
    leaves_decay
    note_play
    sign_change
    enchant_item
    prepare_item_enchant
    creature_spawn
    creeper_power
    entity_break_door
    entity_change_block
    entity_combust_by_block
    entity_combust_by_entity
    entity_combust
    entity_create_portal
    entity_damage_by_block
    entity_damage_by_entity
    entity_damage
    entity_death
    entity_explode
    entity_interact
    entity_portal_enter
    entity_portal
    entity_portal_exit
    entity_regain_health
    entity_shoot_bow
    entity_tame
    entity_target
    entity_target_living_entity
    entity_teleport
    entity_unleash
    exp_bottle
    explosion_prime
    food_level_change
    horse_jump
    item_despawn
    item_spawn
    pig_zap
    player_death
    player_leash_entity
    potion_splash
    projectile_hit
    projectile_launch
    sheep_dye_wool
    sheep_regrow_wool
    slime_split
    hanging_break_by_entity
    hanging_break
    hanging_place
    brew
    craft_item
    furnace_burn
    furnace_extract
    furnace_smelt
    inventory_click
    inventory_close
    inventory_creative
    inventory_drag
    inventory
    inventory_interact
    inventory_move_item
    inventory_open
    inventory_pickup_item
    prepare_item_craft
    async_player_chat
    async_player_pre_login
    player_animation
    player_bed_enter
    player_bed_leave
    player_bucket_empty
    player_bucket_fill
    player_changed_world
    player_channel
    player_chat_tab_complete
    player_command_preprocess
    player_drop_item
    player_edit_book
    player_egg_throw
    player_exp_change
    player_fish
    player_game_mode_change
    player_interact_entity
    player_interact
    player_item_break
    player_item_consume
    player_item_held
    player_join
    player_kick
    player_level_change
    player_login
    player_move
    player_pickup_item
    player_portal
    player_quit
    player_register_channel
    player_respawn
    player_shear_entity
    player_teleport
    player_toggle_flight
    player_toggle_sneak
    player_toggle_sprint
    player_unleash_entity
    player_unregister_channel
    player_velocity
    map_initialize
    plugin_disable
    plugin_enable
    remote_server_command
    server_command
    server_list_ping
    service_register
    service_unregister
    vehicle_block_collision
    vehicle_create
    vehicle_damage
    vehicle_destroy
    vehicle_enter
    vehicle_entity_collision
    vehicle_exit
    vehicle_move
    vehicle_update
    lightning_strike
    thunder_change
    weather_change
    chunk_load
    chunk_populate
    chunk_unload
    portal_create
    spawn_change
    structure_grow
    world_init
    world_load
    world_save
    world_unload
  )

  @events.each do |event_name|
    "#{event_name}_event".gsub(/^(.)|_(.)/) { ($1||$2).upcase }
    define_method("on_#{event_name}") do |evt|
      return unless @code_evaluator
      @code_evaluator.eval(event_name, evt)
    end
  end

  class CodeEvaluator
    def initialize
      @eval_codes = {}
    end

    def register(event_name, code)
      @eval_codes[event_name] ||= []
      @eval_codes[event_name] << code
    end

    def eval(event_name, evt)
      return if @eval_codes[event_name].nil? || @eval_codes[event_name].empty?
      begin
        code = nil
        @eval_codes[event_name].each_with_index do |c|
          code = c
          Kernel.eval(c, BindingForEvent._event_binding(evt))
        end
      rescue
        puts "[exception] eval #{code}"
      ensure
        # TODO:specify execution count
        @eval_codes[event_name].clear
      end
    end
  end
end

module BindingForEvent
  extend self
  extend Rukkit::Util

  def _command_binding(sender, command, label, args)
    binding
  end

  def _tab_complete_binding(sender, command, aliaz, args)
    binding
  end

  def _event_binding(evt)
    binding
  end
end
