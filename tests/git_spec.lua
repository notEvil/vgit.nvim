local git = require('git.git')

local it = it
local describe = describe
local after_each = after_each

local function read_file(path)
    local file = io.open(path, "rb")
    if not file then return nil end

    local lines = {}

    for line in io.lines(path) do
        table.insert(lines, line)
    end

    file:close()
    return lines;
end

local function clear_file_content(path)
    os.execute(string.format('rm -rf %s', path))
    os.execute(string.format('touch %s', path))
end

local function add_line_to_file(line, path)
    os.execute(string.format('echo "%s" >> %s', line, path))
end

describe('git:', function()
    local path = '.gitignore'
    local lines = read_file(path)

    describe('diff', function()

        after_each(function()
            os.execute(string.format('git checkout HEAD -- %s', path))
        end)

        it('should return only added hunks', function()
            clear_file_content(path)
            for i = 1, #lines do
                add_line_to_file(lines[i], path)
                add_line_to_file('#', path)
            end
            local error = nil
            local results = nil
            local job = git.diff(path, function(err, hunks)
                error = err
                results = hunks
            end)
            job:wait()
            assert.are.same(error, nil)
            assert.are.same(#results, #lines)
            for _, hunk in pairs(results) do
                assert.are.same(hunk.type, 'add')
            end
        end)

        it('should return only removed hunks', function()
            clear_file_content(path)
            for i = 1, #lines do
                if i % 2 == 0 then
                    add_line_to_file(lines[i], path)
                end
            end
            local error = nil
            local results = nil
            local job = git.diff(path, function(err, hunks)
                error = err
                results = hunks
            end)
            job:wait()
            assert.are.same(error, nil)
            assert.are.same(#results, #lines / 2)
            for _, hunk in pairs(results) do
                assert.are.same(hunk.type, 'remove')
            end
        end)

        it('should return only changed hunks', function()
            clear_file_content(path)
            for i = 1, #lines do
                if i % 2 == 0 then
                    add_line_to_file(lines[i], path)
                else
                    add_line_to_file(lines[i] .. '#########', path)
                end
            end
            local error = nil
            local results = nil
            local job = git.diff(path, function(err, hunks)
                error = err
                results = hunks
            end)
            job:wait()
            assert.are.same(error, nil)
            assert.are.same(#results, #lines / 2)
            for _, hunk in pairs(results) do
                assert.are.same(hunk.type, 'change')
            end
        end)

        it('should return all possible hunks', function()
            local added_indices = {}
            local changed_indices = {}
            local removed_indices = {}
            clear_file_content(path)
            for i = 1, #lines do
                if i == 1 then
                    add_line_to_file('########', path)
                    add_line_to_file(lines[i], path)
                    table.insert(added_indices, i)
                elseif i == 2 then
                    add_line_to_file(lines[i] .. '#########', path)
                    table.insert(changed_indices, i)
                elseif i == 4 then
                    table.insert(removed_indices, i)
                else
                    add_line_to_file(lines[i], path)
                end
            end
            local error = nil
            local results = nil
            local job = git.diff(path, function(err, hunks)
                error = err
                results = hunks
            end)
            job:wait()
            assert.are.same(error, nil)
            assert.are.same(#results, 3)
            assert.are.same(results[1].type, 'add')
            assert.are.same(results[2].type, 'change')
            assert.are.same(results[3].type, 'remove')
        end)

    end)

end)
