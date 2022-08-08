#===============================================================================
# ZUD Settings.
#===============================================================================
module Settings
################################################################################  
# Switch & Variable Settings
################################################################################
# Switch Numbers for toggling off battle mechanics. Setting these game switch
# numbers to "false" in an event will disable that particular mechanic.
#===============================================================================
  NO_Z_MOVE      = 36
  NO_ULTRA_BURST = 37
  NO_DYNAMAX     = 38
  
  
################################################################################
# Visual Settings
################################################################################
# These settings control how ZUD mechanics are visually represented in battle.
#===============================================================================
# Plays the Z-Move animation when selected in battle. The animation will not
# play if this setting is set to "false", or if the player disabled battle 
# animations in the Options.
#-------------------------------------------------------------------------------
  SHOW_ZMOVE_ANIM = true
#-------------------------------------------------------------------------------  
# Plays the Ultra Burst animation when triggered in battle. The animation will 
# not play if this setting is set to "false".
#-------------------------------------------------------------------------------
  SHOW_ULTRA_ANIM = true
#-------------------------------------------------------------------------------  
# Plays the Dynamax animation when triggered in battle. The animation will not
# play if this setting is set to "false", or if the player disabled battle 
# animations in the Options.
#-------------------------------------------------------------------------------
  SHOW_DYNAMAX_ANIM = true
#-------------------------------------------------------------------------------
# Increases the size of Dynamax Pokemon's sprites and party icons by 50%.
# Note: Party icons larger than 64 pixels tall will not be enlarged.
#-------------------------------------------------------------------------------
  SHOW_DYNAMAX_SIZE = true
#-------------------------------------------------------------------------------
# Applies a colored overlay on Dynamax Pokemon's sprites and icons.
# Note: Calyrex is a special case, and uses its own unique color.
#-------------------------------------------------------------------------------
  SHOW_DYNAMAX_COLOR = true
#-------------------------------------------------------------------------------
# The color used for Dynamax Pokemon when SHOW_DYNAMAX_COLOR is enabled.
#-------------------------------------------------------------------------------
  DYNAMAX_COLOR = Color.new(196, 44, 100, 128) # Reddish
#-------------------------------------------------------------------------------
# The color used for Dynamax Calyrex when SHOW_DYNAMAX_COLOR is enabled.
#-------------------------------------------------------------------------------
  CALYREX_COLOR = Color.new(56, 160, 193, 128) # Blueish

   
################################################################################
# Dynamax Settings
################################################################################
# These settings control the availability or duration of the Dynamax mechanic,
# allowing you to customize where, when, and how Dynamax may be used.
#===============================================================================
# Sets the number of turns Dynamax lasts before expiring. (Default 3)
#-------------------------------------------------------------------------------
  DYNAMAX_TURNS = 3
#-------------------------------------------------------------------------------
# An array of map ID's that are to be considered "Power Spots", and capable of
# supporting Dynamax. You can only trigger Dynamax when on one of these maps.
# By default, this array contains the map ID's for the Pokemon Gym, Pokemon League, 
# and Battle Facilities found in Essential's default maps.
#-------------------------------------------------------------------------------
  POWERSPOTS = [10, 37, 56, 59, 61, 64]
#-------------------------------------------------------------------------------
# Similar to the POWERSPOTS array, except this array contains map ID's that are
# exclusively used to Dynamax Eternatus into Eternamax Eternatus. This Pokemon
# cannot use Dynamax on any map that isn't listed here. By default, this array
# contains no map ID's, because Eternamax Eternatus is not normally available to 
# the player.
#------------------------------------------------------------------------------- 
  ETERNASPOT = []
#-------------------------------------------------------------------------------
# This setting may be used to override the POWERSPOTS array, and flag all maps
# in the game as a Power Spot, allowing you to Dynamax anywhere. (Default false)
# Note that an ETERNASPOT map is still required for Eternatus.
#-------------------------------------------------------------------------------
  DYNAMAX_ANY_MAP = true
#-------------------------------------------------------------------------------
# This setting may be used to allow Dynamax to be available in wild battles.
# Normally, Dynamax is only available in Trainer battles or Max Raid battles. 
# (Default false)
#-------------------------------------------------------------------------------
  CAN_DYNAMAX_WILD = true
#-------------------------------------------------------------------------------
# An array of species ID's that are flagged as incapable of Dynamaxing. You may
# set any species here if you do not wish for that species to be able to Dynamax.
# Certain species have already been hard-coded to be unable to Dynamax, and thus
# do not need to be listed here, such as Zacian & Zamazenta.
# By default, this list contains Spikey-Eared Pichu, and Battle Bond/Ash-Greninja
# (for no particular reason, mostly just to serve as an example).
#
# ***NOTE***
# ANY CHANGES TO THIS PARTICULAR SETTING WILL REQUIRE YOU TO RECOMPILE YOUR GAME
# FOR THE CHANGES TO BE APPLIED.
#-------------------------------------------------------------------------------
  DYNAMAX_BANLIST = [:PICHU_2, :GRENINJA_1, :GRENINJA_2]
  
  
################################################################################
# Max Raid Battle Settings
################################################################################
# These settings control the base conditions of Max Raid battles, which are then
# scaled based on the difficulty of the raid, among other factors. These settings
# don't affect raid battles that take place in a Dynamax Adventure.
#-------------------------------------------------------------------------------
# The default number of Pokemon you may have out in a Max Raid battle. 
# (Default 3)
#-------------------------------------------------------------------------------
  MAXRAID_SIZE = 3
#-------------------------------------------------------------------------------
# The base number of KO's a Max Raid Pokemon needs to eject you from the den. 
# (Default 4)
#-------------------------------------------------------------------------------
  MAXRAID_KOS = 4
#-------------------------------------------------------------------------------
# The base number of turns you have in a Max Raid battle before being ejected. 
# (Default 10)
#-------------------------------------------------------------------------------
  MAXRAID_TIMER = 10
#-------------------------------------------------------------------------------
# The base number of hit points Max Raid shields have when they are raised. 
# (Default 2)
#-------------------------------------------------------------------------------
  MAXRAID_SHIELD = 2
  

################################################################################
# Dynamax Adventure Settings
################################################################################
# These settings control the frequency of a Max Lair generating with a Dark Lair 
# map, which limits the player's visibility during a Dynamax Adventure.
#===============================================================================
# Sets the frequency of Max Lairs being generated as a Dark Lair. 
# (0 = Never, 1 = Rarely, 2 = Common, 3 = Always)
#-------------------------------------------------------------------------------
  DARK_LAIR_FREQUENCY = 1
  
  
################################################################################
# Max Raid Database Settings
################################################################################
# These settings control how the Max Raid Database is obtained and functions.
#===============================================================================
# Automatically unlocks the Max Raid Database in the Pokegear after the player 
# encounters a Max Raid battle for the first time.
#-------------------------------------------------------------------------------
  UNLOCK_DATABASE_FROM_RAIDS = true
#-------------------------------------------------------------------------------
# When true, only species that have been seen by the player will be displayed
# in the Max Raid Database.
#-------------------------------------------------------------------------------
  HIDE_UNSEEN_SPECIES = false
  
  
################################################################################
# Max Raid Exceptions
################################################################################
# These settings control which species may be generated and appear when accessing
# a Max Raid Den, the Max Raid Database, or a Max Lair through a Dynamax Adventure.
#===============================================================================
# Puts a cap on which generation of species should appear. If a species is from
# a generation higher than this cap, it will not appear. This is useful if you
# want to ban species from appearing from higher generations if you lack battle
# sprites for those Pokemon.
# This setting is set to Generation 5 by default, since Essentials only includes
# sprites up to that generation.
#-------------------------------------------------------------------------------
  GENERATION_LIMIT = (PluginManager.installed?("Generation 8 Pack Scripts")) ? 8 : 5
#-------------------------------------------------------------------------------
# An array containing additional arrays, which each contain a regional form name 
# and a region number for that regional form. This will allow for those regional 
# forms to appear when the player is on a map that corresponds to the region number.
#
# For example, if the player is on a map with a region ID that matches the region 
# number in the "Alolan" array, then any entry in pokemon_forms.txt with "Alolan"
# in its form name will now appear in Raids. By default, all regionals are set to
# appear in Region 1 (the Tiall region), so adjust the numbers for each regional
# to suit your game.
#-------------------------------------------------------------------------------
  REGIONAL_FORMS = [
    ["Alolan",   1],
    ["Galarian", 1],
    ["Hisuian",  1]
  ]
end