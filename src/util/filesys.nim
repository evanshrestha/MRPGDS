#[
    Created: Jan 5, 2019 [10:33]

    Purpose: file input/output abstraction/centralization
]#

import logger

import os, ospaths, terminal

#TYPE DECL

#GLOBAL CONSTS
const HEAD = "mrpgds"

#FUNC DECL
proc init*()

proc getUserDataDir*(): string
proc deleteUserData*()

proc toAbsDir*(path: string): string

#GLOBAL FIELDS
let saveDir = getUserDataDir()

#NOTE: could abstract this to function
let bindingsPath* = saveDir.joinPath("bindings.json")

let initializing: bool = not existsDir saveDir

#FUNC IMPL
proc init*() =
    if initializing: #NOTE: logging system
        if saveDir == "": LOG(WARNING, "file saving on this os is not yet supported")
        else: 
            createDir saveDir
    
proc getUserDataDir*(): string =
    when defined Windows:
        LOG(DEBUG, "user data directory="&joinPath([getHomeDir(), "appdata", "local", HEAD]))
        return joinPath([getHomeDir(), "appdata", "local", HEAD])
    elif defined Linux:
        return "" #TODO: Linux serialization support
    elif defined MacOS:
        return "" #TODO: macos serialization support
    elif defined MacOSX:
        return "" #TODO: macosx serialization support


proc deleteUserData*() =
    removeDir(getUserDataDir())

proc toAbsDir*(path: string): string = 
    return
        if path.isAbsolute: path
        else: joinPath(getAppDir(), path)