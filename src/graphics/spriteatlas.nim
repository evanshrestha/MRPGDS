#[
    Created: Jan 15, 2019 [17:19]

    Purpose: functions as a texture atlas and spritesheet, 
             for opimization, organization and cause it's cool
]#

import json, ospaths, tables
import terminal

import texture, renderer
import ../util/logger

import sdl2

#NOTE: not yet tested and debugged

#TYPE DECL
type
    SpriteAtlas* = object
        sheet: WTexture
        map: JsonNode
        sprites: Table[string, Sprite]

    Sprite* = object
        frames: seq[STexture]
        rate: int
        flipped: bool


#GLOBAL CONSTS
#FUNC DECL
proc createSpriteAtlas*(path: string): SpriteAtlas
proc createSpriteAtlas*(sheetPath, atlasPath: string): SpriteAtlas

proc getSprite*(atlas: SpriteAtlas, name: string): Sprite
proc loadSprite*(atlas: var SpriteAtlas, name: string)
proc getOrLoadSprite*(atlas: var SpriteAtlas, name: string): Sprite
proc loadAllSprites*(atlas: var SpriteAtlas)


#GLOBAL FIELDS
#FUNC IMPL
proc createSpriteAtlas*(path: string): SpriteAtlas =
    result = createSpriteAtlas(path&".bmp", path&".json")

proc createSpriteAtlas*(sheetPath, atlasPath: string): SpriteAtlas =
    result.sheet = loadTexture(sheetPath, getRenderer())
    result.map = parseFile(atlasPath)

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
proc getOrLoadSprite*(atlas: var SpriteAtlas, name: string): Sprite =
    if atlas.sprites.hasKey(name):
        result = atlas.sprites.getOrDefault(name)
    else:
        loadSprite(atlas, name)
        return getSprite(atlas, name)