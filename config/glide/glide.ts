// Config docs:
//
//   https://glide-browser.app/config
//
// API reference:
//
//   https://glide-browser.app/api
//
// Default config files can be found here:
//
//   https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
//
// Most default keymappings are defined here:
//
//   https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
//
// Try typing `glide.` and see what you can do!
glide.keymaps.set(
  "command",
  "<c-j>",
  "commandline_focus_next",
);
glide.keymaps.set(
  "command",
  "<c-k>",
  "commandline_focus_back",
);

glide.autocmds.create("UrlEnter", /https:\/\/mail\.google\.com/, async (e) => {
  await glide.excmds.execute("mode_change ignore");
  return async () => await glide.excmds.execute("mode_change normal");
});

glide.autocmds.create("UrlEnter", /https:\/\/www\.overleaf\.com/, async (e) => {
  await glide.excmds.execute("mode_change ignore");
  return async () => await glide.excmds.execute("mode_change normal");
});

glide.keymaps.set("ignore", "<C-j>", "tab_next");
glide.keymaps.set("ignore", "<C-k>", "tab_prev");
