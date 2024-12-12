{
  ksmserverrc.General.loginMode.value = "emptySession";

  # see: https://discuss.kde.org/t/panel-icons-disappear-after-upgrade-to-kde-6/24352/2?u=nowaaru
  kglobals.QtQuickRendererSettings = {
    RenderLoop = "basic";
    SceneGraphBackend = "opengl";
  };
}
