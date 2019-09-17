#[
    Created: Jan 12, 2019 [19:28]

    Purpose: application logger
]#

import macros, terminal

#NOTE: must import terminal everywhere the LOG macro is called

#TODO:
    # multithreading?
    # logging to file
    # allow LOG to be called without importing terminal


#TYPE DECL
type 
    LogLvl* = enum
        DEBUG, INFO, WARNING, ERROR, FATAL

type
    Msg = tuple
        level: LogLvl
        msg: string
        line: int
        filepath: string

#GLOBAL CONSTS
const COLS = [fgCyan, fgBlue, fgYellow, fgRed, fgMagenta]

#FUNC DECL

#GLOBAL FIELDS
var LOG_LEVEL: LogLvl = DEBUG # this can't change but i'd like it too, prob impossible
var LOGGER: seq[Msg] = @[]

#FUNC IMPL
macro LOG*(lvl: static[LogLvl], msg:string): void =
    result = 
        #let info = "file: " & msg.lineInfoObj.filename & "\nline:" & $msg.lineInfoObj.line
        nnkStmtList.newTree(
            nnkCall.newTree(
                newIdentNode("styledWriteLine"),
                newIdentNode("stderr"),
                newIdentNode($COLS[ord(lvl)]),
                newLit($lvl&": "),
                newIdentNode("resetStyle"),
                newLit(msg.lineInfo&"\n"),
                msg
            )
        )
    #echo result.toStrLit

macro SDLCall*(sdlfunc: untyped): int =
    ## `sdlfunc` is an sdl function that returns 0 on success
    ##  
    ## `let s:int = sdlfunc(); if s != 0: echo sdl.getError(); s`
    result = nnkStmtList.newTree(
        nnkStmtListExpr.newTree(
        # decl / assign error code to result of sdl func call
        nnkLetSection.newTree(
            nnkIdentDefs.newTree(
            newIdentNode("s"),
            newIdentNode("int"),
            sdlfunc)),
        # if error then echo sdl error
        nnkIfStmt.newTree(
            nnkElifBranch.newTree(
            nnkInfix.newTree(
                newIdentNode("!="),
                newIdentNode("s"),
                newLit(0)),
            nnkCommand.newTree(
                newIdentNode("echo"),
                nnkCall.newTree(
                nnkDotExpr.newTree(
                    newIdentNode("sdl"),
                    newIdentNode("getError")))))),
        # return error code
        newIdentNode("s")))
    
    
macro SDLNil*(sdlobj: untyped): untyped =
    ## `sdlobj` is an sdl object that can be `nil`, eg. `sdl.Window`, `sdl.Renderer`
    ##
    ## `let n = (sdlobj == nil); if n: echo sdl.getError(); n`
    result = nnkStmtList.newTree(
        nnkStmtListExpr.newTree(
        # let n = (sdlobj == nil)
        nnkLetSection.newTree(
            nnkIdentDefs.newTree(
            newIdentNode("n"),
            newEmptyNode(),
            nnkPar.newTree(
                nnkInfix.newTree(
                newIdentNode("=="),
                sdlobj,
                newNilLit())))),
        # if n: echo sdl.getError()
        nnkIfStmt.newTree(
            nnkElifBranch.newTree(
            newIdentNode("n"),
            nnkCommand.newTree(
                newIdentNode("echo"),
                nnkCall.newTree(
                nnkDotExpr.newTree(
                    newIdentNode("sdl"),
                    newIdentNode("getError")))))),
        # n
        newIdentNode("n")))
