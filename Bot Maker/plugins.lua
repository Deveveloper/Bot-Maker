json = require('json')
widget = require('widget')
app = require('Plugins.app')
device = require('Plugins.device')
jsonfunc = require('Plugins.json-func')
func = require('Plugins.func')
filesfunc = require('Plugins.files-func')
message = require('Plugins.message')
panel = require('Plugins.panel')
eval = require('Groups.Modules.eval')
crypt = require('Plugins.crypt')
androidFilePicker = require('plugin.androidFilePicker')

if platform == "Win" or env == "simulator" then
    tinyfiledialogs = require('plugin.tinyfiledialogs')
end
utf8 = require('plugin.utf8')
zip = require('plugin.zip')

_Chat = require('Groups.Chat.interface')
_Chats = require('Groups.Chats.interface')
_Settings = require('Groups.Settings.interface')
_Constructor = require('Groups.Constructor.interface')