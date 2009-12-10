#!/usr/bin/env io

/**
 * @author Mushex Antaranian
 * @return XPath selector to current element
 * @TODO it's not working:(
 */

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
                //  if there is ---, a commented line or linebreak skip and do nothing 
                continue
            ) elseif(line matchesRegex(rkey)) then(
                //  if the line is a key, like "height:" ..
                ykey := line matchesOfRegex(rkey) next at(1)
                if(yist at(1) at(0) matchesRegex("\\n"), // .. and if next line is the line-break ..
                    stack setSlot(ykey, yist removeFirst at(0)), // .. then it's value like "Yerevan" in "city: Yerevan"
                    stack setSlot(ykey, parse(yist)) // .. else it's a separate node "yaml" so we need to parse it as yaml
                )
            ) elseif(line matchesRegex(rlist)) then(
                //  if the line is a list item, like "- alizee" .. 
                ykey := line matchesOfRegex(rlist) next at(1)
                if(stack protos at(0) == list(), // if stack is a list() already
                    stack, stack = list() // return stack, else create the stack a list()
                ) append(ykey asMutable strip) // and push trimmed key value to it
            )
        )
        return stack
    )
    process := method(ydoc,
        parse( match(ydoc) )
    )
)
