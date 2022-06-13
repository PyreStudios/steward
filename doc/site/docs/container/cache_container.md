---
sidebar_position: 2
---

# CacheContainer
 
The CacheContainer is the default container implementation that ships with Steward. You can access the generated CacheContainer on the Router by calling `myRouter.container`, provided `myRouter` is the name of the variable holding your router. 

Additionally, you're free to new up your own CacheContainer. Its important to know that the Steward framework uses the container that's on the router. Binding items to your container but not setting that as the router's container is effectively useless.