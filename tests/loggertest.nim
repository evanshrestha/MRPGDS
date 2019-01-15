import ../src/util/logger
import macros, terminal


let str = "str info"

LOG(INFO, "this is just info "&str)
LOG(ERROR, "this is an error")
LOG(WARNING, "this is a warning")
LOG(FATAL, "this is a fatal error")
LOG(DEBUG, "this is debug info")
