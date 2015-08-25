ApiHero = 
  WebSock:
    utils:
      getClientNS:->
        unless module? then global[ApiHeroUI.ns].WebSock else module.parent.WebSock