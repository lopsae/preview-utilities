(function () {
    var VERSION = "v0.4.0";
    var RELEASE_URL = "https://github.com/lopsae/preview-utilities/releases/tag/v0.4.0";

    function ensureBadge() {
        var badge = document.getElementById("package-version-badge");
        if (!badge) {
            badge = document.createElement("a");
            badge.id = "package-version-badge";
            badge.href = RELEASE_URL;
            badge.target = "_blank";
            badge.rel = "noopener noreferrer";
            badge.textContent = VERSION;
        }
        return badge;
    }

    function findNavActions() {
        var selectors = [".nav-content .nav-actions", ".nav-actions", ".nav-content", "nav.nav", "#app nav"];
        for (var i = 0; i < selectors.length; i++) {
            var target = document.querySelector(selectors[i]);
            if (target) {
                return target;
            }
        }
        return null;
    }

    function placeBadge() {
        var badge = ensureBadge();
        var navActions = findNavActions();

        if (navActions) {
            badge.className = "package-version-badge package-version-badge--inline";
            if (badge.parentElement !== navActions) {
                navActions.appendChild(badge);
            }
        } else {
            badge.className = "package-version-badge package-version-badge--fixed";
            if (badge.parentElement !== document.body) {
                document.body.appendChild(badge);
            }
        }
    }

    placeBadge();

    // Observing document.body rather than #app is deliberate: this script runs synchronously
    // before Vue's deferred bundle mounts, and Vue replaces the #app element entirely rather than
    // mutating it in place. An observer attached to the pre-mount #app node would watch a node that
    // gets discarded and never fire.
    new MutationObserver(placeBadge).observe(document.body, { childList: true, subtree: true });
})();