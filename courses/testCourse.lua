course = {
    name = "Test Course",
    holes = {
        {
            number = 1,
            car = {
                x = 2,
                y = 4,
                r = -math.pi / 2
            },
            hole = {
                x = 6,
                y = 4,
                s = 1
            },
            ball = {
                x = 4,
                y = 4,
                s = 0.4
            },
            map = {
                {1,1,1,1,1,1,1,1},
                {1,3,3,3,3,3,3,1},
                {1,3,2,2,2,2,3,1},
                {1,3,2,2,2,2,3,1},
                {1,3,2,2,2,2,3,1},
                {1,3,2,2,2,2,3,1},
                {1,3,3,3,3,3,3,1},
                {1,1,1,1,1,1,1,1}
            },
            obstacle = {}
        },
        {
            number = 2,
            car = {
                x = 4,
                y = 8,
                r = -math.pi / 2
            },
            hole = {
                x = 20,
                y = 8,
                r = 0,
                s = 1
            },
            ball = {
                x = 8,
                y = 8,
                s = 0.4
            },
            map = {
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1},
                {1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
            },
            obstacle = {
                -- {
                --     x = 0,
                --     y = 0,
                --     r = 0
                --     s = 1,
                --     type = 1
                -- },
                -- {
                --     x = 0,
                --     y = 0,
                --     r = 0
                --     s = 1,
                --     type = 2
                -- }
            }
        }
    }
}

return course