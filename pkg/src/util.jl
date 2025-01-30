export get_time_microseconds, get_time_nanoseconds

function get_time_microseconds()
    return value(time_microseconds())
end

function get_time_nanoseconds()
    return value(time_nanoseconds())
end