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

const hostname_keys = {
  "<leader>c": "claude.ai",
  "<leader>C": "canvas.upenn.edu",
  "<leader>y": "youtube.com",
  "<leader>g": "github.com",
  "<leader>e": "edstem.org",
};

const ignore_mode_hostnames = [
  "mail.google.com",
  "overleaf.com",
  "docs.google.com",
];

glide.keymaps.set("command", "<C-j>", "commandline_focus_next");
glide.keymaps.set("command", "<C-k>", "commandline_focus_back");
glide.keymaps.set("normal", "q", "clear");

glide.keymaps.set("ignore", "<C-j>", "tab_next");
glide.keymaps.set("ignore", "<C-k>", "tab_prev");
glide.keymaps.set("normal", "<leader>f", "commandline_show tab ");

glide.keymaps.set(
  "normal",
  "<C-c>",
  async ({ tab_id }) => {
    browser.tabs.remove(tab_id);
  },
  { description: "Close current tab" },
);

glide.keymaps.set(["insert", "normal"], "<C-r>", async () => {
  if (glide.ctx.mode == "normal") {
    await glide.keys.send("i");
  }
  await glide.keys.send("rlarkdfus");
});

glide.keymaps.set(
  ["insert", "normal"],
  "<C-p>",
  async () => {
    const accounts = await loadAccounts();
    glide.commandline.show({
      title: "Passwords",
      options: accounts.map((acc) => ({
        label: acc.label,
        async execute() {
          if (glide.ctx.mode == "normal")
            await glide.excmds.execute("mode_change insert");
          await glide.keys.send(acc.username);
          await glide.keys.send("<tab>");
          await glide.keys.send(acc.password);
          await glide.keys.send("<CR>");
        },
      })),
    });
  },
  { description: "Open the passwords picker" },
);

glide.keymaps.set(["insert", "normal"], "<C-j>", async () => {
  if (urlbar_is_focused()) {
    await glide.keys.send("<tab>");
  } else {
    await glide.excmds.execute("tab_next");
  }
});

glide.keymaps.set(["insert", "normal"], "<C-k>", async () => {
  if (urlbar_is_focused()) {
    await glide.keys.send("<S-tab>");
  } else {
    await glide.excmds.execute("tab_prev");
  }
});

for (const [key, hostname] of Object.entries(hostname_keys)) {
  glide.keymaps.set(
    "normal",
    key,
    async () => {
      open_tab(hostname);
    },
    {
      description: hostname,
    },
  );
}

glide.autocmds.create("WindowLoaded", async () => {
  const window = await browser.windows.getCurrent();
  if (window.incognito) {
    document!.getElementById("nav-bar").style.background = "black";
  }
});

glide.autocmds.create("UrlEnter", {hostname: "www.youtube.com"}, async ({ tab_id }) => {
  const url = glide.ctx.url;
  const pathname = url.pathname.split("/").filter(Boolean);
  if (pathname.length > 0) {
    if (pathname[0] == "shorts") {
      await browser.tabs.remove([tab_id]);
    }
  }
});

glide.autocmds.create("UrlEnter", { hostname: "www.instagram.com" }, async ({ tab_id }) => {
  await glide.content.execute(() => {
    const observer = new MutationObserver(() => {
      document.querySelectorAll("video").forEach((v) => {
        if (v.videoHeight >= v.videoWidth)
          v.style.visibility = "hidden";
      });
      document.querySelectorAll("img").forEach((i) => {
        i.style.filter = "blur(32px)";
      });

    });

    observer.observe(document.body, { childList: true, subtree: true });
  }, { tab_id });
});

for (const hostname of ignore_mode_hostnames) {
  glide.autocmds.create("UrlEnter", { hostname: hostname }, async () => {
    await glide.excmds.execute("mode_change ignore");
    return async () => await glide.excmds.execute("mode_change normal");
  });
}

function urlbar_is_focused() {
  return (
    document!.getElementById("urlbar-input")!.getAttribute("aria-expanded") ===
    "true"
  );
}

glide.keymaps.set("insert", "<Escape>", async () => {
  await glide.excmds.execute("mode_change normal");
  await glide.keys.send("<Escape>", { skip_mappings: true });
});

async function open_tab(hostname: string) {
  const url = "https:\/\/" + hostname;
  const tab = await glide.tabs.get_first({ url: url + "/*" });
  const current_tab = await glide.tabs.active();
  if (tab) {
    await browser.tabs.update(tab.id, {
      active: true,
    });
  } else {
    if (current_tab.url == "about:newtab") {
      await browser.tabs.update({ url: url });
    } else {
      await browser.tabs.create({
        active: true,
        url: url,
      });
    }
  }
}

glide.keymaps.set(["normal", "insert"], "<C-b>h", async ({ tab_id }) => {
  if (glide.unstable.split_views.has_split_view(tab_id)) {
    const current_split = glide.unstable.split_views.get(tab_id)?.id;
    const all_tabs = await glide.tabs.query({});
    const current_index = all_tabs.findIndex((t) => t.id === tab_id);
    const other_tab = all_tabs[current_index - 1];
    if (
      other_tab &&
      glide.unstable.split_views.get(other_tab)?.id == current_split
    ) {
      await glide.excmds.execute("tab_prev");
    } else {
      await glide.excmds.execute("tab_next");
    }
  }
});

glide.keymaps.set(["normal", "insert"], "<C-b>l", async ({ tab_id }) => {
  if (glide.unstable.split_views.has_split_view(tab_id)) {
    const current_split = glide.unstable.split_views.get(tab_id)?.id;
    const all_tabs = await glide.tabs.query({});
    const current_index = all_tabs.findIndex((t) => t.id === tab_id);
    const other_tab = all_tabs[current_index + 1];
    if (
      other_tab &&
      glide.unstable.split_views.get(other_tab)?.id == current_split
    ) {
      await glide.excmds.execute("tab_next");
    } else {
      await glide.excmds.execute("tab_prev");
    }
  }
});

glide.keymaps.set(
  ["normal", "insert"],
  "<C-b>v",
  async ({ tab_id }) => {
    const all_tabs = await glide.tabs.query({});
    const new_tab = await browser.tabs.create({ active: false });
    const other_tabs = all_tabs.filter((t) => t.id !== tab_id);
    other_tabs.unshift(new_tab);

    glide.commandline.show({
      title: "Split with tab",
      options: other_tabs.map((tab) => ({
        label: tab.title,
        description: tab.url,
        async execute() {
          if (tab.id != new_tab.id) {
            browser.tabs.remove(new_tab.id);
          }
          glide.unstable.split_views.create([tab_id, tab.id]);
          await browser.tabs.update(tab.id, { active: true });
          await glide.excmds.execute("mode_change normal");
          await glide.excmds.execute("blur");
        },
      })),
    });
  },
  {
    description: "Create a split view with a selected tab",
  },
);

glide.keymaps.set(
  ["normal", "insert"],
  "<C-b>d",
  async ({ tab_id }) => {
    glide.unstable.split_views.separate(tab_id);
  },
  {
    description: "Close the split view for the current tab",
  },
);

async function loadAccounts() {
  const data = await glide.fs.read("accounts.json", "utf8");
  return JSON.parse(data) as {
    label: string;
    username: string;
    password: string;
  }[];
}
