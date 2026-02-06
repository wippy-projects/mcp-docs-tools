-- Browse the Wippy documentation table of contents
-- Returns the full JSON structure of all doc pages

local http_client = require("http_client")

local BASE = "https://home.wj.wippy.ai"

local function call(arguments)
    local resp, err = http_client.get(BASE .. "/llm/toc")
    if err then
        return "Error: " .. tostring(err)
    end

    if resp.status_code ~= 200 then
        return "Error: HTTP " .. tostring(resp.status_code)
    end

    return resp.body
end

return { call = call }
