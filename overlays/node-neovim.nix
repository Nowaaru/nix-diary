withSystem: inputs: (final: prev: {
  nodePackages =
    prev.nodePackages
    // {
      neovim = final.neovim-node-client;
    };
})
