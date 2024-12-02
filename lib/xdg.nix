_: {
  mkShortcut = {
    pkg ? null,
    executable ? pkg + "/bin/${pkg.pname}",
    instance-name ? pkg.pname,
    display-name ? "${instance-name} - Shortcut",
    shortcut-comment ? "A shortcut for ${instance-name}.",
    # https://specifications.freedesktop.org/menu-spec/1.0/category-registry.html
    categories ? [],
    actions ? {},

    icon-path ? "${pkg}/lib/${pkg.pname}/browser/chrome/icons/default/default128.png",
    icon ? icon-path,

    mimeTypes ? [],
    mimeType ? [],
    genericName ? "Unknown",
    type ? "Application",

    startupNotify ? false,

    terminal ? false,
    useTerminal ? terminal,
    extraSettings ? {},
    settings ? extraSettings,
  }: {
      inherit categories genericName startupNotify actions type icon settings;
      name = if display-name != null then display-name else instance-name;
      comment = "${shortcut-comment}";
      # https://specifications.freedesktop.org/desktop-entry-spec/latest/exec-variables.html
      exec = "${executable}";
      mimeType = mimeType ++ mimeTypes;
      terminal = terminal && useTerminal;
  };
}
