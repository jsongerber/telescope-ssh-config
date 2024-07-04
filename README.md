# telescope-ssh-config

> Don't ever type `ssh user@host:port` again (at least less often).

Easily start an SSH session from Neovim using Oil or Netrw.

https://github.com/jsongerber/telescope-ssh-config/assets/18051702/3c50fa6a-747b-497a-9a7f-2a7199c0c535

> [!NOTE]  
> Tested on a fairly unsophisticated ssh_config file, see [ssh-config](#SSH-Config) for more information.

See :h telescope-ssh-config if you are in Neovim.

## 🚀 Usage

This plugin provides a single command, `:Telescope ssh-config`, which will open a Telescope window with all the hosts in your ssh config file. You can then select a host to connect to.

## 🔧 Requirements and dependencies

-   A plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim) or [packer](https://github.com/wbthomason/packer.nvim)
-   Linux or MacOS: not tested on Windows but maybe work, please let me know if you try it.
-   OpenSSH: to connect to the hosts, this need to be a version that supports the `-G` flag. (to check run `ssh -G *`)

## 📋 Installation

-   With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- This is where you have set up Telescope
{
    'nvim-telescope/telescope.nvim',
    -- …other telescope settings
    dependencies = {
        -- …other dependencies
        'jsongerber/telescope-ssh-config',
    },
    config = function()
        require('telescope').setup {
            -- …other settings
            extensions = {
                -- This is default and can be ommited
                ['ssh-config'] = {
                    client = 'oil', -- or 'netrw'
                    ssh_config_path = '~/.ssh/config',
                },
            },
        }

        -- …other Telescope extensions
        telescope.load_extension 'ssh-config'

        -- Optional: map :Telescope ssh-config to a keymap
        vim.keymap.set({ 'n', 'v' }, '<leader>fc', '<cmd>Telescope ssh-config<CR>', { desc = 'Open an ssh connexion' })
    end,
}
```

-   With [packer](https://github.com/wbthomason/packer.nvim)

```lua
use({
    'nvim-telescope/telescope.nvim',
    -- …other telescope settings
    requires = {
        -- …other dependencies
        'jsongerber/telescope-ssh-config',
    },
    config = function()
        require('telescope').setup {
            -- …other settings
            extensions = {
                -- This is default and can be ommited
                ['ssh-config'] = {
                    client = 'oil', -- or 'netrw'
                    ssh_config_path = '~/.ssh/config',
                },
            },
        }

        -- …other Telescope extensions
        telescope.load_extension 'ssh-config'

        -- Optional: map :Telescope ssh-config to a keymap
        vim.keymap.set({ 'n', 'v' }, '<leader>fc', '<cmd>Telescope ssh-config<CR>', { desc = 'Open an ssh connexion' })
    end,
})
```

## ⚙ Configuration

```lua
require('telescope').setup {
    extensions = {
        -- This is the default configuration and can be ommited
        ['ssh-config'] = {
            client = 'oil',
            ssh_config_path = '~/.ssh/config',
        },
    },
}
```

| Option            | Type   | Description                                                               | Default value     |
| ----------------- | ------ | ------------------------------------------------------------------------- | ----------------- |
| `client`          | String | The client to use to connect to the host. Can be `oil` or `netrw`.        | `'oil'`           |
| `ssh_config_path` | String | The path to the ssh config file you would like the hosts to be read from. | `'~/.ssh/config'` |

## 🧰 Commands

| Command                 | Description                                                                                                   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------- |
| `:Telescope ssh-config` | Open a Telescope window with all the hosts in your ssh config file. You can then select a host to connect to. |

## 🚧 SSH Config

The plugins uses the `ssh_config` file to get the hosts, it reads the `host` argument and run `ssh -G host` to get the host information.
My `ssh_config` file looks like this:

```ssh
Host host1
    HostName host1.com
    User user1
    Port 22
```

If you have a more complex `ssh_config` file and the plugin doesn't work, please open an issue with an example of your `ssh_config` structure and explain (like I'm 5) how you are using it to connect to the host and how it differs from my config.

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## 📝 TODO

Will do if there is demand (open issue or PR)

-   [ ] Add native vim.ui.select support
-   [ ] Make it work with more complex ssh config files

## 📜 License

MIT © [jsongerber](https://github.com/jsongerber/thanks/blob/master/LICENSE)

## Shameless plug

See my other plugins:

-   [thanks.nvim](https://github.com/jsongerber/thanks.nvim): A plugin to show your appreciation to the maintainers of the plugin you use.
-   [nvim-px-to-rem](https://github.com/jsongerber/nvim-px-to-rem): A plugin to convert px to rem in Neovim.
