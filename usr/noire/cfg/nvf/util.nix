{ asserts, trivial, strings, ... }: {
  fetchLuaSource = _lua-source-id:
    let
      lua-source-id = 
        if (strings.hasSuffix _lua-source-id ".lua")
        then _lua-source-id
        else (_lua-source-id + ".lua");

      path = (./lua/${lua-source-id});
    in
    assert (asserts.assertMsg (trivial.pathExists path) "path '${path}' does not exist"); (strings.readFile path);
}
