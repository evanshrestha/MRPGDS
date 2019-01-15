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
macro LOG*(lvl: static[LogLvl], msg:string): typed =
    result = 
        if LOG_LEVEL <= lvl:
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
        else: 
            parseStmt("discard")
    #echo result.toStrLit