# Encyclopedia
This is a framework, created by foshes. This is what powers most of my games. Feel free to
use it, fork it, and do whatever you want with it. This is meant to be a community-driven framework. 
Utilities will be added frequently, as voted by the community.

## Community
Questions? [Join our Discord!](https://discord.gg/STzsSyBRNB) 
    
## Setup

Encyclopedia is meant to be required *at least* once on both server and client to initialize their respective global containers. Encyclopedia is designed to exist in a shared container, so recommended practice is to place Encyclopedia in ReplicatedStorage.

Server/Client:
```lua
local Encyclopedia = require(path.to.Encyclopedia)
```

The global container can be referenced via `_G.Encyclopedia`.

The return value of the Encyclopedia require and global container value are identical. To avoid issues with cyclic requires, use of the global container is recommended.

## Usage

Instead of using the native `:GetService` method, recommended Encyclopia practice is to instead use the `Encyclopedia.GetService` function which will return both native services and modules housed in the SharedServices and Services folder.

As for service containers:

* SharedServices: non-exclusive; server and client can access
* Services: exclusive to server
