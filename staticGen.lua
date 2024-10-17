local lfs = require("lfs")

-- Read file content
local function read_file(file_path)
    local file = io.open(file_path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

-- Write content to file
local function write_file(file_path, content)
    local file = io.open(file_path, "w")
    if not file then return false end
    file:write(content)
    file:close()
    return true
end

-- Parse markdown content
local function parse_markdown(content)
    local title = ""
    local contact_info = {}
    local description = ""
    local current_category = ""
    
    for line in content:gmatch("[^\r\n]+") do
        if line:match("^# ") then
            title = line:gsub("^# ", "")
        elseif line:match("^### ") then
            current_category = line:gsub("^### ", "")
        elseif current_category ~= "" and line:match("%S") then
            local info = line:gsub("%[(.-)%]%((.-)%)", function(text, url)
                return string.format('<a href="%s">%s</a>', url, text)
            end)
            table.insert(contact_info, {category = current_category, info = info})
            current_category = ""
        elseif line:match("^%S") and #contact_info > 0 and description == "" then
            description = line
        end
    end
    
    return title, contact_info, description
end

-- Generate HTML
local function generate_html(title, contact_info, description)
    local template = read_file("template.html")
    if not template then
        print("Error: template.html not found")
        return nil
    end
    
    local contact_html = ""
    for _, info in ipairs(contact_info) do
        contact_html = contact_html .. string.format(
            "<dt>%s</dt>\n<dd>%s</dd>\n",
            info.category,
            info.info
        )
    end
    
    local content = string.format([[
        <table>
            <tr>
                <td><img src="assets/img/carl-bw.png"></td>
                <td>
                    <dl>
                        %s
                    </dl>
                </td>
            </tr>
        </table>
        <p>%s</p>
    ]], contact_html, description)
    
    local html = template:gsub("{{title}}", title)
    html = html:gsub("{{content}}", content)
    html = html:gsub("{{last_updated}}", os.date("%Y-%m-%d"))
    
    return html
end


local function main()
    local content = read_file("content/about.md")
    if not content then
        print("Error: content/about.md not found")
        return
    end
    
    local title, contact_info, description = parse_markdown(content)
    local html = generate_html(title, contact_info, description)
    
    if html then
        if write_file("index.html", html) then
            print("Successfully generated index.html")
        else
            print("Error writing to index.html")
        end
    else
        print("Error generating HTML")
    end
end

main()
