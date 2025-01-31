export get_time, timer_microseconds, timer_nanoseconds

function timer_microseconds()
    return time_microseconds()
end

function timer_nanoseconds()
    return time_nanoseconds()
end

function get_time(t::Time)
    return value(t)
end
