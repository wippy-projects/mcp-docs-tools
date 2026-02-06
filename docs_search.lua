-- Search Wippy documentation by query
-- Returns matching chunks with IDs, paths, and summaries

local http_client = require("http_client")

local BASE = "https://home.wj.wippy.ai"

local function call(arguments)
    local query = arguments.query
    if not query or query == "" then
        return "Error: query is required"
    end

    local resp, err = http_client.get(BASE .. "/llm/search?q=" .. query)
    if err then
        return "Error: " .. tostring(err)
    end

    if resp.status_code ~= 200 then
        return "Error: HTTP " .. tostring(resp.status_code)
    end

    return resp.body
end

return { call = call }
