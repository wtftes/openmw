local ui = require('openmw.ui')
local async = require('openmw.async')
local util = require('openmw.util')

local common = require('scripts.omw.settings.common')
local render = require('scripts.omw.settings.render')

render.registerRenderer('text', function(value, set, arg)
    return {
        type = ui.TYPE.TextEdit,
        props = {
            size = util.vector2(arg and arg.size or 150, 30),
            text = value,
            textColor = util.color.rgb(1, 1, 1),
            textSize = 15,
            textAlignV = ui.ALIGNMENT.End,
        },
        events = {
            textChanged = async:callback(function(s) set(s) end),
        },
    }
end)

---
-- @type PageOptions
-- @field #string key A unique key
-- @field #string l10n A localization context (an argument of core.l10n)
-- @field #string name A key from the localization context
-- @field #string description A key from the localization context

---
-- @type GroupOptions
-- @field #string key A unique key, starts with "Settings" by convention
-- @field #string l10n A localization context (an argument of core.l10n)
-- @field #string name A key from the localization context
-- @field #string description A key from the localization context
-- @field #string page Key of a page which will contain this group
-- @field #number order Groups within the same page are sorted by this number, or their key for equal values.
--   Defaults to 0.
-- @field #list<#SettingOptions> settings A [iterables#List](iterables.html#List) of #SettingOptions

---
-- @type SettingOptions
-- @field #string key A unique key
-- @field #string name A key from the localization context
-- @field #string description A key from the localization context
-- @field default A default value
-- @field #string renderer A renderer key
-- @field argument An argument for the renderer
-- @field #boolean permanentStorage Whether the setting should is stored in permanent storage, or in the save file

return {
    interfaceName = 'Settings',
    ---
    -- @module Settings
    -- @usage
    -- -- In a player script
    -- local storage = require('openmw.storage')
    -- local I = require('openmw.interfaces')
    -- I.Settings.registerGroup({
    --     key = 'SettingsPlayerMyMod',
    --     page = 'MyPage',
    --     l10n = 'mymod',
    --     name = 'modName',
    --     description = 'modDescription',
    --     settings = {
    --         {
    --             key = 'Greeting',
    --             renderer = 'text',
    --             name = 'greetingName',
    --             description = 'greetingDescription',
    --             default = 'Hello, world!',
    --             argument = {
    --                 size = 200,
    --             },
    --         },
    --     },
    -- })
    -- local playerSettings = storage.playerSection('SettingsPlayerMyMod')
    -- -- access a setting page registered by a global script
    -- local globalSettings = storage.globalSection('SettingsGlobalMyMod')
    interface = {
        ---
        -- @field [parent=#Settings] #string version
        version = 0,
        ---
        -- @function [parent=#Settings] registerPage Register a page to be displayed in the settings menu,
        --   only available in player scripts
        -- @param #PageOptions options
        -- @usage
        -- I.Settings.registerPage({
        --   key = 'MyModName',
        --   l10n = 'MyModName',
        --   name = 'MyModName',
        --   description = 'MyModDescription',
        -- })---
        registerPage = render.registerPage,
        ---
        -- @function [parent=#Settings] registerRenderer Register a renderer,
        --   only avaialable in player scripts
        -- @param #string key
        -- @param #function renderer A renderer function, receives setting's value,
        --   a function to change it and an argument from the setting options
        -- @usage
        -- I.Settings.registerRenderer('text', function(value, set, arg)
        --   return {
        --     type = ui.TYPE.TextEdit,
        --     props = {
        --       size = util.vector2(arg and arg.size or 150, 30),
        --       text = value,
        --       textColor = util.color.rgb(1, 1, 1),
        --       textSize = 15,
        --       textAlignV = ui.ALIGNMENT.End,
        --     },
        --     events = {
        --       textChanged = async:callback(function(s) set(s) end),
        --     },
        --   }
        -- end)
        registerRenderer = render.registerRenderer,
        ---
        -- @function [parent=#Settings] registerGroup Register a group to be attached to a page,
        --   available both in player and global scripts
        -- @param #GroupOptions options
        -- @usage
        -- I.Settings.registerGroup {
        --     key = 'SettingsTest',
        --     page = 'test',
        --     l10n = 'test',
        --     name = 'Player',
        --     description = 'Player settings group',
        --     settings = {
        --         {
        --             key = 'Greeting',
        --             saveOnly = true,
        --             default = 'Hi',
        --             renderer = 'text',
        --             argument = {
        --                 size = 200,
        --             },
        --             name = 'Text Input',
        --             description = 'Short text input',
        --         },
        --         {
        --             key = 'Key',
        --             saveOnly = false,
        --             default = input.KEY.LeftAlt,
        --             renderer = 'keybind',
        --             name = 'Key',
        --             description = 'Bind Key',
        --         },
        --     }
        -- }
        registerGroup = common.registerGroup,
    },
    engineHandlers = {
        onLoad = common.onLoad,
        onSave = common.onSave,
    },
}