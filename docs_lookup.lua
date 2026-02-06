-- Look up a specific documentation chunk and optionally find related content
-- Chunk IDs come from search results in the format "path#anchor"

local http_client = require("http_client")

local BASE = "https://home.wj.wippy.ai"

local function call(arguments)
    local id = arguments.id
    if not id or id == "" then
        return "Error: id is required (e.g. 'http/router#routing')"
    end

    local encoded_id = string.gsub(id, "#", "%%23")

    if arguments.related then
        local resp, err = http_client.get(BASE .. "/llm/related/" .. encoded_id)
        if err then
            return "Error: " .. tostring(err)
        end
        if resp.status_code ~= 200 then
            return "Error: HTTP " .. tostring(resp.status_code)
        end
        return resp.body
    end

    local resp, err = http_client.get(BASE .. "/llm/chunk/" .. encoded_id)
    if err then
        return "Error: " .. tostring(err)
    end

    if resp.status_code ~= 200 then
        return "Error: HTTP " .. tostring(resp.status_code)
    end

    return resp.body
end

return { call = call }
