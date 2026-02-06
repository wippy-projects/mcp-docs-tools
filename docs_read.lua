-- Read Wippy documentation pages by path
-- Supports single page or batch fetch of multiple comma-separated paths

local http_client = require("http_client")

local BASE = "https://home.wj.wippy.ai"

local function call(arguments)
    local path = arguments.path
    if not path or path == "" then
        return "Error: path is required (e.g. 'start/about' or 'lua/http/client')"
    end

    -- If multiple paths provided (comma-separated), use batch endpoint
    if string.find(path, ",") then
        local resp, err = http_client.get(BASE .. "/llm/context?paths=" .. path)
        if err then
            return "Error: " .. tostring(err)
        end
        if resp.status_code ~= 200 then
            return "Error: HTTP " .. tostring(resp.status_code)
        end
        return resp.body
    end

    -- Single page fetch
    local url = BASE .. "/llm/path/en/" .. path
    if arguments.summary then
        url = BASE .. "/llm/summary/en/" .. path
    end

    local resp, err = http_client.get(url)
    if err then
        return "Error: " .. tostring(err)
    end

    if resp.status_code ~= 200 then
        return "Error: HTTP " .. tostring(resp.status_code)
    end

    return resp.body
end

return { call = call }
