function conky_format(format, number)
    return string.format(format, conky_parse(number))
end

function conky_sformat(format, arg)
    return string.format(format, conky_parse(arg))
end
