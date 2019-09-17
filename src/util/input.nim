#[
    Created: Jan 4, 2019 [20:19]

    Purpose: handle user input and input bindings
]#

import 
    tables,
    marshal,
    streams,
    os,
    math

import 
    sdl2/sdl

import 
    eventhandler,
    filesys

#TODO: scroll wheel support

#TYPE DECL
type
    State* = enum
        INACTIVE, ACTIVE,
        PRESSED, RELEASED

type
    Action* = enum
        UP, DOWN, LEFT, RIGHT,
        ATTACK1, ATTACK2,
        ABILITY1, ABILITY2, ABILITY3, ABILITY4,
        INVENTORY, MAP,
        HUD

#GLOBAL CONSTS
const WASD_BINDINGS*: Table[Action, int] = 
    {
        UP: int K_w, LEFT: int K_a, DOWN: int K_s, RIGHT: int K_d,
        ATTACK1: int BUTTON_LEFT, ATTACK2: int BUTTON_RIGHT,
        ABILITY1: int K_q, ABILITY2: int K_e, ABILITY3: int K_r, ABILITY4: int K_f,
        INVENTORY: int K_TAB, MAP: int K_m, 
        HUD: int K_v
    }.toTable

# NOTE: this is the wave btw
const ESDF_BINDINGS*: Table[Action, int] =
    {
        UP: int K_e, LEFT: int K_s, DOWN: int K_d, RIGHT: int K_f,
        ATTACK1: int BUTTON_LEFT, ATTACK2: int BUTTON_RIGHT,
        ABILITY1: int K_w, ABILITY2: int K_r, ABILITY3: int K_t, ABILITY4: int K_g,
        INVENTORY: int K_q, MAP: int K_m, 
        HUD: int K_b
    }.toTable

#GLOBAL FIELDS
var binds: Table[Action, int]
var inputstates: Table[int, State]
var prev_inputstates: Table[int, State]


#FUNC DECL
proc init*(binding: Table[Action, int] = ESDF_BINDINGS)
proc serialize*()
proc deserialize()

proc update*()
proc state*(action: Action): State
proc active*(action: Action): bool
proc pressed*(action: Action): bool
proc released*(action: Action): bool


proc changeBind*(action: Action, key: cint)
proc genInputStates*()

#FUNC IMPL
proc init*(binding: Table[Action, int]) =
    #TODO: get serialized bind data
    binds = binding
    #deserialize()
    genInputStates()


#TODO: serialize binds
proc serialize*() =
    let stream = openFileStream(bindingsPath, fmWrite)
    stream.store(binds)
    close stream

proc deserialize() =
    if fileExists bindingsPath:
        let stream = openFileStream(bindingsPath, fmRead)
        stream.load(binds)
        close stream
    else:
        binds = WASD_BINDINGS
        serialize()


proc update*() =
    prev_inputstates = inputstates

    for event in eventhandler.input_q:
        case event.kind:
            of KeyDown:
                if inputstates.hasKey(int event.key.keysym.sym):
                    inputstates[int event.key.keysym.sym] = PRESSED
            of KeyUp:
                if inputstates.hasKey(int event.key.keysym.sym):
                    inputstates[int event.key.keysym.sym] = RELEASED
            of MouseButtonDown:
                if inputstates.hasKey(int event.button.button):
                    inputstates[int event.button.button] = PRESSED
            of MouseButtonUp:
                if inputstates.hasKey(int event.button.button):
                    inputstates[int event.button.button] = RELEASED
            else: discard
    input_q = @[]

    for key, state in inputstates:
        case state:
            of PRESSED:
                if prev_inputstates[key] == PRESSED: inputstates[key] = ACTIVE
            of RELEASED:
                if prev_inputstates[key] == RELEASED: inputstates[key] = INACTIVE
            else: discard

proc state*(action: Action): State =
    return inputstates[binds[action]]

proc active*(action: Action): bool = 
    return action.state == ACTIVE or action.state == PRESSED

proc pressed*(action: Action): bool = 
    return action.state == PRESSED

proc released*(action: Action): bool = 
    return action.state == RELEASED

proc changeBind*(action: Action, key: cint) = 
    binds[action] = key
    serialize() # NOTE: serialize every bind change vs. when user is done

proc genInputStates*() =
    inputstates = initTable[int, State](WASD_BINDINGS.len.nextPowerOfTwo)
    for action, key in binds:
        inputstates.add(key, INACTIVE)

    prev_inputstates = inputstates