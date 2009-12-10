#!/usr/bin/env io

Regex

Yaml := Object clone do(
    match := method(ydoc,
        ydoc allMatchesOfRegex("(---|true|false|null|#(.*)|\\[(.*?)\\]|\{(.*?)\}|[\\w\-]+:|-(.+)|\\d+\\.\\d+|\\d+|\\n+)")
    )
    parse := method(yist,
        stack := Object clone
        rkey := "^([\\w\-]+):" asRegex dotAll
        rlist := "^-(.*)" asRegex dotAll
        while(yist isNotEmpty,
            line := yist removeFirst at(0)
            if(line matchesRegex("^(.*#+|---|\\n)")) then(
                continue
            ) elseif(line matchesRegex(rkey)) then(
                ykey := line matchesOfRegex(rkey) next at(1)
                if(yist at(1) at(0) matchesRegex("\\n"), 
                    stack setSlot(ykey, yist removeFirst at(0)), 
                    stack setSlot(ykey, parse(yist)) 
                )
            ) elseif(line matchesRegex(rlist)) then(
                ykey := line matchesOfRegex(rlist) next at(1)
                if(stack protos at(0) == list(),
                    stack, stack = list() 
                ) append(ykey asMutable strip)
            )
        )
        return stack
    )
    process := method(ydoc,
        parse( match(ydoc) )
    )
)
