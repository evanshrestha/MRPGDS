#[
    TODO: copyright claim, license if needed
    Created: Jan 1, 2018 [14:43]
    
    Purpose: timing variables group into a tuple
             companied w/ functions to facilate
             function call timing
]#

import sdl2

# TODO: multi-threading???

#TYPE DECL
type
    Rate* = tuple
        rate: float
        time: float
        ndt: float #normalized delta time
        adt: float #accumulated delta time 
        count: int
        last: float
        mean: float

#FUNC DECL
proc time*(): float
proc rate*(rate: float): Rate
proc deltaFactor*(rate: float): float
proc meanCalc*(rate: Rate): float

proc limit*(rate: var Rate; function: proc(d: float = 0))

#TEMPLATES
template syscount*(): uint64 =
    getPerformanceCounter()

template sysfreq*(): uint64 = 
    getPerformanceFrequency()


#FUNC IMPL
proc time*(): float =
    return float(syscount()) / float(sysfreq()) # TODO: do we want different time precisions???

proc rate*(rate: float): Rate =
    result.rate = rate
    result.mean = rate
    result.time = deltaFactor(rate)
    result.last = time()

proc meanCalc*(rate: Rate): float =
    return 1 / rate.mean

proc limit*(rate: var Rate; function: proc(d: float = 0)) =
    var now = time()
    var delta = now - rate.last
    rate.last = now
    rate.adt += delta
    rate.ndt += delta / rate.time
    if rate.ndt >= 1:
        function(rate.adt)
        rate.mean = (rate.mean + rate.adt) / 2
        rate.adt = 0
        rate.ndt -= 1
        rate.count += 1 # TODO: handle here. currently has to be handled else where (e.g. mainloop)

proc deltaFactor(rate: float): float =
    if rate <= 0: return 0
    return 1 / rate