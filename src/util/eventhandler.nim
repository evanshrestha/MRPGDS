#[
    Created: Jan 4, 2019 [19:11]

    Purpose: handle system wide events
]#

import sdl2

#TYPE DECL

#GLOBAL CONSTS

#GLOBAL FIELDS
var queue: seq[Event]
var input_q*: seq[Event] # TODO: this feels like a band-aid, but im stuck on it so...

#FUNC DECL
proc handle*(event: Event)

#FUNC IMPL
proc handle*(event: Event) =
    if  event.kind == KeyDown or
        event.kind == KeyUp or
        event.kind == MouseButtonDown or
        event.kind == MouseButtonUp or
        event.kind == MouseMotion or
        event.kind == MouseWheel:
            input_q.add(event)
    else: 
        queue.add(event)