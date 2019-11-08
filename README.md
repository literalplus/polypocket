# Polypocket

**Polypocket** is a small collection of Bash scripts and
file management concepts that aim to make your life
as a Minecraft Sysadmin just a little bit easier.

It mainly focuses on easy deployment via automated
scripts. By automagically copying plugins from
multiple configurable folders, it makes your
life much easier: You can just drop the latest
plugins in your central plugin folder, and
Polypocket will pull them to your instanes
as they restart.

Polypocket was created for the [MinoTopia German PvP Server](https://github.com/minotopiame)
and is licensed under the MIT License, a copy of which
can be found in the `LICENSE` file bundled
with this repository.

If this helped you, consider checking out [Spigotctl](https://gist.github.com/literalplus/f3327e2642a07fe2fac42597b583e929),
which provides integration between Systemd, Tmux, and Spigot.

# Concept

You need:

 * A Linux box with shell access
 * Some kind of wrapper (e.g. legacy [Remote Toolkit](https://bukkit.org/threads/remotetoolkit-restarts-crash-detection-auto-saves-remote-console.674/), 
    a custom solution, or the shipped `startloop.sh` file)
 * Polypocket
 * Some Minecraft server software based on Bukkit (e.g. [Paper](https://aquifermc.org/))
 * A lot of plugins which you update sometimes
 * Many folders and loads of symlinks

So, basically, the idea is that your wrapper script takes
care of launching Polypocket and also restarting it
from time to time. Polypocket then takes care of keeping
your server binary and plugins up to date.

By copying the server binary and plugin jars over before
starting the server, but never while it is running,
Polypocket effectively prevents those nasty
`NoClassDefFoundError`s that usually occur when you
replace `jar`s in place, requiring you to reload
or restart immediately.

# Folders

## Polypocket template folder

This folder. This is where you keep your `start.sh` script,
your default config, an your template config. It is usually
a good idea to keep this a Git repository so you can
incorporate upstream changes.

You can also put some server config templates here.

When you need to spin up a new instance, you copy this
whole folder over and just change `config.sh`.

## Central server binary folder

This is where you keep your server binary jars. Ideally,
you would frequently update your server jar. Polypocket
makes sure that all instances get the latest version
once they restart.

## Central plugins folder

This is where you keep your plugins. You can have as many of
these as you want.

At MinoTopia, we keep external plugins
in folders by categories. We symlink common plugins that
all servers need into a `common` folder that all
instances use. Every instance also has a separate 
`extra/$SERVER_NAME` folder, which keeps additional
plugins and override plugins that we want different
from the common folder.

Your Continuous Integration server can now just
drop new versions into your category folders, and
Polypocket would automatically pull them to your
instances once they restart.

Also note that it's possible to override plugins
with newer versions for testing servers.

# Setup

 1. Clone this repository:
     ```bash
     git clone https://github.com/literalplus/polypocket
     ```

 2. Copy `template-config.sh` to `config.sh` and
     adjust your custom template config

 3. You can now start spinning up instances by
     copying the `polypocket` folder!

# Drawbacks

This might not be entirely suitable for your situation.
Further, this does require a wrapper script that does
quite a lot.
