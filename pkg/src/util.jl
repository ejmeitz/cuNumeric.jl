export get_time_microseconds, get_time_nanoseconds

# function timer_microseconds()
#     return time_microseconds()
# end

# function timer_nanoseconds()
#     return time_nanoseconds()
# end

# function get_time(t::Time)
#     return value(t)
# end

"""
Returns the timestamp in microseconds. Blocks on all Legate operations
preceding the call to this function.
"""
function get_time_microseconds()
    return value(time_microseconds())
end

"""
Returns the timestamp in nanoseconds. Blocks on all Legate operations
preceding the call to this function.
"""
function get_time_nanoseconds()
    return value(time_nanoseconds())
end
