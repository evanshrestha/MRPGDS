#[
    Created: Jan 15, 2019 [17:19]

    Purpose: functions as a texture atlas and spritesheet, 
             for opimization, organization and cause it's cool
]#

import 
    json,
    os,
    tables,
    terminal

import 
    texture,
    ../util/logger,
    ../util/misc

import 
    sdl2/sdl

#NOTE: not yet tested and/or debugged

#TYPE DECL
type
    SpriteAtlas* = ref object
        sheet: WTexture
        map: JsonNode
        sprites: Table[string, Sprite]

    SpriteSet* = ref tuple
        down: Sprite
        diagdown: Sprite
        side: Sprite
        up: Sprite
        diagup: Sprite

    Sprite* = ref object
        frames: seq[STexture]
        index: int
        rate: int
        flipped: bool

#GLOBAL CONSTS
#FUNC DECL
#proc createSpriteAtlas*(jsonpath: string, sheet: WTexture): SpriteAtlas

proc getSprite*(atlas: SpriteAtlas, name: string): Sprite
proc loadSprite*(atlas: var SpriteAtlas, name: string)
proc getOrLoadSprite*(atlas: var SpriteAtlas, name: string): Sprite
proc loadAllSprites*(atlas: var SpriteAtlas)

#GLOBAL FIELDS
#FUNC IMPL
proc createSpriteAtlas*(path: string): SpriteAtlas =
    result.map = parseFile(path)

#TODO: function implementation
proc loadAllSprites*(atlas: var SpriteAtlas) = return

proc loadSprite*(atlas: var SpriteAtlas, name: string) = 
    let node = atlas.map.getOrDefault(name)
    if node == nil:
        LOG(ERROR, "failed to load sprite: "&name&" from json")
        return

    let frames = node.getOrDefault("frames")
    if frames == nil: LOG(ERROR, "failed to load frames for sprite: "&name)

    var sprite: Sprite

    for f in frames:
        let src = rect(f[0].getInt.cint, f[1].getInt.cint, f[2].getInt.cint, f[3].getInt.cint)
        let stex = createSubTexture(atlas.sheet, src)
        sprite.frames.add(stex)

    if atlas.sprites.hasKeyOrPut(name, sprite): LOG(DEBUG, "Loaded sprite: "&name)

proc getSprite*(atlas: SpriteAtlas, name: string): Sprite =
    if atlas.sprites.hasKey(name):
        result = atlas.sprites.getOrDefault(name)
    else:
        LOG(ERROR, "sprite: "&name&" is not loaded. maybe call getOrLoadSprite instead...")
    

#NOTE: do we reimplement or reuse funcs in this situation?
#NOTE: why in god's name would we not use loadSprite and getSprite?
proc getOrLoadSprite*(atlas: var SpriteAtlas, name: string): Sprite =
    if atlas.sprites.hasKey(name):
        result = atlas.sprites.getOrDefault(name)
    else:
        loadSprite(atlas, name)
        return getSprite(atlas, name)